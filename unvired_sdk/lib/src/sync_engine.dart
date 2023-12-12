import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:unvired_sdk/src/database/database.dart';
import 'package:unvired_sdk/src/helper/connectivity_manager.dart';
import 'package:unvired_sdk/src/helper/event_handler_constants.dart';
import 'package:unvired_sdk/src/helper/notifications_helper.dart';
import 'package:unvired_sdk/src/inbox/inbox_handler.dart';
import 'package:unvired_sdk/src/notification_center/dart_notification_center.dart';

import 'application_meta/field_constants.dart';
import 'attachment/attachment_downloader.dart';
import 'authentication_service.dart';
import 'database/app_database_manager.dart';
import 'database/database_manager.dart';
import 'database/framework_database.dart';
import 'helper/framework_helper.dart';
import 'helper/getmessage_timer_manager.dart';
import 'helper/http_connection.dart';
import 'helper/server_response_handler.dart';
import 'helper/service_constants.dart';
import 'helper/status.dart';
import 'helper/sync_input_data_manager.dart';
import 'helper/sync_result.dart';
import 'helper/url_service.dart';
import 'inbox/download_message_service.dart';
import 'outbox/outbox_helper.dart';
import 'outbox/outbox_service.dart';
import 'unvired_account.dart';
import 'helper/settings_helper.dart';

enum OutboxLockResult { LockApplied, DataBeingSent, DataNotInQueue }

enum RequestType { rqst, pull, pulld, push, query, req }

enum InputType { standard, custom }

enum SyncType { ASYNC, SYNC }

Batch? batch;
UnviredAccount? selectedAccount;

class SyncBEResponse {
  late int httpResponseCode;
  late List<dynamic> infoMessages;
  late dynamic dataBEs;
  late List<dynamic> beMetaData;
  late bool autoSave;
}

abstract class ConflictHandler {
  void handleConflict(List<dynamic> conflictBEs);
}

class SyncEngine {
  // static final SyncEngine _syncEngine = SyncEngine._internal();
  //
  // factory SyncEngine() {
  //   return _syncEngine;
  // }
  //
  // SyncEngine._internal();

  RequestType _reqtype = RequestType.rqst;
  bool _autoSave = true;
  bool _isAsynchronous = false;
  InputType _inputType = InputType.standard;
  bool _isSensitive = false;

  ConflictHandler? _conflictHandler;
  static String? _lockedLid;
  bool _isReceivingMessages = false;

  var connectionSubscribe;

  /// Specify the type of the request for making api call.
  ///
  /// Default value is 'RequestType.rqst'
  ///
  /// **Usage:**
  /// ```dart
  ///   SyncEngine()..setRequestType(RequestType.rqst);
  /// ```
  void setRequestType(RequestType reqType) {
    this._reqtype = reqType;
  }

  /// Specify the lid to block from syncing to server during an async call.
  ///
  /// Default value is 'null'
  ///
  /// **Usage:**
  /// ```dart
  ///   SyncEngine().lockBe(beName);
  /// ```
  void lock(String lid) {
    _lockedLid = lid;
  }

  void unlock() {
    _lockedLid = null;
  }

  String? get lockedLid {
    return _lockedLid;
  }

  /// Flag to indicate if auto save is required. If autoSave is true the data is auto saved in the database. Pass true if auto save is required and flase otherwise.
  ///
  /// Default value is 'true'
  ///
  /// **Usage:**
  /// ```dart
  ///   SyncEngine()..isAutoSave(true);
  /// ```
  void isAutoSave(bool autoSave) {
    this._autoSave = autoSave;
  }

  /// Flag to indicate if the request to send in Synchronour or Asynchronous. Pass true if you want to make Asynchronous api call and false otherwise.
  ///
  /// Default value is 'false'
  ///
  /// **Usage:**
  /// ```dart
  ///   SyncEngine()..isAsynchronous(false);
  /// ```
  void isAsynchronous(isAsync) {
    this._isAsynchronous = isAsync;
  }

  /// Specify the type of the Input data. Set one of the values from InputType enum.
  ///
  /// Default value is 'InputType.standard'
  ///
  /// **Usage:**
  /// ```dart
  ///   SyncEngine()..setInputType(InputType.standard);
  /// ```
  void setInputType(InputType inputType) {
    this._inputType = inputType;
  }

