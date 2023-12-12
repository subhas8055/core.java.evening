// import 'dart:convert';
//
// import '../Helper/framework_helper.dart';
// import '../application_meta/field_constants.dart';
// import '../database/database_manager.dart';
//
//
//
// class DemoDataHelper {
//   static const String BeJsonFieldA = "a";
//
//   static Future<bool> parseAndInsertDemoData(String demoData) async {
//     //await DatabaseManager().init();
//
//     // ignore: unnecessary_null_comparison
//     bool isSuccess = true;
//     try {
//       var jsonResult = jsonDecode(demoData);
//       print(jsonResult['Meta'].toString());
//       var metaObj = jsonResult['Meta'];
//       var beNames =
//           metaObj['BEName'] as List; //Getting list of BE from Meta object
//       for (var beName in beNames) {
//         var beDataList = jsonResult[beName] as List; //Getting each BE data
//         for (var beData in beDataList) {
//           var lid = FrameworkHelper.getUUID();
//           beData.forEach((key, value) {
//             if (key != BeJsonFieldA) {
//               if (value is List) {
//                 value.forEach((element) {
//                   var itemLid = FrameworkHelper.getUUID();
//                   element[FieldFid] = lid;
//                   element[FieldLid] = itemLid;
//                   element[FieldSyncStatus] = SyncStatus.none;
//                   element[FieldTimestamp] =
//                       DateTime.now().millisecondsSinceEpoch;
//                   element[FieldObjectStatus] = ObjectStatus.global;
//                   DBInputEntity dbInputEntity = DBInputEntity(key, element);
//                   DatabaseManager().insert(dbInputEntity);
//                 });
//               } else {
//                 value[FieldLid] = lid;
//                 value[FieldSyncStatus] = SyncStatus.none;
//                 value[FieldTimestamp] = DateTime.now().millisecondsSinceEpoch;
//                 value[FieldObjectStatus] = ObjectStatus.global;
//                 // value[FieldConflict] = "";
//
//                 DBInputEntity dbInputEntity = DBInputEntity(key, value);
//                 DatabaseManager().insert(dbInputEntity);
//               }
//             }
//           });
//         }
//       }
//     } catch (e) {
//       print(e.toString());
//     }
//
//     return isSuccess;
//   }
// }

import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../helper/framework_helper.dart';
import '../application_meta/field_constants.dart';
import '../database/database_manager.dart';

class DemoDataHelper {
  static const String BeJsonFieldA = "a";

  static Future<List<DBInputEntity>> parseDemoData(String demoData) async {
    //await DatabaseManager().init();
    List<DBInputEntity> dbInputEntityList = [];
    // ignore: unnecessary_null_comparison
    bool isSuccess = true;
    try {
      var jsonResult = jsonDecode(demoData);
      var metaObj = jsonResult['Meta'];
      var beNames =
          metaObj['BEName'] as List; //Getting list of BE from Meta object
      for (var beName in beNames) {
        var beDataList = jsonResult[beName] as List; //Getting each BE data
        for (var beData in beDataList) {
          var lid = FrameworkHelper.getUUID();
          Iterable<String> beDataKeys = beData.keys;
          for (String key in beDataKeys) {
            dynamic value = beData[key];
            if (key != BeJsonFieldA) {
              if (value is List) {
                for (Map<String, dynamic> element in value) {
                  var itemLid = FrameworkHelper.getUUID();
                  element[FieldFid] = lid;
                  element[FieldLid] = itemLid;
                  element[FieldSyncStatus] = SyncStatus.none.index;
                  element[FieldTimestamp] =
                      DateTime.now().millisecondsSinceEpoch;
                  element[FieldObjectStatus] = ObjectStatus.global.index;
                  DBInputEntity dbInputEntity = DBInputEntity(key, element);
                  dbInputEntityList.add(dbInputEntity);
                }
              } else {
                value[FieldLid] = lid;
                value[FieldSyncStatus] = SyncStatus.none.index;
                value[FieldTimestamp] = DateTime.now().millisecondsSinceEpoch;
                value[FieldObjectStatus] = ObjectStatus.global.index;
                // value[FieldConflict] = "";
                DBInputEntity dbInputEntity = DBInputEntity(key, value);
                dbInputEntityList.add(dbInputEntity);
              }
            }
          }
        }
      }
    } catch (e) {
      throw(e);
    }

    return dbInputEntityList;
  }

  static insertDemoData(List<DBInputEntity> entities) async {
    for (DBInputEntity dbInputEntity in entities) {
      await DatabaseManager().insert(dbInputEntity);
    }
  }

  static parseAndInsertDemoData(String demoData) async {
    List<DBInputEntity> list = await compute(parseDemoData, demoData);
    await DemoDataHelper.insertDemoData(list);
  }
}
