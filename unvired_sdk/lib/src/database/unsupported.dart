
import 'package:drift/drift.dart';
import 'package:unvired_sdk/src/helper/service_constants.dart';
import 'package:unvired_sdk/src/unvired_account.dart';

import '../database/database.dart';
import '../database/framework_database.dart';

Future<QueryExecutor> constructAppDb(String appDBFilePath, String userId,
    {bool logStatements = false}) async {
  throw 'Platform not supported';
}

Future<QueryExecutor> constructFrameworkDb(String fwDBFilePath, String userId,
    {bool logStatements = false}) async {
  throw 'Platform not supported';
}

Future<QueryExecutor> constructBackupDb(String fwDBFilePath, String userId,
    {bool logStatements = false}) async {
  throw 'Platform not supported';
}

Future<DatabaseConnection> createDatabaseConnection(
    String path, String userId, DbType dbType) {
  throw 'Platform not supported';
}

Future<Map<String, dynamic>> getOutBoxServiceMap() async {
  throw 'Platform not supported';
}

Future<Database> getWorkerAppDatabase(Map<String, dynamic> map) async {
  throw 'Platform not supported';
}

Future<FrameworkDatabase> getWorkerFrameWorkDatabase(
    Map<String, dynamic> map) async {
  throw 'Platform not supported';
}

void stopOutBox(Map<String, dynamic> map) {
  throw 'Platform not supported';
}

void notifyOutBox(Map<String, dynamic> data, Map<String, dynamic> map) {
  throw 'Platform not supported';
}

Future<Map<String, dynamic>> getDownloadMessageServiceMap() async {
  throw 'Platform not supported';
}

Future<Map<String, dynamic>> getInboxServiceMap() async {
  throw 'Platform not supported';
}

void stopDownloadMessage(Map<String, dynamic> map) {
  throw 'Platform not supported';
}

void notifyDownloadMessage(
    Map<String, dynamic> data, Map<String, dynamic> map) {
  throw 'Platform not supported';
}

PlatformType getPlatform() {
  throw 'Platform not supported';
}

bool isWorkerSupported(){
  throw 'Platform not supported';
}

deleteLoggedInUserFolder(UnviredAccount unviredAccount)async{
  throw 'Platform not supported';
}
