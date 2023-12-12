import 'package:collection/collection.dart';
import 'package:logger/logger.dart';
import 'package:unvired_sdk/src/helper/isolate_helper.dart';

import '../application_meta/field_constants.dart';
import '../attachment/attachment.dart';
import '../attachment/attachment_service.dart';
import '../authentication_service.dart';
import '../database/database_manager.dart';
import '../database/framework_database.dart';
import '../helper/framework_helper.dart';
import '../helper/http_connection.dart';
import '../helper/path_manager.dart';
import '../helper/service_constants.dart';
import '../helper/url_service.dart';
import '../outbox/outbox_service.dart';

class AttachmentDownloader {
  bool _isAttachmentDownloaderRunning = false;
  bool _isStopped = false;

  static final AttachmentDownloader _attachmentDownloader =
      AttachmentDownloader._internal();

  AttachmentDownloader._internal();

  factory AttachmentDownloader() {
    return _attachmentDownloader;
  }

  Future<void> queueForDownload(String attachmentItemName,
      Map<String, dynamic> attachmentItem, int priority) async {
    List<StructureMetaData> structMetas =
        await (await DatabaseManager().getFrameworkDB()).allStructureMetas;
    //get AttachmentStructure
    StructureMetaData? attachmentStructMeta = structMetas.firstWhereOrNull(
        (element) => element.structureName == attachmentItemName);
    if (attachmentStructMeta == null) {
      Logger.logError("AttachmentDownloader", "queueForDownload",
          "Structure Meta for Attachment Item ($attachmentItemName) is not found.");
      return;
    }
    //get BEHeader
    StructureMetaData? headerStructMeta = structMetas.firstWhereOrNull(
        (element) =>
            element.beName == attachmentStructMeta.beName &&
            element.isHeader == "1");
    if (headerStructMeta == null) {
      Logger.logError("AttachmentDownloader", "queueForDownload",
          "Header Structure Meta for Attachment Item ($attachmentItemName) is not found.");
      return;
    }
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    String uid = attachmentItem[AttachmentItemFieldUid] ?? "";

    //create attachmentQObject and save it
    AttachmentQObjectData attachmentQObjectData = AttachmentQObjectData(
        lid: FrameworkHelper.getUUID(),
        timestamp: timestamp,
        objectStatus: ObjectStatus.add.index,
        syncStatus: SyncStatus.none.index,
        uid: uid,
        beName: attachmentStructMeta.beName,
        beHeaderName: headerStructMeta.structureName,
        beAttachmentStructName: attachmentStructMeta.structureName,
        priority: priority,
        timeStamp: timestamp);
    Logger.logDebug("AttachmentDownloader", "queueForDownload",
        "ATTACHMENT QUEUED LID ${attachmentQObjectData.lid} HEADER NAME : ${headerStructMeta.structureName} STRUCT NAME : ${attachmentStructMeta.structureName}");

    try {
      // Add the Attachment Q Object to the Attachment Q
      await Attachment().add(attachmentQObjectData);
    } catch (e) {
      Logger.logDebug("AttachmentDownloader", "queueForDownload",
          "ATTACHMENT QUEUE FAILED...... LID ${attachmentQObjectData.lid} HEADER NAME : ${headerStructMeta.structureName} STRUCT NAME : ${attachmentStructMeta.structureName}");
      Logger.logError("AttachmentDownloader", "queueForDownload",
          "Error while adding attachment Q object to the Attachment Q. Error: $e");
      return;
    }
    //change status to queued for downlaod
    attachmentItem[AttachmentItemFieldAttachmentStatus] =
        AttachmentStatusQueuedForDownload;

    // Update the Attachment Status
    DBInputEntity dbInputEntity =
        DBInputEntity(attachmentItemName, attachmentItem);
    try {
      await DatabaseManager().update(dbInputEntity);
    } catch (e) {
      Logger.logError("AttachmentDownloader", "queueForDownload",
          "DB Error while trying to mark Attachment as Queued for download. Error: $e");
    }
    // call start AttachmentDownloadThread
    //start();
  }