  /// Flag to indicate if the input data is sensitive. Pass true if the server don't want to save the data.
  ///
  /// Default value is 'false'
  ///
  /// **Usage:**
  /// ```dart
  ///   SyncEngine()..setSensitive(false);
  /// ```
  void setSensitive(bool isSensitive) {
    this._isSensitive = isSensitive;
  }

  /// Specify the class which implements ConflixtHandler protocol.
  ///
  /// **Usage:**
  /// ```dart
  ///   SyncEngine()..setConflictHandler(this);
  /// ```
  void setConflictHandler(ConflictHandler conflictHandler) {
    this._conflictHandler = conflictHandler;
  }

  /// Get ConflixtHandler protocol object.
  ///
  /// **Usage:**
  /// ```dart
  ///   SyncEngine().getConflictHandler();
  /// ```
  ConflictHandler? getConflictHandler() {
    return this._conflictHandler;
  }

  /// Starts the get message timer.
  ///
  /// **Usage:**
  /// ```dart
  ///   SyncEngine()..initialize();
  /// ```
  initialize() async {
    if (getPlatform() == PlatformType.android ||
        getPlatform() == PlatformType.ios) {
      if (!kIsWeb) {
        connectionSubscribe = Connectivity()
            .onConnectivityChanged
            .listen((ConnectivityResult result) async {
          OutBoxHelper().checkOutboxAndStartService();
          DownloadMessageService().checkAndStartDownloadMessageService();
        });
        bool connectionStatus = await ConnectivityManager().checkConnection();
        if (connectionStatus) {
          Logger.logInfo(
              "SyncEngine", "initialize", "Registering Notification...");
          await NotificationHelper().registerNotification();
          Database appDb = await DatabaseManager().getAppDB();
          appDb.doWhenOpened((e) async {
            FrameworkDatabase fwDb = await DatabaseManager().getFrameworkDB();
            fwDb.doWhenOpened((e) async {
              OutBoxHelper().checkOutboxAndStartService();
              InboxHandler().start();
              SyncEngine().receive();
              GetMessageTimerManager().startTimer();
            });
          });
        } else {
          Database appDb = await DatabaseManager().getAppDB();
          FrameworkDatabase fwDb = await DatabaseManager().getFrameworkDB();
          await SettingsHelper()
              .setFetchInterval(AuthenticationService().getMessageInterval());
          GetMessageTimerManager().startTimer();
        }
      } else {
        await NotificationHelper().registerNotification();
        Database appDb = await DatabaseManager().getAppDB();
        appDb.doWhenOpened((e) async {
          FrameworkDatabase fwDb = await DatabaseManager().getFrameworkDB();
          fwDb.doWhenOpened((e) async {
            OutBoxHelper().checkOutboxAndStartService();
            InboxHandler().start();
            SyncEngine().receive();
            GetMessageTimerManager().startTimer();
          });
        });
      }
    }
  }

  /// Exchange data with the server in synchronous or asynchronous mode. Synchronous
  /// communication requires an active connection between the mobile
  /// application on the device and the server (and in turn to the enterprise
  /// backend system, if required). Synchronous communication is a blocking
  /// call till is response is obtained.
  ///
  /// Asynchronous mode. Add the data to the queue to be sent to the server.
  /// Exchange of data between the mobile
  /// application on the device and the server is done in two request-response
  /// cycles. Data from the mobile application on the device is queued to be
  /// the sent to the server. When the connectivity to the server is available
  /// the data is submitted to the server. Server responds with an
  /// acknowledgment. Server submits the data to the backend system. Once the
  /// response is available from the backend server the response is pushed /
  /// sent to the application. Once the data is sent to
  /// the application, the data is stored in the database.
  /// Asynchronous communication allows users to use the application in a
  /// non-blocking manner without bothering about connectivity. Also the server
  /// can submit the data from the mobile application on the device to the
  /// backend server in a delayed manner to accommodate backend server load.
  ///
  ///
  /// Use this method for 0:n BE exchange with the server i.e. for search /
  /// query scenarios. Input for the server process agent is optional. Process
  /// agents on the server can send 0 to n BEs.
  ///
  /// If autoSave is true the data is auto saved in the database.
  ///
  /// SyncResult is provided as the response with status code and response JSON object data.
  /// The JSON object data in SyncResult is saved automatically if autoSave flag is
  /// set to true. Otherwise the JSON object data are provided to the caller for action.
  ///
  /// **@param** [paName]
  ///            Name of the process agent that is required to be called in the
  ///            server.
  ///           Eg: UNVIRED_HYBRID_TEST_PA_GET_RESULT
  ///
  /// **@param** [dataObject]
  ///            JSON Object which will have the key as a entity name and value as a json object containing lid.
  ///            Format: { "CUSTOMER_HEADER" : {"LID": "9e204c57-0354-49b2-adc3-011def20f2f5"}}
  ///
  /// **Usage:**
  /// ```dart
  ///   try {
  ///     // Example 1:
  ///     Result respone = SyncEngine().sent("UNVIRED_HYBRID_TEST_PA_GET_RESULT");
  ///     // Example 2:
  ///     Result respone = SyncEngine().sent("UNVIRED_HYBRID_TEST_PA_GET_RESULT", { "CUSTOMER_HEADER" : {"LID": "9e204c57-0354-49b2-adc3-011def20f2f5"}});
  ///   } catch (e) {
  ///   }
  /// ```
  Future<Result> send(
      {String? umpApplicationFunctionName,
      Map<String, dynamic>? dataObject}) async {
    return await _handleSend(umpApplicationFunctionName!,
        dataObject: dataObject);
  }

