import 'dart:io';
import 'dart:math';

import 'package:drift/isolate.dart';
import 'package:logger/logger.dart';
import 'package:drift/drift.dart';

import '../application_meta/field_constants.dart';
import '../database/database.dart';
import '../database/framework_database.dart';

DriftIsolate? driftIsolateAppDb;
DriftIsolate? driftIsolateFrameworkDb;
DriftIsolate? driftIsolateBackupDb;
FrameworkDatabase? frameworkDatabaseIsolate;
Database? appDatabaseIsolate;

Future<List> isolateSelectFromAppDb(Database appDb, String query) async {
  List<dynamic> returnData = [];
  Selectable<QueryRow>? data;
  try {
    data = appDb.customSelect(query);
  } catch (e) {
    Logger.logError("IsolateHelper", "isolateSelectFromApp",
        "DBException caught when querying $query: " + e.toString());
  }
  if (data != null) {
    List<QueryRow> list = await data.get().then((value) {
      return value;
    }, onError: (e) {
      throw (e);
    });
    returnData = list.map((e) => e.data).toList();
  }
  return returnData;
}

Future<bool> isolateUpdateInAppDb(
    FrameworkDatabase frameworkDatabase,
    bool isFromApp,
    String entityName,
    Map<String, dynamic> jsonData,
    bool isDelete,
    Database appDb) async {
  List<String> queries = [];
  try {
    queries = await constructUpdateQueriesIsolate(
        frameworkDatabase, isFromApp, entityName, jsonData, isDelete);
  } catch (e) {
    Logger.logError("DatabaseManager", "update", e.toString());
    throw (e);
  }
  for (String query in queries) {
    if (query.length == 0) {
      Logger.logError("DatabaseManager", "update", "Invalid input json data");
      throw ("Invalid input json data");
    }
    try {
      await appDb.transaction(() async {
        return await appDb.customUpdate(query);
      });
      // await appDb.customUpdate(query);
    } catch (e) {
      Logger.logError("DatabaseManager", "update", e.toString());
      throw (e);
    }
  }

  return true;
}

int _delayInSeconds = 2;
int _exponentialValue = 0;

Future<bool> checkConnectionInIsolate() async {
  print("Waiting for network connectivity");
  bool hasConnection = false;
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      hasConnection = true;
    } else {
      hasConnection = false;
    }
  } on SocketException catch (_) {
    hasConnection = false;
  }
  // if (!hasConnection) {
  //   int expValue = pow(_delayInSeconds, _exponentialValue).toInt();
  //   await Future.delayed(Duration(milliseconds: expValue * 1000));
  //   _exponentialValue++;
  //   return await checkConnectionInIsolate();
  // }
  // _exponentialValue = 1;
  return hasConnection;
}

Future<List<String>> constructUpdateQueriesIsolate(
    FrameworkDatabase frameworkDatabase,
    bool isFromApp,
    String entityName,
    Map<String, dynamic> jsonData,
    bool isDelete) async {
  String updateString = "";
  List<String> queries = [];
// Get Gid field
  List<FieldMetaData> gidFieldMetas = (await frameworkDatabase.allFieldMetas)
      .where((element) =>
          (element.structureName == entityName && element.isGid == "1"))
      .toList();

  if (gidFieldMetas.isEmpty) {
    throw ("Invalid JSON data.");
  }

  if (jsonData[FieldLid] == null) {
    throw ("${entityName} LID field is not set.");
  }

  StructureMetaData structureMetaData =
      (await frameworkDatabase.allStructureMetas)
          .firstWhere((element) => element.structureName == entityName);
  if (structureMetaData.isHeader != "1" && jsonData[FieldFid] == null) {
    throw ("${entityName} FID field is not set.");
  }

  jsonData[FieldTimestamp] = DateTime.now().millisecondsSinceEpoch;

  if (isFromApp &&
      (jsonData[FieldObjectStatus] == null ||
          jsonData[FieldObjectStatus] == ObjectStatus.global.index)) {
    jsonData[FieldObjectStatus] =
        isDelete ? ObjectStatus.delete.index : ObjectStatus.modify.index;
  }

  Iterable<String> jsonDataKeys = jsonData.keys;
  for (String key in jsonDataKeys) {
    dynamic value = jsonData[key];
    if (!(value is List<dynamic>)) {
      int index =
          gidFieldMetas.indexWhere((element) => element.fieldName == key);
      if (key != FieldLid && key != FieldFid) {
        if (value is String) {
          value = value.replaceAll("'", "''");
        }
        if (value != null) {
          updateString +=
              (updateString.length == 0 ? "" : ", ") + "$key='$value'";
        }
      }
    } else if (value is List<dynamic>) {
      List childTables = value;
      List<FieldMetaData> childGidFieldMetas =
          (await frameworkDatabase.allFieldMetas)
              .where((element) =>
                  (element.structureName == key && element.isGid == "1"))
              .toList();
      if (childGidFieldMetas.isEmpty ||
          childGidFieldMetas[0].beName != gidFieldMetas[0].beName) {
        throw ("Invalid JSON data.");
      }
      for (Map<String, dynamic> element in childTables) {
        String childUpdateString = "";
        if (element[FieldLid] == null) {
          throw ("$key LID field is not set.");
        }
        if (element[FieldFid] == null) {
          throw ("$key FID field is not set.");
        }
        if (element[FieldFid] != jsonData[FieldLid]) {
          throw ("${entityName} LID field did not match with $key FID field.");
        }

        element[FieldTimestamp] = DateTime.now().millisecondsSinceEpoch;
        if (isFromApp) {
          element[FieldObjectStatus] = jsonData[FieldObjectStatus];
        }

        Iterable<String> elementKeys = element.keys;
        for (String childKey in elementKeys) {
          dynamic childValue = element[childKey];
          int index = childGidFieldMetas
              .indexWhere((childElement) => childElement.fieldName == childKey);
          if (childKey != FieldLid && childKey != FieldFid) {
            if (childValue is String) {
              childValue = childValue.replaceAll("'", "''");
            }
            if (childValue != null) {
              childUpdateString += (childUpdateString.length == 0 ? "" : ", ") +
                  "$childKey='$childValue'";
            }
          }
        }
        String childQueryString =
            "UPDATE $key SET $childUpdateString WHERE $FieldLid = '${element[FieldLid]}' AND $FieldFid = '${element[FieldFid]}'";
        queries.add(childQueryString);
      }
    }
  }
  String queryString =
      "UPDATE ${entityName} SET $updateString WHERE $FieldLid = '${jsonData[FieldLid]}'";
  queries.add(queryString);
  return queries;
}