  Future<void> checkAndStartAttachmentService() async {
    Logger.logInfo("AttachmentDownloader", "checkAndStartAttachmentService",
        "CHECKING ATTACHMENTS");
    FrameworkDatabase fwDb = await DatabaseManager().getFrameworkDB();
    List<AttachmentQObjectData> attachmentList =
        await fwDb.allAttachmentQObjects;
    Logger.logInfo("AttachmentDownloader", "checkAndStartAttachmentService",
        "ATTACHMENT LENGTH - ${attachmentList.length.toString()}");

    if (attachmentList.isNotEmpty) {
      final appBaseUrl = URLService.getApplicationUrl(
          (await AuthenticationService().getSelectedAccount())!.getUrl());
      String attachmentFolderPath = await PathManager.getAttachmentFolderPath(
          (await AuthenticationService().getSelectedAccount())!.getUserId());
      final appDirPath = await PathManager.getUploadLogFolderPath();

      AttachmentService attachmentService = AttachmentService(
          selectedAccount: await AuthenticationService().getSelectedAccount(),
          appBaseUrl: appBaseUrl,
          attachmentFolderPath: attachmentFolderPath,
          appName: AuthenticationService().getAppName(),
          authToken: HTTPConnection.bearerAuth,
          driftIsolatePortAppDb: driftIsolateAppDb!.connectPort,
          driftIsolatePortFrameWorkDb: driftIsolateFrameworkDb!.connectPort,
          appDirPath: appDirPath);
      if (AttachmentService.threadStatus !=
          ServiceThreadStatus.Running.toString()) {
        attachmentService.start();
      }
    } else {
      Logger.logDebug("AttachmentDownloader", "checkAndStartAttachmentService",
          "No items in attachment box to start service");
    }
  }

  void setup() {
    _isAttachmentDownloaderRunning = false;
    _isStopped = false;
  }

  void start() async {
    if (!_isAttachmentDownloaderRunning) {
      // Initiate the Inbox Handler.
      _isAttachmentDownloaderRunning = true;
      //await _run();
    } else {
      Logger.logInfo("AttachmentDownloader", "start",
          "Could not start the Attachment Downloader Thread since it is already running.");
    }
  }

  void stop() {
    _isStopped = true;
  }

  bool isAlive() {
    return _isAttachmentDownloaderRunning;
  }

