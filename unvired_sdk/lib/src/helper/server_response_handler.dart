import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:drift/drift.dart';
import 'package:unvired_sdk/src/database/database.dart';

import '../attachment/attachment_downloader.dart';
import '../attachment/attachment_helper.dart';
import '../database/database_manager.dart';
import '../application_meta/field_constants.dart';
import '../application_meta/application_metadata_parser.dart';
import '../database/framework_database.dart';
import '../helper/event_handler_constants.dart';
import '../helper/framework_helper.dart';
import '../helper/pull_push_query_reconciler.dart';
import '../helper/request_responce_reconciler.dart';
import '../helper/service_constants.dart';
import '../inbox/inbox.dart';
import '../notification_center/dart_notification_center_base.dart';
import '../outbox/outbox.dart';
import '../sync_engine.dart';

class ServerResponseHandler {
  static handleResponseData(Map<String, dynamic> responseData,
      {bool autoSave = true,
      bool isForeground = false,
      String lid = "",
      String entityName = "",
      RequestType? requestType,
      bool? isFromIsolate,
      Map<String, dynamic>? map}) async {
    if (responseData.isNotEmpty) {
      try {
        Database appDb = await DatabaseManager().getAppDB();
        FrameworkDatabase fwDb = await DatabaseManager().getFrameworkDB();
        List<Map<String, dynamic>> processedHeaders = [];
        Map<String, dynamic> metaData = {};
        List<dynamic> infoMessages = [];
        if (responseData[KeyMeta] != null) {
          metaData = responseData[KeyMeta];
          responseData.remove(KeyMeta);
        }
        bool isInfoMessageFailure = false;
        bool isInfoMessageFailureAndProcess = false;
        String infoMsgCategory = "";
        //Save InfoMessages
        if (responseData[KeyInfoMessage] != null) {
          infoMessages = responseData[KeyInfoMessage];
          if (infoMessages.length > 0) {
            //FrameworkHelper.cleanUpInfoMessages();
            for (Map<String, dynamic> element in infoMessages) {
              if (element[FieldInfoMessageCategory] != null) {
                switch (infoMsgCategory.toUpperCase()) {
                  case InfoMessageWarning:
                    {
                      if (infoMsgCategory != InfoMessageFailure &&
                          infoMsgCategory != InfoMessageFailureAndProcess) {
                        infoMsgCategory = InfoMessageWarning;
                      }
                    }
                    break;
                  case InfoMessageInfo:
                    {
                      if (infoMsgCategory != InfoMessageFailure &&
                          infoMsgCategory != InfoMessageFailureAndProcess &&
                          infoMsgCategory != InfoMessageWarning) {
                        infoMsgCategory = InfoMessageInfo;
                      }
                    }
                    break;
                  default:
                    infoMsgCategory = element[FieldInfoMessageCategory];
                    break;
                }
              }

              if (element[FieldInfoMessageCategory] != null &&
                  element[FieldInfoMessageCategory] == InfoMessageFailure &&
                  !isInfoMessageFailure) {
                isInfoMessageFailure = true;
              }
              if (element[FieldInfoMessageCategory] != null &&
                  element[FieldInfoMessageCategory] ==
                      InfoMessageFailureAndProcess &&
                  !isInfoMessageFailureAndProcess) {
                isInfoMessageFailureAndProcess = true;
              }
              InfoMessageData infoMessage = InfoMessageData(
                  lid: FrameworkHelper.getUUID(),
                  timestamp: DateTime.now().millisecondsSinceEpoch,
                  objectStatus: ObjectStatus.global.index,
                  syncStatus: SyncStatus.none.index,
                  type: "",
                  subtype: "",
                  category: element[FieldInfoMessageCategory],
                  message: element[FieldInfoMessageMessage],
                  bename: entityName,
                  belid: lid,
                  messagedetails: Uint8List(0));
              await (await DatabaseManager().getFrameworkDB())
                  .addInfoMessage(infoMessage);
            }
            if (!isForeground) {
              if ((isFromIsolate != null && isFromIsolate)) {
                var data = {
                  messageServiceType: EventNameInfoMessages,
                  "data": infoMessages
                };
                notifyDownloadMessage(data, map!);
              } else {
                DartNotificationCenter.post(
                    channel: EventNameInfoMessages, options: infoMessages);
              }
            }
            _updateInfoMessageCategoryInHeader(
                entityName, lid, infoMsgCategory);
          }
          responseData.remove(KeyInfoMessage);
        } else {
          _updateInfoMessageCategoryInHeader(entityName, lid, "");
        }

        if (isInfoMessageFailure || isInfoMessageFailureAndProcess) {
          if (requestType == RequestType.rqst) {
            Logger.logError("server_response_handler", "handleResponseData",
                "Info Message Failure. Marking header sync status to error. Response Data: ${responseData.toString()}");
            await _updateErrorStatusInHeaderAndCreateInfoMessage(
                entityName, {FieldLid: lid}, infoMsgCategory);
          }
          if (!isForeground) {
            // notify application after updating sync status to error
            if ((isFromIsolate != null && isFromIsolate)) {
              var data = {
                messageServiceType: EventNameInfoMessages,
                "data": infoMessages
              };
              notifyDownloadMessage(data, map!);
            } else {
              DartNotificationCenter.post(
                  channel: EventNameInfoMessages, options: infoMessages);
            }
          }
          if (!isInfoMessageFailureAndProcess) {
            return;
          }
        }

        if (autoSave && responseData.isNotEmpty) {
          List<BusinessEntityMetaData> beMetas =
              await (await DatabaseManager().getFrameworkDB())
                  .allBusinessEntityMetas;
          List<StructureMetaData> structureMetas =
              await (await DatabaseManager().getFrameworkDB())
                  .allStructureMetas;
          List<FieldMetaData> fieldMetas =
              await (await DatabaseManager().getFrameworkDB()).allFieldMetas;

          if (requestType == RequestType.rqst) {
            StructureMetaData? structureMeta = structureMetas.firstWhereOrNull(
                (element) => element.structureName == entityName);
            if (structureMeta == null) {
              Logger.logError("ServerResponseHandler", "handleResponseData",
                  "Entity definition is not available in metadata.json");
              throw ("Entity definition is not available in metadata.json");
            }
            bool hasAtleastOneBe = await _checkAtleastOneBeAvailable(
                entityName, responseData, structureMeta);
            if (!hasAtleastOneBe) {
              String error =
                  "For Retuest type RQST, Response should contains atleast one Input Entity. But the response data does not contains Input Entity.";
              Logger.logError(
                  "ServerResponseHandler", "handleResponseData", error);
              InfoMessageData infoMessage = InfoMessageData(
                  lid: FrameworkHelper.getUUID(),
                  timestamp: DateTime.now().millisecondsSinceEpoch,
                  objectStatus: ObjectStatus.global.index,
                  syncStatus: SyncStatus.none.index,
                  type: "",
                  subtype: "",
                  category: InfoMessageFailure,
                  message: error,
                  bename: entityName,
                  belid: lid,
                  messagedetails: Uint8List(0));
              // await (await DatabaseManager().getFrameworkDB())
              //     .addInfoMessage(infoMessage);
              throw (error);
            }
          }

          // Handle Metadata Node
          bool metaDataDeleteFlag = false;
          List<dynamic> pullMessageMetaDataBENames = [];

          if (requestType == RequestType.pull) {
            // Get the deletion attribute to delete the data in the device that is not required after saving the PULL data
            if (metaData.isNotEmpty) {
              String? deletionRequiredFlag = metaData[KeyMetadataDelete];
              if (deletionRequiredFlag != null &&
                  deletionRequiredFlag.toLowerCase() == "true") {
                metaDataDeleteFlag = true;
              }
              if (metaData.isNotEmpty) {
                pullMessageMetaDataBENames = metaData[KeyBeName];
              }
            }
          }
          await fwDb.transaction(() async {
            await appDb.transaction(() async {
              for (dynamic beName in pullMessageMetaDataBENames) {
                BusinessEntityMetaData? currentBeMeta = beMetas
                    .firstWhereOrNull((element) => element.beName == beName);
                if (currentBeMeta == null) {
                  Logger.logError("ServerResponseHandler", "handleResponseData",
                      "There was an error while trying to get Business Entity Meta for BE: $beName");
                }
                StructureMetaData? currentHeaderStructureMeta =
                    structureMetas.firstWhereOrNull((element) =>
                        element.beName == beName && element.isHeader == "1");
                if (currentHeaderStructureMeta == null) {
                  Logger.logError("ServerResponseHandler", "handleResponseData",
                      "There was an error while trying to get Header Structure Meta for BE: $beName");
                }
                if (metaDataDeleteFlag) {
                  // Handle PULL_D and No Incoming BEs.
                  // If Server Wins, Delete all table data and insert.
                  // If Client Wins, Delete only unmodified records.
                  DatabaseManager appDbManager = DatabaseManager();
                  if (requestType == RequestType.pull &&
                      currentBeMeta!.conflictRules == ConflictModeServerWins) {
                    // Server Wins.
                    Logger.logInfo("ServerResponseHandler", "deleteTableData",
                        "Deleting the contents of ${currentHeaderStructureMeta!.structureName} table regardless of the state of the header.");
                    // [dataManager createSavepoint:@"DB_DELETE" error:&error]; // TODO: Check equivalent
                    // Get All Children for Table Name.
                    // Deleting the Children tables before the header fasters the deletion process.
                    List<String> childTables = structureMetas
                        .where((itemStruct) =>
                            itemStruct.beName ==
                                currentHeaderStructureMeta.beName &&
                            itemStruct.structureName !=
                                currentHeaderStructureMeta.structureName)
                        .map((e) => e.structureName)
                        .toList();
                    for (String childName in childTables) {
                      DBInputEntity childInput = DBInputEntity(childName, {});
                      await appDbManager.delete(childInput);
                    }
                    DBInputEntity parentInput = DBInputEntity(
                        currentHeaderStructureMeta.structureName, {});
                    await appDbManager.delete(parentInput);
                    // [dataManager releaseSavepoint:@"DB_DELETE" error:&error]; // TODO: Check equivalent
                  } else if (responseData.isEmpty ||
                      (requestType == RequestType.pull &&
                          currentBeMeta!.conflictRules !=
                              ConflictModeServerWins)) {
                    // Client Wins or No Incoming BEs.
                    Logger.logInfo(
                        "ServerResponseHandler",
                        "deleteUnmodifiedTableData",
                        "Deleting the contents of ${currentHeaderStructureMeta!.structureName} table whose header is in GLOBAL state.");

                    // [dataManager createSavepoint:@"DB_DELETE" error:&error]; // TODO: Check equivalent
                    DBInputEntity parentInput = DBInputEntity(
                        currentHeaderStructureMeta.structureName, {})
                      ..setWhereClause(
                          "$FieldObjectStatus = ${ObjectStatus.global.index}");
                    await appDbManager.delete(parentInput);
                    // [dataManager releaseSavepoint:@"DB_DELETE" error:&error]; // TODO: Check equivalent
                  }
                }
              }
            });
          });
          List<dynamic> conflictBEs = [];
          DatabaseManager appDatabaseManager = DatabaseManager();
          Iterable<String> responseDataKeys = responseData.keys;
          await fwDb.transaction(() async {
            await appDb.transaction(() async {
              for (String key in responseDataKeys) {
                dynamic value = responseData[key];
                BusinessEntityMetaData? currentBEMeta = beMetas
                    .firstWhereOrNull((element) => element.beName == key);
                Logger.logDebug("ServerResponseHandler", "handleResponseData",
                    "Processing BE META $currentBEMeta");
                if (currentBEMeta != null) {
                  StructureMetaData? currentHeaderStructureMeta =
                      structureMetas.firstWhereOrNull((element) =>
                          element.beName == key && element.isHeader == "1");
                  if (currentHeaderStructureMeta != null) {
                    Logger.logDebug(
                        "ServerResponseHandler",
                        "handleResponseData",
                        "Processing HEADER ${currentHeaderStructureMeta.structureName}");
                    List<dynamic> beValues = value;
                    int index = 0;
                    for (dynamic element in beValues) {
                      Map<String, dynamic> beObject = element;
                      Map<String, dynamic>? headerObject =
                          beObject[currentHeaderStructureMeta.structureName];

                      // Get Action String
                      String actionType = beObject[KeyActionAttribute];
                      beObject.remove(currentHeaderStructureMeta.structureName);
                      beObject.remove(KeyActionAttribute);

                      if (headerObject == null) {
                        Logger.logError(
                            "ServerResponseHandler",
                            "handleResponseData",
                            "Error while gettting Header for BE name: $key. Continuing with next BE.");
                        continue;
                      }
                      // Bind the data with the data in the database
                      Map<String, dynamic>? headerInDatabase;
                      try {
                        headerInDatabase = await checkDuplicateBe(
                            currentHeaderStructureMeta.structureName,
                            fieldMetas,
                            headerObject,
                            requestType!,
                            lid);
                      } catch (e) {
                        Logger.logError(
                            "ServerResponseHandler",
                            "handleResponseData",
                            "Error while checking for duplicate BE name: $key. Error : ${e.toString()}");
                      }

                      if (requestType != RequestType.pull) {
                        if (headerInDatabase != null) {
                          if (actionType == ActionTypeD) {
                            DBInputEntity dbInputEntity = DBInputEntity(
                                currentHeaderStructureMeta.structureName,
                                headerInDatabase);
                            await appDatabaseManager.delete(dbInputEntity);
                            int inboxCount = await Inbox().inboxCount();
                            int outboxCount = await Outbox().outboxCount();
                            int sentItemsCount =
                                await Outbox().sentItemsCount();
                            Map<String, dynamic> data = {
                              EventSyncStatusFieldType:
                                  EventSyncStatusTypeDeleted,
                              EventFieldData: headerInDatabase,
                              EventSyncStatusFieldInboxCount: inboxCount,
                              EventSyncStatusFieldOutboxCount: outboxCount,
                              EventSyncStatusFieldSentItemsCount: sentItemsCount
                            };
                            if ((isFromIsolate != null && isFromIsolate)) {
                              data[messageServiceType] = EventNameSyncStatus;
                              notifyDownloadMessage(data, map!);
                            } else {
                              DartNotificationCenter.post(
                                  channel: EventNameSyncStatus, options: data);
                            }
                            continue;
                          } else {
                            // If the data structure already exists in the db (based on GID) then copy its LID to the currentHeader object
                            // so that the technical primary field LID is same when the data is returned after parsing.
                            headerObject[FieldLid] = headerInDatabase[FieldLid];
                          }
                          try {
                            await fwDb.deleteInfoMessageByLid(
                                headerInDatabase[FieldLid]);
                          } catch (e) {
                            Logger.logError(
                                "ServerResponseHandler",
                                "handleResponseData",
                                "Error while deleting info message. Error: " +
                                    e.toString());
                          }
                        }
                      }

                      if (actionType != ActionTypeD) {
                        if (headerInDatabase == null) {
                          if (headerObject[FieldLid] == null) {
                            headerObject[FieldLid] = FrameworkHelper.getUUID();
                          }
                          processedHeaders.add({
                            EventFieldBeName:
                                currentHeaderStructureMeta.structureName,
                            EventFieldBeLid: headerObject[FieldLid]
                          });
                          Logger.logDebug(
                              "ServerResponseHandler",
                              "handleResponseData",
                              "Inserting BE DATA : ${currentHeaderStructureMeta.structureName} LID : ${headerObject[FieldLid]} ${index.toString()}");
                          index++;
                          await _insertIncomingBeData(
                              currentHeaderStructureMeta.structureName,
                              headerObject,
                              beObject);
                        } else {
                          Logger.logDebug(
                              "ServerResponseHandler",
                              "handleResponseData",
                              "Reconciling BE DATA : ${currentHeaderStructureMeta.structureName} LID : ${headerInDatabase[FieldLid]} ${index.toString()}");
                          index++;
                          processedHeaders.add({
                            EventFieldBeName:
                                currentHeaderStructureMeta.structureName,
                            EventFieldBeLid: headerObject[FieldLid]
                          });
                          if (requestType == RequestType.rqst &&
                              entityName ==
                                  currentHeaderStructureMeta.structureName) {
                            RequestResponseReconciler
                                requestResponseReconciler =
                                RequestResponseReconciler(
                                    currentHeaderStructureMeta.structureName,
                                    headerInDatabase,
                                    headerObject,
                                    beObject,
                                    currentBEMeta.conflictRules,
                                    isForeground);
                            bool status =
                                await requestResponseReconciler.reconcile(
                                    structureMetas,
                                    fieldMetas,
                                    requestType!,
                                    headerInDatabase[FieldLid]);
                            if (requestResponseReconciler
                                .getConflictBe()
                                .isNotEmpty) {
                              conflictBEs.add(
                                  requestResponseReconciler.getConflictBe());
                            }
                            if (!status) {
                              Logger.logError(
                                  "server_response_handler",
                                  "handleResponseData",
                                  "reconciliation failed. Updating header sync status to error. BE Name: $entityName, headerInDatabase: ${headerInDatabase.toString()}");
                              InfoMessageData infoMessageData =
                                  await _updateErrorStatusInHeaderAndCreateInfoMessage(
                                      entityName,
                                      headerInDatabase,
                                      InfoMessageFailure);
                              await (await DatabaseManager().getFrameworkDB())
                                  .addInfoMessage(infoMessageData);
                            }
                          } else {
                            PullPushQueryReconciler pullPushQueryReconciler =
                                PullPushQueryReconciler(
                                    currentHeaderStructureMeta.structureName,
                                    headerInDatabase,
                                    headerObject,
                                    beObject,
                                    currentBEMeta.conflictRules,
                                    index);
                            bool status =
                                await pullPushQueryReconciler.reconcile(
                                    structureMetas,
                                    fieldMetas,
                                    requestType!,
                                    headerInDatabase[FieldLid]);
                            if (!status) {
                              InfoMessageData infoMessageData =
                                  await _updateErrorStatusInHeaderAndCreateInfoMessage(
                                      entityName,
                                      headerInDatabase,
                                      InfoMessageFailure);
                              await (await DatabaseManager().getFrameworkDB())
                                  .addInfoMessage(infoMessageData);
                            }
                          }
                        }
                      }
                    }
                  }
                } else {
                  Logger.logDebug("ServerResponseHandler", "handleResponseData",
                      "BE which is not defined in metadata.json: $responseData");
                  processedHeaders.add(responseData);
                }
              }
            });
          });

          ConflictHandler? conflictHandler = SyncEngine().getConflictHandler();
          if (conflictHandler != null) {
            conflictHandler.handleConflict(conflictBEs);
          }
        }
        if (processedHeaders.length > 0 && !isForeground) {
          int inboxCount = await Inbox().inboxCount();
          int outboxCount = await Outbox().outboxCount();
          int sentItemsCount = await Outbox().sentItemsCount();
          if (inboxCount > 0) {
            // Current Processed inbox object will be removed after this call only. So, decrementing the inboxCount by 1.
            inboxCount -= 1;
          }
          Map<String, dynamic> data = {
            EventSyncStatusFieldType: EventSyncStatusTypeInbox,
            EventFieldData: processedHeaders,
            EventSyncStatusFieldInboxCount: inboxCount,
            EventSyncStatusFieldOutboxCount: outboxCount,
            EventSyncStatusFieldSentItemsCount: sentItemsCount
          };
          if ((isFromIsolate != null && isFromIsolate)) {
            data[messageServiceType] = EventNameSyncStatus;
            notifyDownloadMessage(data, map!);
          } else {
            DartNotificationCenter.post(
                channel: EventNameSyncStatus, options: data);
          }
        }
      } catch (e) {
        Logger.logError(
            "ServerResponseHandler", "checkDuplicateBe", e.toString());
      }
      if ((isFromIsolate == null || !isFromIsolate)) {
        await AttachmentDownloader().checkAndStartAttachmentService();
      }
    }
  }

