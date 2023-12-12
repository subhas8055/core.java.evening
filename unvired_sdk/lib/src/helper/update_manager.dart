import 'dart:developer';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:unvired_sdk/src/application_meta/application_metadata_parser.dart';
import 'package:unvired_sdk/src/authentication_service.dart';
import 'package:unvired_sdk/src/database/application_manager.dart';

import 'package:unvired_sdk/src/database/database_manager.dart';
import 'package:unvired_sdk/src/database/framework_database.dart';

import 'package:unvired_sdk/src/database/temp_database.dart';
import 'package:unvired_sdk/src/helper/isolate_helper.dart';
import 'package:unvired_sdk/src/helper/path_manager.dart';
import 'package:path/path.dart' as p;
import 'package:unvired_sdk/src/helper/service_constants.dart';
import 'package:unvired_sdk/src/helper/sync_result.dart';

class UpdateManager {
  Future<bool> isUpdateAvailable() async {
    bool updateAvailable = false;
    FrameworkDatabase frameworkDatabase =
        await DatabaseManager().getFrameworkDB();

    //Existing application version in FW DB.
    ApplicationMetaData applicationMetaDataDb =
        (await frameworkDatabase.allApplicationMetas).first;

    //Current metadata application version
    ApplicationMetaData applicationMetaData =
        ApplicationMetaDataParser().getApplicationMeta();

    if (double.parse(applicationMetaDataDb.version) <
        double.parse(applicationMetaData.version)) {
      updateAvailable = true;
    }

    return updateAvailable;
  }

  Future<UpgradeResult> upgrade() async {
    UpgradeResult upgradeResult = UpgradeResult(true, "");
    String appDBFilePath = await PathManager.getAppDBPath(
        (await AuthenticationService().getSelectedAccount())!.getUserId());
    FrameworkDatabase frameworkDatabase =
        await DatabaseManager().getFrameworkDB();
    String applicationPath = await PathManager.getApplicationPath(
        (await AuthenticationService().getSelectedAccount())!.getUserId());
    String backupDbPathTemp = p.join(applicationPath, AppDBTempName);

    //Create backupDB from appDB
    File file = File(appDBFilePath);
    await file.copy(backupDbPathTemp);

    //Delete appDB after backup
    //await (await DatabaseManager().getAppDB()).close();
    await file.delete();

    //Update new metadata to frameworkDB
    await frameworkDatabase.deleteDataForUpgrade();

    //Create new appDB
    ApplicationManager applicationManager = ApplicationManager();
    await applicationManager.initialize(
        AuthenticationService().getAppName(), "");

    //Copy data from backupDB to appDB
    upgradeResult = await createAppDb(backupDbPathTemp);

    //Delete backupDB
    // File backupDbFile = File(backupDbPathTemp);
    await Directory(backupDbPathTemp).delete(recursive: true);
    // try {
    //   await backupDbFile.delete(recursive: true);
    // } catch (e) {
    //   throw e;
    // }

    return upgradeResult;
  }

  Future<dynamic> getTempDbTableNames(
      String query, TempDatabase appTempDatabase) async {
    List<QueryRow> rows = await (appTempDatabase).customWriteReturning(query);
    List<Map<String, dynamic>> result = rows.map((e) => e.data).toList();
    return result;
  }

  Future<bool> checkIfTableExistsInBackupDb(
      String tableName, TempDatabase appTempDatabase) async {
    final String countQuery =
        "SELECT COUNT(*) FROM sqlite_master WHERE name='" + tableName + "'";
    List<QueryRow> rows =
        await (appTempDatabase).customWriteReturning(countQuery);
    List<Map<String, dynamic>> result = rows.map((e) => e.data).toList();
    if (result[0]["COUNT(*)"] == 0) {
      return false;
    } else {
      return true;
    }
  }

  Future<dynamic> copyAllDataFromBackupDBtoAppDB(
      String tableName, TempDatabase appTempDatabase) async {
    final String countQuery = "SELECT * FROM $tableName";
    List<QueryRow> rows =
        await (appTempDatabase).customWriteReturning(countQuery);
    List<Map<String, dynamic>> result = rows.map((e) => e.data).toList();
    if (result.length > 0) {
      for (Map<String, dynamic> row in result) {
        String fieldsString = "";
        String valuesString = "";
        Iterable<String> jsonDataKeys = row.keys;
        for (String key in jsonDataKeys) {
          dynamic value = row[key];
          fieldsString += (fieldsString.length == 0 ? "" : ", ") + "$key";
          valuesString += (valuesString.length == 0 ? "" : ", ") + "'$value'";
        }
        String queryString =
            "INSERT INTO ${tableName} ($fieldsString) VALUES ($valuesString)";
        try {
          List<QueryRow> rows = await (await DatabaseManager().getAppDB())
              .customWriteReturning(queryString);
          List<Map<String, dynamic>> result = rows.map((e) => e.data).toList();
        } catch (e) {
          throw e;
        }
      }
    }
    return true;
  }

  createAppDb(String backupDbPathTemp) async {
    UpgradeResult upgradeResult = UpgradeResult(true, "");
    FrameworkDatabase frameworkDatabase =
        await DatabaseManager().getFrameworkDB();
    TempDatabase? _appTempDatabase = TempDatabase.connect(
        await createDatabaseConnection(
            backupDbPathTemp,
            (await AuthenticationService().getSelectedAccount())!.getUserId(),
            DbType.backupDb));
    List<StructureMetaData> structureMetaList =
        await frameworkDatabase.allStructureMetas;
    for (StructureMetaData structureMetaData in structureMetaList) {
      bool isTablePresent = await checkIfTableExistsInBackupDb(
          structureMetaData.structureName, _appTempDatabase);
      if (isTablePresent) {
        try {
          await copyAllDataFromBackupDBtoAppDB(
              structureMetaData.structureName, _appTempDatabase);
        } catch (e) {
          upgradeResult.success = false;
          upgradeResult.error = e.toString();
          break;
        }
      }
    }
    try {
      await driftIsolateBackupDb!.shutdownAll();
      await _appTempDatabase.close();
      return upgradeResult;
    } catch (e) {
      throw e;
    }
  }
}
