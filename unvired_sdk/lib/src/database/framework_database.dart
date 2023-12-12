import 'package:logger/logger.dart';
import 'package:drift/drift.dart';
import 'package:collection/collection.dart';

import '../application_meta/field_constants.dart';
import '../database/database_manager.dart';
import '../helper/framework_helper.dart';
import '../helper/getmessage_timer_manager.dart';

export 'shared.dart';

part 'framework_database.g.dart';

class ApplicationMeta extends Table {
  TextColumn get lid => text()();

  IntColumn get timestamp => integer()();

  IntColumn get objectStatus => integer()();

  IntColumn get syncStatus => integer()();

  TextColumn get appId => text()();

  TextColumn get appName => text()();

  TextColumn get description => text()();

  TextColumn get version => text()();

  TextColumn get installationDate => text()();

  TextColumn get appClassName => text()();

  @override
  Set<Column> get primaryKey => {lid};

  @override
  List<String> get customConstraints => ['UNIQUE (app_name)'];
}

class BusinessEntityMeta extends Table {
  TextColumn get lid => text()();

  IntColumn get timestamp => integer()();

  IntColumn get objectStatus => integer()();

  IntColumn get syncStatus => integer()();

  TextColumn get appName => text()();

  TextColumn get beName => text()();

  TextColumn get description => text()();

  TextColumn get addFunction => text()();

  TextColumn get modifyFunction => text()();

  TextColumn get deleteFunction => text()();

  TextColumn get notification => text()();

  TextColumn get attachments => text()();

  TextColumn get conflictRules => text()();

  TextColumn get save => text()();

  @override
  Set<Column> get primaryKey => {lid};

  @override
  List<String> get customConstraints => ['UNIQUE (app_name, be_name)'];
}

class StructureMeta extends Table {
  TextColumn get lid => text()();

  IntColumn get timestamp => integer()();

  IntColumn get objectStatus => integer()();

  IntColumn get syncStatus => integer()();

  TextColumn get appName => text()();

  TextColumn get beName => text()();

  TextColumn get structureName => text()();

  TextColumn get description => text()();

  TextColumn get className => text()();

  TextColumn get isHeader => text()();

  @override
  Set<Column> get primaryKey => {lid};

  @override
  List<String> get customConstraints =>
      ['UNIQUE (app_name, be_name, structure_name)'];
}

class FieldMeta extends Table {
  TextColumn get lid => text()();

  IntColumn get timestamp => integer()();

  IntColumn get objectStatus => integer()();

  IntColumn get syncStatus => integer()();

  TextColumn get appName => text()();

  TextColumn get beName => text()();

  TextColumn get structureName => text()();

  TextColumn get fieldName => text()();

  TextColumn get description => text()();

  TextColumn get length => text()();

  TextColumn get mandatory => text()();

  TextColumn get sqlType => text()();

  TextColumn get isGid => text()();

  @override
  Set<Column> get primaryKey => {lid};

  @override
  List<String> get customConstraints =>
      ['UNIQUE (app_name, be_name, structure_name, field_name)'];
}

class Settings extends Table {
  TextColumn get lid => text()();

  IntColumn get timestamp => integer()();

  IntColumn get objectStatus => integer()();

  IntColumn get syncStatus => integer()();

  TextColumn get fieldName => text()();

  TextColumn get fieldValue => text()();

  @override
  Set<Column> get primaryKey => {lid};

  @override
  List<String> get customConstraints => ['UNIQUE (field_name)'];
}

class FrameworkSettings extends Table {
  TextColumn get lid => text()();

  IntColumn get timestamp => integer()();

  IntColumn get objectStatus => integer()();

  IntColumn get syncStatus => integer()();

  TextColumn get fieldName => text()();

  TextColumn get fieldValue => text()();

  @override
  Set<Column> get primaryKey => {lid};

  @override
  List<String> get customConstraints => ['UNIQUE (field_name)'];
}

class MobileUserSettings extends Table {
  TextColumn get lid => text()();

  IntColumn get timestamp => integer()();

  IntColumn get objectStatus => integer()();

  IntColumn get syncStatus => integer()();

  TextColumn get keyName => text()();

  TextColumn get description => text()();

  TextColumn get defaultField => text()();

  TextColumn get current => text()();

  TextColumn get mandatory => text()();

  TextColumn get secure => text()();

  @override
  Set<Column> get primaryKey => {lid};

