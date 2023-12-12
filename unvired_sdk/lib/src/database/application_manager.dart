import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import '../database/database.dart';
import '../database/framework_database.dart';
import '../database/database_manager.dart';
import '../application_meta/application_metadata_parser.dart';
import '../application_meta/field_constants.dart';
import '../application_meta/index_meta.dart';

class ApplicationManager {
  ApplicationMetaDataParser _parser = ApplicationMetaDataParser();

  // FrameworkDatabase _fwDatabase = (await DatabaseManager().getFrameworkDB());

  // INITIALIZES THE FW USING METADATA
  /// Initializes the FW using the provided metadata. i.e Creates Framework database and Application database
  ///
  /// **@param** [appName] Application name.
  /// **@param** [keyForApplicationDatabase] key used in application database.
  ///
  /// **@return** A bool indicating if it is successfully initialized.
  ///
  /// **@throw** If an error occurs, throws the error information.
  ///
  /// **Usage:**
  /// ```dart
  ///   try {
  ///     await ApplicationManager().initialize("appName","");
  ///   } catch (e) {
  ///   }
  /// ```
  Future<bool> initialize(
      String appName, String keyForApplicationDatabase) async {
    try {
      await insertParsedDataIntoFrameworkTables();
      await createAppTables();
    } catch (e) {
      Logger.logError("ApplicationManager", "initialize", e.toString());
      throw e;
    }
    return true;
  }

  Future<bool> insertParsedDataIntoFrameworkTables() async {
    FrameworkDatabase fwDb = await DatabaseManager().getFrameworkDB();
    try {
      Logger.logInfo(
          "ApplicationManager",
          "insertParsedDataIntoFrameworkTables",
          "Adding application meta into FW DB");
      //await (fwDb).transaction(() => fwDb.addApplicationMeta(_parser.getApplicationMeta()));
      await fwDb.batch((batch) => batch
          .insertAll(fwDb.applicationMeta, [_parser.getApplicationMeta()]));
    } catch (e) {
      Logger.logError(
          "ApplicationManager",
          "insertParsedDataIntoFrameworkTables",
          "Error while adding Application Meta. Error: " + e.toString());
      throw e;
    }

    Logger.logInfo("ApplicationManager", "insertParsedDataIntoFrameworkTables",
        "Adding businessEntityMeta into FW DB");
    await fwDb.batch((batch) => batch.insertAll(
        fwDb.businessEntityMeta, _parser.getBusinessEntityMetas()));

    // for (BusinessEntityMetaData businessEntityMeta
    //     in _parser.getBusinessEntityMetas()) {
    //   try {
    //     Logger.logInfo("ApplicationManager", "insertParsedDataIntoFrameworkTables", "Adding businessEntityMeta ${businessEntityMeta.beName} into FW DB");
    //     await (fwDb).transaction(() async =>
    //         (fwDb)
    //             .addBusinessEntityMeta(businessEntityMeta));
    //   } catch (e) {
    //     Logger.logError(
    //         "ApplicationManager",
    //         "insertParsedDataIntoFrameworkTables",
    //         "Error while adding Business Entity Meta. Error: " + e.toString());
    //     throw e;
    //   }
    // }

    Logger.logInfo("ApplicationManager", "insertParsedDataIntoFrameworkTables",
        "Adding structureMeta into FW DB");
    await fwDb.batch((batch) =>
        batch.insertAll(fwDb.structureMeta, _parser.getStructureMetas()));

    // for (StructureMetaData structureMeta in _parser.getStructureMetas()) {
    //   try {
    //     Logger.logInfo("ApplicationManager", "insertParsedDataIntoFrameworkTables", "Adding structureMeta ${structureMeta.structureName} into FW DB");
    //     await (fwDb).transaction(() async =>
    //         (fwDb)
    //             .addStructureMeta(structureMeta));
    //   } catch (e) {
    //     Logger.logError(
    //         "ApplicationManager",
    //         "insertParsedDataIntoFrameworkTables",
    //         "Error while adding Structure Meta. Error: " + e.toString());
    //     throw e;
    //   }
    // }

    Logger.logInfo("ApplicationManager", "insertParsedDataIntoFrameworkTables",
        "Adding fieldMeta into FW DB");

    await fwDb.batch(
        (batch) => batch.insertAll(fwDb.fieldMeta, _parser.getFieldMetas()));

    // for (FieldMetaData fieldMeta in _parser.getFieldMetas()) {
    //   try {
    //     Logger.logInfo("ApplicationManager", "insertParsedDataIntoFrameworkTables", "Adding fieldMeta ${fieldMeta.fieldName} into FW DB");
    //     await (fwDb).transaction(() async =>
    //         (fwDb).addFieldMeta(fieldMeta));
    //   } catch (e) {
    //     Logger.logError(
    //         "ApplicationManager",
    //         "insertParsedDataIntoFrameworkTables",
    //         "Error while adding Field Meta. Error: " + e.toString());
    //     throw e;
    //   }
    // }
    return true;
  }

