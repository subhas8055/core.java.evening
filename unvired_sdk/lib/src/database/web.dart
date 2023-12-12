import 'dart:html';
import 'dart:js';

import 'package:logger/logger.dart';
import 'package:drift/web.dart';
import 'package:drift/remote.dart';
import 'package:drift/drift.dart';

import 'package:unvired_sdk/src/helper/service_constants.dart';
import 'package:unvired_sdk/src/unvired_account.dart';

import '../application_meta/field_constants.dart';
import '../authentication_service.dart';
import '../database/database.dart';
import '../database/database_manager.dart';
import '../database/framework_database.dart';
import '../helper/event_handler_constants.dart';
import '../helper/http_connection.dart';
import '../helper/path_manager.dart';
import '../helper/url_service.dart';
import '../inbox/download_message_service.dart';
import '../notification_center/dart_notification_center_base.dart';
import '../outbox/outbox_service.dart';

Future<QueryExecutor> constructAppDb(String appDBFilePath, String userId,
    {bool logStatements = false}) async {
  String appDbName = "$WebAppDBName" + "_$userId";
  return WebDatabase.withStorage(
      await DriftWebStorage.indexedDbIfSupported(appDbName, inWebWorker: true));

  return (WebDatabase(appDbName, logStatements: logStatements));
}

Future<QueryExecutor> constructFrameworkDb(String fwDBFilePath, String userId,
    {bool logStatements = false}) async {
  String fwDbName = "$WebFrameworkDBName" + "_$userId";
  return WebDatabase.withStorage(
      await DriftWebStorage.indexedDbIfSupported(fwDbName, inWebWorker: true));
  return (WebDatabase(fwDbName, logStatements: logStatements));
}

Future<QueryExecutor> constructBackupDb(String appDBFilePath, String userId,
    {bool logStatements = false}) async {
  String appDbName = "$WebAppDBName" + "_$userId";
  return WebDatabase.withStorage(
      await DriftWebStorage.indexedDbIfSupported(appDbName, inWebWorker: true));

  return (WebDatabase(appDbName, logStatements: logStatements));
}

bool isWorkerSupported() {
  return context.hasProperty('SharedWorker');
}

Future<DatabaseConnection> createDatabaseConnection(
    String path, String userId, DbType dbType) async {
  // return createdriftIsolateAndConnect(path, userId, dbType);
  bool isIndexedDbSupported = await DriftWebStorage.supportsIndexedDb();
  if (dbType == DbType.appDb) {
    String appDbName = "$WebAppDBName" + "_$userId";
    if (isIndexedDbSupported) {
      return DatabaseConnection.fromExecutor(
          WebDatabase.withStorage(DriftWebStorage.indexedDb(appDbName)));
    } else {
      return DatabaseConnection.fromExecutor(
          WebDatabase(appDbName, logStatements: false));
    }
    if (isWorkerSupported() && isIndexedDbSupported) {
      String appDbName = "$WebAppDBName" + "_${userId}";
      final worker = SharedWorker('app_db.dart.js', appDbName);
      return remote(worker.port!.channel());
    } else {
      // return DatabaseConnection.fromExecutor(WebDatabase.withStorage(
      //     DriftWebStorage.indexedDb(appDbName, inWebWorker: true)));
      return DatabaseConnection.fromExecutor(
          WebDatabase(appDbName, logStatements: false));
    }
  } else {
    String fwDbName = "$WebFrameworkDBName" + "_$userId";
    if (isIndexedDbSupported) {
      return DatabaseConnection.fromExecutor(
          WebDatabase.withStorage(DriftWebStorage.indexedDb(fwDbName)));
    } else {
      return DatabaseConnection.fromExecutor(
          WebDatabase(fwDbName, logStatements: false));
    }

    if (context.hasProperty('SharedWorker') && isIndexedDbSupported) {
      String fwDbName = "$WebFrameworkDBName" + "_${userId}";
      final worker = SharedWorker('fw_db.dart.js', fwDbName);
      return remote(worker.port!.channel());
    } else {
      // return DatabaseConnection.fromExecutor(WebDatabase.withStorage(
      //     DriftWebStorage.indexedDb(fwDbName, inWebWorker: true)));
      return DatabaseConnection.fromExecutor(
          WebDatabase(fwDbName, logStatements: false));
    }
  }
}