  @override
  List<String> get customConstraints => ['UNIQUE (lid)'];
}

class InfoMessage extends Table {
  TextColumn get lid =>
      text().withDefault(Constant("${FrameworkHelper.getUUID()}"))();

  IntColumn get timestamp =>
      integer().withDefault(Constant(DateTime.now().millisecondsSinceEpoch))();

  IntColumn get objectStatus =>
      integer().withDefault(Constant(ObjectStatus.global.index))();

  IntColumn get syncStatus =>
      integer().withDefault(Constant(SyncStatus.none.index))();

  TextColumn get type => text()();

  TextColumn get subtype => text()();

  TextColumn get category => text()();

  TextColumn get message => text()();

  TextColumn get bename => text()();

  TextColumn get belid => text()();

  BlobColumn get messagedetails => blob()();

  @override
  Set<Column> get primaryKey => {lid};

  @override
  List<String> get customConstraints => ['UNIQUE (lid)'];
}

class ConflictBE extends Table {
  TextColumn get lid =>
      text().withDefault(Constant("${FrameworkHelper.getUUID()}"))();

  IntColumn get timestamp =>
      integer().withDefault(Constant(DateTime.now().millisecondsSinceEpoch))();

  IntColumn get objectStatus =>
      integer().withDefault(Constant(ObjectStatus.global.index))();

  IntColumn get syncStatus =>
      integer().withDefault(Constant(SyncStatus.none.index))();

  TextColumn get beName => text()();

  TextColumn get beHeaderLid => text()();

  TextColumn get data => text()();

  @override
  Set<Column> get primaryKey => {lid};

  @override
  List<String> get customConstraints => ['UNIQUE (lid)'];
}

class InObject extends Table {
  TextColumn get lid =>
      text().withDefault(Constant("${FrameworkHelper.getUUID()}"))();

  IntColumn get timestamp =>
      integer().withDefault(Constant(DateTime.now().millisecondsSinceEpoch))();

  IntColumn get objectStatus =>
      integer().withDefault(Constant(ObjectStatus.global.index))();

  IntColumn get syncStatus =>
      integer().withDefault(Constant(SyncStatus.none.index))();

  TextColumn get conversationId => text()();

  IntColumn get subtype => integer()();

  IntColumn get type => integer()();

  TextColumn get appId => text()();

  TextColumn get serverId => text()();

  TextColumn get appName => text()();

  TextColumn get requestType => text()();

  TextColumn get jsonData => text()();

  TextColumn get beLid => text()();


  @override
  Set<Column> get primaryKey => {lid, conversationId};

  @override
  List<String> get customConstraints => ['UNIQUE (conversation_id)'];
}

class OutObject extends Table {
  TextColumn get lid =>
      text().clientDefault(() => "${FrameworkHelper.getUUID()}")();

  IntColumn get timestamp =>
      integer().clientDefault(() => DateTime.now().millisecondsSinceEpoch)();

  IntColumn get objectStatus =>
      integer().clientDefault(() => ObjectStatus.global.index)();

  IntColumn get syncStatus =>
      integer().clientDefault(() => SyncStatus.none.index)();

  TextColumn get functionName => text()();

  TextColumn get beName => text()();

  TextColumn get beHeaderLid => text()();

  TextColumn get requestType => text()();

  TextColumn get syncType => text()();

  TextColumn get conversationId => text()();

  TextColumn get messageJson => text()();

  TextColumn get companyNameSpace => text()();

  TextColumn get sendStatus => text()();

  TextColumn get fieldOutObjectStatus => text()();

  BoolColumn get isAdminServices => boolean()();

  @override
  Set<Column> get primaryKey => {lid};

  @override
  List<String> get customConstraints => ['UNIQUE (lid)'];
}

class SentItems extends Table {
  TextColumn get lid =>
      text().clientDefault(() => "${FrameworkHelper.getUUID()}")();

  IntColumn get timestamp =>
      integer().clientDefault(() => DateTime.now().millisecondsSinceEpoch)();

  IntColumn get objectStatus =>
      integer().clientDefault(() => ObjectStatus.global.index)();

  IntColumn get syncStatus =>
      integer().clientDefault(() => SyncStatus.none.index)();

  TextColumn get beName => text()();

  TextColumn get beHeaderLid => text()();

  TextColumn get conversationId => text()();

  TextColumn get entryDate => text()();

  TextColumn get attachmentFlag => text()();

  @override
  Set<Column> get primaryKey => {lid};

