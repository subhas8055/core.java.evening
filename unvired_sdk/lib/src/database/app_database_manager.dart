import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:unvired_sdk/src/attachment/attachment_helper.dart';
import 'package:unvired_sdk/src/authentication_service.dart';
import 'package:unvired_sdk/src/helper/http_connection.dart';
import 'package:unvired_sdk/src/helper/sync_input_data_manager.dart';
import 'package:unvired_sdk/src/helper/url_service.dart';

import '../application_meta/field_constants.dart';
import '../database/database.dart';
import '../database/database_manager.dart';
// import '../database/framework_database.dart';

class AppDatabaseManager {
  /// To get Application Database instance.
  ///
  /// **@return** Database instance.
  ///
  /// **@throw** If an error occurs, throws the error information.
  ///
  /// **Usage:**
  /// ```dart
  ///   try {
  ///     await AppDatabaseManager().insert(dbInputEntity);
  ///   } catch (e) {
  ///   }
  /// ```
  Future<Database> getAppDB() async {
    return DatabaseManager().getAppDB();
  }

  // Future<FrameworkDatabase> getFrameworkDB() async {
  //   return await DatabaseManager().getFrameworkDB();
  // }

  // INSERT
  /// Insert the data into the database.
  /// Create an instance of the DBInputEntity.
  /// Set the required fields and pass the dbInputEntity object into insert function.
  ///
  /// **@param** [dbInputEntity] which contains entity name and json that is to be inserted in the database
  ///
  /// **@return** A boolean value indicating the execution status of the database query.
  ///
  /// **@throw** If an error occurs, throws the error information.
  ///
  /// **Usage:**
  ///
  /// ```dart
  ///   Map<String, dynamic> customerHeader = {
  ///     "CITY": "Bangalore",
  ///     "COUNTRY": "IN",
  ///     "CUST_NO": "CUST_0",
  ///     "EMAIL": "cust0@unvired.io",
  ///     "HOUSE_NO": "No 0",
  ///     "MOB_NO": "9845098450",
  ///     "NAME1": "First 0",
  ///     "NAME2": "Last 0",
  ///     "PINCODE": "560038",
  ///     "STATE": "Karnataka",
  ///     "STREET": "MG Road",
  ///   }
  ///   DBInputEntity dbInputEntity = DBInputEntity("CUSTOMER_HEADER", customerHeader);
  ///   try {
  ///     await AppDatabaseManager().insert(dbInputEntity);
  ///   } catch (e) {
  ///   }
  /// ```
  Future<bool> insert(DBInputEntity dbInputEntity) async {
    return await DatabaseManager().insert(dbInputEntity, isFromApp: true);
  }

  // UPDATE
  /// Update the data into the database based on entity name and LID.
  /// Create an instance of the DBInputEntity.
  /// Set the required fields and pass the dbInputEntity object into update function.
  ///
  ///
  /// **@param** [dbInputEntity] which contains entity name and json that is to be updated in the database.
  ///
  /// **@return** A boolean value indicating the execution status of the database query.
  ///
  /// **@throw** If an error occurs, throws the error information.
  ///
  /// **Usage:**
  /// ```dart
  ///   Map<String, dynamic> customerHeader = {
  ///     "LID": "9e204c57-0354-49b2-adc3-011def20f2f5"
  ///     "CITY": "Mysore",
  ///     "HOUSE_NO": "No 00",
  ///   }
  ///   DBInputEntity dbInputEntity = DBInputEntity("CUSTOMER_HEADER", customerHeader);
  ///   try {
  ///     await AppDatabaseManager().update(dbInputEntity);
  ///   } catch (e) {
  ///   }
  /// ```
  Future<bool> update(DBInputEntity dbInputEntity) async {
    return await DatabaseManager().update(dbInputEntity, isFromApp: true);
  }

