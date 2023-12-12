import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:unvired_sdk/src/helper/isolate_helper.dart';
import 'package:unvired_sdk/src/helper/service_constants.dart';
import 'package:unvired_sdk/src/helper/sync_input_data_manager.dart';
import 'package:unvired_sdk/src/sync_engine.dart';

import '../application_meta/field_constants.dart';
import '../authentication_service.dart';
import '../database/database.dart';
import '../database/framework_database.dart';
import '../helper/framework_helper.dart';
import '../helper/path_manager.dart';

class DBInputEntity {
  String _entityName = "";
  Map<String, dynamic> _jsonData = {};
  String _whereClause = "";
  List<String> _expandChildEntities = [];
  bool isIsolated = false;

  DBInputEntity(String entityName, Map<String, dynamic> jsonData) {
    Map<String, dynamic> data = jsonDecode(jsonEncode(jsonData));
    data.remove(FieldTableName);
    Iterable<String> jsonDataKeys = data.keys;
    for (String key in jsonDataKeys) {
      dynamic value = data[key];
      if (value is List<dynamic>) {
        List childTables = value;
        for (Map<String, dynamic> element in childTables) {
          element.remove(FieldTableName);
        }
      }
    }
    this._entityName = entityName;
    this._jsonData = data;
  }

  String get entityName {
    return this._entityName;
  }

  Map<String, dynamic> get jsonData {
    return this._jsonData;
  }

  String get whereClause {
    return this._whereClause;
  }

  List<String> get expandChildEntities {
    return this._expandChildEntities;
  }

  void setWhereClause(String whereClause) {
    this._whereClause = whereClause;
  }

  void setExpandChildEntities(List<String> childEntities) {
    this._expandChildEntities = childEntities;
  }
}

class DatabaseManagerInternal {
  static Database? _appDatabase;
  static Database? _appDatabase1;
  static FrameworkDatabase? _fwDatabase;

  void closeDatabase() {
    DatabaseManagerInternal._fwDatabase!.close();
    DatabaseManagerInternal._appDatabase!.close();
  }
}

class DatabaseManager {
  static List<StructureMetaData> _structureMetas = [];
  static List<FieldMetaData> _fieldMetas = [];
  DatabaseManager() {
    DatabaseManagerInternal();
  }

  clearDataFromFrameworkDb() async {
    FrameworkDatabase frameworkDatabase =
        await DatabaseManager().getFrameworkDB();
    await frameworkDatabase.transaction(() async {
      for (TableInfo<Table, dynamic> fwTable in frameworkDatabase.allTables) {
        await frameworkDatabase.delete(fwTable).go();
      }
    });
    await frameworkDatabase.close();
  }

  clearDataFromAppDb() async {
    Database appDb = await DatabaseManager().getAppDB();
    FrameworkDatabase frameworkDatabase =
        await DatabaseManager().getFrameworkDB();
    List<StructureMetaData> structureMetas =
        await frameworkDatabase.allStructureMetas;
    await appDb.transaction(() async {
      for (StructureMetaData structureMetaData in structureMetas) {
        try {
          await appDb.customStatement(
              "DROP TABLE IF EXISTS '${structureMetaData.structureName}';");
        } catch (e) {
          Logger.logError(
              "DatabaseManager", "clearDataFromAppDb", e.toString());
          continue;
        }
      }
    });
    await appDb.close();
  }

  clearDatabase() {
    DatabaseManagerInternal._appDatabase = null;
    DatabaseManagerInternal._appDatabase1 = null;
    DatabaseManagerInternal._fwDatabase = null;
    frameworkDatabaseIsolate = null;
    appDatabaseIsolate = null;
    driftIsolateAppDb = null;
    driftIsolateFrameworkDb = null;
  }

  static Future<List<StructureMetaData>> getStructureMetaDataList() async {
    if (_structureMetas.length == 0) {
      Logger.logInfo("DatabaseManager", "getStructureMetaDataList",
          "~~~~~~~ _structureMetas is empty ~~~~~~~~");
      _structureMetas =
          await (await DatabaseManager().getFrameworkDB()).allStructureMetas;
      return _structureMetas;
    } else {
      return _structureMetas;
    }
  }

