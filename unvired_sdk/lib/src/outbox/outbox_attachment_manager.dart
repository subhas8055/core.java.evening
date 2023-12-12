import 'dart:io';

import 'package:collection/src/iterable_extensions.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../application_meta/field_constants.dart';
import '../database/framework_database.dart';
import '../helper/service_constants.dart';
import '../helper/framework_helper.dart';
import '../helper/isolate_helper.dart';
import '../helper/status.dart';
import '../database/database.dart';
import '../unvired_account.dart';

Future<void> checkAndUploadAttachmentsInOutBox(
    String entityName,
    Map<String, dynamic> inputData,
    FrameworkDatabase frameworkDatabase,
    Database appDB,
    UnviredAccount selectedAccount,
    String authToken,
    String appName,
    String appBaseUrl,
    String attachmentFolderPath,
    String appPath) async {
  List<StructureMetaData> structureMetas =
      await frameworkDatabase.allStructureMetas;
  StructureMetaData? structureMeta = structureMetas
      .firstWhereOrNull((element) => element.structureName == entityName);

  // Invalid condition. Should never occur.
  if (structureMeta == null) {
    Logger.logError(
        "OutBoxAttachmentManager",
        "checkAndUploadAttachmentsInOutBox",
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
  bool isAttachmentSupported = await isAttachmentSupportedForBEName(
      structureMeta.beName, frameworkDatabase);
  if (!isAttachmentSupported) {
    Logger.logDebug(
        "OutBoxAttachmentManager",
        "checkAndUploadAttachmentsInOutBox",
        "This BE: ${structureMeta.beName} does not support attachments.");
    return;
  }
  Logger.logDebug(
      "OutBoxAttachmentManager",
      "checkAndUploadAttachmentsInOutBox",
      "This BE: ${structureMeta.beName} supports attachments.");
  try {
    List<String> attachmentEntityNames = structureMetas
        .where((element) =>
            element.beName == structureMeta.beName &&
            element.structureName.endsWith(AttachmentBE))
        .map((e) => e.structureName)
        .toList();

    for (String attachmentEntityName in attachmentEntityNames) {
      List<dynamic> attachmentItems = [];
      try {
        attachmentItems = await getAttachmentsMarkedForUploadOutbox(
            attachmentEntityName, inputData, appDB);
      } catch (e) {
        Logger.logError(
            "OutBoxAttachmentManager",
            "checkAndUploadAttachmentsInOutBox",
            "Error when trying to get attachments marked for upload " +
                e.toString());
      }

      for (Map<String, dynamic> attachmentItem in attachmentItems) {
        try {
          _copyAttachmentToApplicationFolderOutbox(
              attachmentEntityName,
              attachmentItem,
              selectedAccount,
              attachmentFolderPath,
              frameworkDatabase,
              appDB,
              appPath);
          await checkConnectionInIsolate();
          http.StreamedResponse response = await uploadAttachmentOutbox(
              attachmentItem,
              selectedAccount,
              authToken,
              appName,
              appBaseUrl,
              attachmentFolderPath);
          if (response.statusCode == Status.httpOk ||
              response.statusCode == Status.httpCreated) {
            bool isSuccess = await _updateAttachmentStatusOutBox(
                attachmentEntityName,
                attachmentItem,
                AttachmentStatusUploaded,
                appDB,
                frameworkDatabase);
            if (!isSuccess) {
              Logger.logError(
                  "OutBoxAttachmentManager",
                  "checkAndUploadAttachmentsInOutBox",
                  "Failed to update status in $attachmentEntityName LID : ${attachmentItem[FieldLid]}");
            }
          } else {
            Logger.logError(
                "OutBoxAttachmentManager",
                "checkAndUploadAttachmentsInOutBox",
                "Error while uploading attachment.");
            var uuid = Uuid();

            InfoMessageData infoMessage = InfoMessageData(
                lid: uuid.v1(),
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

            await frameworkDatabase.addInfoMessage(infoMessage);
            bool isSuccess = await _updateAttachmentStatusOutBox(
                attachmentEntityName,
                attachmentItem,
                AttachmentStatusErrorInUpload,
                appDB,
                frameworkDatabase);
            if (!isSuccess) {
              Logger.logError(
                  "OutBoxAttachmentManager",
                  "checkAndUploadAttachmentsInOutBox",
                  "Failed to update status in $attachmentEntityName LID : ${attachmentItem[FieldLid]}");
            }
          }
        } catch (e) {
          bool isSuccess = await _updateAttachmentStatusOutBox(
              attachmentEntityName,
              attachmentItem,
              AttachmentStatusErrorInUpload,
              appDB,
              frameworkDatabase);
          if (!isSuccess) {
            Logger.logError(
                "OutBoxAttachmentManager",
                "checkAndUploadAttachmentsInOutBox",
                "Failed to update status in $attachmentEntityName LID : ${attachmentItem[FieldLid]}");
          }
        }
      }
    }
  } catch (e) {
    Logger.logError("OutBoxAttachmentManager",
        "checkAndUploadAttachmentsInOutBox", e.toString());
  }
}

Future<bool> _updateAttachmentStatusOutBox(
    String attachmentItemName,
    Map<String, dynamic> attachmentItem,
    String attachmentStatus,
    Database appDb,
    FrameworkDatabase frameworkDatabase) async {
  attachmentItem[AttachmentItemFieldAttachmentStatus] = attachmentStatus;
  return await isolateUpdateInAppDb(frameworkDatabase, false,
      attachmentItemName, attachmentItem, false, appDb);
}

Future<http.StreamedResponse> uploadAttachmentOutbox(
    Map<String, dynamic> attachmentItem,
    UnviredAccount? account,
    String bearerAuth,
    String appName,
    String appBaseUrl,
    String attachmentFolderPath) async {
  if (account == null || bearerAuth.isEmpty) {
    Logger.logError("OutBoxAttachmentManager", "uploadAttachmentOutbox",
        "Account data not available.");
    throw ("Account data not available.");
  }

  String gUid = attachmentItem[AttachmentItemFieldUid];

  attachmentFolderPath += "/${attachmentItem[AttachmentItemFieldFileName]}";

  String attachmentId = gUid;
  String filePath = attachmentFolderPath;
  String appUrl = "$appBaseUrl/$appName/$ServiceAttachments/$attachmentId";
  var url = Uri.parse(appUrl);

// create multipart request
  var request = new http.MultipartRequest("POST", url);
  var fileObject = File(filePath);
  var stream = fileObject.readAsBytes().asStream();
// get file length
  int length = fileObject.lengthSync();
// multipart that takes file
  var multipartFileSign = new http.MultipartFile(QueryParamFile, stream, length,
      filename: filePath.split("/").last);

// add file to multipart
  request.files.add(multipartFileSign);

//add headers
  request.headers.addAll({'authorization': bearerAuth});

//adding params
// request.fields['loginId'] = '12';
// request.fields['firstName'] = 'abc';
// request.fields['lastName'] = 'efg';

// send
  http.StreamedResponse response = await request.send();
  return response;
}

Future<bool> isAttachmentSupportedForBEName(
    String beName, FrameworkDatabase frameworkDatabase) async {
  if (beName.isEmpty) {
    return false;
  }
  try {
    BusinessEntityMetaData beMeta =
        (await frameworkDatabase.allBusinessEntityMetas)
            .firstWhere((element) => element.beName == beName);
    return beMeta.attachments == "1";
  } catch (e) {
    Logger.logError("OutBoxAttachmentManager", "hasAttachments", e.toString());
  }
  return false;
}

Future<List<dynamic>> getAttachmentsMarkedForUploadOutbox(
    String attachmentEntityName,
    Map<String, dynamic> inputData,
    Database appDb) async {
  Iterable<String> inputDataKeys = inputData.keys;

  var beData = inputData[inputDataKeys.first];

  Map<String, dynamic>? headerData;
  for (String key in beData[0].keys) {
    if (key.toString().endsWith("_HEADER")) {
      headerData = beData[0][key];
      break;
    }
  }

//check if the IDataStructure in question supports attachments, if yes, check if it has any, if yes attach it using the protocols.
  String whereClause =
      "$FieldFid = '${headerData![FieldLid]}' AND $AttachmentItemFieldAttachmentStatus = '$AttachmentStatusSavedForUpload'";
  // DBInputEntity dbInputEntity = DBInputEntity(attachmentEntityName, {})
  //   ..setWhereClause(whereClause);
  String query = "SELECT * FROM $attachmentEntityName WHERE $whereClause";
  Selectable<QueryRow>? data;

  try {
    data = appDb.customSelect(query);
  } catch (e) {
    Logger.logError(
        "OutBoxAttachmentManager",
        "getAttachmentsMarkedForUpload",
        "DBException caught when querying $attachmentEntityName: " +
            e.toString());
  }
  //List<dynamic> attachmentItems = await DatabaseManager().select(dbInputEntity);
  List<dynamic> attachmentItems = [];

  if (data != null) {
    List<QueryRow>? list;
    try {
      list = await data.get();
    } catch (e) {
      Logger.logError(
          "OutBoxAttachmentManager",
          "getAttachmentsMarkedForUpload",
          "Error when getting query row from Selectable.get : " + e.toString());
    }
    if (list != null && list.isNotEmpty) {
      attachmentItems = list.map((e) => e.data).toList();
    }
  }
  return attachmentItems;
}

Future<bool> _copyAttachmentToApplicationFolderOutbox(
    String attachmentItemName,
    Map<String, dynamic> attachmentItem,
    UnviredAccount? selectedAccount,
    String attachmentFolder,
    FrameworkDatabase frameworkDatabase,
    Database appDb,
    String appPath) async {
  if (selectedAccount == null) {
    Logger.logError("Attachment", "saveAttachmentForUpload",
        "Application has not logged in.");
    throw ("Application has not logged in.");
  }

  String localPath = attachmentItem[AttachmentItemFieldLocalPath];
  String uid = FrameworkHelper.getUUID();

// if fileName is missing, then Use the UID for the fileName and No Extension
  String filePath = "";
  String? fileNameWithExtension = attachmentItem[AttachmentItemFieldFileName];
  if (fileNameWithExtension == null) {
    filePath = "$attachmentFolder/$uid";
  } else {
    filePath = "$attachmentFolder/$fileNameWithExtension";
  }
  copyAttachmentOutbox(localPath, filePath);
  attachmentItem[AttachmentItemFieldLocalPath] = filePath;
  return await isolateUpdateInAppDb(frameworkDatabase, false,
      attachmentItemName, attachmentItem, false, appDb);
}

copyAttachmentOutbox(String localPath, String appFolderPath) {
  File file = new File(appFolderPath);
  if (!file.existsSync()) {
    file.createSync(recursive: true);
  }
  return File(localPath).copySync(appFolderPath);
}
