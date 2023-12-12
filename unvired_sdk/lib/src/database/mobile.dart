import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';

import 'package:logger/logger.dart';
import 'package:drift/isolate.dart';
import 'package:path/path.dart';
import 'package:sqlite3/open.dart';
import 'package:sqlite3/sqlite3.dart' as sql;
import 'package:drift/native.dart';
import 'package:drift/drift.dart';
import 'package:unvired_sdk/src/helper/isolate_helper.dart';
import 'package:unvired_sdk/src/helper/service_constants.dart';
import 'package:unvired_sdk/src/helper/settings_helper.dart';
import 'package:unvired_sdk/src/inbox/inbox_handler.dart';
import 'package:unvired_sdk/src/unvired_account.dart';
import 'package:unvired_sdk/unvired_sdk.dart';

import '../application_meta/field_constants.dart';
import '../authentication_service.dart';
import '../database/database.dart';
import '../database/framework_database.dart';

import '../database/sqlcipher_library_windows.dart';
import '../helper/event_handler_constants.dart';
import '../helper/http_connection.dart';
import '../helper/path_manager.dart';
import '../helper/url_service.dart';
import '../inbox/download_message_service.dart';
import '../notification_center/dart_notification_center_base.dart';
import '../outbox/outbox_service.dart';
import '../database/isolate_database.dart'
    if (dart.library.html) '../database/isolate_database_web.dart';

class FfiCheck {
  static void setupSqlcipher() {
    if (Platform.isIOS) {
      open.overrideFor(OperatingSystem.iOS, () => DynamicLibrary.process());
    } else if (Platform.isAndroid) {
      open.overrideFor(OperatingSystem.android,
          () => DynamicLibrary.open('libsqlcipher.so'));
    } else if (Platform.isMacOS) {
      open.overrideFor(OperatingSystem.iOS, () => DynamicLibrary.process());
    } else if (Platform.isLinux) {
      open.overrideFor(OperatingSystem.linux,
          () => DynamicLibrary.open('libsqlcipher.so')); // TODO:
    } else if (Platform.isWindows) {
      open.overrideFor(OperatingSystem.windows, _openOnWindows);
      open.overrideFor(OperatingSystem.windows, openSQLCipherOnWindows);
    }
  }
}

bool isWorkerSupported() {
  return false;
}

Future<DatabaseConnection> createDatabaseConnection(
    String path, String userId, DbType dbType) {
  return createdriftIsolateAndConnect(path, userId, dbType);
}

Future<QueryExecutor> constructAppDb(String appDBFilePath, String userId,
    {String dbKey = "unvired", bool logStatements = false}) async {
  Logger.logDebug("Mobile.dart", "constructAppDb", 'Constructing APP DB....');
  FfiCheck.setupSqlcipher();
  final executor = LazyDatabase(() async {
    final dbFile = File(appDBFilePath);
    return NativeDatabase(dbFile, logStatements: logStatements, setup: (rawDb) {
      rawDb.execute("PRAGMA key = $dbKey;");
      rawDb.execute('PRAGMA journal_mode = WAL;');
      rawDb.execute('PRAGMA foreign_keys = ON;');
      rawDb.execute('PRAGMA read_uncommitted = 1;');
    });
  });
  return executor;
}

Future<QueryExecutor> constructFrameworkDb(String fwDBFilePath, String userId,
    {String dbKey = "unvired", bool logStatements = false}) async {
  Logger.logDebug(
      "Mobile.dart", "constructFrameworkDb", 'Constructing FW DB....');
  FfiCheck.setupSqlcipher();
  final executor = LazyDatabase(() async {
    final dbFile = File(fwDBFilePath);
    return NativeDatabase(dbFile, logStatements: logStatements, setup: (rawDb) {
      rawDb.execute("PRAGMA key = '$dbKey';");
      rawDb.execute('PRAGMA read_uncommitted = 1;');
    });
  });

  return executor;
}

