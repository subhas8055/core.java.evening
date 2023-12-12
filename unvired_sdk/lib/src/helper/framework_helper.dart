import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:encrypt/encrypt.dart' as aes;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as p;
import 'package:unvired_sdk/src/helper/framework_settings_manager.dart';
import 'package:uuid/uuid.dart';

import '../authentication_service.dart';
import '../database/database_manager.dart';
import '../database/framework_database.dart';
import '../helper/path_manager.dart';
import '../helper/unvired_account_manager.dart';
import '../inbox/hive_inbox_data_manager.dart';
import '../outbox/hive_outbox_data_manager.dart';
import '../sync_engine.dart';
import '../unvired_account.dart';

class FrameworkHelper {
  static String getTimeStamp() {
    DateTime currentDate = DateTime.now().toUtc();
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');
    return formatter.format(currentDate);
  }

  static String getDeviceType() {
    if (kIsWeb) {
      return "Web";
    }
    if (Platform.isIOS) {
      return "iOS";
    }
    if (Platform.isAndroid) {
      return "Android";
    }
    if (Platform.isMacOS) {
      return "macOS";
    }
    if (Platform.isLinux) {
      return "Linux";
    }
    if (Platform.isWindows) {
      return "Windows";
    }
    return "";
  }

  static String getFrontendType() {
    if (kIsWeb) {
      return "BROWSER";
    }
    if (Device.get().isIos && Device.get().isTablet) {
      return "IPAD";
    }
    if (Device.get().isIos && !(Device.get().isTablet)) {
      return "IPHONE";
    }
    if (Device.get().isAndroid && Device.get().isTablet) {
      return "ANDROID_TABLET";
    }
    if (Device.get().isAndroid && !(Device.get().isTablet)) {
      return "ANDROID_PHONE";
    }
    if (Platform.isWindows) {
      return "WINDOWS8";
    }
    return "";
  }

  static String getUUID() {
    var uuid = Uuid();
    return uuid.v1().replaceAll("-", "");
  }

  static Future<String> getPublicKeyEncryptedPassword(plainTextPassword) async {
    // _keyPair = await _getKeyPair();
    // String encryptedPassword = encrypt(plainTextPassword, _keyPair.publicKey);
    return "";
  }

  static String getEncryptedPassword(
      String? plainTextPassword, String formattedTimeStamp) {
    if (plainTextPassword == null) {
      return "";
    }
    String md5Password = getMD5String(plainTextPassword);
    String combinedString = md5Password + formattedTimeStamp;
    String encryptedPassword = getMD5String(combinedString);
    return encryptedPassword;
  }

  static String getMD5String(String str) {
    return md5.convert(utf8.encode(str)).toString();
  }

  static String getRequestTypeString(RequestType type) {
    switch (type) {
      case RequestType.rqst:
        return "request";
      case RequestType.pull:
        return "pull";
      case RequestType.req:
        return "upload";
      case RequestType.query:
        return "query";
      case RequestType.push:
        return "push";
      case RequestType.pulld:
        return "pull_d";
      default:
        return "";
    }
  }

  static RequestType getRequestTypeFromString(String type) {
    switch (type) {
      case "RQST":
        return RequestType.rqst;
      case "PULL":
        return RequestType.pull;
      case "REQ":
        return RequestType.req;
      case "QUERY":
        return RequestType.query;
      case "PULL_D":
        return RequestType.pulld;
      case "PUSH":
        return RequestType.push;
    }
    return RequestType.rqst;
  }

  static Future<bool> clearData(UnviredAccount selectedAccount) async {
    // UnviredAccount? selectedAccount =
    //     await AuthenticationService().getSelectedAccount();
    // if (selectedAccount == null) {
    //   return;
    // }
    AuthenticationService().setSelectedAccount(selectedAccount);
    // await DatabaseManager().clearDataFromAppDb();
    // await DatabaseManager().clearDataFromFrameworkDb();
    await (await DatabaseManager().getFrameworkDB()).close();
    await (await DatabaseManager().getAppDB()).close();
    await HiveInboxDataManager(selectedAccount).deleteAll();
    await HiveOutboxDataManager(selectedAccount).deleteAll();
    await UnviredAccountManager().deleteAccount(selectedAccount);
    await deleteLoggedInUserFolder(selectedAccount);
    AuthenticationService().setSelectedAccount(null);
    DatabaseManager().clearDatabase();
    // if (!Platform.isIOS) {
    //   exit(0);
    // }
    return true;
  }

  static cleanUpInfoMessages() async {
    FrameworkDatabase fwDatabase = await DatabaseManager().getFrameworkDB();
    List<InfoMessageData> infoMessages = await fwDatabase.allInfoMessages;

    if (infoMessages.length > 0) {
      Logger.logInfo("FrameworkHelper", "cleanUpInfoMessages",
          "Started Info Message Clean up Algorithm. Info message Count at the Start of Clean up ${infoMessages.length}");
      // Run a Query to delete all info messages except recent 40 Info Messages.
      int limit = 40;
      String query =
          "DELETE FROM InfoMessage WHERE lid NOT IN (SELECT lid FROM InfoMessage ORDER BY timestamp DESC LIMIT $limit)";
      int result =
          await fwDatabase.customUpdate(query, updateKind: UpdateKind.delete);
      if (result == 0) {
        Logger.logError("FrameworkHelper", "cleanUpInfoMessages",
            "Error while Cleaning up Info Messages");
      } else {
        List<InfoMessageData> infoMessages = await fwDatabase.allInfoMessages;
        Logger.logInfo("FrameworkHelper", "cleanUpInfoMessages",
            "Finished Info Message Clean up Algorithm. InfoMessages at the end of clean up ${infoMessages.length}");
      }
    }
  }

  static Future<String> getApplicationPath({String? separator}) async {
    String appPath = (await PathManager.getApplicationPath(
        ((await AuthenticationService().getSelectedAccount())!.getUserId())));
    if (separator != null) {
      final file = Directory(p.join(appPath, separator));
      if (!file.existsSync()) {
        file.createSync(recursive: true);
      }
      return file.path;
    }
    return appPath;
  }

  static Future<String> getExtensionNameFromPath(String path) async {
    return (await p.extension(path));
  }

  static Future<String> encryptString(String text) async {
    try {
      final keyString = await FrameworkSettingsManager()
          .getFieldValue(FrameworkSettingsFields.secKey);
      final key = aes.Key.fromBase64(keyString);
      final iv = aes.IV.fromLength(16);
      final encrypter =
          aes.Encrypter(aes.AES(key, mode: aes.AESMode.ecb, padding: 'PKCS7'));
      final encryptedData = encrypter.encrypt(text, iv: iv);
      return encryptedData.base64;
    } catch (e) {
      Logger.logError("FrameworkHelper", "encryptString",
          "Error while encrypting. Error: $e");
      throw e;
    }
  }

  static Future<String> decryptString(String base64Text) async {
    try {
      final keyString = await FrameworkSettingsManager()
          .getFieldValue(FrameworkSettingsFields.secKey);
      final key = aes.Key.fromBase64(keyString);
      final iv = aes.IV.fromLength(16);
      var enc = aes.Encrypted.fromBase64(base64Text);
      final encrypter =
          aes.Encrypter(aes.AES(key, mode: aes.AESMode.ecb, padding: 'PKCS7'));
      final decryptedString = encrypter.decrypt(enc, iv: iv);
      return decryptedString;
    } catch (e) {
      Logger.logError("FrameworkHelper", "decryptString",
          "Error while decryption. Error: $e");
      throw e;
    }
  }
}