  /// Receive queued messages from the server.
  ///
  /// **Usage:**
  /// ```dart
  ///   SyncEngine().receive()
  /// ```
  Future<void> receive() async {
    await DownloadMessageService().checkAndStartDownloadMessageService();
  }

  /// Queue an attachment for download.
  ///
  ////// **@param** [attachmentTableName]
  ///            Name of the Attachment table.
  ///            Eg: ATTACHMENT_ITEM
  ///
  /// **@param** [lid]
  ///            lid of the ATTACHMENT_ITEM which needs to be queued for download.
  ///            Eg: "9e204c57-0354-49b2-adc3-011def20f2f5"
  ///
  /// **Usage:**
  /// ```dart
  ///   SyncEngine().downloadAttachmentAsync("ATTACHMENT_ITEM", "12qslkad12sdfjsndfj");
  /// ```
  Future<bool> downloadAttachmentAsync(
      String attachmentTableName, String lid) async {
    return await _handleDownloadAttachmentAsync(attachmentTableName, lid);
  }

  // Private Functions

  Future<Result> _handleSend(String paName,
      {Map<String, dynamic>? dataObject}) async {
    if ((await AuthenticationService().getSelectedAccount())!
        .getIsDemoLogin()) {
      return Result(201, {});
    }
    if (dataObject == null) {
      dataObject = {};
    }
    if (paName.isEmpty) {
      throw ("Process agent function name is mandatory.");
    }
    if (lockedLid == null) {
      Logger.logDebug("SyncEngine", "send", "NO BE LOCKED");
    } else {
      Logger.logDebug("SyncEngine", "send", "BE LOCKED ${lockedLid}");
    }

    //Iterable<String> keys = dataObject.keys;
    if (_reqtype != RequestType.pull &&
        _inputType == InputType.standard &&
        (dataObject[FieldTableName] == null ||
            dataObject[FieldTableName].toString().isEmpty)) {
      throw ("Invalid Input data.");
    }
    String entityName = dataObject[FieldTableName] ?? "";
    //Map<String,dynamic> value = dataObject[entityName].toString() == "{}" ? {} : dataObject[entityName];
    Map<String, dynamic> inputDataObject = dataObject;

    if (_isAsynchronous) {
      Logger.logDebug("SyncEngine", "send", "making async call $paName");
      var result = await _sendAsync(inputDataObject, paName, entityName);
      return result;
    } else {
      Logger.logDebug("SyncEngine", "send", "making sync call $paName");
      try {
        Map<String, dynamic> inputJson = inputDataObject;
        if (_inputType == InputType.standard) {
          if (_reqtype == RequestType.req || _reqtype == RequestType.rqst) {
            // Attachment is not supported  yet in the web.
            if (!kIsWeb) {
              await SyncInputDataManager.checkAndUploadAttachments(
                  entityName, inputJson);
            }
          }
          inputJson = await SyncInputDataManager.constructInputBeJson(
              entityName, inputDataObject);
        }
        String inputDataString =
            await _constructRequestString(paName, inputJson);
        if (!(await URLService.isInternetConnected())) {
          Logger.logDebug(
              "SyncEngine", "_handleSend", "Internet is not connected.");
          throw ("Internet is not connected.");
        }

        if (!(await HTTPConnection.isServerReachable())) {
          Logger.logDebug("SyncEngine", "_handleSend", "Server not reachable.");
          throw ("Server not reachable.");
        }
        http.Response result =
            await HTTPConnection.makeSyncCall(inputDataString);
        dynamic responseObject;
        if (result.statusCode == Status.httpOk ||
            result.statusCode == Status.httpCreated) {
          responseObject =
              jsonDecode(jsonDecode(result.body.replaceAll('\"', '"')));
          dynamic copiedResponse = jsonDecode(jsonEncode(responseObject));
          //Database appDb = await DatabaseManager().getAppDB();
          // await appDb.transaction(() async {
          await ServerResponseHandler.handleResponseData(copiedResponse ?? {},
              autoSave: _autoSave,
              lid: inputDataObject[FieldLid] ?? "",
              entityName: entityName,
              isForeground: true,
              requestType: _reqtype);
          //});
        } else {
          responseObject = jsonDecode(result.body);
          if (responseObject["systemError"] != null &&
              responseObject["systemError"] == 13) {
            await SettingsHelper().clearData();
          } else {
            await _handleInfoMessage(responseObject ?? {},
                inputDataObject[FieldLid] ?? "", entityName);
          }
        }

        // Map<String, dynamic> resp = {};
        // if (responseObject[KeyInfoMessage] != null) {
        //   resp[KeyInfoMessage] = responseObject[KeyInfoMessage];
        // }
        return Result(result.statusCode, responseObject);
      } catch (e) {
        throw e;
      }
    }
  }

