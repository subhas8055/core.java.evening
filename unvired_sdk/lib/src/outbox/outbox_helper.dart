import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:unvired_sdk/src/helper/connectivity_manager.dart';
import 'package:unvired_sdk/src/notification_center/dart_notification_center.dart';

import '../application_meta/field_constants.dart';
import '../database/database.dart';
import '../database/database_manager.dart';
import '../database/framework_database.dart';
import '../helper/event_handler_constants.dart';
import '../helper/service_constants.dart';
import '../sync_engine.dart';
import 'outbox_service.dart';


enum OutObjectStatus { none, lockedForModify, lockedForSending, errorOnProcessing }

class OutBoxHelper {
  Future<OutObjectData?> checkIsInOutBox(String beLid) async {
    if (beLid.isEmpty) {
      return null;
    }
    FrameworkDatabase fwDb = await DatabaseManager().getFrameworkDB();
    var outObjectData = await fwDb.getOutObjectFromBeLid(beLid);
    return outObjectData;
  }

  Future<SentItem?> checkIsInSentItems(String beLid) async {
    if (beLid.isEmpty) {
      return null;
    }
    FrameworkDatabase fwDb = await DatabaseManager().getFrameworkDB();
    var sentItem = await fwDb.getSentItemFromLid(beLid);
    return sentItem;
  }

  Future<void> updateSyncStatusToEntityObjects({required OutObjectData outObject,required SyncStatus syncStatus}) async {
    String? requestType = outObject.requestType;

    String? entityName = outObject.beName;
    String? beLid = outObject.beHeaderLid;

    if (requestType == RequestType.rqst.toString()) {
      FrameworkDatabase fwDb = await DatabaseManager().getFrameworkDB();
      Database appDb = await DatabaseManager().getAppDB();
      StructureMetaData? structureMetaData = (await fwDb.allStructureMetas)
          .firstWhere((element) => element.structureName == entityName);
      String? structName = structureMetaData.structureName;
      List<dynamic>? structureFieldData = await DatabaseManager().select(
          DBInputEntity(structName, {})
            ..setWhereClause("$FieldLid = '${outObject.beHeaderLid}'"));
      if (structureFieldData.isEmpty) {
        Logger.logDebug(
            "OutboxHelper",
            "updateSyncStatusToEntityObjects",
            "No Business Entity got from database, BE-NAME: " +
                outObject.beName +
                ", BE-LID: " +
                beLid);
        return;
      }
      Map<String, dynamic> data = structureFieldData[0];

      data[FieldSyncStatus] = syncStatus.index;
      await DatabaseManager().update(DBInputEntity(structName, data));

      List<StructureMetaData> childStructureMetas =
      (await (await DatabaseManager().getFrameworkDB()).allStructureMetas)
          .where((element) =>
      element.beName == structureMetaData.beName &&
          element.isHeader != "1")
          .toList();
      for (StructureMetaData childStructureMetaData in childStructureMetas) {
        String query =
            "UPDATE ${childStructureMetaData.structureName} SET $FieldSyncStatus = ${syncStatus.index} WHERE $FieldFid='$beLid' AND $FieldObjectStatus <> ${ObjectStatus.global.index};";
        await DatabaseManager().execute(query);
      }
    }
  }

  Future<void> checkOutboxAndStartService() async {
    try {
      FrameworkDatabase fwDb = await DatabaseManager().getFrameworkDB();
      List<OutObjectData> outObjectList = await fwDb.allOutObjects;
      if (outObjectList.isNotEmpty) {
        if (OutBoxService.threadStatus != ServiceThreadStatus.Running.toString() && !kIsWeb) {
          bool connectionStatus = await ConnectivityManager().checkConnection();
          if(connectionStatus){
            await OutBoxService().start();
          }else{
            Logger.logDebug("OutboxHelper", "checkOutboxAndStartService",
                "No internet connection to process outbox");
            if(!ConnectivityManager().isOutboxListening){
              ConnectivityManager().isOutboxListening = true;
              ConnectivityManager().notifyConnection();
              DartNotificationCenter.registerChannel(channel: EventNameConnectionStatus);
              DartNotificationCenter.subscribe(
                  channel: EventNameConnectionStatus,
                  observer: this,
                  onNotification: (data) async {
                    if(data==online){
                      await OutBoxService().start();
                      DartNotificationCenter.unsubscribe(observer: this);
                      DartNotificationCenter.unregisterChannel(channel: EventNameConnectionStatus);
                      ConnectivityManager().isOutboxListening = false;
                    }
                  });
            }

          }
        }else{
          await OutBoxService().start();
        }
      } else {
        Logger.logError("OutboxHelper", "checkOutboxAndStartService",
            "No items in outbox to queue");
        //throw (e.toString());
      }
    } catch (e) {
      Logger.logError(
          "OutboxHelper", "checkOutboxAndStartService", e.toString());
      throw (e.toString());
    }
  }
}
