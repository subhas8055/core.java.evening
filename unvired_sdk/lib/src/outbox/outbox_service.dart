import 'dart:convert';

import 'package:collection/src/iterable_extensions.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:isolated_worker/isolated_worker.dart';
import 'package:logger/logger.dart';

import '../application_meta/field_constants.dart';
import '../database/database_manager.dart';
import '../database/framework_database.dart';
import '../helper/event_handler_constants.dart';
import '../helper/framework_helper.dart';
import '../helper/http_connection.dart';
import '../helper/isolate_helper.dart';
import '../helper/service_constants.dart';
import '../helper/status.dart';
import '../notification_center/dart_notification_center_base.dart';
import '../outbox/outbox_attachment_manager.dart';
import '../outbox/outbox_helper.dart';
import '../sync_engine.dart';
import '../unvired_account.dart';
// ignore: import_of_legacy_library_into_null_safe

import 'hive_outbox_data_manager.dart';

enum ServiceThreadStatus { Initialized, Running, Paused, Resumed, Done }

const String sourceClass = 'OutBoxService';

class OutBoxService {
  static bool _isPaused = false;
  static bool _isRunning = false;
  static String _threadStatus = "";

  static String get threadStatus => _threadStatus;

  bool get isRunning => _isRunning;

  bool get isPaused => _isPaused;

  OutBoxService() {}

  Future<void> start() async {
    if (isRunning) {
      String message = "Outbox is Service already running....";
      Logger.logError(sourceClass, "start", message);
      return;
      //throw (message);
    }

    _isRunning = true;
    _threadStatus = ServiceThreadStatus.Running.toString();
    Map<String, dynamic> map = await getOutBoxServiceMap();
    if (!kIsWeb) {
      try {
        IsolatedWorker().run(checkOutBoxAndSendToServer, map);
      } catch (e) {
        Logger.logError(sourceClass, "start", e.toString());
        await stop();
      }
    } else {
      await checkOutBoxAndSendToServer(map);
    }
  }

  Future<void> stop() async {
    if (_threadStatus == ServiceThreadStatus.Running.toString()) {
      _isRunning = false;
      _threadStatus = ServiceThreadStatus.Done.toString();
      Logger.logDebug(sourceClass, "stop",
          "OUTBOX STATUS __ ${OutBoxService.threadStatus}");
      Logger.logDebug(sourceClass, "stop", "OutBoxService finished......");
    } else {
      Logger.logError(sourceClass, "stop", "OutBoxService is not running");
    }
    List<OutObjectData> _outObjectDataList =
        await (await DatabaseManager().getFrameworkDB()).allOutObjects;
    List<OutObjectData> notErroredOutObjectList = _outObjectDataList
        .where((element) =>
            element.fieldOutObjectStatus !=
            OutObjectStatus.errorOnProcessing.index.toString())
        .toList();
    if (notErroredOutObjectList.isNotEmpty) {
      await start();
    }
  }
}

