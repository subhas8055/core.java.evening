import 'dart:convert';

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
import '../helper/sync_input_data_manager.dart';

class RequestResponseReconciler {
  String _entityName = "";
  Map<String, dynamic> _entityInDB = {};
  Map<String, dynamic> _incomingEntity = {};
  Map<String, dynamic> _incomingItems = {};
  String _conflictRule = "";
  bool _isForeground = true;

  Map<String, List<String>> _incomingItemLids = {};
  Map<String, List<String>> _incomingAttachmentItemLids = {};

  Map<String, dynamic> _conflictBe = {};

  RequestResponseReconciler(
      String entityName,
      Map<String, dynamic> entityInDB,
      Map<String, dynamic> incomingEntity,
      Map<String, dynamic> incomingItems,
      String conflictRule,
      bool isForeground) {
    _entityName = entityName;
    _entityInDB = entityInDB;
    _incomingEntity = incomingEntity;
    _incomingItems = incomingItems;
    _conflictRule = conflictRule;
    _isForeground = isForeground;
  }

  Map<String, dynamic> getConflictBe() {
    return _conflictBe;
  }

  Future<bool> reconcile(
      List<StructureMetaData> structureMetas,
      List<FieldMetaData> fieldMetas,
      RequestType requestType,
      String lid) async {
    // Conflict Management.
    // Check whether |currentIncomingHeader| is conflicted.
    if (_incomingEntity[FieldConflict].toString().toUpperCase() == "X") {
      StructureMetaData headerMeta = structureMetas
          .firstWhere((element) => element.structureName == _entityName);
      Logger.logInfo("RequestResponseReconciler", "reconcile",
          "Header with BE: ${headerMeta.beName}, LID: ${_entityInDB[FieldLid]} is in Conflict. Sending Header to Conflict Manager.");
      bool conflictStatus = await manageConflict(
          headerMeta, _entityInDB, _incomingEntity, _incomingItems);
      return conflictStatus;
    }

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

  void setHeaderFieldsAndStatuses() {
    _incomingEntity[FieldLid] = _entityInDB[FieldLid];
    _incomingEntity[FieldObjectStatus] = ObjectStatus.global.index;
    _incomingEntity[FieldSyncStatus] = SyncStatus.none.index;
  }

  Future<bool> actionHeaderForGlobal() async {
    if (_isForeground) {
      setHeaderFieldsAndStatuses();
      DBInputEntity dbInputEntity = DBInputEntity(_entityName, _incomingEntity);
      return await DatabaseManager().update(dbInputEntity);
    }

    int syncStatus = _entityInDB[FieldSyncStatus] as int;

    switch (syncStatus) {
      case 0:
        {
          setHeaderFieldsAndStatuses();
          DBInputEntity dbInputEntity =
              DBInputEntity(_entityName, _incomingEntity);
          return await DatabaseManager().update(dbInputEntity);
        }
      case 1:
      case 2:
      case 3:
        {
          Logger.logError("RequestResponseReconciler", "actionHeaderForGlobal",
              "Invalid case. Header in Object Status GLOBAL can only be in Sync Status NONE. Current Sync Status: $syncStatus, Header Information: $_entityName. LID: ${_entityInDB[FieldLid]}");
          return false;
        }
      default:
        break;
    }
    return true;
  }

  Future<bool> actionHeaderForAdd() async {
    if (_isForeground) {
      setHeaderFieldsAndStatuses();
      DBInputEntity dbInputEntity = DBInputEntity(_entityName, _incomingEntity);
      return await DatabaseManager().update(dbInputEntity);
    }

    int syncStatus = _entityInDB[FieldSyncStatus] as int;

    switch (syncStatus) {
      case 0:
      case 1:
      case 3:
        {
          Logger.logError("RequestResponseReconciler", "actionHeaderForAdd",
              "Invalid case. Header in Object Status ADD can only be in Sync Status SENT. Current Sync Status: $syncStatus, Header Information: $_entityName. LID: ${_entityInDB[FieldLid]}");
          return false;
        }
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

  Future<bool> actionHeaderForModify() async {
    if (_isForeground) {
      setHeaderFieldsAndStatuses();
      DBInputEntity dbInputEntity = DBInputEntity(_entityName, _incomingEntity);
      return await DatabaseManager().update(dbInputEntity);
    }

    int syncStatus = _entityInDB[FieldSyncStatus] as int;

    switch (syncStatus) {
      case 0:
        return await handleHeaderConflict();
      case 2:
        {
          setHeaderFieldsAndStatuses();
          DBInputEntity dbInputEntity =
              DBInputEntity(_entityName, _incomingEntity);
          return await DatabaseManager().update(dbInputEntity);
        }
      case 1:
      case 3:
        Logger.logError("RequestResponseReconciler", "actionHeaderForModify",
            "Invalid case. Header in Object Status MODIFY can only be in Sync Status SENT. Current Sync Status: $syncStatus, Header Information: $_entityName. LID: ${_entityInDB[FieldLid]}");
        return false;
      default:
        break;
    }
    return false;
  }

  Future<bool> actionHeaderForDelete() async {
    // If the Execution type is Foreground then we should not check for the SyncStatus. Because SYNC Statuses typically do not change for a SYNC Call.
    if (_isForeground) {
      Logger.logInfo("RequestResponseReconciler", "actionHeaderForDelete",
          "Deleting The Header in Database. Table: $_entityName");

      // Delete the Current Header in Database.
      DBInputEntity dbInputEntity = DBInputEntity(_entityName, _incomingEntity);
      int result = await DatabaseManager().delete(dbInputEntity);
      return result == 0 ? false : true;
    }

    int syncStatus = _entityInDB[FieldSyncStatus] as int;

    switch (syncStatus) {
      case 0:
      case 1:
      case 3:
        Logger.logError("RequestResponseReconciler", "actionHeaderForModify",
            "Invalid case. Header in Object Status DELETE can only be in Sync Status SENT. Current Sync Status: $syncStatus, Header Information: $_entityName. LID: ${_entityInDB[FieldLid]}");
        return false;
      case 2:
        {
          DBInputEntity dbInputEntity =
              DBInputEntity(_entityName, _incomingEntity);
          int result = await DatabaseManager().delete(dbInputEntity);
          return result == 0 ? false : true;
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
      case 3:
        // Instead of copying all fields from incomingItemDataStructure to itemDataStructureInDB, copying the LID from itemDataStructureInDB into incomingItemDataStructure
        Map<String, dynamic> item =
            setItemFieldsAndStatusesFor(itemInDB, incomingItem);
        DBInputEntity dbInputEntity = DBInputEntity(itemName, item);
        return await DatabaseManager().update(dbInputEntity);
      case 1:
      case 2:
        {
          Logger.logError(
              "RequestResponseReconciler",
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
    if (_isForeground) {
      Map<String, dynamic> item =
          setItemFieldsAndStatusesFor(itemInDB, incomingItem);
      DBInputEntity dbInputEntity = DBInputEntity(itemName, item);
      return await DatabaseManager().update(dbInputEntity);
    }

    int syncStatus = itemInDB[FieldSyncStatus];
    switch (syncStatus) {
      case 0:
      case 1:
      case 3:
        // Delete Item. Not possible to relate an ADD status to incoming item
        DBInputEntity dbInputEntity = DBInputEntity(itemName, itemInDB);
        int result = await DatabaseManager().delete(dbInputEntity);
        return result != 0;
      case 2:
        {
          Map<String, dynamic> item =
              setItemFieldsAndStatusesFor(itemInDB, incomingItem);
          DBInputEntity dbInputEntity = DBInputEntity(itemName, item);
          return await DatabaseManager().replace(dbInputEntity);
        }
      default:
        break;
    }
    return false;
  }

  Future<bool> actionOnIncomingItemForModify(String itemName,
      Map<String, dynamic> itemInDB, Map<String, dynamic> incomingItem) async {
    if (_isForeground) {
      Map<String, dynamic> item =
          setItemFieldsAndStatusesFor(itemInDB, incomingItem);
      DBInputEntity dbInputEntity = DBInputEntity(itemName, item);
      return await DatabaseManager().update(dbInputEntity);
    }

    int syncStatus = itemInDB[FieldSyncStatus];
    switch (syncStatus) {
      case 0:
        {
          return handleItemConflictWithItemDataStructure(
              itemName, itemInDB, incomingItem);
        }
      case 2:
        {
          Map<String, dynamic> item =
              setItemFieldsAndStatusesFor(itemInDB, incomingItem);
          DBInputEntity dbInputEntity = DBInputEntity(itemName, item);
          return await DatabaseManager().replace(dbInputEntity);
        }
      case 1:
      case 3:
        {
          Logger.logError(
              "RequestResponseReconciler",
              "actionOnIncomingItemForModify",
              "Invalid case. Items in Object Status MODIFY can only be in Sync Status SENT. Current Sync Status: $syncStatus, Header: $_entityName, LID: ${_entityInDB[FieldLid]}, Item: $itemName, Lid: ${itemInDB[FieldLid]}");
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
        {
          Logger.logError(
              "RequestResponseReconciler",
              "actionOnIncomingItemForDelete",
              "Do not touch. Item has been modified after synchronization before getting a response. Current Sync Status: $syncStatus, Header: $_entityName, LID: ${_entityInDB[FieldLid]}, Item: $itemName, Lid: ${itemInDB[FieldLid]}");
        }
        break;
      case 2:
        {
          Map<String, dynamic> item =
              setItemFieldsAndStatusesFor(itemInDB, incomingItem);
          DBInputEntity dbInputEntity = DBInputEntity(itemName, item);
          return await DatabaseManager().update(dbInputEntity);
        }
      case 1:
      case 3:
        {
          Logger.logError(
              "RequestResponseReconciler",
              "actionOnIncomingItemForDelete",
              "Invalid case. Items in Object Status DELETE can only be in Sync Status SENT. Current Sync Status: $syncStatus, Header: $_entityName, LID: ${_entityInDB[FieldLid]}, Item: $itemName, Lid: ${itemInDB[FieldLid]}");
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
              setItemFieldsAndStatusesFor(itemInDB, incomingItem);
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
        Logger.logError("RequestResponseReconciler", "handleAttachmentItems",
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
              "RequestResponseReconciler",
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
    if (_isForeground) {
      Map<String, dynamic> incomingAttachemnt =
          setAttachmentItemFieldsAndStatuses(
              attachmentItemInDB, incomingAttachmentItem);
      DBInputEntity dbInputEntity = DBInputEntity(itemName, incomingAttachemnt);
      return await DatabaseManager().update(dbInputEntity);
    }

    int syncStatus = attachmentItemInDB[FieldSyncStatus];
    switch (syncStatus) {
      case 0:
        Logger.logError(
            "RequestResponseReconciler",
            "actionOnIncomingAttachmentItemForAdd",
            "Do not touch. Item has been modified after synchronization before getting a response. Current Sync Status: $syncStatus, Header: $_entityName, LID: ${_entityInDB[FieldLid]}, Item: $itemName, Lid: ${attachmentItemInDB[FieldLid]}");
        break;
      case 2:
        {
          Map<String, dynamic> incomingAttachemnt =
              setAttachmentItemFieldsAndStatuses(
                  attachmentItemInDB, incomingAttachmentItem);
          DBInputEntity dbInputEntity =
              DBInputEntity(itemName, incomingAttachemnt);
          return await DatabaseManager().update(dbInputEntity);
        }
      case 1:
      case 3:
        {
          Logger.logError(
              "RequestResponseReconciler",
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
    if (_isForeground) {
      Map<String, dynamic> incomingAttachemnt =
          setAttachmentItemFieldsAndStatuses(
              attachmentItemInDB, incomingAttachmentItem);
      DBInputEntity dbInputEntity = DBInputEntity(itemName, incomingAttachemnt);
      return await DatabaseManager().update(dbInputEntity);
    }

    int syncStatus = attachmentItemInDB[FieldSyncStatus];
    switch (syncStatus) {
      case 0:
        Logger.logError(
            "RequestResponseReconciler",
            "actionOnIncomingAttachmentItemForModify",
            "Do not touch. Has to be handled by the Attachment upload queue separately. For ERROR application has to resolve. Current Sync Status: $syncStatus, Header: $_entityName, LID: ${_entityInDB[FieldLid]}, Item: $itemName, Lid: ${attachmentItemInDB[FieldLid]}");
        return true;
      case 2:
        {
          Map<String, dynamic> incomingAttachemnt =
              setAttachmentItemFieldsAndStatuses(
                  attachmentItemInDB, incomingAttachmentItem);
          DBInputEntity dbInputEntity =
              DBInputEntity(itemName, incomingAttachemnt);
          return await DatabaseManager().update(dbInputEntity);
        }
      case 1:
      case 3:
        {
          Logger.logError(
              "RequestResponseReconciler",
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
        Logger.logError(
            "RequestResponseReconciler",
            "actionOnIncomingAttachmentItemForDelete",
            "Do not touch. Has to be handled by the Attachment upload queue separately. For ERROR application has to resolve. Current Sync Status: $syncStatus, Header: $_entityName, LID: ${_entityInDB[FieldLid]}, Item: $itemName, Lid: ${attachmentItemInDB[FieldLid]}");
        return true;
      case 2:
        {
          Map<String, dynamic> incomingAttachemnt =
              setAttachmentItemFieldsAndStatuses(
                  attachmentItemInDB, incomingAttachmentItem);
          DBInputEntity dbInputEntity =
              DBInputEntity(itemName, incomingAttachemnt);
          return await DatabaseManager().update(dbInputEntity);
        }
      case 1:
      case 3:
        {
          Logger.logError(
              "RequestResponseReconciler",
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

  Map<String, dynamic> setItemFieldsAndStatusesFor(
      Map<String, dynamic> itemInDB, Map<String, dynamic> incomingItem) {
    // Setting the LID of the incoming Item to the Item present in DB so that its easier for updation.
    incomingItem[FieldLid] = itemInDB[FieldLid];
    incomingItem[FieldFid] = _incomingEntity[FieldLid];
    incomingItem[FieldObjectStatus] = ObjectStatus.global.index;
    incomingItem[FieldSyncStatus] = SyncStatus.none.index;
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

  Future<bool> actionOnDBItemWithoutIncomingItemForAdd(
      String itemName, Map<String, dynamic> itemInDB) async {
    int syncStatus = itemInDB[FieldSyncStatus] as int;
    switch (syncStatus) {
      case 1:
        {
          Logger.logError(
              "RequestResponseReconciler",
              "actionOnDBItemWithoutIncomingItemForAdd",
              "Invalid case. Cannot queue the same object again if the BE is waiting for a response. Current Sync Status: $syncStatus, Header: $_entityName, LID: ${_entityInDB[FieldLid]}, Item: $itemName, Lid: ${itemInDB[FieldLid]}");
          return false;
        }
      case 0:
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

  Future<bool> actionOnDBItemWithoutIncomingItemForModify(
      String itemName, Map<String, dynamic> itemInDB) async {
    int syncStatus = itemInDB[FieldSyncStatus] as int;
    switch (syncStatus) {
      case 0:
      case 2:
      case 3:
        {
          DBInputEntity dbInputEntity = DBInputEntity(itemName, itemInDB);
          int result = await DatabaseManager().delete(dbInputEntity);
          return result != 0;
        }
      case 1:
        {
          Logger.logError(
              "RequestResponseReconciler",
              "actionOnDBItemWithoutIncomingItemForModify",
              "Invalid case. Cannot queue the same object again if the BE is waiting for a response. Current Sync Status: $syncStatus, Header: $_entityName, LID: ${_entityInDB[FieldLid]}, Item: $itemName, Lid: ${itemInDB[FieldLid]}");
          return false;
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
      case 2:
      case 3:
        {
          DBInputEntity dbInputEntity = DBInputEntity(itemName, itemInDB);
          int result = await DatabaseManager().delete(dbInputEntity);
          return result != 0;
        }
      case 1:
        {
          Logger.logError(
              "RequestResponseReconciler",
              "actionOnDBItemWithoutIncomingItemForDelete",
              "Invalid case. Cannot queue the same object again if the BE is waiting for a response. Current Sync Status: $syncStatus, Header: $_entityName, LID: ${_entityInDB[FieldLid]}, Item: $itemName, Lid: ${itemInDB[FieldLid]}");
          return false;
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

    Logger.logInfo(
        "RequestResponseReconciler",
        "handleDeletionOfAttachmentItemsInDBWithoutIncomingItems",
        "Children Table Names Which Supp  ort Attachments. ${childrenTableNames.toString()}");

    if (childrenTableNames.length == 0) {
      return;
    }

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
            "RequestResponseReconciler",
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
              "RequestResponseReconciler",
              "actionOnDBAttachmentItemWithoutIncomingItemForGlobal",
              "Invalid case. Items in this status should have OBJECT_STATUS as ADD, MODIFY or DELETE. Current Sync Status: $syncStatus, Header: $_entityName, LID: ${_entityInDB[FieldLid]}, Item: $attachmentItemName, Lid: ${attachmentItemInDB[FieldLid]}");
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
      // Backend does not have this time. Deleting the attachment.
      // This can happen during a sync submission.
      case 2:
        {
          DBInputEntity dbInputEntity =
              DBInputEntity(attachmentItemName, attachmentItemInDB);
          int result = await DatabaseManager().delete(dbInputEntity);
          return result != 0;
        }
      case 1:
      case 3:
        {
          Logger.logError(
              "RequestResponseReconciler",
              "actionOnDBAttachmentItemWithoutIncomingItemForAdd",
              "Invalid case. Items in Object Status MODIFY can only be in Sync Status SENT. Current Sync Status: $syncStatus, Header: $_entityName, LID: ${_entityInDB[FieldLid]}, Item: $attachmentItemName, Lid: ${attachmentItemInDB[FieldLid]}");
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

  Future<bool> manageConflict(
      StructureMetaData headerMeta,
      Map<String, dynamic> currentDBHeader,
      Map<String, dynamic> currentIncomingHeader,
      Map<String, dynamic> currentIncomingItems) async {
    // 1
    // Store the Local Data in the CONFLICT BE Data Field.
    // Generate Message For Sending to Server.
    Map<String, dynamic> beData = {};
    beData[headerMeta.structureName] = currentDBHeader;
    Map<String, dynamic> childItems = await SyncInputDataManager.getChildData(
        currentDBHeader[FieldLid], headerMeta.structureName, DataType.all);
    beData.addAll(childItems);

    Map<String, dynamic> finalBeObject = {
      headerMeta.beName: [beData]
    };
    String jsonString = jsonEncode(finalBeObject);

    Map<String, dynamic> inputJSON = {
      "beName": headerMeta.beName,
      "beHeaderLid": currentDBHeader[FieldLid],
      "data": jsonString
    };

    ConflictBEData conflictBEData = ConflictBEData.fromJson(inputJSON);
    int result = await (await DatabaseManager().getFrameworkDB())
        .addConflictBe(conflictBEData);
    if (result == 0) {
      return false;
    }
    _conflictBe = inputJSON;

    // 2
    // Set the currentIncomingHeader's LID to currentDBHeader's LID
    currentIncomingHeader[FieldLid] = currentDBHeader[FieldLid];

    // 3
    // Replace Headers and Items with the incoming header and items
    DatabaseManager databaseManager = DatabaseManager();
    DBInputEntity dbInputEntity =
        DBInputEntity(headerMeta.structureName, currentIncomingHeader);
    bool status = await databaseManager.update(dbInputEntity);
    if (!status) {
      return false;
    }
    Iterable<String> keys = currentIncomingItems.keys;
    for (String key in keys) {
      if (!key.endsWith(AttachmentBE)) {
        // delete all the existing items except attachment items
        DBInputEntity dbInputEntity = DBInputEntity(key, {});
        int deleteStatus = await databaseManager.delete(dbInputEntity);
        if (deleteStatus == 0) {
          return false;
        }
      }
      List<dynamic> itemsArray = currentIncomingItems[key];
      for (Map<String, dynamic> value in itemsArray) {
        // Insert All Incoming Items
        DBInputEntity dbInputEntity = DBInputEntity(key, value);
        bool insertStatus = await databaseManager.insert(dbInputEntity);
        if (!insertStatus) {
          return false;
        }
      }
    }
    return true;
  }
}
