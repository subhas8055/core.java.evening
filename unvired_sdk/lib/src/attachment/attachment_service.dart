import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:isolated_worker/isolated_worker.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:drift/isolate.dart';
import 'package:drift/drift.dart';
import 'package:http/http.dart' as http;

import '../database/database.dart';
import '../database/framework_database.dart';
import '../helper/event_handler_constants.dart';
import '../helper/http_connection.dart';
import '../helper/isolate_helper.dart';
import '../helper/path_manager.dart';
import '../helper/service_constants.dart';
import '../helper/settings_helper.dart';
import '../notification_center/dart_notification_center_base.dart';
import '../outbox/outbox_helper.dart';
import '../outbox/outbox_service.dart';
import '../sync_engine.dart';
import '../unvired_account.dart';
import '../helper/status.dart';

int? attachmentRetryCount;

class AttachmentService {
  static bool _isPaused = false;
  static bool _isRunning = false;
  static String _threadStatus = "";

  // Isolate? _isolate;

  static String get threadStatus => _threadStatus;

  static bool get isRunning => _isRunning;

  static bool get isPaused => _isPaused;

  String? _appBaseUrl;
  String? _attachmentFolderPath;
  String? _appName;
  String? _authToken;
  String? _appDirPath;
  UnviredAccount? _selectedAccount;
  SendPort? _driftIsolatePortAppDb;
  SendPort? _driftIsolatePortFrameWorkDb;

  AttachmentService({
    @required UnviredAccount? selectedAccount,
    @required String? appBaseUrl,
    @required String? attachmentFolderPath,
    @required String? appName,
    @required String? authToken,
    @required String? appDirPath,
    @required SendPort? driftIsolatePortAppDb,
    @required SendPort? driftIsolatePortFrameWorkDb,
  }) {
    this._selectedAccount = selectedAccount;
    this._appBaseUrl = appBaseUrl;
    this._attachmentFolderPath = attachmentFolderPath;
    this._appName = appName;
    this._authToken = authToken;
    this._appDirPath = appDirPath;
    this._driftIsolatePortAppDb = driftIsolatePortAppDb;
    this._driftIsolatePortFrameWorkDb = driftIsolatePortFrameWorkDb;
  }

  void start() async {
    if (isRunning) {
      String message = "AttachmentService is already running....";
      Logger.logError("AttachmentService", "start", message);
      throw (message);
    }
    Logger.logInfo("AttachmentService", "start", "Started attachment service");
    _threadStatus = ServiceThreadStatus.Running.toString();
    ReceivePort _receivePort = new ReceivePort();
    Map<String, dynamic> map = {
      "sendPort": _receivePort.sendPort,
      "unviredAccount": _selectedAccount,
      "appBaseUrl": _appBaseUrl,
      "appDirPath": _appDirPath,
      "attachmentFolderPath": _attachmentFolderPath,
      "appName": _appName,
      "authToken": _authToken,
      "driftIsolatePortAppDb": _driftIsolatePortAppDb,
      "driftIsolatePortFrameWorkDb": _driftIsolatePortFrameWorkDb
    };

    IsolatedWorker().run(checkAndDownloadAttachments, map);
    //_isolate = await Isolate.spawn(checkAndDownloadAttachments, map);
    _receivePort.listen((message) {
      Logger.logInfo("AttachmentService", "start",
          "Message received from attachment isolate to main isolate : ${message.toString()}");
      if (message.toString() == "stop") {
        _receivePort.close();
      } else if (message.toString() == "restart") {
        Logger.logDebug("AttachmentService", "start", "Waiting to Restart...");
        _receivePort.close();
        Future.delayed(Duration(seconds: 10), () {
          start();
        });
      } else {
        String type = message["type"];
        message.remove("type");
        DartNotificationCenter.post(channel: type, options: message);
      }
    }, onDone: () {
      this.stop();
    });
  }

