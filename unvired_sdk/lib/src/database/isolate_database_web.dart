import 'dart:isolate';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:drift/isolate.dart';
import 'package:drift/drift.dart';
import 'package:unvired_sdk/src/database/temp_database.dart';
import 'package:unvired_sdk/src/helper/isolate_helper.dart';
import 'package:unvired_sdk/src/helper/path_manager.dart';
import 'package:unvired_sdk/src/helper/service_constants.dart';
import '../database/database.dart';
import '../database/framework_database.dart';

class _IsolateStartRequest {
  final SendPort senddriftIsolate;
  final String targetPath;
  final String userId;
  final String logPath;
  final DbType dbType;

  _IsolateStartRequest(this.senddriftIsolate, this.targetPath, this.userId,
      this.dbType, this.logPath);
}

Future<DatabaseConnection> createdriftIsolateAndConnect(
    String path, String userId, DbType dbType) async {
  // return DatabaseConnection.delayed(() async {
  String logPath = await PathManager.getUploadLogFolderPath();
  if (dbType == DbType.appDb) {
    driftIsolateAppDb = await createdriftIsolate(path, userId, dbType, logPath);
    DatabaseConnection backgroundConnection =
        await driftIsolateAppDb!.connect();
    QueryExecutor executor = await constructAppDb(path, userId);
    return backgroundConnection.withExecutor(
      MultiExecutor(
        write: backgroundConnection.executor,
        read: executor,
      ),
    );
  } else if (dbType == DbType.backupDb) {
    driftIsolateBackupDb =
        await createdriftIsolate(path, userId, dbType, logPath);
    DatabaseConnection backgroundConnection =
        await driftIsolateBackupDb!.connect();
    QueryExecutor executor = await constructBackupDb(path, userId);
    return backgroundConnection.withExecutor(
      MultiExecutor(
        write: backgroundConnection.executor,
        read: executor,
      ),
    );
  } else if (dbType == DbType.fwDb) {
    driftIsolateFrameworkDb =
        await createdriftIsolate(path, userId, dbType, logPath);
    DatabaseConnection backgroundConnection =
        await driftIsolateFrameworkDb!.connect();
    return backgroundConnection;
    QueryExecutor executor = await constructFrameworkDb(path, userId);
    return backgroundConnection.withExecutor(
      MultiExecutor(
        write: backgroundConnection.executor,
        read: executor,
      ),
    );
  } else {
    throw "Invalid DB type";
  }
  // }());
}

Future<DriftIsolate> createdriftIsolate(
    String path, String userId, DbType dbType, String logPath) async {
  // this method is called from the main isolate. Since we can't use
  // getApplicationDocumentsDirectory on a background isolate, we calculate
  // the database path in the foreground isolate and then inform the
  // background isolate about the path.

  final receivePort = ReceivePort();

  await Isolate.spawn(
    _startBackground,
    _IsolateStartRequest(receivePort.sendPort, path, userId, dbType, logPath),
  );

  if (dbType == DbType.appDb) {
    Logger.logDebug("IsolateDatabase", "createdriftIsolate",
        "CREATING drift ISOLATE FOR APPLICATION DB...");
  } else if (dbType == DbType.backupDb) {
    Logger.logDebug("IsolateDatabase", "createdriftIsolate",
        "CREATING drift ISOLATE FOR BACKUP DB...");
  } else if (dbType == DbType.fwDb) {
    Logger.logDebug("IsolateDatabase", "createdriftIsolate",
        "CREATING drift ISOLATE FOR FRAMEWORK DB...");
  }
  // _startBackground will send the driftIsolate to this ReceivePort
  return await receivePort.first as DriftIsolate;
}

Future<Database> getAppDbFromdriftIsolate(DriftIsolate driftIsolate) async {
  return Database.connect(await driftIsolate.connect());
}

Future<FrameworkDatabase> getFrameworkDbFromdriftIsolate(
    DriftIsolate driftIsolate) async {
  return FrameworkDatabase.connect(await driftIsolate.connect());
}

Future<TempDatabase> getBackupDbFromdriftIsolate(
    DriftIsolate driftIsolate) async {
  return TempDatabase.connect(await driftIsolate.connect());
}

void _startBackground(_IsolateStartRequest request) async {
  Logger.initialize(request.logPath);
  await Logger.logDebug(
      "mobile.dart", "_startBackground", "LogPath ${request.logPath}");

  QueryExecutor? executor;
  if (request.dbType == DbType.appDb) {
    executor = await constructAppDb(request.targetPath, request.userId);
  } else if (request.dbType == DbType.fwDb) {
    executor = await constructFrameworkDb(request.targetPath, request.userId);
  } else if (request.dbType == DbType.backupDb) {
    executor = await constructBackupDb(request.targetPath, request.userId);
  }
  // we're using driftIsolate.inCurrent here as this method already runs on a
  // background isolate. If we used driftIsolate.spawn, a third isolate would be
  // started which is not what we want!
  DriftIsolate driftIsolate = DriftIsolate.inCurrent(
    () => DatabaseConnection.fromExecutor(executor!),
  );
  // inform the starting isolate about this, so that it can call .connect()
  request.senddriftIsolate.send(driftIsolate);
}
