import 'dart:developer';

import 'package:logger/logger.dart';
import 'package:unvired_sdk/src/sync_engine.dart';

import '../application_meta/application_metadata_parser.dart';
import '../application_meta/field_constants.dart';
import '../attachment/attachment_helper.dart';
import '../database/database_manager.dart';
import '../database/framework_database.dart';
import '../helper/framework_helper.dart';
import '../helper/server_response_handler.dart';
import '../helper/service_constants.dart';

class PullPushQueryReconciler {
  String _entityName = "";
  Map<String, dynamic> _entityInDB = {};
  Map<String, dynamic> _incomingEntity = {};
  Map<String, dynamic> _incomingItems = {};
  String _conflictRule = "";

  Map<String, List<String>> _incomingItemLids = {};
  Map<String, List<String>> _incomingAttachmentItemLids = {};
  PullPushQueryReconciler(
      String entityName,
      Map<String, dynamic> entityInDB,
      Map<String, dynamic> incomingEntity,
      Map<String, dynamic> incomingItems,
      String conflictRule,
      int index) {
    _entityName = entityName;
    _entityInDB = entityInDB;
    _incomingEntity = incomingEntity;
    _incomingItems = incomingItems;
    _conflictRule = conflictRule;
  }

  Future<bool> reconcile(
      List<StructureMetaData> structureMetas,
      List<FieldMetaData> fieldMetas,
      RequestType requestType,
      String lid) async {
    bool status = true;
    int objectStatus = _entityInDB[FieldObjectStatus] as int;
    switch (objectStatus) {
      case 0:
        status = await actionHeaderForGlobal();
        break;

      case 1:
        status = await actionHeaderForAdd();
        break;

      case 2:
        status = await actionHeaderForModify();
        break;

      case 3:
        status = await actionHeaderForDelete();
        break;

      default:
        break;
    }

    if (!status) {
      return false;
    }

    // Handle Items
    if (_incomingItems.length > 0) {
      Iterable<String> keys = _incomingItems.keys;
      for (String key in keys) {
        List<dynamic> itemsArray = _incomingItems[key];
        for (Map<String, dynamic> item in itemsArray) {
          Map<String, dynamic>? itemInDB =
              await ServerResponseHandler.checkDuplicateBe(
                  key, fieldMetas, item, requestType, lid);
          if (key.endsWith(AttachmentBE)) {
            // Handle Attachment Items
            await handleAttachmentItems(key, itemInDB, item);
          } else {
            // Handle items without Attachment
            await handleItems(key, itemInDB, item);
          }
        }
      }
    }

    await handleDeletionOfItemsInDBWithoutIncomingItems(structureMetas);
    await handleDeletionOfAttachmentItemsInDBWithoutIncomingItems(
        structureMetas);
    return true;
  }

  Future<void> setHeaderFieldsAndStatuses() async {
    _incomingEntity[FieldLid] = _entityInDB[FieldLid];
    _incomingEntity[FieldObjectStatus] = ObjectStatus.global.index;
    _incomingEntity[FieldSyncStatus] = SyncStatus.none.index;
    _incomingEntity[FieldTimestamp] =
        _entityInDB[FieldTimestamp]; //TODO: CHECK IF NEED TO UPDATE TIMESTAMP
  }

  Future<bool> actionHeaderForGlobal() async {
    int syncStatus = _entityInDB[FieldSyncStatus] as int;
    switch (syncStatus) {
      case 0:
        {
          await setHeaderFieldsAndStatuses();
          DBInputEntity dbInputEntity =
              DBInputEntity(_entityName, _incomingEntity);
          return await DatabaseManager().update(dbInputEntity);
        }
      case 1:
      case 2:
      case 3:
        {
          Logger.logError("PullPushQueryReconciler", "actionHeaderForGlobal",
              "Invalid case. Header in Object Status GLOBAL can only be in Sync Status NONE. Current Sync Status: $syncStatus, Header Information: $_entityName. LID: ${_entityInDB[FieldLid]}");
          return false;
        }
      default:
        break;
    }
    return true;
  }