  static Future<List<FieldMetaData>> getFieldMetaDataList() async {
    if (_fieldMetas.length == 0) {
      Logger.logInfo("DatabaseManager", "getFieldMetaDataList",
          "~~~~~~~ _fieldMetas is empty ~~~~~~~~");
      _fieldMetas =
          await (await DatabaseManager().getFrameworkDB()).allFieldMetas;
      return _fieldMetas;
    } else {
      return _fieldMetas;
    }
  }

  Future<Database> getAppDB() async {
    if (appDatabaseIsolate != null) {
      return appDatabaseIsolate!;
    }

    if (DatabaseManagerInternal._appDatabase == null) {
      String appDBFilePath = "";
      if (!kIsWeb) {
        appDBFilePath = await PathManager.getAppDBPath(
            (await AuthenticationService().getSelectedAccount())!.getUserId());
        DatabaseManagerInternal._appDatabase = Database.connect(
            await createDatabaseConnection(
                appDBFilePath,
                (await AuthenticationService().getSelectedAccount())!
                    .getUserId(),
                DbType.appDb));
      } else {
        // DatabaseManagerInternal._appDatabase = Database(await constructAppDb(appDBFilePath,  (await AuthenticationService().getSelectedAccount())!.getUserId()));
        DatabaseManagerInternal._appDatabase = Database.connect(
            await createDatabaseConnection(
                appDBFilePath,
                (await AuthenticationService().getSelectedAccount())!
                    .getUserId(),
                DbType.appDb));
      }

      return DatabaseManagerInternal._appDatabase!;
    } else {
      return DatabaseManagerInternal._appDatabase!;
    }
  }

  Future<FrameworkDatabase> getFrameworkDB() async {
    if (frameworkDatabaseIsolate != null) {
      return frameworkDatabaseIsolate!;
    }

    if (DatabaseManagerInternal._fwDatabase == null) {
      String fwDBFilePath = "";
      if (!kIsWeb) {
        fwDBFilePath = await PathManager.getFrameworkDBPath(
            (await AuthenticationService().getSelectedAccount())!.getUserId());
        DatabaseManagerInternal._fwDatabase = FrameworkDatabase.connect(
            await createDatabaseConnection(
                fwDBFilePath,
                (await AuthenticationService().getSelectedAccount())!
                    .getUserId(),
                DbType.fwDb));
      } else {
        // DatabaseManagerInternal._fwDatabase = FrameworkDatabase(await constructFrameworkDb(fwDBFilePath, (await AuthenticationService().getSelectedAccount())!.getUserId()));
        DatabaseManagerInternal._fwDatabase = FrameworkDatabase.connect(
            await createDatabaseConnection(
                fwDBFilePath,
                (await AuthenticationService().getSelectedAccount())!
                    .getUserId(),
                DbType.fwDb));
      }
      return DatabaseManagerInternal._fwDatabase!;
    } else {
      return DatabaseManagerInternal._fwDatabase!;
    }
  }

  // INSERT
  Future<bool> insert(DBInputEntity dbInputEntity,
      {bool isFromApp = false}) async {
    Database appDb = await DatabaseManager().getAppDB();
    List<String> queries =
        await DatabaseManager.constructInsertOrReplaceQueries(
            dbInputEntity, "INSERT",
            isFromApp: isFromApp);
    for (String query in queries) {
      if (query.length == 0) {
        Logger.logError("DatabaseManager", "insert", "Invalid input json data");
        throw ("Invalid input json data");
      }
      try {
        // if (batch != null) {
        //   batch!.customStatement(query);
        // } else {
        //   await appDb.batch((batch) => batch.customStatement(query));
        // }
        await appDb.transaction(() async {
          return await appDb.customInsert(query);
        });
      } catch (e) {
        Logger.logError("DatabaseManager", "insert", e.toString());
        throw (e);
      }
    }
    return true;
  }

  // UPDATE
  Future<bool> update(DBInputEntity dbInputEntity,
      {bool isFromApp = false, bool isDelete = false}) async {
    Database appDb = await DatabaseManager().getAppDB();

    List<String> queries = [];
    try {
      queries = await DatabaseManager.constructUpdateQueries(dbInputEntity,
          isFromApp: isFromApp, isDelete: isDelete);
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
        if (batch != null) {
          batch!.customStatement(query);
        } else {
          await appDb.transaction(() async {
            return await appDb.customUpdate(query);
          });
        }
      } catch (e) {
        Logger.logError("DatabaseManager", "update", e.toString());
        throw (e);
      }
    }

