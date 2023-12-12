import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:drift/drift.dart';

import '../application_meta/field_constants.dart';
import '../authentication_service.dart';
import '../database/database_manager.dart';
import '../database/framework_database.dart';
import '../helper/connectivity_manager.dart';
import '../helper/framework_helper.dart';
import '../helper/http_connection.dart';
import '../helper/path_manager.dart';
import '../helper/service_constants.dart';
import '../helper/url_service.dart';
import '../unvired_account.dart';
import 'status.dart';

enum DataType { all, changed, changedQueued, queued }

class SyncInputDataManager {
  static Future<Map<String, dynamic>> constructInputBeJson(
      String entityName, Map<String, dynamic> dataObject) async {
    FrameworkDatabase frameworkDatabase =
        await DatabaseManager().getFrameworkDB();
    if (dataObject.isEmpty) {
      return {};
    }
    String? lid = dataObject[FieldLid];
    if (lid == null) {
      throw ("$FieldLid is mandatory in the input data.");
    }

    try {
      FrameworkDatabase frameworkDatabase =
          await DatabaseManager().getFrameworkDB();
      StructureMetaData structureMeta =
          (await frameworkDatabase.allStructureMetas)
              .firstWhere((element) => element.structureName == entityName);
      BusinessEntityMetaData beMeta =
          (await frameworkDatabase.allBusinessEntityMetas)
              .firstWhere((element) => element.beName == structureMeta.beName);
      String whereClause = "$FieldLid='$lid'";
      DBInputEntity inputEntity = DBInputEntity(entityName, {})
        ..setWhereClause(whereClause);
      List<dynamic> result = await DatabaseManager().select(inputEntity);

      if (result.length == 0) {
        throw ("Data not found for $FieldLid: $lid.");
      }
      dynamic header = result[0];
      if (header[FieldSyncStatus] == SyncStatus.queued) {
        throw ("Entity is in outbox. Cannot be submitted again.");
      }
      if (header[FieldSyncStatus] == SyncStatus.sent) {
        throw ("Entity is in sent items waiting for a response from the server. Cannot be submitted again.");
      }

      Map<String, dynamic> beObject = {structureMeta.structureName: header};
      Map<String, dynamic> items =
          await getChildData(lid, structureMeta.beName, DataType.changed);
      beObject.addAll(items);
      Map<String, dynamic> inputObject = {
        beMeta.beName: [beObject]
      };
      return inputObject;
    } catch (e) {
      Logger.logError("SyncInputDataManager", "hasAttachments", e.toString());
    }
    return {};
  }

  static Future<Map<String, dynamic>> getChildData(
      String lid, String beName, DataType dataType) async {
    List<StructureMetaData> childStructureMetas =
        (await (await DatabaseManager().getFrameworkDB()).allStructureMetas)
            .where((element) =>
                element.beName == beName && element.isHeader != "1")
            .toList();

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
    Map<String, dynamic> childJsonObject = {};
    for (StructureMetaData structureMetaData in childStructureMetas) {
      DBInputEntity inputEntity =
          DBInputEntity(structureMetaData.structureName, {})
            ..setWhereClause(whereClause);

      try {
        List<dynamic> result = await DatabaseManager().select(inputEntity);
        childJsonObject[structureMetaData.structureName] = result;
      } catch (e) {
        Logger.logError("SyncInputDataManager", "_getChildData", e.toString());
      }
    }
    return childJsonObject;
  }