//Isolate handled function should be static
checkOutBoxAndSendToServer(Map<String, dynamic> map) async {
  try {
    UnviredAccount? _selectedAccount = map['unviredAccount'];
    String? appName = map['appName'];
    String? authToken = map['authToken'];
    String? appBaseUrl = map['appBaseUrl'];
    String? outboxPath = map['outboxPath'];
    String? appPath = map['appPath'];
    String? appDirPath = map['appDirPath'];
    String? attachmentFolderPath = map['attachmentFolderPath'];
    selectedAccount = _selectedAccount;
    if (!kIsWeb) {
      Logger.initialize(appDirPath!);
    }
    if (frameworkDatabaseIsolate == null) {
      frameworkDatabaseIsolate = await getWorkerFrameWorkDatabase(map);
    }
    if (appDatabaseIsolate == null) {
      appDatabaseIsolate = await getWorkerAppDatabase(map);
    }

    List<OutObjectData> lockedOutObjectList =
        (await frameworkDatabaseIsolate!.allOutObjects)
            .where((element) => element.beHeaderLid == SyncEngine().lockedLid)
            .toList();
    List<OutObjectData> outObjectList =
        (await frameworkDatabaseIsolate!.allOutObjects);

    Logger.logDebug(sourceClass, 'checkOutBoxAndSendToServer',
        'lockedOutObjectList COUNT: ${lockedOutObjectList.length}');

    if (lockedOutObjectList.isNotEmpty) {
      outObjectList = outObjectList
          .where(
              (element) => element.timestamp < lockedOutObjectList[0].timestamp)
          .toList();
    }

    Logger.logInfo(sourceClass, "checkOutBoxAndSendToServer",
        "OUTBOX DATA COUNT : ${outObjectList.length.toString()}");
    if (!kIsWeb) {
      bool connectionStatus = await checkConnectionInIsolate();
      if (!connectionStatus) {
        Logger.logError(sourceClass, "checkOutBoxAndSendToServer",
            "No internet connection to process outbox items...");
        stopOutBox(map);
        return;
      }
      if (!await HTTPConnection.isServerReachable()) {
        Logger.logError(
            sourceClass, "checkOutBoxAndSendToServer", "Server not reachable.");
        stopOutBox(map);
        return;
      }
    }

    await makeNetworkCallWithOutObject(
        outObjectList,
        _selectedAccount!,
        appName!,
        authToken!,
        map,
        appBaseUrl!,
        attachmentFolderPath!,
        outboxPath!,
        appPath!);
  } catch (e) {
    Logger.logError(sourceClass, "checkOutBoxAndSendToServer", e.toString());
    stopOutBox(map);
  }
}