  Future<bool> actionHeaderForAdd() async {
    int syncStatus = _entityInDB[FieldSyncStatus] as int;
    switch (syncStatus) {
      case 0:
      case 1:
      case 2:
      case 3:
        {
          Logger.logInfo("PullPushQueryReconciler", "actionHeaderForAdd",
              "Ignoring the locally added DataStructure: $_entityName.");
          return true;
        }
      default:
        break;
    }
    return false;
  }

  Future<bool> actionHeaderForModify() async {
    int syncStatus = _entityInDB[FieldSyncStatus] as int;
    switch (syncStatus) {
      case 2:
        {
          Logger.logInfo("PullPushQueryReconciler", "actionHeaderForModify",
              "Ignoring the locally added DataStructure: $_entityName.");
          return true;
        }
      case 0:
      case 1:
      case 3:
        return await handleHeaderConflict();
      default:
        break;
    }
    return false;
  }

  Future<bool> actionHeaderForDelete() async {
    int syncStatus = _entityInDB[FieldSyncStatus] as int;
    switch (syncStatus) {
      case 0:
      case 1:
      case 3:
        Logger.logError("PullPushQueryReconciler", "actionHeaderForDelete",
            "Invalid case. Header in Object Status DELETE can only be in Sync Status SENT. Current Sync Status: $syncStatus, Header Information: $_entityName. LID: ${_entityInDB[FieldLid]}");
        return false;
      case 2:
        {
          setHeaderFieldsAndStatuses();
          DBInputEntity dbInputEntity =
              DBInputEntity(_entityName, _incomingEntity);
          return await DatabaseManager().update(dbInputEntity);
        }
      default:
        break;
    }
    return false;
  }

  Future<bool> handleHeaderConflict() async {
    switch (_conflictRule) {
      case ConflictModeServerWins:
        // modify the header and set statuses
        setHeaderFieldsAndStatuses();
        DBInputEntity dbInputEntity =
            DBInputEntity(_entityName, _incomingEntity);
        return await DatabaseManager().update(dbInputEntity);

      case ConflictModeDeviceWins:
        // Do not touch the header. Let the header data in the device remain. Do not do anything here.
        break;

      case ConflictModeAppHandled:

        // Provide the conflict object back so that the application can handle it

        // TODO:
        // if (self.conflictBE == NULL) {
        //     self.conflictBE = [[ConflictBE alloc] initWithDeviceHeader:self.currentDBHeader andServerHeader:self.currentIncomingHeader];
        // }

        // self.conflictBE.isHeaderInConflict = true;

        break;
    }
    return true;
  }

  Future<void> handleItems(String itemName, Map<String, dynamic>? itemInDB,
      Map<String, dynamic> incomingItem) async {
    if (itemInDB == null) {
      incomingItem[FieldLid] = FrameworkHelper.getUUID();
      incomingItem[FieldFid] = _entityInDB[FieldLid];
      incomingItem[FieldObjectStatus] = ObjectStatus.global.index;
      incomingItem[FieldSyncStatus] = SyncStatus.none.index;

      DBInputEntity dbInputEntity = DBInputEntity(itemName, incomingItem);
      bool isDatabaseOperationSuccessfull =
          await DatabaseManager().insert(dbInputEntity);
      if (!isDatabaseOperationSuccessfull) {
        return;
      }
    } else {
      int objectStatus = itemInDB[FieldObjectStatus];
      switch (objectStatus) {
        case 0:
          {
            await actionOnIncomingItemForGlobal(
                itemName, itemInDB, incomingItem);
          }
          break;

        case 1:
          {
            await actionOnIncomingItemForAdd(itemName, itemInDB, incomingItem);
          }
          break;

        case 2:
          {
            await actionOnIncomingItemForModify(
                itemName, itemInDB, incomingItem);
          }
          break;

        case 3:
          {
            await actionOnIncomingItemForDelete(
                itemName, itemInDB, incomingItem);
          }
          break;

        default:
          break;
      }
    }
    addItemToCollection(itemName, incomingItem);
  }