  static checkAndUploadAttachments(
      String entityName, Map<String, dynamic> inputData,
      {bool isAsynchronous = false}) async {
    FrameworkDatabase frameworkDatabase =
        await DatabaseManager().getFrameworkDB();
    List<StructureMetaData> structureMetas =
        await frameworkDatabase.allStructureMetas;
    StructureMetaData? structureMeta = structureMetas
        .firstWhereOrNull((element) => element.structureName == entityName);

    // Invalid condition. Should never occur.
    if (structureMeta == null) {
      Logger.logError("SyncInputDataManager", "checkAndUploadAttachments",
          "Invalid BE. Cannot Upload Attachments. Table Name: $entityName");
      return;
    }

    // if it has attachments, upload it first... and then continue queuing
    // it.
    // check if the IDataStructure in context supports attachments, if yes,
    // check if it has any, if yes attach it using the protocol defined.

    // structMeta will certainly be null in 2 cases.
    // 1. SendDataQueryInAsyncMode, because predicting the output BE is not
    // possible.
    // 2. while using input business entity as input (custom data)

    // If attachments are not supported do not do anything

    if (!await isAttachmentSupportedForBEName(structureMeta.beName)) {
      print(structureMeta.beName);
      Logger.logError("SyncInputDataManager", "checkAndUploadAttachments",
          "This BE: ${structureMeta.beName} does not support attachments.");
      return;
    }

    try {
      List<String> attachmentItemNames = structureMetas
          .where((element) =>
              element.beName == structureMeta.beName &&
              element.structureName.endsWith(AttachmentBE))
          .map((e) => e.structureName)
          .toList();

      for (String attachmentItemName in attachmentItemNames) {
        List<dynamic> attachmentItems =
            await getAttachmentsMarkedForUpload(attachmentItemName, inputData);
        for (Map<String, dynamic> attachmentItem in attachmentItems) {
          try {
            _copyAttachmentToApplicationFolder(
                attachmentItemName, attachmentItem);
            if (isAsynchronous) {
              // Wait till the internet is connected.
              await ConnectivityManager().waitForConnection();
            } else {
              if (!(await URLService.isInternetConnected())) {
                break;
              }
              if (!(await HTTPConnection.isServerReachable())) {
                break;
              }
            }
            http.StreamedResponse response =
                await HTTPConnection.uploadAttachment(attachmentItem);
            if (response.statusCode == Status.httpOk ||
                response.statusCode == Status.httpCreated) {
              _updateAttachmentStatus(
                  attachmentItemName, attachmentItem, AttachmentStatusUploaded);
            } else {
              Logger.logError(
                  "SyncInputDataManager",
                  "checkAndUploadAttachments",
                  "Error while uploading attachment.");

              InfoMessageData infoMessage = InfoMessageData(
                  lid: FrameworkHelper.getUUID(),
                  timestamp: DateTime.now().millisecondsSinceEpoch,
                  objectStatus: ObjectStatus.global.index,
                  syncStatus: SyncStatus.none.index,
                  type: "",
                  subtype: "",
                  category: InfoMessageFailure,
                  message: "Error while uploading attachment.",
                  bename: entityName,
                  belid: attachmentItem[FieldLid],
                  messagedetails: Uint8List(0));
              await (await DatabaseManager().getFrameworkDB())
                  .addInfoMessage(infoMessage);
              _updateAttachmentStatus(attachmentItemName, attachmentItem,
                  AttachmentStatusErrorInUpload);
            }
          } catch (e) {
            Logger.logError("SyncInputDataManager", "checkAndUploadAttachments",
                e.toString());
            _updateAttachmentStatus(attachmentItemName, attachmentItem,
                AttachmentStatusErrorInUpload);
          }
        }
      }
    } catch (e) {
      Logger.logError(
          "SyncInputDataManager", "checkAndUploadAttachments", e.toString());
    }
  }

  static Future<bool> _copyAttachmentToApplicationFolder(
      String attachmentItemName, Map<String, dynamic> attachmentItem) async {
    UnviredAccount? selectedAccount =
        await AuthenticationService().getSelectedAccount();
    if (selectedAccount == null) {
      Logger.logError("Attachment", "saveAttachmentForUpload",
          "Application has not logged in.");
      throw ("Application has not logged in.");
    }
    String appPath =
        await PathManager.getApplicationPath(selectedAccount.getUserId());
    String localPath = attachmentItem[AttachmentItemFieldLocalPath];
    String attachmentFolder =
        await PathManager.getAttachmentFolderPath(selectedAccount.getUserId());
    String uid = FrameworkHelper.getUUID();

    // if fileName is missing, then Use the UID for the fileName and No Extension
    String filePath = "";
    String? fileNameWithExtension = attachmentItem[AttachmentItemFieldFileName];
    if (fileNameWithExtension == null) {
      filePath = "$attachmentFolder/$uid";
    } else {
      filePath = "$attachmentFolder/$fileNameWithExtension";
    }
    PathManager.copyAttachment(localPath, filePath);
    attachmentItem[AttachmentItemFieldLocalPath] = filePath;
    DBInputEntity dbInputEntity =
        DBInputEntity(attachmentItemName, attachmentItem);
    return await DatabaseManager().update(dbInputEntity);
  }

  static Future<bool> _updateAttachmentStatus(String attachmentItemName,
      Map<String, dynamic> attachmentItem, String attachmentStatus) async {
    attachmentItem[AttachmentItemFieldAttachmentStatus] = attachmentStatus;
    DBInputEntity dbInputEntity =
        DBInputEntity(attachmentItemName, attachmentItem);
    return await DatabaseManager().update(dbInputEntity);
  }

  static Future<bool> isAttachmentSupportedForBEName(String beName) async {
    if (beName.isEmpty) {
      return false;
    }
    try {
      BusinessEntityMetaData beMeta =
          (await (await DatabaseManager().getFrameworkDB())
                  .allBusinessEntityMetas)
              .firstWhere((element) => element.beName == beName);
      return beMeta.attachments == "1";
    } catch (e) {
      Logger.logError("SyncInputDataManager", "hasAttachments", e.toString());
    }
    return false;
  }

  static Future<List<dynamic>> getAttachmentsMarkedForUpload(
      String attachmentItemName, Map<String, dynamic> inputData) async {
    //check if the IDataStructure in question supports attachments, if yes, check if it has any, if yes attach it using the protocols.
    String whereClause =
        "$FieldFid = '${inputData[FieldLid]}' AND $AttachmentItemFieldAttachmentStatus = '$AttachmentStatusSavedForUpload'";
    DBInputEntity dbInputEntity = DBInputEntity(attachmentItemName, {})
      ..setWhereClause(whereClause);
    List<dynamic> attachmentItems =
        await DatabaseManager().select(dbInputEntity);
    return attachmentItems;
  }
}
