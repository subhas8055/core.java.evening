const String FieldLid = "LID";
const String FieldFid = "FID";
const String FieldConflict = "HAS_CONFLICT";
const String FieldTimestamp = "TIMESTAMP";
const String FieldSyncStatus = "SYNC_STATUS";
const String FieldObjectStatus = "OBJECT_STATUS";
const String FieldTableName = "TABLE_NAME";
const String FieldInfoMsgCat = "INFO_MSG_CAT";

const String FieldTypeLid = "Text";
const String FieldTypeFid = "Text";
const String FieldTypeConflict = "Text";
const String FieldTypeTimestamp = "Integer";
const String FieldTypeSyncStatus = "Integer";
const String FieldTypeObjectStatus = "Integer";
const String FieldTypeInfoMsgCat = "Text";

const String FieldInfoMessageCategory = "category";
const String FieldInfoMessageMessage = "message";

const String InfoMessageFailure = "FAILURE";
const String InfoMessageFailureAndProcess = "FAILURE_N_PROCESS";
const String InfoMessageWarning = "WARNING";
const String InfoMessageInfo = "INFO";
const String InfoMessageSuccess = "SUCCESS";

const String driftNoElement =
    "No element"; // Returned as an exception message from drift when no row is present in the table

const String InfoMessageError = "FAILURE";

const String yes = "YES";

const String messageServiceType = "message_service_type";

enum ObjectStatus { global, add, modify, delete }

enum SyncStatus { none, queued, sent, error }