  Future<bool> actionOnIncomingItemForGlobal(String itemName,
      Map<String, dynamic> itemInDB, Map<String, dynamic> incomingItem) async {
    int syncStatus = itemInDB[FieldSyncStatus];
    switch (syncStatus) {
      case 0:
        // Instead of copying all fields from incomingItemDataStructure to itemDataStructureInDB, copying the LID from itemDataStructureInDB into incomingItemDataStructure
        Map<String, dynamic> item =
            await setItemFieldsAndStatusesFor(itemInDB, incomingItem);
        DBInputEntity dbInputEntity = DBInputEntity(itemName, item);
        return await DatabaseManager().update(dbInputEntity);
      case 1:
      case 2:
      case 3:
        {
          Logger.logError(
              "PullPushQueryReconciler",
              "actionOnIncomingItemForGlobal",
              "Invalid case. Items in Object Status GLOBAL can only be in Sync Status NONE. Current Sync Status: $syncStatus, Header: $_entityName, LID: ${_entityInDB[FieldLid]}, Item: $itemName, Lid: ${itemInDB[FieldLid]}");
        }
        break;
      default:
        break;
    }
    return false;
  }

  Future<bool> actionOnIncomingItemForAdd(String itemName,
      Map<String, dynamic> itemInDB, Map<String, dynamic> incomingItem) async {
    int syncStatus = itemInDB[FieldSyncStatus];
    switch (syncStatus) {
      case 0:
      case 1:
      case 2:
      case 3:
        Logger.logInfo(
            "PullPushQueryReconciler",
            "actionOnIncomingItemForModify",
            "Do not touch. Has to be handled by request-response. Current Sync Status: $syncStatus, Header: $_entityName, LID: ${_entityInDB[FieldLid]}, Item: $itemName, Lid: ${itemInDB[FieldLid]}");
        break;
      default:
        break;
    }
    return true;
  }

  Future<bool> actionOnIncomingItemForModify(String itemName,
      Map<String, dynamic> itemInDB, Map<String, dynamic> incomingItem) async {
    int syncStatus = itemInDB[FieldSyncStatus];
    switch (syncStatus) {
      case 0:
      case 1:
      case 3:
        {
          return handleItemConflictWithItemDataStructure(
              itemName, itemInDB, incomingItem);
        }
      case 2:
        {
          Logger.logInfo(
              "PullPushQueryReconciler",
              "actionOnIncomingItemForModify",
              "Server did not return this item which is modified on the client and with the Sync Status as SENT. Reconciler retaining this item. Current Sync Status: $syncStatus, Header: $_entityName, LID: ${_entityInDB[FieldLid]}, Item: $itemName, Lid: ${itemInDB[FieldLid]}");
        }
        break;
      default:
        break;
    }
    return false;
  }

  Future<bool> actionOnIncomingItemForDelete(String itemName,
      Map<String, dynamic> itemInDB, Map<String, dynamic> incomingItem) async {
    int syncStatus = itemInDB[FieldSyncStatus];
    switch (syncStatus) {
      case 0:
      case 1:
      case 3:
        {
          return handleItemConflictWithItemDataStructure(
              itemName, itemInDB, incomingItem);
        }
      case 2:
        {
          Logger.logInfo(
              "PullPushQueryReconciler",
              "actionOnIncomingItemForDelete",
              "Server did not return this item which is marked for DELETE on the client and with the Sync Status as SENT. Reconciler retaining this item. Current Sync Status: $syncStatus, Header: $_entityName, LID: ${_entityInDB[FieldLid]}, Item: $itemName, Lid: ${itemInDB[FieldLid]}");
        }
        break;
      default:
        break;
    }
    return false;
  }

  Future<bool> handleItemConflictWithItemDataStructure(String itemName,
      Map<String, dynamic> itemInDB, Map<String, dynamic> incomingItem) async {
    switch (_conflictRule) {
      case ConflictModeServerWins:
        {
          // modify the item and set statuses
          Map<String, dynamic> item =
              await setItemFieldsAndStatusesFor(itemInDB, incomingItem);
          DBInputEntity dbInputEntity = DBInputEntity(itemName, item);
          return await DatabaseManager().update(dbInputEntity);
        }

      case ConflictModeDeviceWins:

        // Do not touch the item. Let the item data in the device remain. Do not do anything here.
        break;

      case ConflictModeAppHandled:
        {
          // Provide the conflict object back so that the application can handle it

          // TODO:
          // if (self.conflictBE == NULL) {
          //     self.conflictBE = [[ConflictBE alloc] initWithDeviceHeader:self.currentDBHeader andServerHeader:self.currentIncomingHeader];
          // }

          // [self.conflictBE setItemInConflict:itemDataStructureInDB serverItem:incomingItemDataStructure];
        }
        break;
    }
    return true;
  }

