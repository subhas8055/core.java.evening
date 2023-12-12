import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';

import '../unvired_account.dart';

Box? hiveInboxManagerBox;

_initHiveInboxManagerBox(
    UnviredAccount? selectedAccount, String inboxPath) async {
  if (!kIsWeb) {
    Hive.init(inboxPath);
  }

  // UnviredAccount? selectedAccount =
  //     await AuthenticationService().getSelectedAccount();
  if (selectedAccount == null) {
    // Logger.logError("HiveInboxDataManager", "_init", "User not logged in.");
    Logger.logError("HiveInboxDataManager", "_initHiveInboxManagerBox",
        "_initHiveInboxManagerBox User not logged in.");
    throw ("User not logged in.");
  }
  hiveInboxManagerBox =
      await Hive.openBox(selectedAccount.getUserId() + "Inbox");
}

Future<void> addInBoxData(String inboxPath, UnviredAccount? selectedAccount,
    String conversationId, Map<String, dynamic> responseData) async {
  if (hiveInboxManagerBox == null) {
    await _initHiveInboxManagerBox(selectedAccount, inboxPath);
  }
  Logger.logDebug("HiveInboxDataManager", "addInBoxData",
      "Adding data to HiveInboxDataManager");
  await hiveInboxManagerBox!.put(
      conversationId, responseData.isEmpty ? "" : jsonEncode(responseData));
}

Future<Map<String, dynamic>> getInboxData(UnviredAccount? selectedAccount,
    String inboxPath, String conversationId) async {
  if (hiveInboxManagerBox == null) {
    await _initHiveInboxManagerBox(selectedAccount, inboxPath);
  }
  String inboxData = hiveInboxManagerBox!.get(conversationId, defaultValue: "");
  if (inboxData.isEmpty) {
    return {};
  }
  return jsonDecode(inboxData);
}

class HiveInboxDataManager {
  Box? _hiveBox;
  String _boxName = "Inbox";
  UnviredAccount? selectedAccount;
  HiveInboxDataManager(UnviredAccount selectedAccount) {
    this.selectedAccount = selectedAccount;
  }
  _init() async {
    await Hive.initFlutter();
    if (selectedAccount == null) {
      Logger.logError("HiveInboxDataManager", "_init", "User not logged in.");
      throw ("User not logged in.");
    }
    this._hiveBox = await Hive.openBox(selectedAccount!.getUserId() + _boxName);
  }

  // Future<List<Map<String, dynamic>>> getAllInboxData() async {
  //   if (this._hiveBox == null) {
  //     await _init();
  //   }
  //   List<Map<String, dynamic>> unviredAccounts = [];
  //   Iterable<dynamic> allKeys = this._hiveBox!.keys;
  //   for (String key in allKeys) {
  //     Map<String, dynamic> obj = {};
  //     String valueJson = this._hiveBox!.get(key, defaultValue: "");
  //     if (valueJson.isEmpty) {
  //       continue;
  //     }
  //     obj[key] = valueJson;
  //     unviredAccounts.add(obj);
  //   }
  //   return unviredAccounts;
  // }
  //
  // Future<void> addInboxData(
  //     String conversationId, Map<String, dynamic> responseData) async {
  //   if (this._hiveBox == null) {
  //     await _init();
  //   }
  //   this._hiveBox!.put(
  //       conversationId, responseData.isEmpty ? "" : jsonEncode(responseData));
  // }

  Future<Map<String, dynamic>> getInboxData(String conversationId) async {
    if (this._hiveBox == null) {
      await _init();
    }
    String inboxData = this._hiveBox!.get(conversationId, defaultValue: "");
    if (inboxData.isEmpty) {
      return {};
    }
    return jsonDecode(inboxData);
  }

  Future<void> deleteInboxData(String conversationId) async {
    if (this._hiveBox == null) {
      await _init();
    }
    this._hiveBox!.delete(conversationId);
  }

  Future<int> deleteAll() async {
    if (this._hiveBox == null) {
      await _init();
    }
    return this._hiveBox!.clear();
  }
}
