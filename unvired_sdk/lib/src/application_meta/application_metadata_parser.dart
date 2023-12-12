import 'dart:convert';

import 'package:intl/intl.dart';

import '../application_meta/field_constants.dart';
import '../application_meta/index_meta.dart';
import '../database/framework_database.dart';
import '../helper/framework_helper.dart';

const ApplicationNameAttribute = "name";
const ApplicationDescriptionAttribute = "description";
const ApplicationVersionAttribute = "version";
const ApplicationClassNameAttribute = "applicationClassName";

// Meta Data
const String BeMetaData = "MetaData";
const String BeMetaDataDeleteAttribute = "delete";

// Business Entity
const String BeNode = "BusinessEntity";
const String Be = "BE";

const String BeDescriptionAttribute = "description";
const String BeAttachmentsAttribute = "attachments";
const String BeNameAttribute = "name";
const String BeFieldTextAttribute = "value";
const String BeVersionAttribute = "version";
const String BeAddFunctionAttribute = "addFunction";
const String BeModifyFunctionAttribute = "modifyFunction";
const String BeDeleteFunctionAttribute = "deleteFunction";
const String BeNotificationAttribute = "notification";
const String BeOnConflictAttribute = "onConflict";
const String BeSaveAttribute = "save";

const String BeActionAttribute = "action";

const String ConflictModeServerWins = "SERVER_WINS";
const String ConflictModeDeviceWins = "DEVICE_WINS";
const String ConflictModeAppHandled = "APP_HANDLED";

const String BeItemIndex = "index";
const String BeItemDescriptionAttribute = "description";
const String BeItemNameAttribute = "name";
const String BeItemClassNameAttribute = "className";
const String BeItemActionAttribute = "action";
const String BeItemIsHeader = "header";
const String BeItemIsAttachment = "attachment";

const String BeJsonFieldNode = "field";
const String BeJsonFieldNameNode = "name";
const String BeJsonFieldIsGid = "isGid";
const String BeJsonFieldLength = "length";
const String BeJsonFieldMandatory = "mandatory";
const String BeJsonFieldSqlType = "sqlType";
const String BeJsonFieldDescription = "description";

const String IndexNode = "Index";
const String IndexName = "name";
const String IndexFields = "Fields";
const String IndexTableName = "tableName";

class ApplicationMetaDataParser {
  late String _appName;
  late ApplicationMetaData _applicationMeta;
  late List<BusinessEntityMetaData> _businessEntityMetas;
  late List<StructureMetaData> _structureMetas;
  late List<FieldMetaData> _fieldMetas;
  late List<IndexMeta> _indexMetas;
  late String _metadataJSON;

  static final ApplicationMetaDataParser _applicationMetaDataParser =
      ApplicationMetaDataParser._internal();
  ApplicationMetaDataParser._internal();
  factory ApplicationMetaDataParser() {
    return _applicationMetaDataParser;
  }

  init(String jsonString) async {
    _appName = "";
    //_applicationMeta = ApplicationMetaData(lid: "", timestamp: 0, objectStatus: 0, syncStatus: 0, appId: "", appName: "", description: "", version: "", installationDate: "", appClassName: "");
    _businessEntityMetas = [];
    _structureMetas = [];
    _fieldMetas = [];
    _indexMetas = [];
    _metadataJSON = jsonString;
    await _parse();
  }

  ApplicationMetaData getApplicationMeta() {
    return _applicationMeta;
  }

  List<BusinessEntityMetaData> getBusinessEntityMetas() {
    return _businessEntityMetas;
  }

  List<StructureMetaData> getStructureMetas() {
    return _structureMetas;
  }

  List<FieldMetaData> getFieldMetas() {
    return _fieldMetas;
  }

  List<IndexMeta> getIndexMetas() {
    return _indexMetas;
  }