  static Future<bool> _checkAtleastOneBeAvailable(
      String entityName,
      Map<String, dynamic> responseData,
      StructureMetaData structureMeta) async {
    if (responseData[structureMeta.beName] != null) {
      bool returnValue = false;
      List<dynamic> beValues = responseData[structureMeta.beName];
      for (Map<String, dynamic> data in beValues) {
        if (data[entityName] != null) {
          returnValue = true;
          break;
        }
      }
      // Map<String, dynamic>? inputBe =
      //     beValues.firstWhereOrNull((element) => element[entityName]);
      // if(inputBe!=null){
      //   return true;
      // }else{
      //   return false;
      // }
      return returnValue;
    }
    return false;
  }

  static Future<Map<String, dynamic>?> checkDuplicateBe(
      String tableName,
      List<FieldMetaData> fieldMetas,
      Map<String, dynamic> dataObj,
      RequestType requestType,
      String lid) async {
    if (fieldMetas.length == 0) {
      return null;
    }
    String whereClaues = "";
    if (requestType != RequestType.rqst) {
      List<String> gidFields = [];
      try {
        gidFields = fieldMetas
            .where((fMeta) =>
                fMeta.structureName == tableName && fMeta.isGid == "1")
            .map((e) => e.fieldName)
            .toList();
      } catch (e) {
        Logger.logError("ServerResponseHandler", "checkDuplicateBe",
            "Error while gettting GID fields. Error: $e");
      }
      for (String element in gidFields) {
        dynamic val = dataObj[element];
        if (val != null) {
          whereClaues += whereClaues.length == 0 ? "" : " AND ";
          whereClaues += "$element = '$val'";
        }
      }
    } else {
      if (tableName.endsWith("_HEADER")) {
        whereClaues = "$FieldLid = '$lid'";
      } else {
        List<String> gidFields = [];
        try {
          gidFields = fieldMetas
              .where((fMeta) =>
                  fMeta.structureName == tableName && fMeta.isGid == "1")
              .map((e) => e.fieldName)
              .toList();
        } catch (e) {
          Logger.logError("ServerResponseHandler", "checkDuplicateBe",
              "Error while gettting GID fields. Error: $e");
        }
        for (String element in gidFields) {
          dynamic val = dataObj[element];
          if (val != null) {
            whereClaues += whereClaues.length == 0 ? "" : " AND ";
            whereClaues += "$element = '$val'";
          }
        }
        whereClaues += whereClaues.length == 0 ? "" : " AND ";
        whereClaues += "$FieldFid = '$lid'";
      }
    }

    DBInputEntity inputEntity = DBInputEntity(tableName, {})
      ..setWhereClause(whereClaues);
    List<dynamic> result = await DatabaseManager().select(inputEntity);
    if (result.length > 0) {
      return result[0];
    }
    return null;
  }

