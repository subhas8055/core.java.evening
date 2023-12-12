import 'package:flutter/foundation.dart';
import 'package:isolated_worker/isolated_worker.dart';
import 'package:logger/logger.dart';
import 'package:unvired_sdk/src/attachment/attachment_downloader.dart';
import 'package:unvired_sdk/src/helper/isolate_helper.dart';
import 'package:unvired_sdk/src/inbox/download_message_service.dart';
import 'package:unvired_sdk/src/sync_engine.dart';
import 'package:unvired_sdk/src/unvired_account.dart';

import '../authentication_service.dart';
import '../database/framework_database.dart';
import '../helper/framework_helper.dart';
import '../helper/server_response_handler.dart';
import 'hive_inbox_data_manager.dart';
import 'inbox.dart';

startInboxService(Map<String, dynamic> map) async {
  String? appBaseUrl = map['appBaseUrl'];
  String? baseUrlAcknowlegement = map['baseUrlAcknowlegement'];
  String? attachmentFolderPath = map['attachmentFolderPath'];
  String? appName = map['appName'];
  String? authToken = map['authToken'];
  String? inboxPath = map['inboxPath'];
  String? appDirPath = map['appDirPath'];
  UnviredAccount? _selectedAccount = map['unviredAccount'];
  selectedAccount = _selectedAccount;
  Logger.initialize(appDirPath!);
  if (!kIsWeb) {
    Logger.initialize(appDirPath);
  }
  if (frameworkDatabaseIsolate == null) {
    frameworkDatabaseIsolate = await getWorkerFrameWorkDatabase(map);
  }
  if (appDatabaseIsolate == null) {
    appDatabaseIsolate = await getWorkerAppDatabase(map);
  }

  await startInboxProcessing(selectedAccount, inboxPath!, map);
}

class InboxHandler {
  bool _isInboxHandlerRunning = false;
  bool _isStopped = false;

  static final InboxHandler _inboxHandler = InboxHandler._internal();
  InboxHandler._internal();
  factory InboxHandler() {
    return _inboxHandler;
  }

  void setup() {
    _isInboxHandlerRunning = false;
    _isStopped = false;
  }

  void start() async {
    if (!_isInboxHandlerRunning) {
      Map<String, dynamic> map = await getDownloadMessageServiceMap();
      if (!kIsWeb) {
        try {
          IsolatedWorker().run(startInboxService, map);
        } catch (e) {
          _isInboxHandlerRunning = false;
          throw (e);
        }
      } else {
        await startInboxService(map);
      }
    } else {
      Logger.logInfo("InboxHandler", "start",
          "Could not start the Inbox Handler Thread since it is already running.");
    }
  }

  void stop() async {
    if (_isInboxHandlerRunning) {
      _isInboxHandlerRunning = false;
      Logger.logDebug("Download Message Service", "stop",
          "Download Message Service finished......");
      await AttachmentDownloader().checkAndStartAttachmentService();
    } else {
      Logger.logError("Download Message Service", "stop",
          "Download Message Service is not running");
      //throw ("Download Message Service is not running");
    }
  }

  // void stop() {
  //   _isStopped = true;
  // }

  bool isAlive() {
    return _isInboxHandlerRunning;
  }

  _run() async {
    Logger.logInfo("InboxHandler", "_run", "S T A R T");
    List<InObjectData> inObjectData = await Inbox().getAllInObject();
    for (InObjectData inObject in inObjectData) {
      if (_isStopped) {
        _isInboxHandlerRunning = false;
        break;
      }
      Map<String, dynamic> jsonData = await HiveInboxDataManager(
              (await AuthenticationService().getSelectedAccount())!)
          .getInboxData(inObject.conversationId);
      try {
        await ServerResponseHandler.handleResponseData(jsonData,
            requestType:
                FrameworkHelper.getRequestTypeFromString(inObject.requestType));
        //TODO : Test this is accessible inside isolate (FrameworkHelper.getRequestTypeFromString)
        await Inbox().remove(inObject.conversationId);
      } catch (e) {
        Logger.logError("InboxHandler", "_run", e.toString());
      }
    }
    _isInboxHandlerRunning = false;
    Logger.logInfo("InboxHandler", "_run", "E N D");
  }
}
