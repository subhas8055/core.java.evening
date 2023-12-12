const String FrameworkVersionNumber = "0.0.83";
const String FrameworkBuildNumber = "95";
const String FrameworkRevisionNumber = "";
const String FrameworkRevisionUrl = "";

const String ApplicationRevisionNumber = "99.99";

// Header Constants
const String HeaderConstantConversationId = "X-UNVIRED-CONVERSATION-ID";
const String HeaderConstantRequestType = "REQUEST_TYPE";
const String HeaderConstantNumberOfPendingMessages =
    "X-UNVIRED-NUMBER-OF-PENDING-MESSAGES";

// Send Logs/Data api params
const String ParamCompanyNamespace = "COMPANY_NAMESPACE";
const String ParamCompanyAlias = "COMPANY_ALIAS";
const String ParamAction = "ACTION";
const String ParamJwtToken = "JWT_TOKEN";
const String ParamOneTimeLoginToken = "X-ONE-TIME-LOGIN-TOKEN";
const String ParamApplication = "APPLICATION";
const String ParamAttachmentGuid = "X_ATTACHMENT_GUID";
const String ParamMimeType = "MIME_TYPE";
const String ParamServerId = "SERVER_ID";
const String ParamServerUserId = "MUSID";
const String ParamFeUserId = "FEUSERID";
const String ParamPassword = "PWD";
const String ParamOneTimeToken = "onetimetoken";
const String ParamMessageTime = "messagetime";
const String ParamLoginType = "LOGIN_TYPE";
const String ParamDeviceType = "DEVICE_TYPE";
const String ParamAppVersion = "cltAppVer";
const String ParamFrameworkVersion = "cltFwkVer";
const String ParamDeviceOsVersion = "devOS";
const String ParamDeviceModel = "devModel";
const String ParamDeviceState = "X-DEVICE-STATE";

// Send Logs/Data api ACTION param values
const String ActionUploadLogs = "UPLOAD_LOG";
const String ActionUploadData = "UPLOAD_DATA";

// endpoints
const String ServiceApiVersion = "API/v2/";
const String ServiceSession = "session";
const String ServiceApplications = "applications";
const String ServiceActivate = "activate";
const String ServiceLocal = "?local";
const String ServiceExecute = "execute";
const String ServiceMessage = "message";
const String ServiceAttachments = "attachments";
const String ServiceAttachment = "attachment";
const String ServiceAdminServices = "adminservices";
const String ServicePasswordLess = "passwordless";
const String ServiceStatus = "status";

const String AdminServicePing = "ping";
const String AdminServiceTestNotif = "testnotify";
const String AdminServiceInitialDownload = "initialdownload";
const String AdminServiceAuthBackend = "authbackend";

// route
const String ServiceFrontendUsers = "frontendusers";
const String ServiceConversation = "conversation";
const String ServiceMessages = "messages";

// Query Params
const String QueryParamFrontendUser = "frontendUser";
const String QueryParamInputMessage = "inputMessage";
const String QueryParamMessageFormat = "messageFormat";
const String QueryParamQueuedExecute = "queuedExecute";
const String QueryParamExternalReference = "externalReference";
const String QueryParamRequestType = "requestType";
const String QueryParamFile = "file";
const String QueryParamSensitive = "sensitive";
const String QueryParamCredentials = "credentials";

// Message Types
const String MessageTypeStandard = "standard";
const String MessageTypeCustom = "custom";

const String LoginTypeUnviredId = "UNVIRED-USER";
const String LoginTypeSAP = "SAP";
const String LoginTypeEmail = "EMAIL";
const String LoginTypeADS = "ACTIVE-DIRECTORY";
// const String LoginTypeLDAP = "LDAP";
const String LoginTypeCustom = "CUSTOM";
// const String LoginTypeSAML2 = "SAML2";

// Session Api response keys
const String KeyUnviredId = "unviredId";
const String KeyUnviredMd5Pwd = "md5Pwd";
const String KeySessionId = "sessionId";
const String KeyUsers = "users";
const String KeyFrontendType = "frontendType";
const String KeyApplications = "applications";
const String KeyName = "name";
const String KeyError = "error";
const String KeyToken = "token";
const String KeySettings = "settings";
const String KeyLocation = "location";
const String KeyLocationTracking = "tracking";
const String KeyLocationInterval = "interval";
const String KeyLocationUploadInterval = "uploadInterval";
const String KeyLocationDays = "days";
const String KeyLocationStart = "start";
const String KeyLocationEnd = "end";
const String KeySystems = "systems";
const String KeySystemsName = "name";
const String KeySystemsPortName = "portName";
const String KeySystemsPortType = "portType";
const String KeySystemsPortDesc = "portDescr";
const String KeySystemsDesc = "systemDescr";

// PA response keys
const String KeyMeta = "Meta";
const String KeyActionAttribute = "a";
const String KeyMetadataDelete = "d";
const String KeyBeName = "BEName";
const String KeyInfoMessage = "InfoMessage";

// Info Message Keys
const String KeyInfoMessageType = "type";
const String KeyInfoMessageSubtype = "subtype";
const String KeyInfoMessageCategory = "category";
const String KeyInfoMessageMessage = "message";
const String KeyInfoMessageBeName = "bename";
const String KeyInfoMessageBeLid = "belid";
const String KeyInfoMessageMessageDetails = "messagedetails";

// PA response header key
const String KeyJwtToken = "jwttoken";

// Attachment response keys
const String KeyAttachmentResponse = "AttachmentResponse";
const String KeyMessage = "message";

// Action Type
const String ActionTypeA = "A";
const String ActionTypeM = "M";
const String ActionTypeD = "D";

