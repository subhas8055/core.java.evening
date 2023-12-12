import 'package:collection/collection.dart';
import 'package:logger/logger.dart';

import '../database/database_manager.dart';
import '../database/framework_database.dart';

class Outbox {
  static final Outbox _Outbox = Outbox._internal();
  Outbox._internal();
  factory Outbox() {
    return _Outbox;
  }

  Future<bool> add(OutObjectData outObject) async {
    FrameworkDatabase frameworkDatabase =
        await DatabaseManager().getFrameworkDB();
    try {
      int result = await frameworkDatabase.addOutObject(outObject);
      return result != 0;
    } catch (e) {
      Logger.logError("Outbox", "add", e.toString());
      throw (e);
    }
  }

  Future<bool> remove(OutObjectData outObjectData) async {
    FrameworkDatabase frameworkDatabase =
        await DatabaseManager().getFrameworkDB();
    try {
      int result = await frameworkDatabase.deleteOutObject(outObjectData);
      return result != 0;
    } catch (e) {
      Logger.logError("Outbox", "remove", e.toString());
      throw (e);
    }
  }

  Future<bool> removeAll() async {
    FrameworkDatabase frameworkDatabase =
        await DatabaseManager().getFrameworkDB();
    try {
      int result = await frameworkDatabase.deleteAllOutObjects();
      return result != 0;
    } catch (e) {
      Logger.logError("Outbox", "removeAll", e.toString());
      throw (e);
    }
  }

  Future<bool> contains(String conversationId) async {
    List<OutObjectData> outObjects = await getAllOutObject();
    OutObjectData? outObject = outObjects.firstWhereOrNull(
        (element) => element.conversationId == conversationId);
    return outObject != null;
  }

  Future<bool> isInQueue(String beHeaderLid) async {
    List<OutObjectData> outObjects = await getAllOutObject();
    OutObjectData? outObject = outObjects.firstWhereOrNull(
            (element) => element.beHeaderLid == beHeaderLid);
    return outObject != null;
  }

  Future<OutObjectData?> getNextOutObject() async {
    List<OutObjectData> outObjects = await getAllOutObject();
    return outObjects.length > 0 ? outObjects[0] : null;
  }

  Future<List<OutObjectData>> getAllOutObject() async {
    FrameworkDatabase frameworkDatabase =
        await DatabaseManager().getFrameworkDB();
    return await frameworkDatabase.allOutObjects;
  }

  Future<bool> hasAnyOutObject() async {
    List<OutObjectData> outObjects = await getAllOutObject();
    return outObjects.length > 0;
  }

  Future<int> outboxCount() async {
    List<OutObjectData> outObjects = await getAllOutObject();
    return outObjects.length;
  }

  Future<int> sentItemsCount() async {
    List<SentItem> sentItems =
        await (await DatabaseManager().getFrameworkDB()).allSentItems;
    return sentItems.length;
  }
}