Future<QueryExecutor> constructBackupDb(String backupDBFilePath, String userId,
    {String dbKey = "unvired", bool logStatements = false}) async {
  Logger.logDebug(
      "Mobile.dart", "constructBackupDb", 'Constructing BACKUP DB....');
  FfiCheck.setupSqlcipher();
  final executor = LazyDatabase(() async {
    final dbFile = File(backupDBFilePath);
    return NativeDatabase(dbFile, logStatements: logStatements, setup: (rawDb) {
      rawDb.execute("PRAGMA key = '$dbKey';");
    });
  });

  return executor;
}

DynamicLibrary _openOnWindows() {
  try {
    String scripPath = File(Platform.resolvedExecutable).parent.path;
    final libraryNextToScript = File(join(scripPath, 'sqlite3.dll'));
    Logger.logDebug(
        "mobile.dart", "_openOnWindows", "Opening ${libraryNextToScript.path}");
    return DynamicLibrary.open(libraryNextToScript.path);
  } catch (e) {
    Logger.logError(
        "Mobile.dart", "_openOnWindows", 'Exception ${e.toString()}');
    final script = File(Platform.script.toFilePath(windows: true));
    String scripPath = script.path.substring(0, (script.path.length) - 10);
    Logger.logDebug("Mobile.dart", "_openOnWindows",
        'Trying to open from path $scripPath\\sqlite3.dll');
    final libraryNextToScript = File('$scripPath\\sqlite3.dll');
    return DynamicLibrary.open(libraryNextToScript.path);
  }
}

DynamicLibrary _openOnWindowsCipher() {
  try {
    String scripPath = File(Platform.resolvedExecutable).parent.path;
    final libraryNextToScript = File(join(scripPath, 'sqlcipher.dll'));
    Logger.logDebug("mobile.dart", "_openOnWindowsCipher",
        "Opening ${libraryNextToScript.path}");
    return DynamicLibrary.open(libraryNextToScript.path);
  } catch (e) {
    Logger.logError(
        "Mobile.dart", "_openOnWindowsCipher", 'Exception ${e.toString()}');
    final script = File(Platform.script.toFilePath(windows: true));
    String scripPath = script.path.substring(0, (script.path.length) - 10);
    Logger.logDebug("Mobile.dart", "_openOnWindowsCipher",
        'Trying to open from path $scripPath\\sqlcipher.dll');
    final libraryNextToScript = File('$scripPath\\sqlcipher.dll');
    return DynamicLibrary.open(libraryNextToScript.path);
  }
}