Future<void> makeNetworkCallWithOutObject(
    List<OutObjectData> outObjectList,
    UnviredAccount _selectedAccount,
    String appName,
    String authToken,
    // SendPort sendPort,
    Map<String, dynamic> map,
    String appBaseUrl,
    String attachmentFolderPath,
    String outboxPath,
    String appPath) async {
  if (outObjectList.isNotEmpty) {
    for (int i = 0; i < outObjectList.length; i++) {
      OutObjectData outObjectData = outObjectList[i];
      Logger.logDebug(
          sourceClass,
          "makeNetworkCallWithOutObject",
          "OutObject to send: " +
              outObjectData.beName +
              " - " +
              outObjectData.beHeaderLid +
              "- outobject lid" +
              outObjectData.lid +
              "  ConversationId: " +
              outObjectData.conversationId);

      if (outObjectData.fieldOutObjectStatus ==
          OutObjectStatus.lockedForSending.index.toString()) {
        Logger.logDebug(
            sourceClass,
            "makeNetworkCallWithOutObject",
            "Cannot modify or re-submit again. OutObject is locked for sending" +
                outObjectData.beName +
                "-" +
                outObjectData.beHeaderLid +
                "- outobject lid" +
                outObjectData.lid +
                "  ConversationId: " +
                outObjectData.conversationId);
        // throw ("Cannot modify or re-submit again. OutObject is locked for sending : " +
        //     outObjectData.beName +
        //     "-" +
        //     outObjectData.beHeaderLid);
        if (i == (outObjectList.length - 1)) {
          stopOutBox(map);
          return;
        } else {
          Logger.logInfo(sourceClass, "checkOutBoxAndSendToServer",
              "Continuing with other outObjects...");
          continue;
        }
      } else {
        outObjectData = OutObjectData(
            lid: outObjectData.lid,
            timestamp: outObjectData.timestamp,
            objectStatus: outObjectData.objectStatus,
            syncStatus: outObjectData.syncStatus,
            functionName: outObjectData.functionName,
            beName: outObjectData.beName,
            beHeaderLid: outObjectData.beHeaderLid,
            requestType: outObjectData.requestType,
            syncType: outObjectData.syncType,
            conversationId: outObjectData.conversationId,
            messageJson: outObjectData.messageJson,
            companyNameSpace: outObjectData.companyNameSpace,
            sendStatus: outObjectData.sendStatus,
            fieldOutObjectStatus:
                OutObjectStatus.lockedForSending.index.toString(),
            // Update status to LOCKED_FOR_SENDING,
            isAdminServices: outObjectData.isAdminServices);
      }
      try {
        await frameworkDatabaseIsolate!.updateOutObject(outObjectData);
      } catch (e) {
        Logger.logError(sourceClass, "checkOutBoxAndSendToServer",
            "Cannot update outObject into DB LID : ${outObjectData.lid}");
        if (i == (outObjectList.length - 1)) {
          await updateOutObjectProcessingError(
              outObjectData, frameworkDatabaseIsolate!);
          stopOutBox(map);
          return;
        } else {
          await updateOutObjectProcessingError(
              outObjectData, frameworkDatabaseIsolate!);
          Logger.logInfo(sourceClass, "checkOutBoxAndSendToServer",
              "Continuing with other outObjects...");
          continue;
        }
      }

      try {
        if (outObjectData.isAdminServices) {
          http.Response result = await HTTPConnection.makeAdminServicesCall(
              outObjectData.messageJson,
              selectedAccount: _selectedAccount,
              appNameInput: appName,
              authToken: authToken);
          if (result.statusCode == Status.httpOk ||
              result.statusCode == Status.httpCreated) {
            await deleteOutObject(outObjectData);
          } else {
            Logger.logError(sourceClass, "checkOutBoxAndSendToServer",
                "Error In making admin services call, error message : ${result.body}");
          }
        } else {
          String inputData = "";
          try {
            const start = "&$QueryParamInputMessage=";
            const end = "&$QueryParamRequestType=";

            final startIndex = outObjectData.messageJson.indexOf(start);
            final endIndex = outObjectData.messageJson
                .indexOf(end, startIndex + start.length);
            inputData = outObjectData.messageJson.substring(
                startIndex + start.length,
                endIndex); // Get only the input message data from the request string
          } catch (e) {
            Logger.logError(sourceClass, "checkOutBoxAndSendToServer",
                "Error when processing input message from outObject ${outObjectData.toJson().toString()} EXCEPTION : ${e.toString()}");
            if (i == (outObjectList.length - 1)) {
              await updateOutObjectProcessingError(
                  outObjectData, frameworkDatabaseIsolate!);
              stopOutBox(map);
              return;
            } else {
              await updateOutObjectProcessingError(
                  outObjectData, frameworkDatabaseIsolate!);
              Logger.logInfo(sourceClass, "checkOutBoxAndSendToServer",
                  "Continuing with other outObjects...");
              continue;
            }
          }
          try {
            await addOutBoxData(outboxPath, _selectedAccount,
                outObjectData.beHeaderLid, inputData);
          } catch (e) {
            Logger.logError(sourceClass, "checkOutBoxAndSendToServer",
                "Failed to add outbox data to hive BE Header LID ${outObjectData.beHeaderLid} INPUT DATA - ${inputData}");
            if (i == (outObjectList.length - 1)) {
              await updateOutObjectProcessingError(
                  outObjectData, frameworkDatabaseIsolate!);
              stopOutBox(map);
              return;
            } else {
              Logger.logInfo(sourceClass, "checkOutBoxAndSendToServer",
                  "Continuing with other outObjects...");
              continue;
            }
          }
          if (outObjectData.requestType == RequestType.rqst.toString() ||
              outObjectData.requestType == RequestType.req.toString()) {
            if (!kIsWeb) {
              await checkAndUploadAttachmentsInOutBox(
                  outObjectData.beName,
                  jsonDecode(inputData),
                  frameworkDatabaseIsolate!,
                  appDatabaseIsolate!,
                  _selectedAccount,
                  authToken,
                  appName,
                  appBaseUrl,
                  attachmentFolderPath,
                  appPath);
            }
          }

          http.Response result = await HTTPConnection.makeSyncCall(
              outObjectData.messageJson,
              selectedAccount: _selectedAccount,
              appNameInput: appName,
              authToken: authToken);

          int statusCode = result.statusCode;
          Logger.logDebug(
              sourceClass,
              "checkOutBoxAndSendToServer",
              "DataSender submitRequest: " +
                  statusCode.toString() +
                  " InputQuery : " +
                  outObjectData.messageJson);

          outObjectData = OutObjectData(
              lid: outObjectData.lid,
              timestamp: outObjectData.timestamp,
              objectStatus: outObjectData.objectStatus,
              syncStatus: outObjectData.syncStatus,
              functionName: outObjectData.functionName,
              beName: outObjectData.beName,
              beHeaderLid: outObjectData.beHeaderLid,
              requestType: outObjectData.requestType,
              syncType: outObjectData.syncType,
              conversationId: outObjectData.conversationId,
              messageJson: outObjectData.messageJson,
              companyNameSpace: outObjectData.companyNameSpace,
              sendStatus: outObjectData.sendStatus,
              fieldOutObjectStatus:
                  OutObjectStatus.none // Update status to NONE
                      .toString(),
              isAdminServices: outObjectData.isAdminServices);
          await frameworkDatabaseIsolate!.updateOutObject(outObjectData);

          switch (statusCode) {
            case Status.httpCreated:
              await handleSuccess(result, outObjectData, map);
              break;
            case Status.httpNoContent:
              await handleSuccess(result, outObjectData, map);
              break;
            case 0:
              await handleZeroResponse(result, outObjectData);
              break;
            // case 526: // TODO : Need to check how flutter works for certification update
            //   break;
            case Status.httpBadRequest: //400
            case Status.httpUnauthorized: //401
            case Status.httpForbidden: //403
            case Status.httpNotFound: //404
            case Status.httpNotAcceptable: //406
            case Status.httpUnsupportedMediaType: //415
              await handleServerError(result, outObjectData);
              break;

            case Status.httpGone: //410
              await handleServerError(result, outObjectData);
              break;

            default:
              await handleServerError(result, outObjectData);

              break;
          }
        }
      } catch (e) {
        Logger.logError(sourceClass, "checkOutBoxAndSendToServer",
            "Exception when processing outObject ${outObjectData.lid} ${outObjectData.toJson().toString()} MESSAGE : ${e.toString()}");
        if (i == (outObjectList.length - 1)) {
          await updateOutObjectProcessingError(
              outObjectData, frameworkDatabaseIsolate!);
          stopOutBox(map);
          return;
        } else {
          await updateOutObjectProcessingError(
              outObjectData, frameworkDatabaseIsolate!);
          Logger.logInfo(sourceClass, "checkOutBoxAndSendToServer",
              "Continuing with other outObjects...");
          continue;
        }
      }

      if (i == (outObjectList.length - 1)) {
        Logger.logDebug(sourceClass, "checkOutBoxAndSendToServer",
            "Rechecking outbox for new items.");
        List<OutObjectData> lockedOutObjectList =
            (await frameworkDatabaseIsolate!.allOutObjects)
                .where(
                    (element) => element.beHeaderLid == SyncEngine().lockedLid)
                .toList();
        List<OutObjectData> outObjectList =
            (await frameworkDatabaseIsolate!.allOutObjects);
        if (lockedOutObjectList.isNotEmpty) {
          outObjectList = outObjectList
              .where((element) =>
                  element.timestamp < lockedOutObjectList[0].timestamp)
              .toList();
        }
        if (outObjectList.isNotEmpty) {
          Logger.logDebug(sourceClass, "checkOutBoxAndSendToServer",
              "Found ${outObjectList.length.toString()} new items in outbox.");
          await makeNetworkCallWithOutObject(
              outObjectList,
              _selectedAccount,
              appName,
              authToken,
              map,
              appBaseUrl,
              attachmentFolderPath,
              outboxPath,
              appPath);
        } else {
          Logger.logDebug(sourceClass, "checkOutBoxAndSendToServer",
              "No items in out box. Stopping the outbox service.");
          stopOutBox(map);
        }
      }
    }
  } else {
    Logger.logDebug(sourceClass, "checkOutBoxAndSendToServer",
        "No items in out box. Stopping the outbox service.");
    stopOutBox(map);
  }
}

