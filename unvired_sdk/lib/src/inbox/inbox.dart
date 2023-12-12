import 'package:collection/collection.dart';
import 'package:logger/logger.dart';

import '../database/database_manager.dart';
import '../database/framework_database.dart';

class Inbox {
  static final Inbox _inbox = Inbox._internal();
  Inbox._internal();
  factory Inbox() {
    return _inbox;
  }

  Future<bool> add(InObjectData inObject) async {
    FrameworkDatabase frameworkDatabase =
        await DatabaseManager().getFrameworkDB();
    try {
      int result = await frameworkDatabase.transaction(() async {
        return await frameworkDatabase.addInObject(inObject);
      });
      //int result = await frameworkDatabase.addInObject(inObject);
      return result != 0;
    } catch (e) {
      Logger.logError("Inbox", "add", e.toString());
      throw (e);
    }
  }

  Future<bool> remove(String conversationId) async {
    FrameworkDatabase frameworkDatabase =
        await DatabaseManager().getFrameworkDB();
    try {
      int result = await frameworkDatabase.transaction(() async {
        return await frameworkDatabase.deleteInObject(conversationId);
      });
      return result != 0;
    } catch (e) {
      Logger.logError("Inbox", "remove", e.toString());
      throw (e);
    }
  }

  Future<bool> removeAll() async {
    FrameworkDatabase frameworkDatabase =
        await DatabaseManager().getFrameworkDB();
    try {
      int result = await frameworkDatabase.transaction(() async {
        return await frameworkDatabase.deleteAllInObjects();
      });
      //int result = await frameworkDatabase.deleteAllInObjects();
      return result != 0;
    } catch (e) {
      Logger.logError("Inbox", "removeAll", e.toString());
      throw (e);
    }
  }

  Future<bool> contains(String conversationId) async {
    List<InObjectData> inObjects = await getAllInObject();
    InObjectData? inObject = inObjects.firstWhereOrNull(
        (element) => element.conversationId == conversationId);
    return inObject != null;
  }

  Future<InObjectData?> getNextInObject() async {
    List<InObjectData> inObjects = await getAllInObject();
    return inObjects.length > 0 ? inObjects[0] : null;
  }

  Future<List<InObjectData>> getAllInObject() async {
    FrameworkDatabase frameworkDatabase =
        await DatabaseManager().getFrameworkDB();
    // return await frameworkDatabase.transaction(() async {
    //   return await frameworkDatabase.allInObjects;
    // });
    return await frameworkDatabase.allInObjects;
  }

  Future<bool> hasAnyInObject() async {
    List<InObjectData> inObjects = await getAllInObject();
    return inObjects.length > 0;
  }

  Future<int> inboxCount() async {
    List<InObjectData> inObjects = await getAllInObject();
    return inObjects.length;
  }
}