  Future<void> handleAttachmentItems(
      String attachmentItemName,
      Map<String, dynamic>? attachmentItemInDB,
      Map<String, dynamic> incomingAttachmentItem) async {
    //If attachmentItem is not in Db..then insert and add to collection else resolve the conflict..
    if (attachmentItemInDB == null) {
      incomingAttachmentItem[FieldLid] = FrameworkHelper.getUUID();
      incomingAttachmentItem[FieldFid] = _entityInDB[FieldLid];
      incomingAttachmentItem[FieldObjectStatus] = ObjectStatus.global.index;
      incomingAttachmentItem[FieldSyncStatus] = SyncStatus.none.index;

      DBInputEntity dbInputEntity =
          DBInputEntity(attachmentItemName, incomingAttachmentItem);
      bool isDatabaseOperationSuccessfull =
          await DatabaseManager().insert(dbInputEntity);
      if (!isDatabaseOperationSuccessfull) {
        return;
      }
      AttachmentHelper.checkAttachmentAndQueueForAutoDownload(
          attachmentItemName, incomingAttachmentItem);
    } else {
      try {
        var fwDb = await DatabaseManager().getFrameworkDB();
        await fwDb.deleteInfoMessageByLid(attachmentItemInDB[FieldLid]);
      } catch (e) {
        Logger.logError("PullPushQueryReconciler", "handleAttachmentItems",
            "Error while deleting info message. Error: " + e.toString());
      }
      int objectStatus = attachmentItemInDB[FieldObjectStatus];
      switch (objectStatus) {
        case 0:
          {
            await actionOnIncomingAttachmentItemForGlobal(
                attachmentItemName, attachmentItemInDB, incomingAttachmentItem);
          }
          break;

        case 1:
          {
            await actionOnIncomingAttachmentItemForAdd(
                attachmentItemName, attachmentItemInDB, incomingAttachmentItem);
          }
          break;

        case 2:
          {
            await actionOnIncomingAttachmentItemForModify(
                attachmentItemName, attachmentItemInDB, incomingAttachmentItem);
          }
          break;

        case 3:
          {
            await actionOnIncomingAttachmentItemForDelete(
                attachmentItemName, attachmentItemInDB, incomingAttachmentItem);
          }
          break;

        default:
          break;
      }
    }
    addAttachmentItemToCollection(attachmentItemName, incomingAttachmentItem);
  }

  Future<bool> actionOnIncomingAttachmentItemForGlobal(
      String itemName,
      Map<String, dynamic> attachmentItemInDB,
      Map<String, dynamic> incomingAttachmentItem) async {
    int syncStatus = attachmentItemInDB[FieldSyncStatus];
    switch (syncStatus) {
      case 0:

        // Instead of copying all fields from incomingItemDataStructure to itemDataStructureInDB, copying the LID from itemDataStructureInDB into incomingItemDataStructure
        Map<String, dynamic> incomingAttachemnt =
            setAttachmentItemFieldsAndStatuses(
                attachmentItemInDB, incomingAttachmentItem);
        DBInputEntity dbInputEntity =
            DBInputEntity(itemName, incomingAttachemnt);
        return await DatabaseManager().update(dbInputEntity);
      case 1:
      case 2:
      case 3:
        {
          Logger.logError(
              "PullPushQueryReconciler",
              "actionOnIncomingAttachmentItemForGlobal",
              "Invalid case. Items in this status should have OBJECT_STATUS as ADD, MODIFY or DELETE. Current Sync Status: $syncStatus, Header: $_entityName, LID: ${_entityInDB[FieldLid]}, Item: $itemName, Lid: ${attachmentItemInDB[FieldLid]}");
          return false;
        }

      default:
        break;
    }
    return false;
  }