  void stop() async {
    if (_threadStatus == ServiceThreadStatus.Running.toString()) {
      _isRunning = false;
      //_isolate!.kill(priority: Isolate.immediate);
      // _isolate = null;
      // if(task!=null){
      //   task.cancel();
      //   task=null;
      //   }
      //IsolatedWorker().close();
      _threadStatus = ServiceThreadStatus.Done.toString();
      Logger.logInfo(
          "AttachmentService", "start", "AttachmentService finished......");
      await OutBoxHelper().checkOutboxAndStartService();
    } else {
      Logger.logError(
          "AttachmentService", "stop", "AttachmentService is not running");
      throw ("AttachmentService is not running");
    }
  }

  Future<void> _handleOnFinish(dynamic response) async {
    if (response == "stop") {
      //stop();
    }
  }
}

void checkAndDownloadAttachments(Map<String, dynamic> map) async {
  SendPort sendPort = map['sendPort'];
  String? appBaseUrl = map['appBaseUrl'];
  String? attachmentFolderPath = map['attachmentFolderPath'];
  String? appDirPath = map['appDirPath'];
  String? appName = map['appName'];
  String? authToken = map['authToken'];
  SendPort driftIsolatePortAppDb = map["driftIsolatePortAppDb"];
  SendPort driftIsolatePortFrameWorkDb = map["driftIsolatePortFrameWorkDb"];
  UnviredAccount? _selectedAccount = map['unviredAccount'];
  selectedAccount = _selectedAccount;
  Logger.initialize(appDirPath!);
  attachmentRetryCount = 0;
  if (frameworkDatabaseIsolate == null) {
    frameworkDatabaseIsolate = await getWorkerFrameWorkDatabase(map);
  }
  if (appDatabaseIsolate == null) {
    appDatabaseIsolate = await getWorkerAppDatabase(map);
  }
  List<AttachmentQObjectData> attachmentQObjectData =
      await frameworkDatabaseIsolate!.allAttachmentQObjects;
  await makeNetworkCallToDownloadAttachment(
      attachmentQObjectData,
      _selectedAccount!,
      appBaseUrl!,
      attachmentFolderPath!,
      appName!,
      authToken!,
      sendPort);
}