  Future<void> _parse() async {
    Map<String, dynamic> jsonData = jsonDecode(_metadataJSON);
    if (jsonData == null) {
      return;
    }
    _appName = jsonData[ApplicationNameAttribute];

    // Parse Application Meta
    // ApplicationMetaData applicationMeta =  await compute(parseApplicationMeta,_metadataJSON);
    // _applicationMeta =applicationMeta;

    String applicationDescription =
        jsonData[ApplicationDescriptionAttribute] ?? "";
    String applicationVersion = jsonData[ApplicationVersionAttribute];
    String applicationClassName = jsonData[ApplicationClassNameAttribute] ?? "";
    DateTime currentDate = DateTime.now();
    DateFormat formatter = DateFormat('MMMM dd, yyyy hh:mm:ss aa');
    _applicationMeta = ApplicationMetaData(
        lid: FrameworkHelper.getUUID(),
        timestamp: DateTime.now().millisecondsSinceEpoch,
        objectStatus: ObjectStatus.global.index,
        syncStatus: SyncStatus.none.index,
        appClassName: applicationClassName,
        appId: "",
        appName: _appName,
        description: applicationDescription,
        version: applicationVersion,
        installationDate: formatter.format(currentDate));

    Iterable<String> jsonDataKeys = jsonData.keys;
    for (String key in jsonDataKeys) {
      dynamic value = jsonData[key];
      if (key != ApplicationNameAttribute &&
          key != ApplicationDescriptionAttribute &&
          key != ApplicationVersionAttribute) {
        String beName = key;
        if (key == IndexNode) {
          // Parse Index Meta
          for (Map<String, dynamic> index in value) {
            String name = index[IndexName];
            String structureName = index[IndexTableName];
            List<String> fieldNames = index[IndexFields];
            IndexMeta indexMeta = IndexMeta();
            indexMeta
              ..setIndexName(name)
              ..setStructureName(structureName)
              ..setFieldName(fieldNames);
            _indexMetas.add(indexMeta);
          }
        } else if (!(value is List)) {
          // Parse Business Entity Meta
          String beDesc = value[BeDescriptionAttribute] ?? "";

          bool saveAttributeValue = value[BeSaveAttribute] ?? false;

          String saveAttribute = saveAttributeValue ? "true" : "false";

          String? conflictRule = value[BeOnConflictAttribute];
          if (conflictRule == null || conflictRule.length == 0) {
            conflictRule = ConflictModeServerWins;
          }

          bool isAttachmentRequired = value[BeAttachmentsAttribute] ?? false;

          BusinessEntityMetaData businessEntityMeta = BusinessEntityMetaData(
              lid: FrameworkHelper.getUUID(),
              timestamp: DateTime.now().millisecondsSinceEpoch,
              objectStatus: ObjectStatus.global.index,
              syncStatus: SyncStatus.none.index,
              appName: _appName,
              beName: beName,
              description: beDesc,
              addFunction: "",
              modifyFunction: "",
              deleteFunction: "",
              notification: "",
              attachments: isAttachmentRequired ? "1" : "0",
              conflictRules: conflictRule,
              save: saveAttribute);
          _businessEntityMetas.add(businessEntityMeta);

          // Parse Structure Meta
          dynamic beJSON = value;
          Iterable<String> beJSONKeys = beJSON.keys;
          for (String key2 in beJSONKeys) {
            dynamic value2 = beJSON[key2];
            if (key2 != BeDescriptionAttribute &&
                key2 != BeSaveAttribute &&
                key2 != BeOnConflictAttribute &&
                key2 != BeAttachmentsAttribute) {
              String structureName = key2;
              if (!(value2 is List)) {
                String structureDesc = value2[BeItemDescriptionAttribute] ?? "";
                String className = value2[BeItemClassNameAttribute];
                bool isHeader = value2[BeItemIsHeader] ?? false;

                StructureMetaData structureMeta = StructureMetaData(
                    lid: FrameworkHelper.getUUID(),
                    timestamp: DateTime.now().millisecondsSinceEpoch,
                    objectStatus: ObjectStatus.global.index,
                    syncStatus: SyncStatus.none.index,
                    structureName: structureName,
                    description: structureDesc,
                    className: className,
                    isHeader: isHeader ? "1" : "0",
                    appName: _appName,
                    beName: beName);

                _structureMetas.add(structureMeta);

                // Parse Field Meta
                List<dynamic> fields = value2[BeJsonFieldNode];
                for (Map<String, dynamic> field in fields) {
                  String name = field[BeJsonFieldNameNode];
                  String description = field[BeJsonFieldDescription] ?? "";
                  String fieldType = field[BeJsonFieldSqlType];
                  bool isGID = field[BeJsonFieldIsGid] ?? false;
                  bool isMandatory = field[BeJsonFieldMandatory] ?? false;
                  int length = 0;
                  try {
                    String len = field[BeJsonFieldLength] ?? "";
                    length = int.parse(len);
                  } catch (e) {}

                  FieldMetaData fieldMeta = FieldMetaData(
                      lid: FrameworkHelper.getUUID(),
                      timestamp: DateTime.now().millisecondsSinceEpoch,
                      objectStatus: ObjectStatus.global.index,
                      syncStatus: SyncStatus.none.index,
                      appName: _appName,
                      beName: beName,
                      structureName: structureName,
                      fieldName: name,
                      description: description,
                      length: length.toString(),
                      mandatory: isMandatory ? "1" : "0",
                      sqlType: fieldType,
                      isGid: isGID ? "1" : "0");
                  _fieldMetas.add(fieldMeta);
                }
              }
            }
          }
        }
      }
    }
  }

  static Future<ApplicationMetaData> parseApplicationMeta(String data) async {
    Map<String, dynamic> jsonData = jsonDecode(data);
    String _appName = jsonData[ApplicationNameAttribute];
    String applicationDescription =
        jsonData[ApplicationDescriptionAttribute] ?? "";
    String applicationVersion = jsonData[ApplicationVersionAttribute];
    String applicationClassName = jsonData[ApplicationClassNameAttribute] ?? "";
    DateTime currentDate = DateTime.now();
    DateFormat formatter = DateFormat('MMMM dd, yyyy hh:mm:ss aa');
    return ApplicationMetaData(
        lid: FrameworkHelper.getUUID(),
        timestamp: DateTime.now().millisecondsSinceEpoch,
        objectStatus: ObjectStatus.global.index,
        syncStatus: SyncStatus.none.index,
        appClassName: applicationClassName,
        appId: "",
        appName: _appName,
        description: applicationDescription,
        version: applicationVersion,
        installationDate: formatter.format(currentDate));
  }
}