  Future<bool> createAppTables() async {
    FrameworkDatabase fwDb = await DatabaseManager().getFrameworkDB();
    // Get the structure information related to the table
    List<StructureMetaData> structureMetas = await (fwDb).allStructureMetas;

    if (structureMetas.length == 0) {
      Logger.logError(
          "ApplicationManager", "createAppTables", "Invalid metadata.");
      throw "Invalid metadata.";
    }

    List<BusinessEntityMetaData> beMetaArray =
        await (fwDb).allBusinessEntityMetas;
    List<FieldMetaData> fieldMetaArray = await (fwDb).allFieldMetas;

    Map<String, dynamic> map = {
      "structureMetas": structureMetas,
      "beMetaArray": beMetaArray,
      "fieldMetaArray": fieldMetaArray
    };
    List<String> queries = await compute(appTableGenerator, map);
    Database db = await DatabaseManager().getAppDB();
    for (String query in queries) {
      if (query.length == 0) {
        throw ("Invalid input json data");
      }
      try {
        Logger.logInfo("ApplicationManager", "createAppTables",
            "Executing query : " + query);
        await db.transaction(() => db.customStatement(query));
      } catch (e) {
        Logger.logError("ApplicationManager", "createAppTables",
            "Error while creating tables. Error: " + e.toString());
        throw (e);
      }
    }

    for (IndexMeta indexMeta in _parser.getIndexMetas()) {
      String queryString = _prepareCreateIndexQuery(indexMeta.getIndexName(),
          indexMeta.getStructureName(), indexMeta.getFieldName());
      try {
        Logger.logInfo("ApplicationManager", "createAppTables",
            "Executing query : " + queryString);
        await db.transaction(() => db.customStatement(queryString));
      } catch (e) {
        Logger.logError("ApplicationManager", "createAppTables",
            "Error while creating Index. Error: " + e.toString());
        throw e;
      }
    }
    return true;
  }

  static String _prepareCreateTableQuery(
      String tableName,
      List<String> tableColumnNames,
      List<dynamic> tableColumnTypes,
      List<String> primaryKeys,
      List<String> uniqueKeys,
      List<bool> mandatoryFields,
      {List<String> foreignKeys = const [],
      String foreignKeyTableName = "",
      List<String> foreignKeyTableKeys = const []}) {
    String query = "";
    String primaryKey = primaryKeys.join(", ");
    String uniqueKey = uniqueKeys.join(", ");
    String foreignKey = "";
    String foreignKeyTableKey = "";

    if (foreignKeyTableName.length > 0) {
      foreignKey = foreignKeys.join(", ");
      foreignKeyTableKey = foreignKeyTableKeys.join(", ");
    }
    int noOfColumns = tableColumnNames.length;
    query += "CREATE TABLE IF NOT EXISTS $tableName (";

    for (int i = 0; i < noOfColumns; i++) {
      if (i == 0) {
        query += tableColumnNames[i];
      } else {
        query += ", ${tableColumnNames[i]}";
      }

      if (tableColumnTypes.length > 0) {
        query += " ${tableColumnTypes[i]}";
      }

      if (mandatoryFields.length > 0) {
        if (mandatoryFields[i]) {
          query += " NOT NULL";
        }
      }
    }

    if (primaryKey.length > 0) {
      query += ", PRIMARY KEY($primaryKey)";
    }

    if (uniqueKey.length > 0) {
      query += ", UNIQUE($uniqueKey)";
    }

    if (foreignKeyTableName.length > 0) {
      query +=
          ", FOREIGN KEY ($foreignKey) REFERENCES $foreignKeyTableName($foreignKeyTableKey) ON DELETE CASCADE";
    }
    query += ")";
    return query;
  }

  String _prepareCreateIndexQuery(
      String indexName, String structureName, List<String> fieldNames) {
    String query = "CREATE INDEX $indexName ON $structureName (";
    query += fieldNames.join(", ");
    query += ")";
    return query;
  }