makeNetworkCallToDownloadAttachment(
  List<AttachmentQObjectData>? attachmentQObjectData,
  UnviredAccount selectedAccount,
  String appBaseUrl,
  String attachmentFolderPath,
  String appName,
  String authToken,
  SendPort sendPort,
) async {
  if (attachmentQObjectData!.isNotEmpty) {
    if (attachmentRetryCount == 3) {
      Logger.logDebug(
          "AttachmentService",
          "makeNetworkCallToDownloadAttachment",
          "Retry limit reached. Stopping the attachment service.");
      sendPort.send("stop");
    } else {
      attachmentRetryCount = attachmentRetryCount! + 1;
      for (int i = 0; i < attachmentQObjectData.length; i++) {
        Logger.logInfo(
            "AttachmentService",
            "makeNetworkCallToDownloadAttachment",
            "Processing UID : ${attachmentQObjectData[i].uid} Processing ATTACHMENT :  ${i.toString()}");
        List<dynamic> attachmentItems = await getAttachmentItems(
            appDatabaseIsolate!, attachmentQObjectData[i]);
        if (attachmentItems.length == 0) {
          Logger.logInfo(
              "AttachmentService",
              "makeNetworkCallToDownloadAttachment",
              "Error while getting attachment item from database. Attachment Structure Name: ${attachmentQObjectData[i].beAttachmentStructName}. UID: ${attachmentQObjectData[i].uid}. Error:");
          await checkAndStopAttachmentService(
              i,
              attachmentQObjectData,
              selectedAccount,
              appBaseUrl,
              attachmentFolderPath,
              appName,
              authToken,
              sendPort);
          continue;
        }
        Map<String, dynamic> attachmentItem = attachmentItems[0];
        await checkConnectionInIsolate();
        http.Response result = await HTTPConnection.downloadAttachment(
            attachmentQObjectData[i].uid,
            account: selectedAccount,
            appBaseUrl: appBaseUrl,
            bearerAuth: authToken,
            appName: appName);
        if (result.statusCode == Status.httpOk) {
          String filePath =
              "$attachmentFolderPath/${attachmentItem[AttachmentItemFieldFileName]}";
          File file = new File(filePath);
          if (!file.existsSync()) {
            file.createSync(recursive: true);
          }
          await file.writeAsBytes(result.bodyBytes);
          // Update the local path and attachment status and then update into DB.
          attachmentItem[AttachmentItemFieldLocalPath] = filePath;
          attachmentItem[AttachmentItemFieldAttachmentStatus] =
              AttachmentStatusDownloaded;
          try {
            bool isSuccess = await isolateUpdateInAppDb(
                frameworkDatabaseIsolate!,
                false,
                attachmentQObjectData[i].beAttachmentStructName,
                attachmentItem,
                false,
                appDatabaseIsolate!);
            if (isSuccess) {
              try {
                await frameworkDatabaseIsolate!
                    .deleteAttachmentQObject(attachmentQObjectData[i].uid);
              } catch (e) {
                Logger.logError(
                    "AttachmentService",
                    "makeNetworkCallToDownloadAttachment",
                    "Failed to remove attachment from ${attachmentQObjectData[i].beAttachmentStructName}---${e.toString()}");
                throw (e);
              }

              // Post 'attachmentstatus' success event to the application.
              Map<String, dynamic> data = {
                "type": EventNameAttachmentStatus,
                EventAttachmentStatusFieldStatus: EventAttachmentStatusSuccess,
                EventFieldData: {
                  EventFieldBeName:
                      attachmentQObjectData[i].beAttachmentStructName,
                  EventAttachmentStatusFieldUid: attachmentQObjectData[i].uid
                }
              };
              sendPort.send(data);
            } else {
              Logger.logInfo(
                  "AttachmentService",
                  "makeNetworkCallToDownloadAttachment",
                  "Failed to update attachment into database. Attachment Structure Name: ${attachmentQObjectData[i].beAttachmentStructName}. UID: ${attachmentItem[AttachmentItemFieldUid]}.");
            }
          } catch (e) {
            Logger.logInfo(
                "AttachmentService",
                "makeNetworkCallToDownloadAttachment",
                "Error while updating attachment into database. Attachment Structure Name: ${attachmentQObjectData[i].beAttachmentStructName}. UID: ${attachmentItem[AttachmentItemFieldUid]}. Error: $e");
          }
        } else if (result.statusCode == Status.httpGone) {
          Map<String, dynamic> response =
              (result.body != null && result.body != "")
                  ? jsonDecode(result.body)
                  : {};
          response["type"] = EventNameSystemError;
          sendPort.send(response);
          sendPort.send("stop");
          // TODO: May need to call _run()
          break;
        } else if (result.statusCode == Status.httpNoContent) {
          sendPort.send("restart");
        } else {
          Logger.logInfo(
              "AttachmentService",
              "makeNetworkCallToDownloadAttachment",
              "Error while downloading attachment. Attachment Structure Name: ${attachmentQObjectData[i].beAttachmentStructName}. UID: ${attachmentQObjectData[i].uid}. Error:");
          // Update the error attachment status and error message and then update into DB.
          Map<String, dynamic> response =
              (result.body != null && result.body != "")
                  ? jsonDecode(result.body)
                  : {};
          String errorMessage = "Unknown Error";
          if (response[KeyError] != null) {
            errorMessage = response[KeyError];
          }
          if (response[KeyAttachmentResponse] != null &&
              (response[KeyAttachmentResponse])[KeyMessage]) {
            errorMessage = (response[KeyAttachmentResponse])[KeyMessage];
          }

          attachmentItem[AttachmentItemFieldAttachmentStatus] =
              AttachmentStatusErrorInDownload;
          attachmentItem[AttachmentItemFieldMessage] = errorMessage;
          try {
            bool isSuccess = await isolateUpdateInAppDb(
                frameworkDatabaseIsolate!,
                false,
                attachmentQObjectData[i].beAttachmentStructName,
                attachmentItem,
                false,
                appDatabaseIsolate!);
            if (isSuccess) {
              // Post 'attachmentstatus' error event to the application.
              Map<String, dynamic> data = {
                "type": EventNameAttachmentStatus,
                EventAttachmentStatusFieldStatus: EventAttachmentStatusError,
                EventFieldData: {
                  EventFieldBeName:
                      attachmentQObjectData[i].beAttachmentStructName,
                  EventAttachmentStatusFieldUid: attachmentQObjectData[i].uid
                },
                EventFieldError: {
                  EventFieldErrorCode: result.statusCode,
                  EventFieldErrorMessage: errorMessage
                }
              };
              sendPort.send(data);
            } else {
              Logger.logInfo(
                  "AttachmentService",
                  "makeNetworkCallToDownloadAttachment",
                  "Failed to update an attachment into database. Attachment Structure Name: ${attachmentQObjectData[i].beAttachmentStructName}. UID: ${attachmentItem[AttachmentItemFieldUid]}.");
            }
          } catch (e) {
            Logger.logError(
                "AttachmentService",
                "makeNetworkCallToDownloadAttachment",
                "Error while updating attachment into database. Attachment Structure Name: ${attachmentQObjectData[i].beAttachmentStructName}. UID: ${attachmentItem[AttachmentItemFieldUid]}. Error: $e");
          }
          try {
            await frameworkDatabaseIsolate!
                .deleteAttachmentQObject(attachmentQObjectData[i].uid);
          } catch (e) {
            Logger.logError(
                "AttachmentService",
                "makeNetworkCallToDownloadAttachment",
                "Failed to remove attachment from ${attachmentQObjectData[i].beAttachmentStructName}---${e.toString()}");
            // throw (e);
          }
        }

        await checkAndStopAttachmentService(
            i,
            attachmentQObjectData,
            selectedAccount,
            appBaseUrl,
            attachmentFolderPath,
            appName,
            authToken,
            sendPort);
      }
    }
  } else {
    Logger.logInfo("AttachmentService", "makeNetworkCallToDownloadAttachment",
        "No items in attachment box. Stopping the attachment service.");
    sendPort.send("stop");
  }
}