// Attachment
const String AttachmentBE = "_ATTACHMENT";

// Attachment Status
const String AttachmentStatusDefault = "DEFAULT";
const String AttachmentStatusQueuedForDownload = "QUEUED_FOR_DOWNLOAD";
const String AttachmentStatusDownloaded = "DOWNLOADED";
const String AttachmentStatusErrorInDownload = "ERROR_IN_DOWNLOAD";
const String AttachmentStatusSavedForUpload = "SAVED_FOR_UPLOAD";
const String AttachmentStatusUploaded = "UPLOADED";
const String AttachmentStatusErrorInUpload = "ERROR_IN_UPLOAD";
const String AttachmentStatusMarkedForDelete = "MARKED_FOR_DELETE";
const int FwAttachmentForceDownloadPriority = 1;
const int FwAttachmentAutoDownloadPriority = 2;

// Attachment Item Fields
const String AttachmentItemFieldUid = "UID";
const String AttachmentItemFieldMimeType = "MIME_TYPE";
const String AttachmentItemFieldFileName = "FILE_NAME";
const String AttachmentItemFieldDescription = "DESCRIPTION";
const String AttachmentItemFieldUrl = "URL";
const String AttachmentItemFieldExternalUrl = "EXTERNAL_URL";
const String AttachmentItemFieldLocalPath = "LOCAL_PATH";
const String AttachmentItemFieldAutoDownload = "AUTO_DOWNLOAD";
const String AttachmentItemFieldAttachmentStatus = "ATTACHMENT_STATUS";
const String AttachmentItemFieldErrorMessage = "ERROR_MESSAGE";
const String AttachmentItemFieldMessage = "MESSAGE";

const String Type = "type";
const String Subtype = "subtype";
const String ServerId = "serverId";
const String ApplicationId = "applicationId";
const String AppName = "appName";

/**
 * Messages for the application.
 */
const int MESSAGE_TYPE_APPLICATION = 8000;
/**
 * Messages for the system / framework.
 */
const int MESSAGE_TYPE_SYSTEM = 9000;
/**
 * Message to clear all the data in the application.
 */
const int MESSAGE_TYPE_WIPE = 5000;
/**
 * Messages for authentication.
 */
const int MESSAGE_TYPE_AUTHENTICATION = 4000;

const int MESSAGE_SUBTYPE_SYSTEM_PING = 100;
const int MESSAGE_SUBTYPE_SYSTEM_LOG = 200;
const int MESSAGE_SUBTYPE_SYSTEM_LOG_RESET = 210;
const int MESSAGE_SUBTYPE_SYSTEM_LOG_SET_ERROR = 220;
const int MESSAGE_SUBTYPE_SYSTEM_LOG_SET_DEBUG = 230;
const int MESSAGE_SUBTYPE_SYSTEM_DATA_DUMP = 300;
const int MESSAGE_SUBTYPE_SYSTEM_INITIAL_DATA = 400;
const int MESSAGE_SUBTYPE_SYSTEM_APPLICATION_ASSIGN = 410;
const int MESSAGE_SUBTYPE_SYSTEM_APPLICATION_UNASSIGN = 430;
const int MESSAGE_SUBTYPE_SYSTEM_FRAMEWORK_SETTINGS = 500;
const int MESSAGE_SUBTYPE_SYSTEM_RESET_DATA = 700;
const int MESSAGE_SUBTYPE_SYSTEM_ACTIVATION = 800;
const int MESSAGE_SUBTYPE_SYSTEM_MULTIPLE_FRONTEND_USERS = 810;
const int MESSAGE_SUBTYPE_SYSTEM_ERROR = 900;
const int MESSAGE_SUBTYPE_SYSTEM_INFO = 1000;
const int MESSAGE_SUBTYPE_SYSTEM_INITIATE_PULL = 440;
const int MESSAGE_SUBTYPE_SYSTEM_PULL_COMPLETE = 450;
const int MESSAGE_SUBTYPE_SYSTEM_SEND_PUSH_NOTIFICATION_ID = 610;

const int MESSAGE_SUBTYPE_AUTHENTICATION = 100;
const int MESSAGE_SUBTYPE_AUTHENTICATION_AND_ACTIVATE = 200;
const int MESSAGE_SUBTYPE_SAP_AUTHENTICATE = 300;
const int MESSAGE_SUBTYPE_CHANGE_PASSWORD = 400;
const int MESSAGE_SUBTYPE_FORGOT_PASSWORD = 500;
const int MESSAGE_SUBTYPE_REGISTER_USER = 600;
const int MESSAGE_SUBTYPE_GET_LOGIN_TOKEN = 700;

const int MESSAGE_SUBTYPE_APPLICATION_USER_SETTNGS_UPDATE = 625;
const int MESSAGE_SUBTYPE_LOCATION_INFORMATION = 1100;
const int MESSAGE_SUBTYPE_CHECK_FOR_APP_UPGRADE = 1300;
const int MESSAGE_SUBTYPE_TEST_PUSH = 110;

const String logError = "ERROR";
const String logDebug = "DEBUG";
const String logImportant = "IMPORTANT";

//Network connections
const String online = "Online";
const String offline = "Offline";

//DB types
enum DbType { appDb, fwDb, backupDb }

//PlatformType
enum PlatformType { ios, android, web, linux, windows, fuchsia, macOs }

enum DeviceInfoType {
  androidPhone,
  androidTablet,
  iPhone,
  iPad,
  windowsDesktop,
  windowsTab,
  linux,
  macOs,
  webDesktop,
  webPhone,
  webTab,
  fuchsia
}

enum ScreenInfoSize { smallPhone, phone, tab, largeTab, desktop }

enum DeviceType { phone, tab, desktop }