  Future<String> _constructRequestString(
      String paName, Map<String, dynamic> dataObject) async {
    UnviredAccount? account =
        await AuthenticationService().getSelectedAccount();
    if (account == null) {
      Logger.logError("SyncEngine", "_constructRequestString",
          "Account data not available.");
      throw ("Account data not available.");
    }
    String dataString = dataObject.isEmpty ? "" : jsonEncode(dataObject);
    String inputData = dataString;
    //TODO : GZip compression
    // FrameworkSettingsManager frameworkSettingsManager =
    //     FrameworkSettingsManager();
    // String compressPostData = await frameworkSettingsManager
    //     .getFieldValue(FrameworkSettingsFields.compressPostData);
    // if (compressPostData == yes) {
    //   var stringBytes = utf8.encode(dataString);
    //   var gzipBytes = GZipEncoder().encode(stringBytes);
    //   var compressedString = base64.encode(gzipBytes!);
    //   inputData = compressedString;
    // }

    String queryString =
        "$paName?$QueryParamFrontendUser=${account.getFrontendId()}";
    if (inputData.length > 0) {
      queryString += "&$QueryParamInputMessage=$inputData";
    }

    String requestType = FrameworkHelper.getRequestTypeString(_reqtype);
    if (requestType.isNotEmpty) {
      queryString += "&$QueryParamRequestType=$requestType";
    }

    if (_inputType == InputType.custom) {
      queryString += "&$QueryParamMessageFormat=$MessageTypeCustom";
    }
    if (_isAsynchronous) {
      String externalRef = "${DateTime.now().millisecondsSinceEpoch}";
      queryString +=
          "&$QueryParamQueuedExecute=true&$QueryParamExternalReference=$externalRef";
    }
    if (_isSensitive) {
      queryString += "&$QueryParamSensitive=true";
    }

    FrameworkDatabase fwDb = await DatabaseManager().getFrameworkDB();
    List<SystemCredential> systemCredentials = await fwDb.allSystemCredentials;
    if (systemCredentials.length > 0) {
      List<Map<String, dynamic>> credDetails = [];
      for (SystemCredential cred in systemCredentials) {
        if (cred.userId.length > 0 && cred.password.length > 0) {
          Map<String, dynamic> details = {
            "port": cred.portName,
            "user": cred.userId,
            "password": cred.password
          };
          credDetails.add(details);
        }
      }
      if (credDetails.length > 0) {
        String credDetailsString = jsonEncode(credDetails);
        queryString += "&$QueryParamCredentials=$credDetailsString";
      }
    }
    var postParams = await HTTPConnection.getCommonPostParameters();
    postParams.forEach((k, v) =>
        (queryString += (queryString.length > 0 ? "&" : "") + "$k=$v"));
    // queryString += "&$ParamOneTimeToken=${postParams[ParamOneTimeToken]}";
    // queryString += "&$ParamMessageTime=${postParams[ParamMessageTime]}";

    return queryString;
  }