    return true;
  }

  // DELETE
  Future<int> delete(DBInputEntity dbInputEntity) async {
    if (dbInputEntity.entityName.isEmpty) {
      Logger.logError(
          "DatabaseManager", "delete", "Entity name cannot be empty");
      throw ("Entity name cannot be empty");
    }
    String queryString = "DELETE FROM ${dbInputEntity.entityName}";
    if (dbInputEntity.jsonData.isNotEmpty &&
        dbInputEntity.jsonData[FieldLid] != null) {
      // Construct DELETE query to delete parent table
      queryString = queryString +
          " WHERE $FieldLid = '${dbInputEntity.jsonData[FieldLid]}'";
    }

    int result = 0;
    try {
      result = await (await DatabaseManager().getAppDB()).transaction(() async {
        return await (await DatabaseManager().getAppDB())
            .customUpdate(queryString, updateKind: UpdateKind.delete);
      });
    } catch (e) {
      Logger.logError("DatabaseManager", "delete", e.toString());
      throw (e);
    }
    return result;
  }

  // REPLACE
  Future<bool> replace(DBInputEntity dbInputEntity,
      {bool isFromApp = false}) async {
    Database appDb = await DatabaseManager().getAppDB();
    List<String> queries =
        await DatabaseManager.constructInsertOrReplaceQueries(
            dbInputEntity, "REPLACE",
            isFromApp: isFromApp);
    for (String query in queries) {
      if (query.length == 0) {
        Logger.logError(
            "DatabaseManager", "replace", "Invalid input json data");
        throw ("Invalid input json data");
      }
      try {
        await appDb.transaction(() => appDb.customInsert(query));
        // sendPort.send((query));
      } catch (e) {
        Logger.logError("DatabaseManager", "replace", e.toString());
        throw (e);
      }
    }
    return true;
  }

  // SELECT
  Future<List<dynamic>> select(DBInputEntity dbInputEntity) async {
    String queryString = "SELECT * FROM ${dbInputEntity.entityName}";
    String whereClause = "";
    if (dbInputEntity.whereClause.length > 0) {
      whereClause = " WHERE ${dbInputEntity.whereClause}";
    }
    Selectable<QueryRow>? data;
    Database appDb = await DatabaseManager().getAppDB();
    FrameworkDatabase fwDb = await DatabaseManager().getFrameworkDB();
    try {
      data = appDb.customSelect(queryString + whereClause);
    } catch (e) {
      Logger.logError("DatabaseManager", "replace", e.toString());
    }
    List<Map<String, dynamic>> result = [];

    if (data != null) {
      try {
        List<QueryRow> list = await data.get();
        result = list.map((e) => e.data).toList();
      } catch (e) {
        Logger.logError(
            "DatabaseManager",
            "replace",
            "Error when trying to get QueryRowList from Selectable.get :" +
                e.toString());
      }
    }

    if (dbInputEntity.expandChildEntities.length > 0) {
      FieldMetaData headerGidFieldMeta = (await fwDb.allFieldMetas).firstWhere(
          (element) => (element.structureName == dbInputEntity.entityName &&
              element.isGid == "1"));
      for (String childEntity in dbInputEntity.expandChildEntities) {
        String childQuery =
            "SELECT * FROM $childEntity WHERE ${headerGidFieldMeta.fieldName} IN (SELECT ${headerGidFieldMeta.fieldName} FROM ${dbInputEntity.entityName}$whereClause)";

        Selectable<QueryRow> childData = appDb.customSelect(childQuery);
        List<QueryRow> childList = await childData.get();
        List<Map<String, dynamic>> childResult =
            childList.map((e) => e.data).toList();
        result = _upadteHeaderWithChildData(
            result, headerGidFieldMeta.fieldName, childEntity, childResult);
      }
    }

    return result;
  }

  // EXECUTE
  Future<dynamic> execute(String query) async {
    List<QueryRow> rows =
        await (await DatabaseManager().getAppDB()).customWriteReturning(query);
    List<Map<String, dynamic>> result = rows.map((e) => e.data).toList();
    return result;
  }

  Future<List<dynamic>> getChildrenData(
      {required Map<String, dynamic> header,
      DataType dataType = DataType.all}) async {
    if (!header.containsKey(FieldTableName)) {
      throw ("Missing field table name");
    }
    if (header[FieldTableName] == null ||
        header[FieldTableName].toString().isEmpty) {
      throw ("Invalid table name");
    }

    if (!header[FieldTableName].toString().contains("_HEADER")) {
      throw ("${header[FieldTableName]} is not a HEADER BE");
    }
    String lid = header[FieldLid];
    List<String> childStructureMetas =
        await getChildrenItemNames(tableName: header[FieldTableName]);

    String whereClause = "$FieldFid='$lid'";

    switch (dataType) {
      case DataType.all:
        whereClause += "";
        break;
      case DataType.changed:
        whereClause +=
            " AND $FieldObjectStatus IN (${ObjectStatus.add.index}, ${ObjectStatus.modify.index}, ${ObjectStatus.delete.index}) AND $FieldSyncStatus IN (${SyncStatus.none.index}, ${SyncStatus.error.index})";
        break;
      case DataType.changedQueued:
        whereClause +=
            " AND $FieldObjectStatus IN (${ObjectStatus.add.index}, ${ObjectStatus.modify.index}, ${ObjectStatus.delete.index}) AND $FieldSyncStatus IN (${SyncStatus.none.index}, ${SyncStatus.error.index}, ${SyncStatus.queued.index})";
        break;
      case DataType.queued:
        whereClause +=
            " AND $FieldObjectStatus IN (${ObjectStatus.add.index}, ${ObjectStatus.modify.index}, ${ObjectStatus.delete.index}) AND $FieldSyncStatus IN (${SyncStatus.queued.index})";
        break;
      default:
        break;
    }
    List<dynamic> childrenData = [];
    for (String structureMetaData in childStructureMetas) {
      DBInputEntity inputEntity = DBInputEntity(structureMetaData, {})
        ..setWhereClause(whereClause);

      try {
        List<dynamic> result = await DatabaseManager().select(inputEntity);
        childrenData.addAll(result);
      } catch (e) {
        Logger.logError("DatabaseManager", "getChildren", e.toString());
      }
    }
    return childrenData;
  }

  Future<List<String>> getChildrenItemNames({required String tableName}) async {
    List<String> childNames = [];
    String beName =
        (await (await DatabaseManager().getFrameworkDB()).allStructureMetas)
            .where((element) => element.structureName == tableName)
            .first
            .beName;
    List<StructureMetaData> childStructureMetas =
        (await (await DatabaseManager().getFrameworkDB()).allStructureMetas)
            .where((element) =>
                element.beName == beName && element.isHeader != "1")
            .toList();
    for (StructureMetaData structureMetaData in childStructureMetas) {
      childNames.add(structureMetaData.structureName);
    }
    return childNames;
  }

  /// D E L E T E - D A T A B A S E
  ///
  /// drop the database
  Future<bool> dropDataBase() async {
    return true;
  }

  /// drop specific database table
  /// Eg for tableName: CUSTOMER_HEADER
  Future<bool> dropTable(String tableName) async {
    return true;
  }

  static Future<List<String>> constructInsertOrReplaceQueries(
      DBInputEntity inputEntity, String prefixString,
      {bool isFromApp = false}) async {
    String fieldsString = "";
    String valuesString = "";
    List<String> queries = [];

    StructureMetaData structureMetaData = (await getStructureMetaDataList())
        .firstWhere(
            (element) => element.structureName == inputEntity.entityName);

    if (inputEntity.jsonData[FieldLid] == null ||
        inputEntity.jsonData[FieldLid].toString().isEmpty) {
      inputEntity.jsonData[FieldLid] = FrameworkHelper.getUUID();
    }

    if (structureMetaData.isHeader != "1" &&
        (inputEntity.jsonData[FieldFid] == null ||
            inputEntity.jsonData[FieldFid].toString().isEmpty)) {
      throw ("${inputEntity.entityName} FID field is not set.");
    }

    List<FieldMetaData> fieldMetas = await getFieldMetaDataList();

    if (fieldMetas.isEmpty) {
      throw ("${inputEntity.entityName} fields are not found in Framework DB in field_meta table.");
    }

    inputEntity.jsonData[FieldTimestamp] =
        DateTime.now().millisecondsSinceEpoch;

    if (isFromApp) {
      if (prefixString == "INSERT") {
        inputEntity.jsonData[FieldObjectStatus] = ObjectStatus.add.index;
        inputEntity.jsonData[FieldSyncStatus] =
            inputEntity.jsonData[FieldSyncStatus] ?? SyncStatus.none.index;
      } else {
        inputEntity.jsonData[FieldObjectStatus] = ObjectStatus.modify.index;
        inputEntity.jsonData[FieldSyncStatus] =
            inputEntity.jsonData[FieldSyncStatus] ?? SyncStatus.none.index;
      }
    }

    Iterable<String> jsonDataKeys = inputEntity.jsonData.keys;
    List<FieldMetaData> entityFieldMetas = fieldMetas
        .where((element) => element.structureName == inputEntity.entityName)
        .toList(); //Filter fieldMetas of only the incoming entity name

    List<String> constantFields = [
      FieldLid,
      FieldFid,
      FieldConflict,
      FieldTimestamp,
      FieldObjectStatus,
      FieldSyncStatus
    ];

    for (String key in jsonDataKeys) {
      dynamic value = inputEntity.jsonData[key];
      if (!(value is List<dynamic>)) {
        if (entityFieldMetas
                    .indexWhere((element) => element.fieldName == key) ==
                -1 &&
            !constantFields.contains(key)) {
          //Field is not present in meta data
          continue;
        }
        if (value is String) {
          value = value.replaceAll("'", "''");
        }
        if (value != null) {
          fieldsString += (fieldsString.length == 0 ? "" : ", ") + "$key";
          valuesString += (valuesString.length == 0 ? "" : ", ") + "'$value'";
        }
      } else if (value is List<dynamic>) {
        List childTables = value;
        for (Map<String, dynamic> element in childTables) {
          String childFieldsString = "";
          String childValuesString = "";
          if (element[FieldLid] == null ||
              element[FieldLid].toString().isEmpty) {
            element[FieldLid] = FrameworkHelper.getUUID();
          }
          if (element[FieldFid] == null ||
              element[FieldFid].toString().isEmpty) {
            element[FieldFid] = inputEntity.jsonData[FieldLid];
          }
          element[FieldTimestamp] = DateTime.now().millisecondsSinceEpoch;
          if (isFromApp) {
            if (prefixString == "INSERT") {
              element[FieldObjectStatus] = ObjectStatus.add.index;
              element[FieldSyncStatus] =
                  element[FieldSyncStatus] ?? SyncStatus.none.index;
            } else {
              element[FieldObjectStatus] = ObjectStatus.modify.index;
              element[FieldSyncStatus] =
                  element[FieldSyncStatus] ?? SyncStatus.none.index;
            }
          }
          Iterable<String> elementKeys = element.keys;
          List<FieldMetaData> childFieldMetas = fieldMetas
              .where((element) => element.structureName == key)
              .toList(); //Filter fieldMetas of only the incoming child entity name
          for (String key2 in elementKeys) {
            if (childFieldMetas
                        .indexWhere((element) => element.fieldName == key2) ==
                    -1 &&
                !constantFields.contains(key2)) {
              //Field is not present in meta data
              continue;
            }
            dynamic value2 = element[key2];
            if (value2 is String) {
              value2 = value2.replaceAll("'", "''");
            }
            if (value2 != null) {
              childFieldsString +=
                  (childFieldsString.length == 0 ? "" : ", ") + "$key2";
              childValuesString +=
                  (childValuesString.length == 0 ? "" : ", ") + "'$value2'";
            }
          }
          String childQueryString =
              "$prefixString INTO $key ($childFieldsString) VALUES ($childValuesString)";
          queries.add(childQueryString);
        }
      }
    }
    String queryString =
        "$prefixString INTO ${inputEntity.entityName} ($fieldsString) VALUES ($valuesString)";
    queries.insert(0, queryString);
    return queries;
  }

  static Future<List<String>> constructUpdateQueries(DBInputEntity inputEntiry,
      {bool isFromApp = false, bool isDelete = false}) async {
    String updateString = "";
    List<String> queries = [];

    List<FieldMetaData> fieldMetas = await getFieldMetaDataList();

    if (fieldMetas.isEmpty) {
      throw ("${inputEntiry.entityName} fields are not found in Framework DB in field_meta table.");
    }

    // Get Gid field
    List<FieldMetaData> gidFieldMetas = fieldMetas
        .where((element) => (element.structureName == inputEntiry.entityName &&
            element.isGid == "1"))
        .toList();

    if (gidFieldMetas.isEmpty) {
      throw ("Invalid JSON data.");
    }

    if (inputEntiry.jsonData[FieldLid] == null) {
      throw ("${inputEntiry.entityName} LID field is not set.");
    }

    StructureMetaData structureMetaData = ((await getStructureMetaDataList()))
        .firstWhere(
            (element) => element.structureName == inputEntiry.entityName);
    if (structureMetaData.isHeader != "1" &&
        inputEntiry.jsonData[FieldFid] == null) {
      throw ("${inputEntiry.entityName} FID field is not set.");
    }

    inputEntiry.jsonData[FieldTimestamp] =
        DateTime.now().millisecondsSinceEpoch;

    if (isFromApp &&
        (inputEntiry.jsonData[FieldObjectStatus] == null ||
            inputEntiry.jsonData[FieldObjectStatus] ==
                ObjectStatus.global.index)) {
      inputEntiry.jsonData[FieldObjectStatus] =
          isDelete ? ObjectStatus.delete.index : ObjectStatus.modify.index;
    }

    Iterable<String> jsonDataKeys = inputEntiry.jsonData.keys;
    List<FieldMetaData> entityFieldMetas = fieldMetas
        .where((element) => element.structureName == inputEntiry.entityName)
        .toList(); //Filter fieldMetas of only the incoming entity name

    List<String> constantFields = [
      FieldLid,
      FieldFid,
      FieldConflict,
      FieldTimestamp,
      FieldObjectStatus,
      FieldSyncStatus
    ];

    for (String key in jsonDataKeys) {
      dynamic value = inputEntiry.jsonData[key];
      if (!(value is List<dynamic>)) {
        if (entityFieldMetas
                    .indexWhere((element) => element.fieldName == key) ==
                -1 &&
            !constantFields.contains(key)) {
          //Field is not present in meta data
          continue;
        }
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
            (await (await DatabaseManager().getFrameworkDB()).allFieldMetas)
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
          if (element[FieldFid] != inputEntiry.jsonData[FieldLid]) {
            throw ("${inputEntiry.entityName} LID field did not match with $key FID field.");
          }

          element[FieldTimestamp] = DateTime.now().millisecondsSinceEpoch;
          if (isFromApp) {
            element[FieldObjectStatus] =
                inputEntiry.jsonData[FieldObjectStatus];
          }

          Iterable<String> elementKeys = element.keys;
          List<FieldMetaData> childFieldMetas = fieldMetas
              .where((element) => element.structureName == key)
              .toList(); //Filter fieldMetas of only the incoming child entity name

          for (String childKey in elementKeys) {
            if (childFieldMetas.indexWhere(
                        (element) => element.fieldName == childKey) ==
                    -1 &&
                !constantFields.contains(childKey)) {
              //Field is not present in meta data
              continue;
            }
            dynamic childValue = element[childKey];
            int index = childGidFieldMetas.indexWhere(
                (childElement) => childElement.fieldName == childKey);
            if (childKey != FieldLid && childKey != FieldFid) {
              if (childValue is String) {
                childValue = childValue.replaceAll("'", "''");
              }
              if (childValue != null) {
                childUpdateString +=
                    (childUpdateString.length == 0 ? "" : ", ") +
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
        "UPDATE ${inputEntiry.entityName} SET $updateString WHERE $FieldLid = '${inputEntiry.jsonData[FieldLid]}'";
    queries.add(queryString);
    return queries;
  }

  List<Map<String, dynamic>> _upadteHeaderWithChildData(
      List<Map<String, dynamic>> headerResult,
      String gitField,
      String childEntity,
      List<Map<String, dynamic>> childResult) {
    headerResult.forEach((element) {
      List<Map<String, dynamic>> filteredList = childResult
          .where((childElement) => childElement[gitField] == element[gitField])
          .toList();
      element[childEntity] = filteredList;
    });
    return headerResult;
  }
}
