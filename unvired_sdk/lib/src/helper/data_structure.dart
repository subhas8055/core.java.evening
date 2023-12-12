import 'package:unvired_sdk/unvired_sdk.dart';

import '../application_meta/field_constants.dart';

class DataStructure {
  String lid = FrameworkHelper.getUUID();
  String? fid;
  String? hasConflicts;
  int? timeStamp;
  SyncStatus syncStatus = SyncStatus.none;
  ObjectStatus objectStatus = ObjectStatus.global;
  String? tableName;
  String? infoMsgCat;
}