handleServerError(Response result, OutObjectData outObjectData) async {
  dynamic responseObject =
      jsonDecode(jsonDecode(result.body.replaceAll('\"', '"')));
  // dynamic copiedResponse = jsonDecode(jsonEncode(responseObject));
  if (responseObject[KeyInfoMessage] != null) {
    var infoMessages = responseObject[KeyInfoMessage];
    if (infoMessages.length > 0) {
      //FrameworkHelper.cleanUpInfoMessages();
      for (Map<String, dynamic> element in infoMessages) {
        String category = element[FieldInfoMessageCategory];
        String message =
            element[FieldInfoMessageMessage] ?? "UNI_RESPONSE_ERROR_500_503";
        createInfoMessage(outObjectData, message, category);
      }
    }
    DartNotificationCenter.post(
        channel: EventNameSystemError, options: responseObject);
  } else if (responseObject[KeyError] != null) {
    Map<String, dynamic> data = {
      EventFieldError: responseObject[KeyError].toString(),
    };

    DartNotificationCenter.post(channel: EventNameSystemError, options: data);
  }

  await deleteOutObject(outObjectData);
}

Future<void> handleZeroResponse(
  Response result,
  OutObjectData outObjectData,
) async {
  int responseCode = result.statusCode;
  String errorMessage = getResponseText(responseCode);

  Logger.logError(
      sourceClass,
      "handleZeroResponse",
      "HTTP response error. Response code: " +
          responseCode.toString() +
          " Response message: " +
          errorMessage);
  await createInfoMessage(outObjectData, errorMessage, InfoMessageFailure);
  await deleteOutObject(outObjectData);
}