  Future<bool> actionOnIncomingAttachmentItemForAdd(
      String itemName,
      Map<String, dynamic> attachmentItemInDB,
      Map<String, dynamic> incomingAttachmentItem) async {
    int syncStatus = attachmentItemInDB[FieldSyncStatus];
    switch (syncStatus) {
      case 0:
      case 1:
      case 2:
      case 3:
        {
          Logger.logError(
              "PullPushQueryReconciler",
              "actionOnIncomingAttachmentItemForAdd",
              "Do not touch. Has to be handled by the Attachment upload queue separately. For ERROR application has to resolve. Current Sync Status: $syncStatus, Header: $_entityName, LID: ${_entityInDB[FieldLid]}, Item: $itemName, Lid: ${attachmentItemInDB[FieldLid]}");
          return false;
        }
      default:
        break;
    }

    return false;
  }

  Future<bool> actionOnIncomingAttachmentItemForModify(
      String itemName,
      Map<String, dynamic> attachmentItemInDB,
      Map<String, dynamic> incomingAttachmentItem) async {
    int syncStatus = attachmentItemInDB[FieldSyncStatus];
    switch (syncStatus) {
      case 0:
      case 1:
      case 2:
      case 3:
        {
          Logger.logError(
              "PullPushQueryReconciler",
              "actionOnIncomingAttachmentItemForModify",
              "Do not touch. Has to be handled by the Attachment upload queue separately. For ERROR application has to resolve. Current Sync Status: $syncStatus, Header: $_entityName, LID: ${_entityInDB[FieldLid]}, Item: $itemName, Lid: ${attachmentItemInDB[FieldLid]}");
          return false;
        }
      default:
        break;
    }
    return false;
  }

  Future<bool> actionOnIncomingAttachmentItemForDelete(
      String itemName,
      Map<String, dynamic> attachmentItemInDB,
      Map<String, dynamic> incomingAttachmentItem) async {
    int syncStatus = attachmentItemInDB[FieldSyncStatus];
    switch (syncStatus) {
      case 0:
      case 1:
      case 2:
      case 3:
        {
          Logger.logError(
              "PullPushQueryReconciler",
              "actionOnIncomingAttachmentItemForDelete",
              "Do not touch. Has to be handled by the Attachment upload queue separately. For ERROR application has to resolve. Current Sync Status: $syncStatus, Header: $_entityName, LID: ${_entityInDB[FieldLid]}, Item: $itemName, Lid: ${attachmentItemInDB[FieldLid]}");
          return false;
        }
      default:
        break;
    }
    return false;
  }

  void addItemToCollection(String itemName, Map<String, dynamic>? item) {
    if (item == null) {
      return;
    }
    List<String>? items = _incomingItemLids[itemName];
    if (items == null) {
      items = [];
    }
    items.add(item[FieldLid]);
    _incomingItemLids[itemName] = items;
  }

  void addAttachmentItemToCollection(
      String attachmentItemName, Map<String, dynamic>? attachmentItem) {
    if (attachmentItem == null) {
      return;
    }
    List<String>? items = _incomingAttachmentItemLids[attachmentItemName];
    if (items == null) {
      items = [];
    }
    items.add(attachmentItem[FieldLid]);
    _incomingAttachmentItemLids[attachmentItemName] = items;
  }

  Future<Map<String, dynamic>> setItemFieldsAndStatusesFor(
      Map<String, dynamic> itemInDB, Map<String, dynamic> incomingItem) async {
    // Setting the LID of the incoming Item to the Item present in DB so that its easier for updation.
    incomingItem[FieldLid] = itemInDB[FieldLid];
    incomingItem[FieldFid] = _incomingEntity[FieldLid];
    incomingItem[FieldObjectStatus] = ObjectStatus.global.index;
    incomingItem[FieldSyncStatus] = SyncStatus.none.index;
    incomingItem[FieldTimestamp] = itemInDB[
        FieldTimestamp]; //TODO : CHeck if timestamp needs to be updated
    return incomingItem;
  }