  Future<dynamic>? _sendAsync(
      Map<String, dynamic> dataObject, String paName, String entityName) async {
    try {
      Map<String, dynamic> inputJson = dataObject;
      if (_inputType == InputType.standard) {
        inputJson = await SyncInputDataManager.constructInputBeJson(
            entityName, dataObject);
      }
      String inputDataString = await _constructRequestString(paName, inputJson);

      switch (_reqtype) {
        case RequestType.pull:
        case RequestType.query:
          if (dataObject.isNotEmpty) {
            if (entityName.isEmpty) {
              Logger.logError(
                  "SyncEngine", "_sendAsync", "BE Name cannot be null");
              throw ("BE Name cannot be null");
            }
          }
          break;
        case RequestType.rqst:
          if (entityName.isEmpty) {
            Logger.logError(
                "SyncEngine", "_sendAsync", "BE Name cannot be null");
            throw ("BE Name cannot be null");
          }

          //TODO : Need to check this validation if it is required
          // BusinessEntityMetaData? businessEntityMeta = await DatabaseManager()
          //     .getFrameworkDB()
          //     .getBusinessEntityMetaFromBeName(entityName);

          // if (businessEntityMeta == null) {
          //   Logger.logError(
          //       "SyncEngine", "_sendAsync", "Invalid BE: " + entityName);
          //   throw ("Invalid BE: " + entityName);
          // }

          if (dataObject.isEmpty || dataObject[FieldLid].toString().isEmpty) {
            Logger.logError("SyncEngine", "_sendAsync",
                "BE LID cannot be null. BE name : " + entityName);
            throw ("BE LID cannot be null. BE name : " + entityName);
          }
          break;

        default:
          break;
      }

      OutObjectData outObjectData = OutObjectData(
          lid: FrameworkHelper.getUUID(),
          timestamp: DateTime.now().millisecondsSinceEpoch,
          objectStatus: ObjectStatus.global.index,
          syncStatus: SyncStatus.none.index,
          functionName: paName,
          beName: entityName,
          beHeaderLid: dataObject.isEmpty ? "" : dataObject[FieldLid],
          requestType: _reqtype.toString(),
          syncType: SyncType.ASYNC.toString(),
          conversationId: "",
          messageJson: inputDataString,
          companyNameSpace: "",
          sendStatus: "",
          fieldOutObjectStatus: OutObjectStatus.none.index.toString(),
          isAdminServices: false);
      await checkInOutBoxAndQueue(outObjectData);
    } catch (e) {
      throw ("Failed to add into Outbox ${e.toString()}");
    }
    return Result(Status.submittedToOutbox, {});
  }

  Future<void> _handleInfoMessage(
      Map<String, dynamic> responseData, String lid, String entityName) async {
    if (responseData.isNotEmpty) {
      //Save InfoMessages
      if (responseData[KeyInfoMessage] != null) {
        List<dynamic> infoMessages = responseData[KeyInfoMessage];
        for (Map<String, dynamic> element in infoMessages) {
          InfoMessageData infoMessage = InfoMessageData(
              lid: FrameworkHelper.getUUID(),
              timestamp: DateTime.now().millisecondsSinceEpoch,
              objectStatus: ObjectStatus.global.index,
              syncStatus: SyncStatus.none.index,
              type: "",
              subtype: "",
              category: element[FieldInfoMessageCategory],
              message: element[FieldInfoMessageMessage],
              bename: entityName,
              belid: lid,
              messagedetails: Uint8List(0));
          await (await DatabaseManager().getFrameworkDB())
              .addInfoMessage(infoMessage);
        }
      }
    }
  }