  @override
  List<String> get customConstraints => ['UNIQUE (conversation_id)'];
}

class AttachmentQObject extends Table {
  TextColumn get lid =>
      text().withDefault(Constant("${FrameworkHelper.getUUID()}"))();

  IntColumn get timestamp =>
      integer().withDefault(Constant(DateTime.now().millisecondsSinceEpoch))();

  IntColumn get objectStatus =>
      integer().withDefault(Constant(ObjectStatus.global.index))();

  IntColumn get syncStatus =>
      integer().withDefault(Constant(SyncStatus.none.index))();

  TextColumn get uid => text()();

  TextColumn get beName => text()();

  TextColumn get beHeaderName => text()();

  TextColumn get beAttachmentStructName => text()();

  IntColumn get priority => integer()();

  IntColumn get timeStamp => integer()();

  @override
  Set<Column> get primaryKey => {uid};

  @override
  List<String> get customConstraints => ['UNIQUE (uid)'];
}

class SystemCredentials extends Table {
  TextColumn get lid =>
      text().withDefault(Constant("${FrameworkHelper.getUUID()}"))();

  IntColumn get timestamp =>
      integer().withDefault(Constant(DateTime.now().millisecondsSinceEpoch))();

  IntColumn get objectStatus =>
      integer().withDefault(Constant(ObjectStatus.global.index))();

  IntColumn get syncStatus =>
      integer().withDefault(Constant(SyncStatus.none.index))();

  TextColumn get name => text()();

  TextColumn get portName => text()();

  TextColumn get portType => text()();

  TextColumn get portDesc => text()();

  TextColumn get systemDesc => text()();

  TextColumn get userId => text()();

  TextColumn get password => text()();

  @override
  Set<Column> get primaryKey => {lid};

  @override
  List<String> get customConstraints => ['UNIQUE (port_name)'];
}

@DriftDatabase(tables: [
  ApplicationMeta,
  StructureMeta,
  BusinessEntityMeta,
  FieldMeta,
  Settings,
  FrameworkSettings,
  MobileUserSettings,
  InfoMessage,
  OutObject,
  ConflictBE,
  InObject,
  SentItems,
  AttachmentQObject,
  SystemCredentials
])
class FrameworkDatabase extends _$FrameworkDatabase {
  FrameworkDatabase(QueryExecutor e) : super(e);

  FrameworkDatabase.connect(DatabaseConnection connection)
      : super.connect(connection);

  @override
  int get schemaVersion => 2;

  Future<void> deleteDataForUpgrade() async{
    await deleteAllInfoMessages();
    await deleteAllFieldMetas();
    await deleteAllBEMetas();
    await deleteAllStructureMetas();
    await deleteAllApplicationMeta();
    await deleteAllInObjects();
    await deleteAllSentItems();
  }

  Future<int> addApplicationMeta(ApplicationMetaData entry) async {
    return await transaction(() => into(applicationMeta).insert(entry));
  }

  Future<int> addBusinessEntityMeta(BusinessEntityMetaData entry) async {
    return await transaction(() => into(businessEntityMeta).insert(entry));
  }

  Future<int> addStructureMeta(StructureMetaData entry) async {
    return await transaction(() => into(structureMeta).insert(entry));
  }

  Future<int> addFieldMeta(FieldMetaData entry) async {
    return await transaction(() => into(fieldMeta).insert(entry));
  }

  Future<int> addFrameworkSetting(FrameworkSetting entry) async {
    return await transaction(() => into(frameworkSettings).insert(entry));
  }

  Future<bool> updateFrameworkSetting(FrameworkSetting entry) async {
    return await transaction(() => update(frameworkSettings).replace(entry));
  }

  Future<int> addSetting(Setting entry) async {
    return await transaction(() => into(settings).insert(entry));
  }

  Future<int> addInfoMessage(InfoMessageData entry) async {
    return await transaction(() => into(infoMessage).insert(entry));
  }

  Future<int> addOutObject(OutObjectData entry) async {
    return await transaction(() => into(outObject).insert(entry));
  }

  Future<int> deleteOutObject(OutObjectData entry) async {
    return await transaction(() =>
        (delete(outObject)..where((tbl) => tbl.lid.equals(entry.lid))).go());
  }

  Future<bool> updateOutObject(OutObjectData entry) async {
    return await transaction(() => update(outObject).replace(entry));
  }