  Map<String, dynamic> setAttachmentItemFieldsAndStatuses(
      Map<String, dynamic> attachmentItemInDB,
      Map<String, dynamic> incomingAttachmentItem) {
    incomingAttachmentItem[FieldLid] = attachmentItemInDB[FieldLid];
    incomingAttachmentItem[FieldFid] = _incomingEntity[FieldLid];
    incomingAttachmentItem[FieldObjectStatus] = ObjectStatus.global.index;
    incomingAttachmentItem[FieldSyncStatus] = SyncStatus.none.index;
    incomingAttachmentItem[AttachmentItemFieldAttachmentStatus] =
        attachmentItemInDB[AttachmentItemFieldAttachmentStatus];
    incomingAttachmentItem[AttachmentItemFieldFileName] =
        attachmentItemInDB[AttachmentItemFieldFileName];
    incomingAttachmentItem[AttachmentItemFieldLocalPath] =
        attachmentItemInDB[AttachmentItemFieldLocalPath];
    return incomingAttachmentItem;
  }

  handleDeletionOfItemsInDBWithoutIncomingItems(
      List<StructureMetaData> structureMetas) async {
    // Handle Items in DB that do not have a matching incoming item from server

    // Get All the Children Table Names which are not attachmenrts.
    List<String> childrenTableNames = structureMetas
        .where((element) => (!element.structureName.endsWith(AttachmentBE) &&
            element.isHeader == "0"))
        .map((e) => e.structureName)
        .toList();

    for (String childTableName in childrenTableNames) {
      // Get all items from the child item table that does not have incoming items
      List<String>? incomingItemLids = _incomingItemLids[childTableName];
      String whereClauseForExcludingIncomingItems =
          "$FieldFid = '${_entityInDB[FieldLid]}'";
      if (incomingItemLids != null && incomingItemLids.length > 0) {
        whereClauseForExcludingIncomingItems += " AND $FieldLid NOT IN (";
        for (int i = 0; i < incomingItemLids.length; i++) {
          if (i != 0) {
            whereClauseForExcludingIncomingItems += ",";
          }
          whereClauseForExcludingIncomingItems += "'${incomingItemLids[i]}'";
        }
        whereClauseForExcludingIncomingItems += ")";
      }
      DBInputEntity dbInputEntity = DBInputEntity(childTableName, {})
        ..setWhereClause(whereClauseForExcludingIncomingItems);
      List<dynamic> itemsInDBWithoutIncomingItems =
          await DatabaseManager().select(dbInputEntity);

      if (itemsInDBWithoutIncomingItems.length > 0) {
        await actionOnItemsInDBWithoutIncomingItems(
            childTableName, itemsInDBWithoutIncomingItems);
      }
    }
  }

  Future<bool> actionOnItemsInDBWithoutIncomingItems(
      String itemName, List<dynamic> itemsInDBWithoutIncomingItems) async {
    for (Map<String, dynamic> itemInDB in itemsInDBWithoutIncomingItems) {
      int objectStatus = itemInDB[FieldObjectStatus] as int;
      switch (objectStatus) {
        case 0:
          {
            await actionOnDBItemWithoutIncomingItemForGlobal(
                itemName, itemInDB);
          }
          break;

        case 1:
          {
            await actionOnDBItemWithoutIncomingItemForAdd(itemName, itemInDB);
          }
          break;

        case 2:
          {
            await actionOnDBItemWithoutIncomingItemForModify(
                itemName, itemInDB);
          }
          break;

        case 3:
          {
            await actionOnDBItemWithoutIncomingItemForDelete(
                itemName, itemInDB);
          }
          break;

        default:
          break;
      }
    }
    return true;
  }

  Future<bool> actionOnDBItemWithoutIncomingItemForGlobal(
      String itemName, Map<String, dynamic> itemInDB) async {
    int syncStatus = itemInDB[FieldSyncStatus] as int;
    switch (syncStatus) {
      case 0:
        {
          DBInputEntity dbInputEntity = DBInputEntity(itemName, itemInDB);
          int result = await DatabaseManager().delete(dbInputEntity);
          return result != 0;
        }
      case 1:
      case 2:
      case 3:
        {
          Logger.logError(
              "PullPushQueryReconciler",
              "actionOnDBItemWithoutIncomingItemForGlobal",
              "Invalid case. Items in Object Status GLOBAL can only be in Sync Status NONE. Current Sync Status: $syncStatus, Header: $_entityName, LID: ${_entityInDB[FieldLid]}, Item: $itemName, Lid: ${itemInDB[FieldLid]}");
          return false;
        }
      default:
        break;
    }
    return true;
  }