Future<void> handleSuccess(Response result, OutObjectData outObjectData,
    Map<String, dynamic> map) async {
  // For async requests the conversation id has to be stored in sent
  // items and cleared from outbox as the client is waiting for a response for its request
  if (outObjectData.syncType == SyncType.ASYNC.toString()) {
    String? conversationId =
        result.headers[HeaderConstantConversationId.toLowerCase()];
    int isConversationIdPresent = (await frameworkDatabaseIsolate!.allSentItems)
        .indexWhere((element) => element.conversationId == conversationId);

    if (conversationId == null) {
      Logger.logError(sourceClass, "handleSuccess",
          "Conversation Id empty in http header fields");
      await deleteOutObjectAndCreateInfoMessage(
        outObjectData,
        "Conversation id not available in response. Deleting out object.",
      );
      return;
    }

    Logger.logInfo(
        sourceClass, "handleSuccess", "Conversation Id: ${conversationId}");

    if (isConversationIdPresent != (-1)) {
      Logger.logError(sourceClass, "handleSuccess",
          "Conversation Id already present in sent items...ignoring ${outObjectData.toJson().toString()}");
      return;
    }
    await deleteOutObject(outObjectData);
    if (outObjectData.requestType == RequestType.rqst.toString()) {
      List<StructureMetaData> structureMetas =
          await frameworkDatabaseIsolate!.allStructureMetas;
      StructureMetaData? structureMeta = structureMetas.firstWhereOrNull(
          (element) => element.structureName == outObjectData.beName);

      // Invalid condition. Should never occur.
      if (structureMeta == null) {
        Logger.logError(sourceClass, "handleSuccess",
            "Invalid BE. Cannot Upload Attachments. Table Name: ${outObjectData.beName}");
        return;
      }
      bool isAttachmentSupported = await isAttachmentSupportedForBEName(
          structureMeta.beName, frameworkDatabaseIsolate!);
      String attachmentFlag = "";
      if (isAttachmentSupported) {
        attachmentFlag = "X";
      }
      try {
        SentItem sentItem = SentItem(
            lid: FrameworkHelper.getUUID(),
            timestamp: DateTime.now().millisecondsSinceEpoch,
            objectStatus: 0,
            syncStatus: 0,
            beName: outObjectData.beName,
            beHeaderLid: outObjectData.beHeaderLid,
            conversationId: conversationId,
            entryDate: DateTime.now().millisecondsSinceEpoch.toString(),
            attachmentFlag: attachmentFlag);

        await frameworkDatabaseIsolate!.addSentItem(sentItem);

        int inboxCount = (await frameworkDatabaseIsolate!.allInObjects).length;
        int outboxCount =
            (await frameworkDatabaseIsolate!.allOutObjects).length;
        int sentItemsCount =
            (await frameworkDatabaseIsolate!.allSentItems).length;

        Map<String, dynamic> data = {
          EventSyncStatusFieldType: EventSyncStatusTypeSent,
          EventFieldData: {
            EventFieldBeName: outObjectData.beName,
            EventFieldBeLid: outObjectData.beHeaderLid
          },
          EventSyncStatusFieldInboxCount: inboxCount,
          EventSyncStatusFieldOutboxCount: outboxCount,
          EventSyncStatusFieldSentItemsCount: sentItemsCount
        };
        notifyOutBox(data, map);
      } catch (e) {
        Logger.logError(
            sourceClass,
            "handleSuccess",
            "Exception caught while adding sent item object to database. Deleting out object. OutObject LID: " +
                outObjectData.lid +
                ", " +
                e.toString());
        await deleteOutObjectAndCreateInfoMessage(
            outObjectData,
            "Exception caught while adding sent item object to database. Deleting out object. OutObject LID: " +
                outObjectData.lid +
                ", " +
                e.toString());
        return;
      }
    } else if (outObjectData.requestType == RequestType.req.toString()) {
      int inboxCount = (await frameworkDatabaseIsolate!.allInObjects).length;
      int outboxCount = (await frameworkDatabaseIsolate!.allOutObjects).length;
      int sentItemsCount =
          (await frameworkDatabaseIsolate!.allSentItems).length;

      Map<String, dynamic> data = {
        EventSyncStatusFieldType: EventSyncStatusTypeSent,
        EventFieldData: {
          EventFieldBeName: outObjectData.beName,
          EventFieldBeLid: outObjectData.beHeaderLid
        },
        EventSyncStatusFieldInboxCount: inboxCount,
        EventSyncStatusFieldOutboxCount: outboxCount,
        EventSyncStatusFieldSentItemsCount: sentItemsCount
      };
      notifyOutBox(data, map);
      await updateOutObjectBEWithGlobalStatus(outObjectData);
    } else {
      int inboxCount = (await frameworkDatabaseIsolate!.allInObjects).length;
      int outboxCount = (await frameworkDatabaseIsolate!.allOutObjects).length;
      int sentItemsCount =
          (await frameworkDatabaseIsolate!.allSentItems).length;

      Map<String, dynamic> data = {
        EventSyncStatusFieldType: EventSyncStatusTypeSent,
        EventFieldData: {
          EventFieldBeName: outObjectData.beName,
          EventFieldBeLid: outObjectData.beHeaderLid
        },
        EventSyncStatusFieldInboxCount: inboxCount,
        EventSyncStatusFieldOutboxCount: outboxCount,
        EventSyncStatusFieldSentItemsCount: sentItemsCount
      };
      notifyOutBox(data, map);
    }
  } else {
    await deleteOutObject(outObjectData);
  }
}