  // _run() async {
  //   Logger.logInfo("AttachmentDownloader", "_run", "S T A R T");
  //   List<AttachmentQObjectData> attachmentQObjectData =
  //       await Attachment().getAllAttachmentQObjects();
  //   for (AttachmentQObjectData attachmentQObject in attachmentQObjectData) {
  //     if (_isStopped) {
  //       _isAttachmentDownloaderRunning = false;
  //       break;
  //     }
  //     DBInputEntity dbInputEntity =
  //         DBInputEntity(attachmentQObject.beAttachmentStructName, {})
  //           ..setWhereClause(
  //               "$AttachmentItemFieldUid = '${attachmentQObject.uid}'");
  //     List<dynamic> attachmentItems =
  //         await DatabaseManager().select(dbInputEntity);
  //     if (attachmentItems.length == 0) {
  //       Logger.logError("AttachmentDownloader", "_run",
  //           "Error while getting attachment item from database. Attachment Structure Name: ${attachmentQObject.beAttachmentStructName}. UID: ${attachmentQObject.uid}. Error:");
  //       continue;
  //     }
  //     Map<String, dynamic> attachmentItem = attachmentItems[0];
  //     await ConnectivityManager().checkConnection();
  //     try {
  //       http.Response result =
  //           await HTTPConnection.downloadAttachment(attachmentQObject.uid);
  //       if (result.statusCode == Status.httpOk) {
  //         String attachmentFolderPath =
  //             await PathManager.getAttachmentFolderPath(
  //                 (await AuthenticationService().getSelectedAccount())!.getUserId());
  //
  //         String filePath =
  //             "$attachmentFolderPath/${attachmentItem[AttachmentItemFieldFileName]}";
  //         new File(filePath).writeAsBytes(result.bodyBytes);
  //         // Update the local path and attachment status and then update into DB.
  //         attachmentItem[AttachmentItemFieldLocalPath] =
  //             "/$AttachmentFolderName/${attachmentItem[AttachmentItemFieldFileName]}";
  //         attachmentItem[AttachmentItemFieldAttachmentStatus] =
  //             AttachmentStatusDownloaded;
  //         await _updateAttachmentItemIntoDatabase(
  //             attachmentQObject.beAttachmentStructName, attachmentItem);
  //         await Attachment().remove(attachmentQObject.uid);
  //
  //         // Post 'attachmentstatus' success event to the application.
  //         Map<String, dynamic> data = {
  //           EventAttachmentStatusFieldStatus: EventAttachmentStatusSuccess,
  //           EventFieldData: {
  //             EventFieldBeName: attachmentQObject.beAttachmentStructName,
  //             EventAttachmentStatusFieldUid: attachmentQObject.uid
  //           }
  //         };
  //         DartNotificationCenter.post(
  //             channel: EventNameAttachmentStatus, options: data);
  //       } else if (result.statusCode == Status.httpGone) {
  //         _isAttachmentDownloaderRunning = false;
  //         Map<String, dynamic> response = jsonDecode(result.body);
  //         DartNotificationCenter.post(
  //             channel: EventNameSystemError, options: response);
  //         break;
  //       } else {
  //         Logger.logError("AttachmentDownloader", "_run",
  //             "Error while downloading attachment. Attachment Structure Name: ${attachmentQObject.beAttachmentStructName}. UID: ${attachmentQObject.uid}. Error:");
  //         // Update the error attachment status and error message and then update into DB.
  //         Map<String, dynamic> response = jsonDecode(result.body);
  //         String errorMessage = response[KeyError] ?? "";
  //         attachmentItem[AttachmentItemFieldAttachmentStatus] =
  //             AttachmentStatusErrorInDownload;
  //         attachmentItem[AttachmentItemFieldErrorMessage] = errorMessage;
  //         await _updateAttachmentItemIntoDatabase(
  //             attachmentQObject.beAttachmentStructName, attachmentItem);
  //
  //         // Post 'attachmentstatus' error event to the application.
  //         Map<String, dynamic> data = {
  //           EventAttachmentStatusFieldStatus: EventAttachmentStatusError,
  //           EventFieldData: {
  //             EventFieldBeName: attachmentQObject.beAttachmentStructName,
  //             EventAttachmentStatusFieldUid: attachmentQObject.uid
  //           },
  //           EventFieldError: {
  //             EventFieldErrorCode: result.statusCode,
  //             EventFieldErrorMessage: errorMessage
  //           }
  //         };
  //         DartNotificationCenter.post(
  //             channel: EventNameAttachmentStatus, options: data);
  //       }
  //     } catch (e) {
  //       Logger.logError("AttachmentDownloader", "_run", e.toString());
  //       // This may not needed as this is not an error from server.
  //       // Update the error attachment status and error message and then update into DB.
  //       // attachmentItem[AttachmentItemFieldAttachmentStatus] =
  //       //     AttachmentStatusErrorInDownload;
  //       // attachmentItem[AttachmentItemFieldErrorMessage] = e.toString();
  //       // await _updateAttachmentItemIntoDatabase(
  //       //     attachmentQObject.beAttachmentStructName, attachmentItem);
  //     }
  //   }
  //   _isAttachmentDownloaderRunning = false;
  //   Logger.logInfo("AttachmentDownloader", "_run", "E N D");
  // }

  _updateAttachmentItemIntoDatabase(
      String attachmentItemName, Map<String, dynamic> attachmentItem) async {
    DBInputEntity dbInputEntity =
        DBInputEntity(attachmentItemName, attachmentItem);
    try {
      await DatabaseManager().update(dbInputEntity);
    } catch (e) {
      Logger.logError("AttachmentDownloader", "_run",
          "Error while updating attachment into database. Attachment Structure Name: $attachmentItemName. UID: ${attachmentItem[AttachmentItemFieldUid]}. Error: $e");
    }
  }
}