  Future<bool> actionOnDBItemWithoutIncomingItemForAdd(
      String itemName, Map<String, dynamic> itemInDB) async {
    int syncStatus = itemInDB[FieldSyncStatus] as int;
    switch (syncStatus) {
      case 0:
      case 1:
      case 2:
      case 3:
        {
          Logger.logError(
              "PullPushQueryReconciler",
              "actionOnDBItemWithoutIncomingItemForAdd",
              "Server did not return this item, which was added in the device. Reconciler retaining this item. Current Sync Status: $syncStatus, Header: $_entityName, LID: ${_entityInDB[FieldLid]}, Item: $itemName, Lid: ${itemInDB[FieldLid]}");
        }
        break;
      default:
        break;
    }
    return true;
  }

  Future<bool> actionOnDBItemWithoutIncomingItemForModify(
      String itemName, Map<String, dynamic> itemInDB) async {
    int syncStatus = itemInDB[FieldSyncStatus] as int;
    switch (syncStatus) {
      case 0:
      case 1:
      case 2:
      case 3:
        {
          DBInputEntity dbInputEntity = DBInputEntity(itemName, itemInDB);
          int result = await DatabaseManager().delete(dbInputEntity);
          return result != 0;
        }
      default:
        break;
    }
    return true;
  }

  Future<bool> actionOnDBItemWithoutIncomingItemForDelete(
      String itemName, Map<String, dynamic> itemInDB) async {
    int syncStatus = itemInDB[FieldSyncStatus] as int;
    switch (syncStatus) {
      case 0:
      case 1:
      case 2:
      case 3:
        {
          DBInputEntity dbInputEntity = DBInputEntity(itemName, itemInDB);
          int result = await DatabaseManager().delete(dbInputEntity);
          return result != 0;
        }
      default:
        break;
    }
    return true;
  }

  handleDeletionOfAttachmentItemsInDBWithoutIncomingItems(
      List<StructureMetaData> structureMetas) async {
    // Handle Items in DB that do not have a matching incoming item from server

    // Get all attachment table names
    List<String> childrenTableNames = structureMetas
        .where((element) => element.structureName.endsWith(AttachmentBE))
        .map((e) => e.structureName)
        .toList();

    if (childrenTableNames.length == 0) {
      return;
    }

    Logger.logInfo(
        "PullPushQueryReconciler",
        "handleDeletionOfAttachmentItemsInDBWithoutIncomingItems",
        "Children Table Names Which Support Attachments. ${childrenTableNames.toString()}");

    for (String childTableName in childrenTableNames) {
      // Get all items from the child item table that does not have incoming items
      List<String>? incomingItemLids =
          _incomingAttachmentItemLids[childTableName];
      String whereClauseForExcludingIncomingItems =
          "$FieldFid = '${_entityInDB[FieldLid]}'";
      if (incomingItemLids != null && incomingItemLids.length > 0) {
        whereClauseForExcludingIncomingItems += " AND $FieldLid NOT IN (";
        for (int i = 0; i < incomingItemLids.length; i++) {
          if (i != 0) {
            whereClauseForExcludingIncomingItems += ",";
          }
          whereClauseForExcludingIncomingItems += "'${incomingItemLids[i]}'";
        }
        whereClauseForExcludingIncomingItems += ")";
      }
      DBInputEntity dbInputEntity = DBInputEntity(childTableName, {})
        ..setWhereClause(whereClauseForExcludingIncomingItems);
      List<dynamic> itemsInDBWithoutIncomingItems =
          await DatabaseManager().select(dbInputEntity);

      if (itemsInDBWithoutIncomingItems.length > 0) {
        await actionOnAttachmentItemsInDBWithoutIncomingItems(
            childTableName, itemsInDBWithoutIncomingItems);
      }
    }
  }