Future<void> updateOutObjectBEWithGlobalStatus(
    OutObjectData outObjectData) async {
  //Database appDb = await getAppDb(appDbPath);
  //FrameworkDatabase fwDb = await getFwDb(fwDbPath);
  StructureMetaData? structureMetaData = await frameworkDatabaseIsolate!
      .getStructureMetaFromBeName(outObjectData.beName);
  if (structureMetaData != null) {
    String structName = structureMetaData.structureName;
    String queryString =
        "SELECT * FROM $structName WHERE $FieldLid = '${outObjectData.beHeaderLid}'";
    Selectable<QueryRow>? data;
    try {
      data = await appDatabaseIsolate!.customSelect(queryString);
    } catch (e) {
      Logger.logError(sourceClass, "updateOutObjectBEWithGlobalStatus",
          "DBException caught when querying $structName: " + e.toString());
    }
    List<Map<String, dynamic>> result = [];

    if (data != null) {
      List<QueryRow> list = await data.get().then((value) {
        return value;
      }, onError: (e) {
        Logger.logError(
            sourceClass,
            "updateOutObjectBEWithGlobalStatus",
            "Error when getting query row from Selectable.get : " +
                e.toString());
      });
      result = list.map((e) => e.data).toList();
    }

    if (result.isNotEmpty && result.length > 0) {
      Map<String, dynamic> data = result[0];
      data[FieldSyncStatus] = SyncStatus.none.index.toString();
      String queryHeader =
          "UPDATE $structName SET $FieldSyncStatus = ${SyncStatus.none.index}, $FieldInfoMsgCat = '' WHERE $FieldLid='${data[FieldLid]}';";
      await appDatabaseIsolate!.transaction(() async {
        return await appDatabaseIsolate!.customStatement(queryHeader);
      });
      List<StructureMetaData> childStructureMetas =
          (await frameworkDatabaseIsolate!.allStructureMetas)
              .where((element) =>
                  element.beName == structureMetaData.beName &&
                  element.isHeader != "1")
              .toList();

      for (StructureMetaData childStructureMetaData in childStructureMetas) {
        String query =
            "UPDATE ${childStructureMetaData.structureName} SET $FieldSyncStatus = ${SyncStatus.none.index} WHERE $FieldFid='${data[FieldLid]}' AND $FieldObjectStatus <> ${ObjectStatus.global.index};";
        await appDatabaseIsolate!.transaction(() async {
          return await appDatabaseIsolate!.customStatement(query);
        });
      }
    }
  }
}