  Future<void> checkInOutBoxAndQueue(OutObjectData? entry) async {
    OutObjectData? outObject =
        await OutBoxHelper().checkIsInOutBox(entry!.beHeaderLid);

    if (outObject != null) {
      //Out object is  there in the table

      if (outObject.fieldOutObjectStatus ==
          OutObjectStatus.lockedForSending.toString()) {
        Logger.logError("SyncEngine", "_checkInOutBoxAndQueue",
            "Cannot modify. OutObject is locked for sending");
        return;
      }

      if (entry.functionName != outObject.functionName) {
        Logger.logError(
            "SyncEngine",
            "_checkInOutBoxAndQueue",
            "Cannot modify. OutObject is already queued for " +
                outObject.functionName.toString());
        return;
      }

      //Set the out object status to MODIFY
      OutObjectData outObjectData = OutObjectData(
          lid: outObject.lid,
          timestamp: outObject.timestamp,
          objectStatus: outObject.objectStatus,
          syncStatus: outObject.syncStatus,
          functionName: outObject.functionName,
          beName: outObject.beName,
          beHeaderLid: outObject.beHeaderLid,
          requestType: outObject.requestType,
          syncType: outObject.syncType,
          conversationId: outObject.conversationId,
          messageJson: outObject.messageJson,
          companyNameSpace: outObject.companyNameSpace,
          sendStatus: outObject.sendStatus,
          fieldOutObjectStatus: OutObjectStatus.lockedForModify.toString(),
          //Modify the status
          isAdminServices: outObject.isAdminServices);

      FrameworkDatabase fwDb = await DatabaseManager().getFrameworkDB();
      try {
        Logger.logDebug("SyncEngine", "_checkInOutBoxAndQueue",
            "Updating to outbox ${outObject.lid}");
        fwDb.updateOutObject(outObjectData);
      } catch (e) {
        Logger.logError("SyncEngine", "_checkInOutBoxAndQueue",
            "Update Failed, DBException: " + e.toString());
      }
      return;
    } else {
      //Out object is not there in the table
      outObject = entry;
    }

    SentItem? sentItem =
        await OutBoxHelper().checkIsInSentItems(outObject.beHeaderLid);
    if (sentItem != null) {
      Logger.logDebug("SyncEngine", "_checkInOutBoxAndQueue",
          "Sent to outbox ${outObject.lid}");

      //already in sent item
      String error =
          "Object already present in sent items. Cannot queue the same object twice. BE Name: " +
              outObject.beName +
              " Process Agent Name: " +
              outObject.functionName +
              " BE Name: " +
              outObject.beName +
              " BE Lid: " +
              outObject.beHeaderLid +
              " Data: " +
              outObject.messageJson;
      Logger.logError("SyncEngine", "_checkInOutBoxAndQueue", error);
      throw (error);
    }
    await OutBoxHelper().updateSyncStatusToEntityObjects(
        outObject: outObject, syncStatus: SyncStatus.queued);
    try {
      Logger.logDebug("SyncEngine", "_checkInOutBoxAndQueue",
          "Adding to outbox ${outObject.lid}");
      FrameworkDatabase fwDb = await DatabaseManager().getFrameworkDB();
      await fwDb.addOutObject(outObject);
      List<OutObjectData> outObjectList = await fwDb.allOutObjects;
      Logger.logDebug("SyncEngine", "_checkInOutBoxAndQueue",
          "Checking out box ${outObjectList.length.toString()}");
    } catch (e) {
      Logger.logError("SyncEngine", "_checkInOutBoxAndQueue",
          "Adding to outbox failed ${outObject.lid} ${e.toString()}");

      String error =
          "Exception while adding data structure to outbox. BE Name: " +
              outObject.beName +
              " Process Agent Name: " +
              outObject.functionName +
              " Exception: " +
              e.toString() +
              " Data: " +
              outObject.messageJson;
      Logger.logError("SyncEngine", "_checkInOutBoxAndQueue", error);
    }

    OutBoxHelper().checkOutboxAndStartService();
    return;
  }

  Future<bool> _handleDownloadAttachmentAsync(
      String attahcmentTableName, String lid) async {
    if (attahcmentTableName.length == 0) {
      throw ("Invalid input. attahcmentTableName is empty.");
    }
    if (lid.length == 0) {
      throw ("Invalid input. lid is empty.");
    }
    List<dynamic> attachmentItems = await AppDatabaseManager().select(
        DBInputEntity(attahcmentTableName, {})
          ..setWhereClause("$FieldLid = '$lid'"));
    if (attachmentItems.length > 0) {
      try {
        await AttachmentDownloader().queueForDownload(attahcmentTableName,
            attachmentItems[0], FwAttachmentForceDownloadPriority);
        await AttachmentDownloader().checkAndStartAttachmentService();
      } catch (e) {
        throw (e);
      }
      return true;
    }
    throw ("Unable to find the attachment item.");
  }
}