  actionOnAttachmentItemsInDBWithoutIncomingItems(String attachmentItemName,
      List<dynamic> attachmentItemsInDBWithoutIncomingItems) async {
    for (Map<String, dynamic> attachmentItemInDB
        in attachmentItemsInDBWithoutIncomingItems) {
      try {
        var fwDb = await DatabaseManager().getFrameworkDB();
        await fwDb.deleteInfoMessageByLid(attachmentItemInDB[FieldLid]);
      } catch (e) {
        Logger.logError(
            "PullPushQueryReconciler",
            "actionOnAttachmentItemsInDBWithoutIncomingItems",
            "Error while deleting info message. Error: " + e.toString());
      }
      int objectStatus = attachmentItemInDB[FieldObjectStatus] as int;
      switch (objectStatus) {
        case 0:
          await actionOnDBAttachmentItemWithoutIncomingItemForGlobal(
              attachmentItemName, attachmentItemInDB);
          break;

        case 1:
          await actionOnDBAttachmentItemWithoutIncomingItemForAdd(
              attachmentItemName, attachmentItemInDB);
          break;

        case 2:
          await actionOnDBAttachmentItemWithoutIncomingItemForModify(
              attachmentItemName, attachmentItemInDB);
          break;

        case 3:
          await actionOnDBAttachmentItemWithoutIncomingItemForDelete(
              attachmentItemName, attachmentItemInDB);
          break;

        default:
          break;
      }
    }
  }

  Future<bool> actionOnDBAttachmentItemWithoutIncomingItemForGlobal(
      String attachmentItemName,
      Map<String, dynamic> attachmentItemInDB) async {
    int syncStatus = attachmentItemInDB[FieldSyncStatus] as int;
    switch (syncStatus) {
      case 0: // Backend does not have this item
        {
          DBInputEntity dbInputEntity =
              DBInputEntity(attachmentItemName, attachmentItemInDB);
          int result = await DatabaseManager().delete(dbInputEntity);
          return result != 0;
        }
      case 1:
      case 2:
      case 3:
        {
          Logger.logError(
              "PullPushQueryReconciler",
              "actionOnDBAttachmentItemWithoutIncomingItemForGlobal",
              "Invalid case. Items in Object Status GLOBAL can only be in Sync Status NONE. Current Sync Status: $syncStatus, Header: $_entityName, LID: ${_entityInDB[FieldLid]}, Item: $attachmentItemName, Lid: ${attachmentItemInDB[FieldLid]}");
        }
        break;

      default:
        break;
    }
    return true;
  }

  Future<bool> actionOnDBAttachmentItemWithoutIncomingItemForAdd(
      String attachmentItemName,
      Map<String, dynamic> attachmentItemInDB) async {
    int syncStatus = attachmentItemInDB[FieldSyncStatus] as int;

    switch (syncStatus) {
      case 0:
      case 1:
      case 2:
      case 3:
        {
          Logger.logInfo(
              "PullPushQueryReconciler",
              "actionOnDBAttachmentItemWithoutIncomingItemForAdd",
              "Server did not return this item, which was added in the device. Reconciler retaining this item. Current Sync Status: $syncStatus, Header: $_entityName, LID: ${_entityInDB[FieldLid]}, Item: $attachmentItemName, Lid: ${attachmentItemInDB[FieldLid]}");
          return false;
        }
      default:
        break;
    }
    return true;
  }

  Future<bool> actionOnDBAttachmentItemWithoutIncomingItemForModify(
      String attachmentItemName,
      Map<String, dynamic> attachmentItemInDB) async {
    int syncStatus = attachmentItemInDB[FieldSyncStatus] as int;

    switch (syncStatus) {
      case 0:
      case 1:
      case 2:
      case 3:
        {
          DBInputEntity dbInputEntity =
              DBInputEntity(attachmentItemName, attachmentItemInDB);
          int result = await DatabaseManager().delete(dbInputEntity);
          return result != 0;
        }
      default:
        break;
    }
    return true;
  }

  Future<bool> actionOnDBAttachmentItemWithoutIncomingItemForDelete(
      String attachmentItemName,
      Map<String, dynamic> attachmentItemInDB) async {
    int syncStatus = attachmentItemInDB[FieldSyncStatus] as int;

    switch (syncStatus) {
      case 0:
      case 1:
      case 2:
      case 3:
        {
          DBInputEntity dbInputEntity =
              DBInputEntity(attachmentItemName, attachmentItemInDB);
          int result = await DatabaseManager().delete(dbInputEntity);
          return result != 0;
        }
      default:
        break;
    }
    return true;
  }
}
