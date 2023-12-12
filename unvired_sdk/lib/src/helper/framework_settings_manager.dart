import 'dart:convert';

import 'package:enum_to_string/enum_to_string.dart';

import '../application_meta/field_constants.dart';
import '../database/database_manager.dart';
import '../database/framework_database.dart';
import '../helper/framework_helper.dart';
import '../unvired_account.dart';

enum FrameworkSettingsFields {
  appLockTimeout,
  email,
  firstName,
  lastName,
  dataFormat,
  serverType,
  unviredUser,
  namespace,
  serverVersion,
  activationId,
  frontendIdentifier,
  feUser,
  frontendType,
  secKey,
  secLevel,
  logLevel,
  url,
  overrideUMPUrl,
  localPassword,
  frontendId,
  locationTracking,
  locationTrackingInterval,
  locationUploadInterval,
  locationTrackingDays,
  locationTrackingStart,
  locationTrackingEnd,
  loginLanguage,
  compressPostData,
  phone,
  profilePic,
  oneTimeToken,
  applicationId,
  // extra fields
  isDemo,
  serverId,
  companyAlias,
  config
}

class FrameworkSettingsManager {
  Map<String, FrameworkSetting> _frameworkSettingsHashtable = {};

  static final FrameworkSettingsManager _frameworkSettingsManager =
      FrameworkSettingsManager._internal();
  FrameworkSettingsManager._internal();
  factory FrameworkSettingsManager() {
    return _frameworkSettingsManager;
  }


  void setFieldValue(FrameworkSettingsFields field, dynamic fieldValue) async {
    String fieldName = EnumToString.convertToString(field);
    FrameworkDatabase frameworkDB = await DatabaseManager().getFrameworkDB();
    FrameworkSetting? frameworkSetting;
    try {
      frameworkSetting = await frameworkDB.getFrameworkSetting(fieldName);
    } catch (e) {}

    if (frameworkSetting == null) {
      FrameworkSetting frameworkObject = FrameworkSetting(
          lid: FrameworkHelper.getUUID(),
          timestamp: DateTime.now().millisecondsSinceEpoch,
          objectStatus: ObjectStatus.global.index,
          syncStatus: SyncStatus.none.index,
          fieldName: fieldName,
          fieldValue: "$fieldValue");
      _frameworkSettingsHashtable[fieldName] = frameworkObject;
      frameworkDB.addFrameworkSetting(frameworkObject);
    } else {
      FrameworkSetting frameworkObject = FrameworkSetting(
          lid: frameworkSetting.lid,
          timestamp: DateTime.now().millisecondsSinceEpoch,
          objectStatus: frameworkSetting.objectStatus,
          syncStatus: frameworkSetting.objectStatus,
          fieldName: fieldName,
          fieldValue: "$fieldValue");
      _frameworkSettingsHashtable[fieldName] = frameworkObject;
      frameworkDB.updateFrameworkSetting(frameworkObject);
    }
  }

  Future<String> getFieldValue(FrameworkSettingsFields field) async {
    String fieldName = EnumToString.convertToString(field);
    if (_frameworkSettingsHashtable[fieldName] != null) {
      return _frameworkSettingsHashtable[fieldName]!.fieldValue;
    }
    FrameworkDatabase frameworkDB = await DatabaseManager().getFrameworkDB();
    try {
      FrameworkSetting? frameworkSetting =
          await frameworkDB.getFrameworkSetting(fieldName);
      _frameworkSettingsHashtable[fieldName] = frameworkSetting!;

      return frameworkSetting.fieldValue;
    } catch (e) {}
    return "";
  }

  static Map<String, dynamic> getDemoModeFwSettings(UnviredAccount account) {
    var map = [
      {"name": "Inbox", "group": "Messages", "enabled": true},
      {"name": "OutBox", "group": "Messages", "enabled": true},
      {"name": "Sent", "group": "Messages", "enabled": true},
      {"name": "Attachments", "group": "Messages", "enabled": true},
      {"name": "Info Messages", "group": "Messages", "enabled": true},
      {"name": "Request data", "group": "Messages", "enabled": true},
      {"name": "Get message", "group": "Messages", "enabled": true},
      {"name": "Timeout", "group": "Others", "enabled": true},
      {"name": "Notification", "group": "Others", "enabled": true},
      {"name": "Logs", "group": "Others", "enabled": true},
      {"name": "Clear data", "group": "Others", "enabled": true},
      {"name": "About", "group": "Info", "enabled": true},
      {"name": "Appication Version", "group": "Info", "enabled": true},
      {"name": "SDK version", "group": "Info", "enabled": true}
    ];
    String config = jsonEncode(map).toString();
    Map<String, dynamic> tempFrameworkSettings = {
      "settings": {
        "activationId": "demo",
        "companyAlias": account.getCompany(), // "UNVIRED"
        "isDemo": "true",
        "frontendId": "demo",
        "frontendType": FrameworkHelper.getFrontendType(), // demo
        "frontendIdentifier": "demo",
        "feUser": account.getFrontendId(), // demo
        "localPassword": "false",
        "logLevel": "8",
        "namespace": "UNVIRED",
        "serverId": "demo",
        "url": account.getUrl(), // "http://live.unvired.io/UNI",
        "config": config,
        "oneTimeToken": "Unvired"
      }
    };
    return tempFrameworkSettings;
  }
}