Future<void> checkAndStopAttachmentService(
    int i,
    List<AttachmentQObjectData> attachmentQObjectData,
    UnviredAccount selectedAccount,
    String appBaseUrl,
    String attachmentFolderPath,
    String appName,
    String authToken,
    SendPort sendPort) async {
  if (i == (attachmentQObjectData.length - 1)) {
    List<AttachmentQObjectData> attachmentQObjectDataList =
        await frameworkDatabaseIsolate!.allAttachmentQObjects;
    if (attachmentQObjectDataList.isNotEmpty) {
      Logger.logDebug("AttachmentService", "checkAndStopAttachmentService",
          "found ${attachmentQObjectDataList.length.toString()} new attachments");
      makeNetworkCallToDownloadAttachment(
          attachmentQObjectDataList,
          selectedAccount,
          appBaseUrl,
          attachmentFolderPath,
          appName,
          authToken,
          sendPort);
    } else {
      Logger.logDebug(
          "AttachmentService",
          "makeNetworkCallToDownloadAttachment",
          "No items in attachment box. Stopping the attachment service.");
      sendPort.send("stop");
    }
  }
}

Future<List<dynamic>> getAttachmentItems(
    Database appDb, AttachmentQObjectData attachmentQObjectData) async {
  String whereClause =
      "$AttachmentItemFieldUid = '${attachmentQObjectData.uid}'";
  String query =
      "SELECT * FROM ${attachmentQObjectData.beAttachmentStructName} WHERE $whereClause";
  List<dynamic> attachmentItems = await isolateSelectFromAppDb(appDb, query);
  return attachmentItems;
}