Future<Map<String, dynamic>> getDownloadMessageServiceMap() async {
  ReceivePort _receivePort = new ReceivePort();
  final appBaseUrl = URLService.getApplicationUrl(
      (await AuthenticationService().getSelectedAccount())!.getUrl());
  final baseUrlAcknowlegement = URLService.getBaseUrl(
      (await AuthenticationService().getSelectedAccount())!.getUrl());
  String attachmentFolderPath = await PathManager.getAttachmentFolderPath(
      (await AuthenticationService().getSelectedAccount())!.getUserId());
  String inboxPath = await PathManager.getInboxFolderPath(
      (await AuthenticationService().getSelectedAccount())!.getUserId());
  final appDirPath = await PathManager.getUploadLogFolderPath();
  Map<String, dynamic> map = {
    "sendPort": _receivePort.sendPort,
    "unviredAccount": await AuthenticationService().getSelectedAccount(),
    "appBaseUrl": appBaseUrl,
    "baseUrlAcknowlegement": baseUrlAcknowlegement,
    "attachmentFolderPath": attachmentFolderPath,
    "appName": AuthenticationService().getAppName(),
    "appDirPath": appDirPath,
    "authToken": HTTPConnection.bearerAuth,
    "inboxPath": inboxPath,
    "driftIsolatePortAppDb":
        driftIsolateAppDb != null ? driftIsolateAppDb!.connectPort : "",
    "driftIsolatePortFrameWorkDb": driftIsolateFrameworkDb != null
        ? driftIsolateFrameworkDb!.connectPort
        : ""
  };

  _receivePort.listen((message) async {
    Logger.logDebug("Download Message Service", "start",
        "message from download message service isolate : ${message.toString()}");
    if (message.toString() == "stopInbox") {
      DownloadMessageService().stop();
    } else {
      String type = message[messageServiceType];
      message.remove(messageServiceType);
      if (type.toString() == MESSAGE_SUBTYPE_SYSTEM_LOG.toString()) {
        await SettingsHelper().sendLogsToServer();
      } else if (type.toString() ==
          MESSAGE_SUBTYPE_SYSTEM_DATA_DUMP.toString()) {
        await SettingsHelper().sendAppDbToServer();
      } else if (type.toString() == MESSAGE_SUBTYPE_SYSTEM_PING.toString()) {
        await SettingsHelper().queuePingToOutbox();
      } else if (type.toString() ==
          MESSAGE_SUBTYPE_SYSTEM_LOG_RESET.toString()) {
        await SettingsHelper().deleteLogs();
      } else if (type.toString() ==
          MESSAGE_SUBTYPE_SYSTEM_LOG_SET_DEBUG.toString()) {
        await SettingsHelper().setLogLevel(logDebug);
      } else if (type.toString() ==
          MESSAGE_SUBTYPE_SYSTEM_LOG_SET_ERROR.toString()) {
        await SettingsHelper().setLogLevel(logError);
      } else {
        if (type == EventNameSystemError &&
            message["systemError"] != null &&
            message["systemError"] == 13) {
          await SettingsHelper().clearData();
        }
        DartNotificationCenter.post(channel: type, options: message);
      }
    }
  }, onDone: () {
    // DownloadMessageService().stop();
  });
  return map;
}

Future<Map<String, dynamic>> getInboxServiceMap() async {
  ReceivePort _receivePort = new ReceivePort();
  final appBaseUrl = URLService.getApplicationUrl(
      (await AuthenticationService().getSelectedAccount())!.getUrl());
  final baseUrlAcknowlegement = URLService.getBaseUrl(
      (await AuthenticationService().getSelectedAccount())!.getUrl());
  String attachmentFolderPath = await PathManager.getAttachmentFolderPath(
      (await AuthenticationService().getSelectedAccount())!.getUserId());
  String inboxPath = await PathManager.getInboxFolderPath(
      (await AuthenticationService().getSelectedAccount())!.getUserId());
  final appDirPath = await PathManager.getUploadLogFolderPath();
  Map<String, dynamic> map = {
    "sendPort": _receivePort.sendPort,
    "unviredAccount": await AuthenticationService().getSelectedAccount(),
    "appBaseUrl": appBaseUrl,
    "baseUrlAcknowlegement": baseUrlAcknowlegement,
    "attachmentFolderPath": attachmentFolderPath,
    "appName": AuthenticationService().getAppName(),
    "appDirPath": appDirPath,
    "authToken": HTTPConnection.bearerAuth,
    "inboxPath": inboxPath,
    "driftIsolatePortAppDb":
        driftIsolateAppDb != null ? driftIsolateAppDb!.connectPort : "",
    "driftIsolatePortFrameWorkDb": driftIsolateFrameworkDb != null
        ? driftIsolateFrameworkDb!.connectPort
        : ""
  };

  _receivePort.listen((message) {
    Logger.logDebug("Download Message Service", "start",
        "message from download message service isolate : ${message.toString()}");
    if (message.toString() == "stopInbox") {
      InboxHandler().stop();
    } else {
      String type = message[messageServiceType];
      message.remove(messageServiceType);
      DartNotificationCenter.post(channel: type, options: message);
    }
  }, onDone: () {
    // DownloadMessageService().stop();
  });
  return map;
}

