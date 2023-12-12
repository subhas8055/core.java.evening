// ignore: import_of_legacy_library_into_null_safe
import 'dart:io';

import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:unvired_sdk/src/helper/http_connection.dart';
import 'package:unvired_sdk/src/helper/path_manager.dart';
import 'package:unvired_sdk/src/helper/url_service.dart';
import 'package:unvired_sdk/unvired_sdk.dart';

import '../database/database_manager.dart';
import '../attachment/attachment_downloader.dart';
import '../authentication_service.dart';
import '../helper/event_handler_constants.dart';
import '../helper/service_constants.dart';
import '../notification_center/dart_notification_center_base.dart';

class AttachmentHelper {
  static Future<void> checkAttachmentAndQueueForAutoDownload(
      String attachmentItemName, Map<String, dynamic> attachmentItem) async {
    if (kIsWeb) {
      Logger.logError(
          "AttachmentHelper",
          "checkAttachmentAndQueueForAutoDownload",
          "Attachment download is not supported in Web.");
      return;
    }

    attachmentItem[AttachmentItemFieldAttachmentStatus] =
        AttachmentStatusDefault;
    DBInputEntity dbInputEntity =
        DBInputEntity(attachmentItemName, attachmentItem);
    try {
      await DatabaseManager().update(dbInputEntity);
    } catch (e) {
      Logger.logError(
          "AttachmentHelper",
          "checkAttachmentAndQueueForAutodownload",
          "Error while updating the status of the attachment item. Error: $e");
    }

    // Check it is marked with auto download and queue request if required
    String? autoDownload = attachmentItem[AttachmentItemFieldAutoDownload];
    if (autoDownload != null && autoDownload == "true") {
      bool isDatabaseOperationSuccessfull = await _queueForDownload(
          attachmentItemName, attachmentItem, FwAttachmentAutoDownloadPriority);
      if (!isDatabaseOperationSuccessfull) {
        Logger.logError(
            "AttachmentHelper",
            "checkAttachmentAndQueueForAutodownload",
            "Failed to Queue Attachment Item for Download");
      }
    }
  }

  static Future<bool> _queueForDownload(String attachmentItemName,
      Map<String, dynamic> attachmentItem, int priority) async {
    //  In Demo Mode, Attachments cannot be queued for Download.
    //  Therefore we log an Error Mesage saying that this feature is not suppoted in demo Mode.

    if ((await AuthenticationService().getSelectedAccount())!
        .getIsDemoLogin()) {
      // Create an Error Object.
      attachmentItem[AttachmentItemFieldMessage] =
          "Downloading of attachments is not supported in demo mode.";
      attachmentItem[AttachmentItemFieldAttachmentStatus] =
          AttachmentStatusErrorInDownload;

      // Update the Attachment in the Database as well.
      DBInputEntity dbInputEntity =
          DBInputEntity(attachmentItemName, attachmentItem);
      try {
        DatabaseManager().update(dbInputEntity);
      } catch (e) {
        Logger.logError("AttachmentHelper", "queueForDownload",
            "There was an error while downloading Attachments. Error: $e");
      }

      Map<String, dynamic> data = {
        EventAttachmentStatusFieldStatus: EventAttachmentStatusError,
        EventFieldData: {
          EventFieldBeName: attachmentItemName,
          EventAttachmentStatusFieldUid:
              attachmentItem[AttachmentItemFieldUid] ?? ""
        },
        EventFieldError: {
          EventFieldErrorCode: 0,
          EventFieldErrorMessage:
              "Downloading of attachments is not supported in demo mode."
        }
      };
      DartNotificationCenter.post(
          channel: EventNameAttachmentStatus, options: data);

      return true;
    }
    if (attachmentItem.isEmpty) {
      throw ("Attachment Item is null.");
    }
    await AttachmentDownloader()
        .queueForDownload(attachmentItemName, attachmentItem, priority);
    return true;
  }

  Future<String?> downloadAttachmentAndGetPath(
      String uid, String fileName) async {
    final appBaseUrl = URLService.getApplicationUrl(
        (await AuthenticationService().getSelectedAccount())!.getUrl());
    String attachmentFolderPath = await PathManager.getAttachmentFolderPath(
        (await AuthenticationService().getSelectedAccount())!.getUserId());
    Response result = await HTTPConnection.downloadAttachment(uid,
        account: await AuthenticationService().getSelectedAccount(),
        appBaseUrl: appBaseUrl,
        bearerAuth: HTTPConnection.bearerAuth,
        appName: AuthenticationService().getAppName());
    if (result.statusCode == Status.httpOk) {
      String filePath = "$attachmentFolderPath/${fileName}";
      File file = new File(filePath);
      if (!file.existsSync()) {
        file.createSync(recursive: true);
      }
      await file.writeAsBytes(result.bodyBytes);
      return filePath;
    } else {
      Logger.logDebug("AttachmentHelper", "downloadAttachmentAndGetPath",
          'Failed to download attachment. Result: ${result.toString()}');
      Logger.logError("AttachmentHelper", "downloadAttachmentAndGetPath",
          'Failed to download attachment.');
      throw (result);
    }
  }
}
