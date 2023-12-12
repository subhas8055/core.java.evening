import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:unvired_sdk/src/helper/path_manager.dart';
import 'package:unvired_sdk/unvired_sdk.dart';

import '../unvired_account.dart';

class UnviredAccountManager {
  Box? _hiveBox;
  String _accountKey = "LoggedInUsers";
  String _boxName = "UnviredSDK";
  String _actIdForPush = "ActIdForPush";
  static final UnviredAccountManager _unviredAccountManager =
      UnviredAccountManager._internal();

  UnviredAccountManager._internal();

  factory UnviredAccountManager() {
    return _unviredAccountManager;
  }

  _init() async {
    if(!kIsWeb){
      await Hive.initFlutter(await PathManager.getApplicationPath(""));
    }else{
      await Hive.initFlutter();
    }
    try{
      this._hiveBox = await Hive.openBox(_boxName);

    }catch(e){
      Logger.logError("UnviredAccountManager", "_init", e.toString());
    }
  }

  Future<List<UnviredAccount>> getAllLoggedInAccounts() async {
    if (this._hiveBox == null) {
      await _init();
    }
    //await this._hiveBox!.deleteFromDisk();
    String valueJson = this._hiveBox!.get(_accountKey, defaultValue: "");
    if (valueJson.isEmpty) {
      return [];
    }
    List<dynamic> accountJsonArray = jsonDecode(valueJson);
    List<UnviredAccount> unviredAccounts = [];
    for (Map<String, dynamic> item in accountJsonArray) {
      unviredAccounts.add(UnviredAccount.fromJson(item));
    }
    return unviredAccounts;
  }

  Future<void> _setAllLoggedInAccounts(
      List<UnviredAccount> loggedInAccouts) async {
    if (this._hiveBox == null) {
      await _init();
    }
    String valueJson = "";
    List<dynamic> accountJsonArray = [];
    for (UnviredAccount item in loggedInAccouts) {
      accountJsonArray.add(item.toJson());
    }
    if (accountJsonArray.length > 0) {
      valueJson = jsonEncode(accountJsonArray);
    }
    this._hiveBox!.put(_accountKey, valueJson);
  }

  Future<void> addLoggedInAccount(UnviredAccount loggedInAccount) async {
    List<UnviredAccount> unviredAccounts = await getAllLoggedInAccounts();
    unviredAccounts.add(loggedInAccount);
    await _setAllLoggedInAccounts(unviredAccounts);
  }

  Future<void> updateAccount(UnviredAccount account) async {
    List<UnviredAccount> unviredAccounts = await getAllLoggedInAccounts();
    if (unviredAccounts.length == 0) {
      unviredAccounts.add(account);
    } else {
      int index = unviredAccounts
          .indexWhere((element) => element.getUserId() == account.getUserId());
      if (index >= 0) {
        unviredAccounts[index] = account;
      } else {
        unviredAccounts.add(account);
      }
    }
    await _setAllLoggedInAccounts(unviredAccounts);
  }

  Future<void> deleteAccount(UnviredAccount loggedInAccount) async {
    List<UnviredAccount> unviredAccounts = await getAllLoggedInAccounts();
    unviredAccounts.removeWhere(
        (element) => element.getUserId() == loggedInAccount.getUserId());
    await _setAllLoggedInAccounts(unviredAccounts);
  }

  Future<bool> isAccountAlreadyPresent(UnviredAccount account) async {
    List<UnviredAccount> unviredAccounts = await getAllLoggedInAccounts();
    List<UnviredAccount> filteredAccounts = unviredAccounts
        .where((element) =>
            element.getUserName() == account.getUserName() &&
            element.getCompany() == account.getCompany() &&
            element.getUrl() == account.getUrl())
        .toList();
    return filteredAccounts.length > 0;
  }

  Future<bool> isValidAccount(UnviredAccount account) async {
    List<UnviredAccount> unviredAccounts = await getAllLoggedInAccounts();
    List<UnviredAccount> filteredAccounts = unviredAccounts
        .where((element) => element.getUserId() == account.getUserId())
        .toList();
    return filteredAccounts.length > 0;
  }

  Future<void> setActIdForPush(String actId) async {
    if (this._hiveBox == null) {
      await _init();
    }
    this._hiveBox!.put(_actIdForPush, actId);
  }

  Future<String> getActIdForPush() async {
    if (this._hiveBox == null) {
      await _init();
    }
    String value = this._hiveBox!.get(_actIdForPush, defaultValue: "");
    return value;
  }
}