  static Future<List<String>> appTableGenerator(
      Map<String, dynamic> message) async {
    List<String> queries = [];
    List<StructureMetaData> structureMetas = message['structureMetas'];
    List<BusinessEntityMetaData> beMetaArray = message['beMetaArray'];
    List<FieldMetaData> fieldMetaArray = message['fieldMetaArray'];

    int noOfStructureMetas = structureMetas.length;

    StructureMetaData structureMeta;
    List<String> foreignKeysForItemStructure = [FieldFid];
    List<String> parentsForForeignKeysInHeaderStructure = [FieldLid];

    for (int i = 0; i < noOfStructureMetas; i++) {
      structureMeta = structureMetas[i];

      // Get the Business Entity Meta for this Structure Meta.
      // For this BE, if the save flag is set to false, do not create tables for this structure.
      String beName = structureMeta.beName;
      if (beName.length == 0) {
        continue;
      }

      BusinessEntityMetaData beMeta =
          beMetaArray.firstWhere((element) => element.beName == beName);
      if (beMeta.save != "true") {
        continue;
      }

      // Get the fields that belong to the structure
      List<FieldMetaData> fieldMetas = fieldMetaArray
          .where((element) =>
              element.appName == structureMeta.appName &&
              element.beName == structureMeta.beName &&
              element.structureName == structureMeta.structureName)
          .toList();

      if (fieldMetas.length == 0) {
        throw "Invalid metadata.";
      }

      List<String> columnNames = [];
      List<dynamic> columnTypes = [];
      List<bool> mandatoryFields = [];

      List<String> gidsVector = [];

      List<String> primaryKeys = [FieldLid];
      bool isStructureHeader = structureMeta.isHeader == "1";

      // Add the Mandatory Fields.

      // 1. LID
      columnNames.add(FieldLid);
      columnTypes.add(FieldTypeLid);
      mandatoryFields.add(true);

      // 2. TIME_STAMP
      columnNames.add(FieldTimestamp);
      columnTypes.add(FieldTypeTimestamp);
      mandatoryFields.add(true);

      // 3. SYNC_STATUS
      columnNames.add(FieldSyncStatus);
      columnTypes.add(FieldTypeSyncStatus);
      mandatoryFields.add(true);

      // 4. OBJECT_STATUS
      columnNames.add(FieldObjectStatus);
      columnTypes.add(FieldTypeObjectStatus);
      mandatoryFields.add(true);

      if (isStructureHeader) {
        // 5. CONFLICT. For Headers only.
        columnNames.add(FieldConflict);
        columnTypes.add(FieldTypeConflict);
        mandatoryFields.add(false);

        // INFO_MSG_CAT. New field added to indicate if the header contains info messages.
        // This field is available one in flutter fw. It holds the Info Message category with high priority.
        // Priority Order (FAILURE > WARNING > INFO > SUCCESS)
        columnNames.add(FieldInfoMsgCat);
        columnTypes.add(FieldTypeInfoMsgCat);
        mandatoryFields.add(false);
      }

      // For Items, add a new field, FID.
      if (!isStructureHeader) {
        // FID
        columnNames.add(FieldFid);
        columnTypes.add(FieldTypeFid);
        mandatoryFields.add(true);
      }

      // Get field names and types
      FieldMetaData fieldMeta;

      for (int j = 0; j < fieldMetas.length; j++) {
        fieldMeta = fieldMetas[j];

        String _columnName = fieldMeta.fieldName;
        String _columnType = fieldMeta.sqlType;

        columnNames.add(_columnName);
        columnTypes.add(_columnType);

        if (fieldMeta.isGid == "1") {
          mandatoryFields.add(true);
          gidsVector.add(fieldMeta.fieldName);
        } else {
          mandatoryFields.add(false);
        }
      }

      int noOfGids = gidsVector.length;
      List<String> uniqueKeys = [];
      for (int j = 0; j < noOfGids; j++) {
        uniqueKeys.add(gidsVector[j]);
      }

      if (isStructureHeader) {
        String queryString = _prepareCreateTableQuery(
            structureMeta.structureName,
            columnNames,
            columnTypes,
            primaryKeys,
            uniqueKeys,
            mandatoryFields);
        queries.add(queryString);
      } else {
        String headerName = structureMeta.beName + "_HEADER";
        try {
          StructureMetaData headerStructureMeta = structureMetas.firstWhere(
              (element) =>
                  element.beName == structureMeta.beName &&
                  element.isHeader == "1");
          headerName = headerStructureMeta.structureName;
        } catch (e) {}
        String queryString = _prepareCreateTableQuery(
            structureMeta.structureName,
            columnNames,
            columnTypes,
            primaryKeys,
            uniqueKeys,
            mandatoryFields,
            foreignKeys: foreignKeysForItemStructure,
            foreignKeyTableName: headerName,
            foreignKeyTableKeys: parentsForForeignKeysInHeaderStructure);
        queries.add(queryString);
      }
    }
    return queries;
  }
}