  static _insertIncomingBeData(
      String entityName,
      Map<String, dynamic> incomingHeader,
      Map<String, dynamic> incomingItems) async {
    incomingHeader[FieldTimestamp] = FrameworkHelper.getTimeStamp();
    incomingHeader[FieldObjectStatus] = ObjectStatus.global.index;
    incomingHeader[FieldSyncStatus] = SyncStatus.none.index;
    DBInputEntity dbInputEntity = DBInputEntity(entityName, incomingHeader);
    try {
      await DatabaseManager().insert(dbInputEntity);
    } catch (e) {
      Logger.logError("server_response_handler", "_insertIncomingBeData",
          "Error while inserting incoming be. Error: ${e.toString()}");
      InfoMessageData infoMessageData =
          await _updateErrorStatusInHeaderAndCreateInfoMessage(
              entityName, incomingHeader, InfoMessageFailure);
      await (await DatabaseManager().getFrameworkDB())
          .addInfoMessage(infoMessageData);
      return;
    }
    Iterable<String> keys = incomingItems.keys;
    for (String key in keys) {
      List<dynamic> itemsArray = incomingItems[key];
      int index = 0;
      for (Map<String, dynamic> value in itemsArray) {
        // Insert All Incoming Items
        if (value[FieldLid] == null) {
          value[FieldLid] = FrameworkHelper.getUUID();
        }
        value[FieldFid] = incomingHeader[FieldLid];
        value[FieldTimestamp] = FrameworkHelper.getTimeStamp();
        value[FieldObjectStatus] = ObjectStatus.global.index;
        value[FieldSyncStatus] = SyncStatus.none.index;
        DBInputEntity dbInputEntity = DBInputEntity(key, value);
        Logger.logDebug("ServerResponseHandler", "handleResponseData",
            "Inserting BE ITEM : $key LID : ${value[FieldLid]} ${index.toString()}");

        try {
          await DatabaseManager().insert(dbInputEntity);
          if (key.endsWith(AttachmentBE)) {
            await AttachmentHelper.checkAttachmentAndQueueForAutoDownload(
                key, value);
          } else {}
        } catch (e) {
          Logger.logError("ServerResponseHandler", "handleResponseData",
              "Error while insering dbInputEntity. ERROR: ${e.toString()}");
          InfoMessageData infoMessageData =
              await _updateErrorStatusInHeaderAndCreateInfoMessage(
                  entityName, incomingHeader, InfoMessageFailure);
          await (await DatabaseManager().getFrameworkDB())
              .addInfoMessage(infoMessageData);
          return;
        }
        index++;
      }
    }
  }