  Future<OutObjectData?> getOutObjectFromLid(String lid) async {
    return (await allOutObjects)
        .firstWhereOrNull((element) => element.lid == lid);
  }

  Future<OutObjectData?> getOutObjectFromBeLid(String beLid) async {
    return (await allOutObjects)
        .firstWhereOrNull((element) => element.beHeaderLid == beLid);
  }

  Future<int> addSentItem(SentItem entry) async {
    int result =
    await transaction(() async => await into(sentItems).insert(entry));
    FrameworkDatabase? frameworkDatabase =
    await DatabaseManager().getFrameworkDB();
    List<StructureMetaData> structureMetas =
    await frameworkDatabase.allStructureMetas;
    StructureMetaData? structureMeta = structureMetas
        .firstWhereOrNull((element) => element.structureName == entry.beName);
    if (structureMeta == null) {
      Logger.logError("ServerResponseHandler", "addSentItem",
          "There was an error while trying to get Header Structure Meta for BE: ${entry.beName}");
    }
    List beHeaderData = await DatabaseManager().select(
        DBInputEntity(entry.beName, {})
          ..setWhereClause("$FieldLid = '${entry.beHeaderLid}'"));

    for (var header in beHeaderData) {
      header[FieldSyncStatus] = SyncStatus.sent.index;
      (await DatabaseManager().update(DBInputEntity(entry.beName, header)));
    }
    String whereClause = "$FieldFid='${entry.beHeaderLid}'";
    List<String> childTables = structureMetas
        .where((itemStruct) =>
    itemStruct.beName == structureMeta!.beName &&
        itemStruct.structureName != structureMeta.structureName)
        .map((e) => e.structureName)
        .toList();
    for (String childName in childTables) {
      List beChildData = await DatabaseManager()
          .select(DBInputEntity(childName, {})..setWhereClause(whereClause));
      for (var childData in beChildData) {
        if(childData[FieldObjectStatus].toString() == ObjectStatus.add.index.toString() ||
            childData[FieldObjectStatus].toString() == ObjectStatus.modify.index.toString() ||
            childData[FieldObjectStatus].toString() == ObjectStatus.delete.index.toString()){
          childData[FieldSyncStatus] = SyncStatus.sent.index;
          (await DatabaseManager().update(DBInputEntity(childName, childData)));
        }
      }
    }
    GetMessageTimerManager().startTimer();
    return result;
  }

  Future<SentItem?> getSentItemFromLid(String lid) async {
    return (await allSentItems)
        .firstWhereOrNull((element) => element.lid == lid);
  }

  Future<SentItem?> getSentItemFromConvId(String convId) async {
    return await transaction(() async => (await allSentItems)
        .firstWhereOrNull((element) => element.conversationId == convId));
  }

  Future<bool> isInSentItems(String beHeaderLid) async {
    List<SentItem> sentItems = await allSentItems;
    SentItem? sentItem = sentItems.firstWhereOrNull(
            (element) => element.beHeaderLid == beHeaderLid);
    return sentItem != null;
  }


  Future<bool> updateSetting(Setting entry) async {
    return await transaction(() => update(settings).replace(entry));
  }

  Future<int> addConflictBe(ConflictBEData entry) async {
    return await transaction(() => into(conflictBE).insert(entry));
  }

  Future<int> addInObject(InObjectData entry) async {
    return await transaction(() => into(inObject).insert(entry));
  }

  Future<int> deleteInObject(String convId) async {
    return await transaction(() async => await (delete(inObject)
      ..where((tbl) => tbl.conversationId.equals(convId)))
        .go());
  }

  Future<int> deleteSentItem(String conversationId) async {
    return await transaction(() async => await (delete(sentItems)
      ..where((tbl) => tbl.conversationId.equals(conversationId)))
        .go());
  }

  Future<int> deleteAllInfoMessages() async {
    return await transaction(() async => await delete(infoMessage).go());
  }


  Future<int> deleteAllApplicationMeta() async {
    return await transaction(() async => await delete(applicationMeta).go());
  }

  Future<int> deleteAllFieldMetas() async {
    return await transaction(() async => await delete(fieldMeta).go());
  }

  Future<int> deleteAllBEMetas() async {
    return await transaction(() async => await delete(businessEntityMeta).go());
  }

  Future<int> deleteAllStructureMetas() async {
    return await transaction(() async => await delete(structureMeta).go());
  }

  Future<int> deleteAllInObjects() async {
    return await transaction(() async => await delete(inObject).go());
  }

