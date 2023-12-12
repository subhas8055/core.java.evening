import 'package:flutter/material.dart';

class Constants {
  static const fieldInbox = "Inbox";
  static const fieldOutbox = "OutBox";
  static const fieldSent = "Sent";
  static const fieldAttachments = "Attachments";
  static const fieldInfoMessages = "Info Messages";
  static const fieldRequestData = "Request data";
  static const fieldGetMessage = "Get message";
  static const fieldTimeout = "HTTP Timeout";
  static const fieldNotification = "Notification";
  static const fieldLogs = "Logs";
  static const fieldFetchNewData = "Fetch New Data";
  static const fieldSendAppDB = "Send App DB";
  static const fieldClearData = "Clear data";
  static const fieldAbout = "About Us";
  static const fieldApplicationVersion = "Application Version";
  static const fieldSdkVersion = "SDK version";
  static const fieldStatus = "Status";
  static const fieldSystemCredentials = "System Credentials";
  static const fieldNewPassword = "New Password";
  static const fieldLocationTracking = "Location Tracking";
  static Map<String, IconData> iconsMap = {
    fieldInbox: Icons.inbox,
    fieldOutbox: Icons.outbox,
    fieldSent: Icons.send,
    fieldAttachments: Icons.attachment,
    fieldInfoMessages: Icons.message,
    fieldRequestData: Icons.send_and_archive,
    fieldGetMessage: Icons.call_received,
    fieldTimeout: Icons.timer_outlined,
    fieldNotification: Icons.notifications,
    fieldLogs: Icons.text_snippet,
    fieldSendAppDB: Icons.send_to_mobile,
    fieldClearData: Icons.cleaning_services_rounded,
    fieldAbout: Icons.info,
    fieldApplicationVersion: Icons.info,
    fieldSdkVersion: Icons.info,
    fieldStatus: Icons.paste_sharp,
    fieldSystemCredentials: Icons.lock,
    fieldNewPassword: Icons.password,
    fieldLocationTracking: Icons.location_on_rounded,
    fieldFetchNewData: Icons.access_time_outlined,
  };

  static Icon getIconForItem(String name, BuildContext context) {
    return Icon(
      iconsMap[name],
      color: Theme.of(context).primaryColorDark,
    );
  }
}