Future<Map<String, dynamic>> getOutBoxServiceMap() async {
  ReceivePort _receivePort = new ReceivePort();
  String appDirPath = await PathManager.getUploadLogFolderPath();
  String appPath = await PathManager.getApplicationPath(
      (await AuthenticationService().getSelectedAccount())!.getUserId());
  String attachmentFolderPath = await PathManager.getAttachmentFolderPath(
      (await AuthenticationService().getSelectedAccount())!.getUserId());
  String outBoxPath = await PathManager.getOutboxFolderPath(
      (await AuthenticationService().getSelectedAccount())!.getUserId());
  final appBaseUrl = URLService.getApplicationUrl(
      (await AuthenticationService().getSelectedAccount())!.getUrl());
  Map<String, dynamic> map = {
    "sendPort": _receivePort.sendPort,
    "unviredAccount": await AuthenticationService().getSelectedAccount(),
    "appName": AuthenticationService().getAppName(),
    "authToken": HTTPConnection.bearerAuth,
    "appBaseUrl": appBaseUrl,
    "appPath": appPath,
    "appDirPath": appDirPath,
    "attachmentFolderPath": attachmentFolderPath,
    "driftIsolatePortAppDb":
        driftIsolateAppDb != null ? driftIsolateAppDb!.connectPort : "",
    "driftIsolatePortFrameWorkDb": driftIsolateFrameworkDb != null
        ? driftIsolateFrameworkDb!.connectPort
        : "",
    "outboxPath": outBoxPath,
  };
  Logger.logDebug("OutboxService", "start", "Starting OutboxService...");
  _receivePort.listen((message) {
    Logger.logDebug("OutboxService", "start",
        "MESSAGE FROM ISOLATE : ${message.toString()}");
    if (message.toString() == "stopOutbox") {
      OutBoxService().stop();
    } else {
      DartNotificationCenter.post(
          channel: EventNameSyncStatus, options: message);
    }
  }, onDone: () {
    Logger.logDebug("OutboxService", "start", "OutboxService Done...");
    //OutBoxService().stop();
  });
  return map;
}

Future<Database> getWorkerAppDatabase(Map<String, dynamic> map) async {
  return await getAppDbFromdriftIsolate(
      DriftIsolate.fromConnectPort(map["driftIsolatePortAppDb"]));
}

Future<FrameworkDatabase> getWorkerFrameWorkDatabase(
    Map<String, dynamic> map) async {
  return await getFrameworkDbFromdriftIsolate(
      DriftIsolate.fromConnectPort(map["driftIsolatePortFrameWorkDb"]));
}

void stopOutBox(Map<String, dynamic> map) {
  SendPort? sendPort = map['sendPort'];
  sendPort!.send("stopOutbox");
}

void notifyOutBox(Map<String, dynamic> data, Map<String, dynamic> map) {
  SendPort? sendPort = map['sendPort'];
  sendPort!.send(data);
}

void stopDownloadMessage(Map<String, dynamic> map) {
  SendPort? sendPort = map['sendPort'];
  sendPort!.send("stopInbox");
}

void notifyDownloadMessage(
    Map<String, dynamic> data, Map<String, dynamic> map) {
  SendPort? sendPort = map['sendPort'];
  sendPort!.send(data);
}

PlatformType getPlatform() {
  if (Platform.isIOS) {
    return PlatformType.ios;
  } else if (Platform.isAndroid) {
    return PlatformType.android;
  } else if (Platform.isWindows) {
    return PlatformType.windows;
  } else if (Platform.isLinux) {
    return PlatformType.linux;
  } else if (Platform.isMacOS) {
    return PlatformType.macOs;
  } else if (Platform.isFuchsia) {
    return PlatformType.fuchsia;
  } else {
    throw ("Could not identify this platform");
  }
}

deleteLoggedInUserFolder(UnviredAccount unviredAccount) async {
  await PathManager.deleteLoggedInUserFolder(unviredAccount.getUserId());
}

String getFwDbName() {
  return FrameworkDBName;
}

String getAppDbName() {
  return AppDBName;
}