  // DELETE
  /// Delete the row from the database based on entity name and LID.
  /// Create an instance of the DBInputEntity.
  /// Set the required fields and pass the dbInputEntity object into delete function.
  ///
  /// **@param** [dbInputEntity] which contains entity and json that is to be marked as delete in the database.
  ///
  /// **@return** A boolean value indicating the execution status of the database query.
  ///
  /// **@throw** If an error occurs, throws the error information.
  ///
  /// **Usage:**
  /// ```dart
  ///   Map<String, dynamic> customerHeader = {
  ///     "LID": "9e204c57-0354-49b2-adc3-011def20f2f5"
  ///   }
  ///   DBInputEntity dbInputEntity = DBInputEntity("CUSTOMER_HEADER", customerHeader);
  ///   try {
  ///     await AppDatabaseManager().delete(dbInputEntity);
  ///   } catch (e) {
  ///   }
  /// ```
  Future<bool> delete(DBInputEntity dbInputEntity) async {
    if (dbInputEntity.jsonData.isEmpty ||
        dbInputEntity.jsonData[FieldLid] == null) {
      Logger.logError("AppDatabaseManager", "delete",
          "${dbInputEntity.entityName} LID field is not set.");
      throw ("${dbInputEntity.entityName} LID field is not set.");
    }
    if (dbInputEntity.jsonData[FieldObjectStatus] == ObjectStatus.add.index) {
      int result = await DatabaseManager().delete(dbInputEntity);
      return result == 1;
    }
    return await DatabaseManager()
        .update(dbInputEntity, isFromApp: true, isDelete: true);
  }

  // SELECT
  /// Select data from the database based on entity name and where clause.
  /// Create an instance of the DBInputEntity.
  /// Set the required fields and pass the dbInputEntity object into delete function.
  ///
  /// **@param** [dbInputEntity] which contains entity name and the where clause for select statement.
  ///
  /// **@return** A List of data from the select statement.
  ///
  /// **@throw** If an error occurs, throws the error information.
  ///
  /// **Usage:**
  /// ```dart
  ///   String whereClause = "CITY='Bangalore'"
  ///   DBInputEntity dbInputEntity = DBInputEntity("CUSTOMER_HEADER", {})..setWhereClause(whereClause));
  ///   try {
  ///     await AppDatabaseManager().select(dbInputEntity);
  ///   } catch (e) {
  ///   }
  /// ```
  Future<List<dynamic>> select(DBInputEntity dbInputEntity) async {
    return await DatabaseManager().select(dbInputEntity);
  }

  // EXECUTE
  /// Executes a single SQL statement that does not return data. SQL statement CANNOT be a SELECT, MAX, MIN, TOTAL, etc. statement.
  ///
  /// **@param** [sqlStatement] Single SQL statement that has to be executed.
  ///
  /// **@throw** If an error occurs, throws the error information.
  ///
  /// **Usage:**
  /// ```dart
  ///   String sqlStatement = "DELETE CUSTOMER_HEADER WHERE LID='9e204c57-0354-49b2-adc3-011def20f2f5'";
  ///   try {
  ///     await AppDatabaseManager().execute(sqlStatement);
  ///   } catch (e) {
  ///   }
  /// ```
  Future<dynamic> execute(String sqlStatement) async {
    return await DatabaseManager().execute(sqlStatement);
  }

  // CHILDREN DATA
  /// Get all the children data of a header based based on the Object Status and Sync Status using enum DataType.
  ///
  /// **@param** [header] Header for which the children data has to be fetched.
  /// **@param** [dataType] type of children that has to be fetched. i.e (all,changed,queued).
  ///
  /// **@return** A List<dynamic> with all the ITEM data of the HEADER.
  ///
  /// **@throw** If an error occurs, throws the error information.
  ///
  /// **Usage:**
  /// ```dart
  ///   Map<String, dynamic> customerHeader = {
  ///     "LID": "9e204c57-0354-49b2-adc3-011def20f2f5"
  ///     "CITY": "Mysore",
  ///     "HOUSE_NO": "No 00",
  ///   }
  ///   try {
  ///     await AppDatabaseManager().getChildrenData(header : customerHeader,dataType : DataType.changed);
  ///   } catch (e) {
  ///   }
  /// ```
  Future<List<dynamic>> getChildrenData(
      {required Map<String, dynamic> header,
        DataType dataType = DataType.all}) async {
    return await DatabaseManager().getChildrenData(header: header,dataType: dataType);
  }