deleteOutObjectAndCreateInfoMessage(
    OutObjectData? outObjectData, String message) async {
  if (outObjectData != null) {
    await deleteOutObject(outObjectData);
    // try {
    // List<int> list = utf8.encode(
    //     outObjectData.messageJson); // TODO: In android this field is optional
    // Uint8List bytes = Uint8List.fromList(list);
    // InfoMessageData infoMessageData = InfoMessageData(
    //     lid: FrameworkHelper.getUUID(),
    //     timestamp: DateTime.now().millisecondsSinceEpoch,
    //     objectStatus: 0,
    //     syncStatus: 0,
    //     type: "type",
    //     subtype: "subtype",
    //     category: InfoMessageError,
    //     message:
    //         "Function:" + outObjectData.functionName + ". Message:" + message,
    //     bename: outObjectData.beName,
    //     belid: outObjectData.beHeaderLid,
    //     messagedetails: bytes);
    //
    // await frameworkDatabaseIsolate!.addInfoMessage(infoMessageData);
    // } catch (e) {
    //   Logger.logError(className, "deleteOutObjectAndCreateInfoMessage",
    //       "DBException caught while inserting Info Message: " + e.toString());
    // }
  }
}

Future<void> updateOutObjectProcessingError(OutObjectData outObjectData,
    FrameworkDatabase frameworkDatabaseIsolate) async {
  OutObjectData outObject = OutObjectData(
      lid: outObjectData.lid,
      timestamp: outObjectData.timestamp,
      objectStatus: outObjectData.objectStatus,
      syncStatus: outObjectData.syncStatus,
      functionName: outObjectData.functionName,
      beName: outObjectData.beName,
      beHeaderLid: outObjectData.beHeaderLid,
      requestType: outObjectData.requestType,
      syncType: outObjectData.syncType,
      conversationId: outObjectData.conversationId,
      messageJson: outObjectData.messageJson,
      companyNameSpace: outObjectData.companyNameSpace,
      sendStatus: outObjectData.sendStatus,
      fieldOutObjectStatus: OutObjectStatus.errorOnProcessing.index.toString(),
      // Update status to LOCKED_FOR_SENDING,
      isAdminServices: outObjectData.isAdminServices);
  await frameworkDatabaseIsolate.updateOutObject(outObject);

  await OutBoxHelper().updateSyncStatusToEntityObjects(
      outObject: outObject, syncStatus: SyncStatus.error);
}