  static Future<InfoMessageData> _updateErrorStatusInHeaderAndCreateInfoMessage(
      String entityName,
      Map<String, dynamic> header,
      String infoMsgCategory) async {
    String errorString =
        "Reconciliation failed. Rolling Back DB Operation of BE: $entityName.";

    Logger.logError("ServerResponseHandler",
        "_updateErrorStatusInHeaderAndCreateInfoMessage", errorString);

    String headerLid = header[FieldLid] ?? "";

    InfoMessageData infoMessage = InfoMessageData(
        lid: FrameworkHelper.getUUID(),
        timestamp: DateTime.now().millisecondsSinceEpoch,
        objectStatus: ObjectStatus.global.index,
        syncStatus: SyncStatus.none.index,
        type: "",
        subtype: "",
        category: InfoMessageFailure,
        message: errorString,
        bename: entityName,
        belid: headerLid,
        messagedetails: Uint8List(0));

    if (headerLid.length == 0) {
      return infoMessage;
    }

    // Update the incomingHeaderDataStructure with the Error Status.
    // 1.Update Header
    String query =
        "UPDATE $entityName SET $FieldSyncStatus = ${SyncStatus.error.index}, $FieldInfoMsgCat = '$infoMsgCategory' WHERE $FieldLid = '$headerLid'";
    try {
      await DatabaseManager().execute(query);
    } catch (e) {
      Logger.logError(
          "ServerResponseHandler",
          "_updateErrorStatusInHeaderAndCreateInfoMessage",
          "Error while updating header ($entityName) status into database. Error: $e");
    }

    // Update Children.
    // 2. Update all the Children with Status NONE
    List<StructureMetaData> allStructureMetas =
        await (await DatabaseManager().getFrameworkDB()).allStructureMetas;
    StructureMetaData? headerStructureMeta = allStructureMetas
        .firstWhereOrNull((element) => element.structureName == entityName);

    if (headerStructureMeta == null) {
      Logger.logError(
          "ServerResponseHandler",
          "_updateErrorStatusInHeaderAndCreateInfoMessage",
          "Error while getting header structure meta. Error: Structure meta for $entityName is not found.");
      return infoMessage;
    }

    try {
      List<StructureMetaData> childStructureMetas = allStructureMetas
          .where((element) =>
              element.beName == headerStructureMeta.beName &&
              element.isHeader != "1")
          .toList();

      for (StructureMetaData childStructureMeta in childStructureMetas) {
        // For Attachment Structure, do not change the status.
        if (!childStructureMeta.structureName.endsWith(AttachmentBE)) {
          String query =
              "UPDATE ${childStructureMeta.structureName} SET $FieldSyncStatus = ${SyncStatus.none.index} WHERE $FieldFid = '$headerLid'";
          try {
            await DatabaseManager().execute(query);
          } catch (e) {
            Logger.logError(
                "ServerResponseHandler",
                "_updateErrorStatusInHeaderAndCreateInfoMessage",
                "Error while Updating Children Data Structure : ${childStructureMeta.structureName}. Error: $e");
          }
        }
      }
    } catch (e) {
      Logger.logError(
          "ServerResponseHandler",
          "_updateErrorStatusInHeaderAndCreateInfoMessage",
          "Error while Fetching Children For Data Structure : $entityName. Error: $e");
    }
    return infoMessage;
  }

  static Future<void> _updateInfoMessageCategoryInHeader(
      String entityName, String headerLid, String infoMsgCategory) async {
    if (entityName.length == 0 || headerLid.length == 0) {
      return;
    }
    // Update the incomingHeaderDataStructure with the Error Status.
    // 1.Update Header
    String query =
        "UPDATE $entityName SET $FieldInfoMsgCat = '$infoMsgCategory' WHERE $FieldLid = '$headerLid'";
    try {
      await DatabaseManager().execute(query);
    } catch (e) {
      Logger.logError(
          "ServerResponseHandler",
          "_updateInfoMessageCategoryInHeader",
          "Error while updating header ($entityName) Info Message Category into database. Error: $e");
    }
  }
}