  // CHILDREN ITEM NAMES
  /// Get all the children ITEMS of a HEADER.
  ///
  /// **@param** [tableName] Header table name for which the ITEM has to be returned.
  ///
  /// **@return** A List<String> with all the ITEM names of the HEADER.
  ///
  /// **@throw** If an error occurs, throws the error information.
  ///
  /// **Usage:**
  /// ```dart
  ///   try {
  ///     await AppDatabaseManager().getChildrenItemNames(tableName : CUSTOMER_HEADER.TABLE_NAME);
  ///   } catch (e) {
  ///   }
  /// ```
  Future<List<String>> getChildrenItemNames({required String tableName}) async {
    return await DatabaseManager().getChildrenItemNames(tableName: tableName);
  }

    /// S A V E P O I N T
  ///
  /// Create Save point
  Future<void> createSavePoint(String savePointName) async {
    if (savePointName.length == 0) {
      throw ("Savepoint Name is empty.");
    }
    Database appDb = await DatabaseManager().getAppDB();
    appDb.customStatement("SAVEPOINT $savePointName");
  }

  /// Release save point
  Future<void> releaseSavePoint(String savePointName) async {
    if (savePointName.length == 0) {
      throw ("Savepoint Name is empty.");
    }
    Database appDb = await DatabaseManager().getAppDB();
    appDb.customStatement("RELEASE SAVEPOINT $savePointName");
  }

  /// Rollback save point
  Future<void> rollbackToSavePoint(String savePointName) async {
    if (savePointName.length == 0) {
      throw ("Savepoint Name is empty.");
    }
    Database appDb = await DatabaseManager().getAppDB();
    appDb.customStatement("ROLLBACK TO SAVEPOINT $savePointName");
  }

  /// Get save point name
  String getSavePointName() {
    return "S${DateTime.now().millisecondsSinceEpoch}D";
  }

  /// T R A N S A C T I O N S
  ///
  /// Begin transaction before sqlite database query execution
  Future<void> beginTransaction() async {
    Database appDb = await DatabaseManager().getAppDB();
    appDb.customStatement("BEGIN TRANSACTION");
  }

  /// Commit transaction after sqlite database query execution
  Future<void> commitTransaction() async {
    Database appDb = await DatabaseManager().getAppDB();
    appDb.customStatement("COMMIT TRANSACTION");
  }

  /// Rollback the transaction execution
  Future<void> rollbackTransaction() async {
    Database appDb = await DatabaseManager().getAppDB();
    appDb.customStatement("ROLLBACK TRANSACTION");
  }

  // DOWNLOAD ATTACHMENT BY UID
  /// Download attachment based on uid and get bytes of the attachment
  ///
  /// **@param** [uid] uid of the attachment.
  ///
  /// **@return** A List<int> bytes of the attachment downloaded.
  ///
  /// **@throw** If an error occurs, throws the error information.
  ///
  /// **Usage:**
  /// ```dart
  ///   try {
  ///     await AppDatabaseManager().downloadAttachmentAndGetBytes(uid);
  ///   } catch (e) {
  ///   }
  /// ```
  Future<List<int>> downloadAttachmentAndGetBytes(String uid)async{
    final appBaseUrl = URLService.getApplicationUrl(
        (await AuthenticationService().getSelectedAccount())!.getUrl());
    Response result= await HTTPConnection.downloadAttachment(
        uid,
        account:  await AuthenticationService().getSelectedAccount(),
        appBaseUrl: appBaseUrl,
        bearerAuth: HTTPConnection.bearerAuth,
        appName: AuthenticationService().getAppName());
    return result.bodyBytes;
  }

  // DOWNLOAD ATTACHMENT BY UID AND GET LOCAL PATH
  /// Download attachment based on uid and get local path of the attachment in return
  ///
  /// **@param** [uid] uid of the attachment.
  /// **@param** [fileName] name of the attachment.
  ///
  /// **@return** A String value with the local path of the downloaded attachment.
  ///
  /// **@throw** If an error occurs, throws the error information.
  ///
  /// **Usage:**
  /// ```dart
  ///   try {
  ///     await AppDatabaseManager().downloadAttachmentAndGetPath(uid);
  ///   } catch (e) {
  ///   }
  /// ```
  Future<String?> downloadAttachmentAndGetPath(String uid,String fileName)async {
    return (await AttachmentHelper().downloadAttachmentAndGetPath(uid, fileName));
  }
}
