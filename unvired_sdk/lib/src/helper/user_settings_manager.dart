import 'package:enum_to_string/enum_to_string.dart';

import '../application_meta/field_constants.dart';
import '../database/database_manager.dart';
import '../database/framework_database.dart';
import '../unvired_account.dart';
import 'framework_helper.dart';
import 'package:logger/logger.dart';

enum UserSettingsFields {
  serverUserId,
  serverPassword,
  unviredUserId,
  unviredPassword,
  serverUrl,
  companyAlias,
  deviceType,
  customDeviceId,
  companyNamespace,
  requestTimeout,
  demoMode,
  domainName,
  loginType,
  notificationTimeout,
  fetchInterval,
  serverCertificateHash,
  currentFrameworkVersion,
  unviredPin,
  unviredId,
  jwtToken
}

class UserSettingsManager {
  Map<String, Setting> _userSettingsHashtable = {};

  Future<void> setFieldValue(
      UserSettingsFields field, dynamic fieldValue) async {
    String fieldName = EnumToString.convertToString(field);
    await setFieldValueForKey(fieldName, fieldValue);
  }

  Future<String> getFieldValue(UserSettingsFields field) async {
    String fieldName = EnumToString.convertToString(field);
    return await getFieldValueForKey(fieldName);
  }

  Future<void> setFieldValueForKey(String fieldName, dynamic fieldValue) async {
    FrameworkDatabase frameworkDB = await DatabaseManager().getFrameworkDB();
    Setting? userSetting;
    try {
      userSetting = await frameworkDB.getSetting(fieldName);
    } catch (e) {}

    if (userSetting == null) {
      Setting settingObject = Setting(
          lid: FrameworkHelper.getUUID(),
          timestamp: DateTime.now().millisecondsSinceEpoch,
          objectStatus: ObjectStatus.global.index,
          syncStatus: SyncStatus.none.index,
          fieldName: fieldName,
          fieldValue: "$fieldValue");
      _userSettingsHashtable[fieldName] = settingObject;
      await frameworkDB.addSetting(settingObject);
    } else {
      Setting settingObject = Setting(
          lid: userSetting.lid,
          timestamp: DateTime.now().millisecondsSinceEpoch,
          objectStatus: userSetting.objectStatus,
          syncStatus: userSetting.objectStatus,
          fieldName: fieldName,
          fieldValue: "$fieldValue");
      _userSettingsHashtable[fieldName] = settingObject;
      await frameworkDB.updateSetting(settingObject);
    }
  }

  Future<String> getFieldValueForKey(String fieldName) async {
    if (_userSettingsHashtable.isNotEmpty &&
        _userSettingsHashtable[fieldName] != null) {
      return _userSettingsHashtable[fieldName]!.fieldValue;
    }
    FrameworkDatabase frameworkDB = await DatabaseManager().getFrameworkDB();
    try {
      Setting? userSetting = await frameworkDB.getSetting(fieldName);
      if (userSetting == null) {
        return "";
      }
      _userSettingsHashtable[fieldName] = userSetting;
      return userSetting.fieldValue;
    } catch (e) {
      Logger.logError("UserSettingsManager", "getFieldValue",
          "Error while getting settings. Error: ${e.toString()}");
    }
    return "";
  }

  static Map<String, dynamic> getDemoModeUserSettings(UnviredAccount account) {
    Map<String, dynamic> tempFrameworkSettings = {
      "companyAlias": account.getCompany(), // "UNVIRED"
      "isDemo": "true",
      "deviceType": FrameworkHelper.getFrontendType(), // demo
      "loginType": account.getLoginType(),
      "customDeviceId": "demo",
      "serverUserId": "demo",
      "serverPassword": "demo",
      "serverUrl": account.getUrl(), // "http://live.unvired.io/UNI"
      "currentFrameworkVersion": "DEMO v1.0"
    };
    return tempFrameworkSettings;
  }
}