Future<Map<String, dynamic>> getOutBoxServiceMap() async {
  final appBaseUrl = URLService.getApplicationUrl(
      (await AuthenticationService().getSelectedAccount())!.getUrl());
  Map<String, dynamic> map = {
    "sendPort": null,
    "unviredAccount": await AuthenticationService().getSelectedAccount(),
    "appName": AuthenticationService().getAppName(),
    "authToken": HTTPConnection.bearerAuth,
    "appBaseUrl": appBaseUrl,
    "appPath": "",
    "appDirPath": "",
    "attachmentFolderPath": "",
    "driftIsolatePortAppDb": null,
    "driftIsolatePortFrameWorkDb": null,
    "outboxPath": "",
  };
  Logger.logDebug("OutboxService", "start", "Starting OutboxService...");

  return map;
}

Future<Map<String, dynamic>> getDownloadMessageServiceMap() async {
  final appBaseUrl = URLService.getApplicationUrl(
      (await AuthenticationService().getSelectedAccount())!.getUrl());

  final baseUrlAcknowlegement = URLService.getBaseUrl(
      (await AuthenticationService().getSelectedAccount())!.getUrl());
  Map<String, dynamic> map = {
    "sendPort": null,
    "unviredAccount": await AuthenticationService().getSelectedAccount(),
    "appBaseUrl": appBaseUrl,
    "baseUrlAcknowlegement": baseUrlAcknowlegement,
    "attachmentFolderPath": "",
    "appName": AuthenticationService().getAppName(),
    "appDirPath": "",
    "authToken": HTTPConnection.bearerAuth,
    "inboxPath": "",
    "driftIsolatePortAppDb": null,
    "driftIsolatePortFrameWorkDb": null
  };
  return map;
}

Future<Map<String, dynamic>> getInboxServiceMap() async {
  final appBaseUrl = URLService.getApplicationUrl(
      (await AuthenticationService().getSelectedAccount())!.getUrl());

  final baseUrlAcknowlegement = URLService.getBaseUrl(
      (await AuthenticationService().getSelectedAccount())!.getUrl());
  Map<String, dynamic> map = {
    "sendPort": null,
    "unviredAccount": await AuthenticationService().getSelectedAccount(),
    "appBaseUrl": appBaseUrl,
    "baseUrlAcknowlegement": baseUrlAcknowlegement,
    "attachmentFolderPath": "",
    "appName": AuthenticationService().getAppName(),
    "appDirPath": "",
    "authToken": HTTPConnection.bearerAuth,
    "inboxPath": "",
    "driftIsolatePortAppDb": null,
    "driftIsolatePortFrameWorkDb": null
  };
  return map;
}

Future<Database> getWorkerAppDatabase(Map<String, dynamic> map) async {
  return await DatabaseManager().getAppDB();
}

Future<FrameworkDatabase> getWorkerFrameWorkDatabase(
    Map<String, dynamic> map) async {
  return await DatabaseManager().getFrameworkDB();
}

void stopOutBox(Map<String, dynamic> map) {
  OutBoxService().stop();
}

void notifyOutBox(Map<String, dynamic> data, Map<String, dynamic> map) {
  DartNotificationCenter.post(channel: EventNameSyncStatus, options: data);
}

void stopDownloadMessage(Map<String, dynamic> map) {
  DownloadMessageService().stop();
}

void notifyDownloadMessage(
    Map<String, dynamic> data, Map<String, dynamic> map) {
  String type = data[messageServiceType];
  data.remove(messageServiceType);
  DartNotificationCenter.post(channel: type, options: data);
}

PlatformType getPlatform() {
  return PlatformType.web;
}

deleteLoggedInUserFolder(UnviredAccount unviredAccount) async {
  bool isIndexedDbSupported = await DriftWebStorage.supportsIndexedDb();
  if (isIndexedDbSupported) {
    String appDbName = "$WebAppDBName" + "_${unviredAccount.getUserId()}";
    String fwDbName = "$WebFrameworkDBName" + "_${unviredAccount.getUserId()}";

    await window.indexedDB!.deleteDatabase("moor_databases");
    //await window.indexedDB!.deleteDatabase("fwDbName");
  } else {
    window.localStorage.clear();
  }
}