Future<void> createInfoMessage(
    OutObjectData? outObjectData, String errorMessage, String category) async {
  List<int> list = utf8.encode(
      outObjectData!.messageJson); // TODO: In android this field is optional
  Uint8List bytes = Uint8List.fromList(list);

  InfoMessageData infoMessageData = InfoMessageData(
      lid: FrameworkHelper.getUUID(),
      timestamp: DateTime.now().millisecondsSinceEpoch,
      objectStatus: ObjectStatus.global.index,
      syncStatus: SyncStatus.none.index,
      type: "",
      subtype: "",
      category: category,
      message: "Function:" +
          outObjectData.functionName +
          ". Message:" +
          errorMessage,
      bename: outObjectData.beName,
      belid: outObjectData.beHeaderLid,
      messagedetails: bytes);

  //FrameworkDatabase frameworkDatabase = await getFwDb(fwDbPath);
  await frameworkDatabaseIsolate!.addInfoMessage(infoMessageData);
}

Future<int?> deleteOutObject(OutObjectData? outObjectData) async {
  Logger.logDebug(
      sourceClass,
      "deleteOutObject",
      "Deleting outobject " +
          " outobject lid : " +
          outObjectData!.lid +
          "  ConversationId: " +
          outObjectData.conversationId);
  if (outObjectData != null) {
    int? isDeleted =
        await frameworkDatabaseIsolate!.deleteOutObject(outObjectData);

    Logger.logDebug(
        sourceClass,
        'deleteOutObject',
        "Deleted  ConversationId: " +
            outObjectData.conversationId +
            " isDeleted: " +
            (isDeleted ?? -1).toString());
    return isDeleted;
  }
}

String getResponseText(int responseCode) {
  String text = "";

  switch (responseCode) {
    case 0:
    case -1:
      text = "Cannot connect to server. Please try again later.";
      break;

    case 200:
      text = "Successful.";
      break;

    case 204:
      text =
          "No content. The server successfully processed the request, but is not returning any content.";
      break;

    case 400:
      text =
          "Bad request. The request could not be understood by the server due to malformed syntax.";
      break;

    case 401:
      text = "Unauthorized request. The request requires user authentication.";
      break;

    case 403:
      text =
          "Forbidden. The server understood the request, but is refusing to fulfill it.";
      break;

    case 404:
      text =
          "Not found. The server has not found anything matching the Request-URI.";
      break;

    case 405:
      text =
          "Method not allowed. The method specified in the Request-Line is not allowed for the resource identified by the Request-URI.";
      break;

    case 406:
      text = "Not acceptable.";
      break;

    case 407:
      text = "Proxy authentication required.";
      break;

    case 408:
      text =
          "Request timeout. The client did not produce a request within the time that the server was prepared to wait.";
      break;

    case 410:
      text =
          "Gone. The requested resource is no longer available at the server and no forwarding address is known.";
      break;

    case 500:
      text =
          "Internal server error. The server encountered an unexpected condition which prevented it from fulfilling the request.";
      break;

    case 501:
      text =
          "Not implemented. The server does not support the functionality required to fulfill the request.";
      break;

    case 502:
      text =
          "Bad gateway. The server, while acting as a gateway or proxy, received an invalid response from the upstream server it accessed in attempting to fulfill the request.";
      break;

    case 503:
      text =
          "Service unavailable. The server is currently unable to handle the request due to a temporary overloading or maintenance of the server.";
      break;

    case 504:
      text =
          "Gateway timeout. The server, while acting as a gateway or proxy, did not receive a timely response from the upstream server specified by the URI.";
      break;

    case 505:
      text =
          "HTTP version not supported. The server does not support, or refuses to support, the HTTP protocol version that was used in the request message.";
      break;

    default:
      break;
  }

  return text;
}