  Future<int> deleteAllSentItems() async {
    return await transaction(() async => await delete(sentItems).go());
  }

  Future<int> deleteAllOutObjects() async {
    return await transaction(() async => await delete(outObject).go());
  }

  Future<int> addAttachmentQObject(AttachmentQObjectData entry) async {
    return await transaction(() async => await into(attachmentQObject).insert(entry));
  }

  Future<int> deleteAttachmentQObject(String uid) async {
    return await transaction(() async => await (delete(attachmentQObject)
      ..where((tbl) => tbl.uid.equals(uid)))
        .go());
  }

  Future<int> deleteAllAttachmentQObjects() async {
    return await transaction(() async => await delete(attachmentQObject).go());
  }

  Future<int> addSystemCredential(SystemCredential entry) async {
    return await transaction(() async => await into(systemCredentials).insert(entry));
  }

  Future<bool> updateSystemCredential(SystemCredential entry) async {
    return await transaction(() => update(systemCredentials).replace(entry));
  }

  Future<List<ApplicationMetaData>> get allApplicationMetas =>
      select(applicationMeta).get();

  Future<List<BusinessEntityMetaData>> get allBusinessEntityMetas =>
      select(businessEntityMeta).get();

  Future<List<StructureMetaData>> get allStructureMetas =>
      select(structureMeta).get();

  Future<List<FieldMetaData>> get allFieldMetas => select(fieldMeta).get();

  Future<List<FrameworkSetting>> get allFrameworkSettings =>
      select(frameworkSettings).get();

  Future<List<OutObjectData>> get allOutObjects => select(outObject).get();

  Future<List<SentItem>> get allSentItems => select(sentItems).get();

  Future<FrameworkSetting?> getFrameworkSetting(String fieldName) async {
    return await transaction(() async => (await allFrameworkSettings)
        .firstWhereOrNull((element) => element.fieldName == fieldName));
  }

  Future<List<Setting>> get allSettings => select(settings).get();

  Future<Setting?> getSetting(String fieldName) async {
    return await transaction(() async => (await allSettings)
        .firstWhereOrNull((element) => element.fieldName == fieldName));
  }

  Future<List<InfoMessageData>> get allInfoMessages =>
      select(infoMessage).get();

  Future<InfoMessageData?> getInfoMessage(String lid) async {
    return await transaction(() async => (await allInfoMessages)
        .firstWhereOrNull((element) => element.lid == lid));
  }

  Future<List<InfoMessageData?>> getInfoMessageByBeLid(String beLid) async {
    return await transaction(() async => (await allInfoMessages)
        .where((element) => element.belid == beLid).toList());
  }

  Future<List<InfoMessageData>> getInfoMessageByBeName(String beName) async {
    return await transaction(() async => (await allInfoMessages)
        .where((element) => element.bename == beName).toList());
  }

  Future<int> deleteInfoMessageByLid(String lid) async {
    return await transaction(() async => await (delete(infoMessage)
      ..where((tbl) => tbl.lid.equals(lid)))
        .go());
  }

  Future<int> deleteInfoMessageByBeLid(String beLid) async {
    return await transaction(() async => await (delete(infoMessage)
      ..where((tbl) => tbl.belid.equals(beLid)))
        .go());
  }

  Future<int> deleteInfoMessageByBeName(String beName) async {
    return await transaction(() async => await (delete(infoMessage)
      ..where((tbl) => tbl.bename.equals(beName)))
        .go());
  }

  Future<BusinessEntityMetaData?> getBusinessEntityMetaFromBeName(
      String entityName) async {
    return await transaction(() async => (await allBusinessEntityMetas)
        .firstWhereOrNull((element) => element.beName == entityName));
  }

  Future<StructureMetaData?> getStructureMetaFromBeName(
      String entityName) async {
    return await transaction(() async => (await allStructureMetas)
        .firstWhereOrNull((element) =>
    (element.beName == entityName && element.isHeader == "1")));
  }

  Future<List<InObjectData>> get allInObjects => select(inObject).get();

  Future<List<AttachmentQObjectData>> get allAttachmentQObjects =>
      select(attachmentQObject).get();

  Future<List<SystemCredential>> get allSystemCredentials =>
      select(systemCredentials).get();

// Future<void> addMultipleStructureMetas(
//     List<STRUCTURE_METACompanion> items) async {
//   await batch((batch) {
//     batch.insertAll(structureMeta, items);
//   });
// }
}
