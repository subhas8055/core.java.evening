import 'package:collection/collection.dart';
import 'package:logger/logger.dart';

import '../database/database_manager.dart';
import '../database/framework_database.dart';

class Attachment {
  static final Attachment _attachment = Attachment._internal();
  Attachment._internal();
  factory Attachment() {
    return _attachment;
  }

  Future<bool> add(AttachmentQObjectData attachmentQObject) async {
    FrameworkDatabase frameworkDatabase =
        await DatabaseManager().getFrameworkDB();
    try {
      int result =
          await frameworkDatabase.addAttachmentQObject(attachmentQObject);
      return result != 0;
    } catch (e) {
      Logger.logError("Attachment", "add", e.toString());
      throw (e);
    }
  }

  Future<bool> remove(String uid) async {
    FrameworkDatabase frameworkDatabase =
        await DatabaseManager().getFrameworkDB();
    try {
      int result = await frameworkDatabase.deleteAttachmentQObject(uid);
      return result != 0;
    } catch (e) {
      Logger.logError("Attachment", "remove", e.toString());
      throw (e);
    }
  }

  Future<bool> removeAll() async {
    FrameworkDatabase frameworkDatabase =
        await DatabaseManager().getFrameworkDB();
    try {
      int result = await frameworkDatabase.deleteAllAttachmentQObjects();
      return result != 0;
    } catch (e) {
      Logger.logError("Attachment", "removeAll", e.toString());
      throw (e);
    }
  }

  Future<bool> contains(String uid) async {
    List<AttachmentQObjectData> inObjects = await getAllAttachmentQObjects();
    AttachmentQObjectData? inObject =
        inObjects.firstWhereOrNull((element) => element.uid == uid);
    return inObject != null;
  }

  Future<AttachmentQObjectData?> getNextInObject() async {
    List<AttachmentQObjectData> inObjects = await getAllAttachmentQObjects();
    return inObjects.length > 0 ? inObjects[0] : null;
  }

  Future<List<AttachmentQObjectData>> getAllAttachmentQObjects() async {
    FrameworkDatabase frameworkDatabase =
        await DatabaseManager().getFrameworkDB();
    return await frameworkDatabase.allAttachmentQObjects;
  }

  Future<bool> hasAnyAttachmentQObject() async {
    List<AttachmentQObjectData> inObjects = await getAllAttachmentQObjects();
    return inObjects.length > 0;
  }

  Future<int> attachmentQObjectCount() async {
    List<AttachmentQObjectData> inObjects = await getAllAttachmentQObjects();
    return inObjects.length;
  }
}
