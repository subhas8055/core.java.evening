import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';

import '../unvired_account.dart';

Box? hiveOutboxManagerBox;

_initHiveOutboxManagerBox(
    UnviredAccount? selectedAccount, String outboxPath) async {
  if (!kIsWeb) {
    Hive.init(outboxPath);
  }
  // UnviredAccount? selectedAccount =
  //     await AuthenticationService().getSelectedAccount();
  if (selectedAccount == null) {
    Logger.logError("HiveInboxDataManager", "_init", "User not logged in.");
    throw ("User not logged in.");
  }
  hiveOutboxManagerBox =
      await Hive.openBox(selectedAccount.getUserId() + "Outbox");
}

Future<void> addOutBoxData(String outboxPath, UnviredAccount? selectedAccount,
    String beLid, String responseData) async {
  if (hiveOutboxManagerBox == null) {
    await _initHiveOutboxManagerBox(selectedAccount, outboxPath);
  }
  await hiveOutboxManagerBox!.put(beLid, responseData);
}

class HiveOutboxDataManager {
  Box? _hiveBox;
  String _boxName = "Outbox";
  UnviredAccount? selectedAccount;

  HiveOutboxDataManager(UnviredAccount? unviredAccount) {
    selectedAccount = unviredAccount;
  }

  Future<Box?> getBox() async {
    if (selectedAccount == null) {
      Logger.logError("HiveInboxDataManager", "_init", "User not logged in.");
      throw ("User not logged in.");
    }
    Box? _hiveBox = await Hive.openBox(selectedAccount!.getUserId() + _boxName);
    return _hiveBox;
  }

  Future<List<Map<String, dynamic>>> getAllOutboxData() async {
    if (this._hiveBox == null) {
      //await _init();
    }
    List<Map<String, dynamic>> unviredAccounts = [];
    Iterable<dynamic> allKeys = this._hiveBox!.keys;
    for (String key in allKeys) {
      Map<String, dynamic> obj = {};
      String valueJson = this._hiveBox!.get(key, defaultValue: "");
      if (valueJson.isEmpty) {
        continue;
      }
      obj[key] = valueJson;
      unviredAccounts.add(obj);
    }
    return unviredAccounts;
  }

  Future<void> addOutboxData(
      String beLid, Map<String, dynamic> responseData) async {
    if (this._hiveBox == null) {
      //await _init();
    }
    this
        ._hiveBox!
        .put(beLid, responseData.isEmpty ? "" : jsonEncode(responseData));
  }

  Future<Map<String, dynamic>> getOutboxData(String conversationId) async {
    if (this._hiveBox == null) {
      // await _init();
    }
    String inboxData = this._hiveBox!.get(conversationId, defaultValue: "");
    if (inboxData.isEmpty) {
      return {};
    }
    return jsonDecode(inboxData);
  }

  Future<void> deleteOutboxData(String beLid) async {
    if (this._hiveBox == null) {
      // await _init();
    }
    this._hiveBox!.delete(beLid);
  }

  Future<int> deleteAll() async {
    if (this._hiveBox == null) {
      this._hiveBox = await getBox();
    }

    return this._hiveBox!.clear();
  }
}
