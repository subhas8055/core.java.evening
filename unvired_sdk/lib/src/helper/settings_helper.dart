import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:unvired_sdk/src/helper/getmessage_timer_manager.dart';

import '../application_meta/field_constants.dart';
import '../authentication_service.dart';
import '../database/database_helper.dart';
import '../database/database_manager.dart';
import '../database/framework_database.dart';
import '../helper/framework_helper.dart';
import '../helper/framework_settings_manager.dart';
import '../helper/http_connection.dart';
import '../helper/path_manager.dart';
import '../helper/service_constants.dart';
import '../helper/user_settings_manager.dart';
import '../inbox/inbox.dart';
import '../outbox/outbox.dart';
import '../outbox/outbox_helper.dart';
import '../sync_engine.dart';
import '../unvired_account.dart';
import 'status.dart';

class SettingsHelper {
  /// Get Framework version number.
  ///
  /// **@return** A String value of Framework Version Number.
  ///
  /// **Usage:**
  /// ```dart
  ///   String fwVersionNumber = SettingsHelper().getFrameworkVersionNumber();
  /// ```
  String getFrameworkVersionNumber() {
    return FrameworkVersionNumber;
  }

  /// Get Framework build number.
  ///
  /// **@return** A String value of Framework build number.
  ///
  /// **Usage:**
  /// ```dart
  ///   String fwBuildNumber = SettingsHelper().getFrameworkBuildNumber();
  /// ```
  String getFrameworkBuildNumber() {
    return FrameworkBuildNumber;
  }

  /// Get App name.
  ///
  /// **@return** A String value of App Name.
  ///
  /// **Usage:**
  /// ```dart
  ///   String appName = SettingsHelper().getApplicationName();
  /// ```
  String getApplicationName() {
    return AuthenticationService().getAppName();
  }

  /// Get App version number.
  ///
  /// **@return** A String value of App Version Number.
  ///
  /// **@throw** If an error occurs, throws the error information.
  ///
  /// **Usage:**
  /// ```dart
  ///   try {
  ///     String appVersionNumber = await SettingsHelper().getApplicationVersionNumber();
  ///   } catch (e) {
  ///   }
  /// ```
  Future<String> getApplicationVersionNumber() async {
    if (Platform.isWindows) {
      return "";
    } else {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.version;
    }
  }

  /// Get Framework revision number.
  ///
  /// **@return** A String value of Framework revision Number.
  ///
  /// **Usage:**
  /// ```dart
  ///   String fwRevisionNumber = SettingsHelper().getFrameworkRevisionNumber();
  /// ```
  String getFrameworkRevisionNumber() {
    return FrameworkRevisionNumber;
  }

  /// Get App revision number.
  ///
  /// **@return** A String value of App revision Number.
  ///
  /// **Usage:**
  /// ```dart
  ///   String appRevisionNumber = SettingsHelper().getFrameworkVersionNumber();
  /// ```
  String getApplicationRevisionNumber() {
    return ApplicationRevisionNumber;
  }

  /// Get App revision number.
  ///
  /// **@return** A String value of App revision Number.
  ///
  /// **@throw** If an error occurs, throws the error information.
  ///
  /// **Usage:**
  /// ```dart
  ///   try {
  ///     String appDbVersion = await SettingsHelper().getApplicationDBVersion();
  ///   } catch (e) {
  ///   }
  /// ```
  Future<String> getApplicationDBVersion() async {
    FrameworkDatabase frameworkDatabase =
        await DatabaseManager().getFrameworkDB();
    List<ApplicationMetaData> allAppMetas =
        await frameworkDatabase.allApplicationMetas;
    if (allAppMetas.length == 0) {
      return "";
    }
    return allAppMetas[0].version;
  }

  /// Get App build number.
  ///
  /// **@return** A String value of App build Number.
  ///
  /// **@throw** If an error occurs, throws the error information.
  ///
  /// **Usage:**
  /// ```dart
  ///   try {
  ///     String appBuildNumber = await SettingsHelper().getApplicationBuildNumber();
  ///   } catch (e) {
  ///   }
  /// ```
  Future<String> getApplicationBuildNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.buildNumber;
  }

  /// Get Count of Inbox Items.
  ///
  /// **@return** An integer value of Inbox Items count.
  ///
  /// **@throw** If an error occurs, throws the error information.
  ///
  /// **Usage:**
  /// ```dart
  ///   try {
  ///     int inboxCount = await SettingsHelper().getInboxCount();
  ///   } catch (e) {
  ///   }
  /// ```
  Future<int> getInboxCount() async {
    return await Inbox().inboxCount();
  }

  /// Get Count of Outbox Items.
  ///
  /// **@return** An integer value of Outbox Items count.
  ///
  /// **@throw** If an error occurs, throws the error information.
  ///
  /// **Usage:**
  /// ```dart
  ///   try {
  ///     int outboxCount = await SettingsHelper().getOutboxCount();
  ///   } catch (e) {
  ///   }
  /// ```
  Future<int> getOutboxCount() async {
    return await Outbox().outboxCount();
  }

  /// Get Count of Sent Items.
  ///
  /// **@return** An integer value of Sent Items count.
  ///
  /// **@throw** If an error occurs, throws the error information.
  ///
  /// **Usage:**
  /// ```dart
  ///   try {
  ///     int sentItemsCount = await SettingsHelper().getSentItemsCount();
  ///   } catch (e) {
  ///   }
  /// ```
  Future<int> getSentItemsCount() async {
    return await Outbox().sentItemsCount();
  }

  /// Get Count of Attachment Items.
  ///
  /// **@return** An integer value of Attachment Items count.
  ///
  /// **@throw** If an error occurs, throws the error information.
  ///
  /// **Usage:**
  /// ```dart
  ///   try {
  ///     int attachmentsCount = await SettingsHelper().getAttachmentCount();
  ///   } catch (e) {
  ///   }
  /// ```
  Future<int> getAttachmentCount() async {
    FrameworkDatabase fwDb = await DatabaseManager().getFrameworkDB();
    return (await fwDb.allAttachmentQObjects).length;
  }

  /// Check if HeaderLid is in queue.
  ///
  /// **@return** a bool value.
  ///
  /// **@throw** If an error occurs, throws the error information.
  ///
  /// **Usage:**
  /// ```dart
  ///   try {
  ///     int attachmentsCount = await SettingsHelper().isInOutBoxQueue();
  ///   } catch (e) {
  ///   }
  /// ```
  Future<bool> isInOutBoxQueue(beHeaderLid) async {
    return (await Outbox().isInQueue(beHeaderLid));
  }

  /// Check if HeaderLid is in sent items.
  ///
  /// **@return** a bool value.
  ///
  /// **@throw** If an error occurs, throws the error information.
  ///
  /// **Usage:**
  /// ```dart
  ///   try {
  ///     int attachmentsCount = await SettingsHelper().isInSentItems();
  ///   } catch (e) {
  ///   }
  /// ```
  Future<bool> isInSentItems(beHeaderLid) async {
    FrameworkDatabase fwDb = await DatabaseManager().getFrameworkDB();
    return (await fwDb.isInSentItems(beHeaderLid));
  }

  /// Sends the complete log informations to the server.
  ///
  /// **Usage:**
  /// ```dart
  ///   try {
  ///     await SettingsHelper().sendLogsToServer();
  ///   } catch (e) {
  ///   }
  /// ```
  Future<void> sendLogsToServer() async {
    String userId =
        (await AuthenticationService().getSelectedAccount())!.getUserId();
    String uploadLogFilePath = await PathManager.getUploadLogFilePath(userId);
    File uploadFile = File(uploadLogFilePath);
    if (!uploadFile.existsSync()) {
      uploadFile.createSync(recursive: true);
    }

    // 1. Duplicate the existing Log File
    String fileUrl = await Logger.getLogFileURL();
    File file = File(fileUrl);
    await file.copy(uploadLogFilePath);

    // 2. Append Additional Info like Inbox / Outbox count to the log file.
    File uploadLogFile = File(uploadLogFilePath);
    String additionalMessages = await _getAdditionalInfo();
    await uploadLogFile.writeAsString(additionalMessages,
        mode: FileMode.append);

    // 3. Zip the Log file
    String appFolder = await PathManager.getApplicationPath(userId);
    String zipPath = appFolder + "/" + UploadLogZip;
    var encoder = ZipFileEncoder();
    encoder.create(zipPath);
    encoder.addFile(uploadLogFile);
    encoder.close();

    // 4. Delete the Log copy file which produced the Zip file
    try {
      if (uploadLogFile.existsSync()) {
        uploadLogFile.deleteSync();
      }
    } catch (e) {
      Logger.logError("SettingsHelper", "sendLogsToServer",
          "Error while deleteing $UploadLogFileName. Error: $e");
    }

    // 5. Send the Zip file as an attachment
    http.StreamedResponse response =
        await HTTPConnection.uploadLogOrData(zipPath, ActionUploadLogs);
    if (response.statusCode == Status.httpOk) {
      // 6. Delete the Zip file
      try {
        File uploadedZip = File(zipPath);
        if (uploadedZip.existsSync()) {
          uploadedZip.deleteSync();
        }
      } catch (e) {
        Logger.logError("SettingsHelper", "sendLogsToServer",
            "Error while deleteing $UploadLogZip. Error: $e");
      }
    }
    return;
  }

  /// Get the complete log informations as Zip file.
  ///
  /// **@return** A String value of log zip file path.
  ///
  /// **@throw** If an error occurs, throws the error information.
  ///
  /// **Usage:**
  /// ```dart
  ///   try {
  ///     String logZipFilePath = await SettingsHelper().createAndGetLogZipPath();
  ///   } catch (e) {
  ///   }
  /// ```
  Future<String> createAndGetLogZipPath() async {
    String userId =
        (await AuthenticationService().getSelectedAccount())!.getUserId();
    String uploadLogFilePath = await PathManager.getUploadLogFilePath(userId);
    File uploadFile = File(uploadLogFilePath);
    if (!uploadFile.existsSync()) {
      uploadFile.createSync(recursive: true);
    }

    // 1. Duplicate the existing Log File
    String fileUrl = await Logger.getLogFileURL();
    File file = File(fileUrl);
    await file.copy(uploadLogFilePath);

    // 2. Append Additional Info like Inbox / Outbox count to the log file.
    File uploadLogFile = File(uploadLogFilePath);
    String additionalMessages = await _getAdditionalInfo();
    await uploadLogFile.writeAsString(additionalMessages,
        mode: FileMode.append);

    // 3. Zip the Log file
    String appFolder = await PathManager.getApplicationPath(userId);
    String zipPath = appFolder + "/" + UploadLogZip;
    var encoder = ZipFileEncoder();
    encoder.create(zipPath);
    encoder.addFile(uploadLogFile);
    encoder.close();

    return zipPath;
  }

  /// Sends the Application database to the server.
  ///
  /// **@throw** If an error occurs, throws the error information.
  ///
  /// **Usage:**
  /// ```dart
  ///   try {
  ///     await SettingsHelper().sendAppDbToServer();
  ///   } catch (e) {
  ///   }
  /// ```
  Future<void> sendAppDbToServer() async {
    return await DatabaseHelper.exportAppDatabaseAndSendToServer();
  }

  Future<void> deleteLogs() async {
    return (await Logger.deleteLogs());
  }

  /// Initiate the request to server for downloading initial customization data.
  ///
  /// **@throw** If an error occurs, throws the error information.
  ///
  /// **@param** [functions]
  ///     List of JSON Object which will have the key `name` and value as name of the function, `input` and value as input for the function.
  ///     Note: `name` is a string and `input` is a json object. If there is no input for the function, sent `input` value as null.
  ///     Format: [{"name": your_function_name, "input": null}]
  ///
  /// **Usage:**
  /// ```dart
  ///   try {
  ///     await SettingsHelper().requestInitialDataDownload();
  ///   } catch (e) {
  ///   }
  /// ```
  Future<void> requestInitialDataDownload(
      {List<Map<String, dynamic>> functions = const []}) async {
    String comanyAlias = await FrameworkSettingsManager()
        .getFieldValue(FrameworkSettingsFields.companyAlias);
    String serverId = await FrameworkSettingsManager()
        .getFieldValue(FrameworkSettingsFields.serverId);
    String applicationId = await FrameworkSettingsManager()
        .getFieldValue(FrameworkSettingsFields.applicationId);
    String namespace = await FrameworkSettingsManager()
        .getFieldValue(FrameworkSettingsFields.namespace);
    Map<String, dynamic> dataObject = {
      EnumToString.convertToString(FrameworkSettingsFields.companyAlias):
          comanyAlias,
      EnumToString.convertToString(FrameworkSettingsFields.serverId): serverId,
      EnumToString.convertToString(FrameworkSettingsFields.applicationId):
          applicationId,
      EnumToString.convertToString(FrameworkSettingsFields.namespace):
          namespace,
      "applicationName": AuthenticationService().getAppName(),
      "type": 9000,
      "subtype": 400,
      "functions": functions
    };

    String dataString = dataObject.isEmpty ? "" : jsonEncode(dataObject);
    String inputString =
        "$AdminServiceInitialDownload?$QueryParamInputMessage=$dataString";
    OutObjectData outObjectData = OutObjectData(
        lid: FrameworkHelper.getUUID(),
        timestamp: DateTime.now().millisecondsSinceEpoch,
        objectStatus: ObjectStatus.global.index,
        syncStatus: SyncStatus.none.index,
        functionName: AdminServiceInitialDownload,
        beName: "",
        beHeaderLid: "",
        requestType: "",
        syncType: SyncType.SYNC.toString(),
        conversationId: "",
        messageJson: inputString,
        companyNameSpace: "",
        sendStatus: "",
        fieldOutObjectStatus: OutObjectStatus.none.index.toString(),
        isAdminServices: true);

    try {
      FrameworkDatabase fwDb = await DatabaseManager().getFrameworkDB();
      await fwDb.addOutObject(outObjectData);
      await OutBoxHelper().checkOutboxAndStartService();
    } catch (e) {
      throw (e);
    }
  }

  /// Test the push notification.
  ///
  /// **@throw** If an error occurs, throws the error information.
  ///
  /// **Usage:**
  /// ```dart
  ///   try {
  ///     await SettingsHelper().testPushNotification();
  ///   } catch (e) {
  ///   }
  /// ```
  Future<void> testPushNotification() async {
    try {
      UnviredAccount? account =
          await AuthenticationService().getSelectedAccount();

      await HTTPConnection.makeAdminServicesCall(AdminServiceTestNotif +
          "?$QueryParamFrontendUser=${account!.getFrontendId()}");
    } catch (e) {
      throw e;
    }
  }

  /// Get the complete log string with additional informations.
  ///
  /// **@return** A String value of logs and additional information.
  ///
  /// **@throw** If an error occurs, throws the error information.
  ///
  /// **Usage:**
  /// ```dart
  ///   try {
  ///     String logString = await SettingsHelper().getCompleteLogs();
  ///   } catch (e) {
  ///   }
  /// ```
  Future<String> getCompleteLogs() async {
    String logString = await Logger.getLogs();
    // Append Additional Info like Inbox / Outbox count to the log file.
    String additionalMessages = await _getAdditionalInfo();
    return logString + additionalMessages;
  }

  /// Get Info Messages stored in the database.
  ///
  /// **@return** A List of InfoMessageData object.
  ///
  /// **@throw** If an error occurs, throws the error information.
  ///
  /// **Usage:**
  /// ```dart
  ///   try {
  ///     List<InfoMessageData> infoMessages = await SettingsHelper().getInfoMessages();
  ///   } catch (e) {
  ///   }
  /// ```
  Future<List<InfoMessageData>> getInfoMessages() async {
    FrameworkDatabase fwDb = await DatabaseManager().getFrameworkDB();
    return await fwDb.allInfoMessages;
  }

  /// Set http rest api request timeout.
  ///
  /// **@throw** If an error occurs, throws the error information.
  ///
  /// **@param** [timeInMinutes]
  ///           Request timeout number in minutes.
  ///
  /// **Usage:**
  /// ```dart
  ///   try {
  ///     await SettingsHelper().setRequestTimeout(2);
  ///   } catch (e) {
  ///   }
  /// ```
  Future<void> setRequestTimeout(int timeInMinutes) async {
    Logger.logDebug("SettingsHelper", "setRequestTimeout",
        "Request Timeout: $timeInMinutes");
    UserSettingsManager()
        .setFieldValue(UserSettingsFields.requestTimeout, timeInMinutes);
  }

  /// Get http rest api request timeout.
  ///
  /// **@return** A integer value of http rest api request timeout.
  ///
  /// **@throw** If an error occurs, throws the error information.
  ///
  /// **Usage:**
  /// ```dart
  ///   try {
  ///     int requestTimeout = await SettingsHelper().getRequestTimeout();
  ///   } catch (e) {
  ///   }
  /// ```
  Future<int> getRequestTimeout() async {
    String timeInMinutes = await UserSettingsManager()
        .getFieldValue(UserSettingsFields.requestTimeout);
    Logger.logDebug("SettingsHelper", "getRequestTimeout",
        "Request Timeout String: $timeInMinutes");
    if (timeInMinutes.isEmpty) {
      return 0;
    }
    return int.parse(timeInMinutes);
  }

  /// Set log level for logger to write the log type.
  ///
  /// **@throw** If an error occurs, throws the error information.
  ///
  /// **@param** [loglevel]
  ///            String value to set the Log Level.
  ///            Valid inputs: "Important", "Error", "Debug"
  ///
  /// **Usage:**
  /// ```dart
  ///   try {
  ///     await SettingsHelper().setLogLevel("Debug");
  ///   } catch (e) {
  ///   }
  /// ```
  Future<void> setLogLevel(String loglevel) async {
    Logger.logDebug("SettingsHelper", "setLogLevel", "logLevel: $loglevel");
    String logNumber = "";
    switch (loglevel) {
      case logImportant:
      case "7":
        logNumber = "7";
        Logger.setLogLevel(LogLevel.important);
        break;
      case logError:
      case "8":
        logNumber = "8";
        Logger.setLogLevel(LogLevel.error);
        break;
      case logDebug:
      case "9":
        logNumber = "9";
        Logger.setLogLevel(LogLevel.debug);
        break;
      default:
    }
    FrameworkSettingsManager()
        .setFieldValue(FrameworkSettingsFields.logLevel, logNumber);
  }

  /// Get current log level.
  ///
  /// **@return** A string value of log level.
  ///
  /// **@throw** If an error occurs, throws the error information.
  ///
  /// **Usage:**
  /// ```dart
  ///   try {
  ///     String logLevel = await SettingsHelper().getLogLevel(); // Valid result: "Important", "Error", "Debug"
  ///   } catch (e) {
  ///   }
  /// ```
  Future<String> getLogLevel() async {
    String logLevel = await FrameworkSettingsManager()
        .getFieldValue(FrameworkSettingsFields.logLevel);
    Logger.logDebug("SettingsHelper", "getLogLevel", "logLevel: $logLevel");
    switch (logLevel) {
      case "7":
        Logger.setLogLevel(LogLevel.important);
        return logImportant;
      case "8":
        Logger.setLogLevel(LogLevel.error);
        return logError;
      case "9":
        Logger.setLogLevel(LogLevel.debug);
        return logDebug;
      default:
    }
    return "";
  }

  /// Get logged in username.
  ///
  /// **@return** A string value of username.
  ///
  /// **@throw** If an error occurs, throws the error information.
  ///
  /// **Usage:**
  /// ```dart
  ///   try {
  ///     String userName = await SettingsHelper().getUserName();
  ///   } catch (e) {
  ///   }
  /// ```
  Future<String> getUserName() async {
    UnviredAccount? _selectedAccount =
        await AuthenticationService().getSelectedAccount();
    String username;
    if (_selectedAccount!.getLoginType() == LoginType.sap ||
        _selectedAccount.getLoginType() == LoginType.ads ||
        kIsWeb) {
      username = _selectedAccount.getUnviredUser();
    } else {
      username = await FrameworkSettingsManager()
          .getFieldValue(FrameworkSettingsFields.unviredUser);
    }

    Logger.logDebug("SettingsHelper", "getUserName", "UserName: $username");
    return username;
  }

  /// Get UMP url.
  ///
  /// **@return** A string value of UMP url.
  ///
  /// **@throw** If an error occurs, throws the error information.
  ///
  /// **Usage:**
  /// ```dart
  ///   try {
  ///     String url = await SettingsHelper().getUrl();
  ///   } catch (e) {
  ///   }
  /// ```
  Future<String> getUrl() async {
    String url = await FrameworkSettingsManager()
        .getFieldValue(FrameworkSettingsFields.url);
    Logger.logDebug("SettingsHelper", "getUrl", "Url: $url");
    return url;
  }

  /// Get server type which is received on user activation call.
  ///
  /// **@return** A string value of server type``.
  ///
  /// **@throw** If an error occurs, throws the error information.
  ///
  /// **Usage:**
  /// ```dart
  ///   try {
  ///     String serverType = await SettingsHelper().getServerType();
  ///   } catch (e) {
  ///   }
  /// ```
  Future<String> getServerType() async {
    String serverType = await FrameworkSettingsManager()
        .getFieldValue(FrameworkSettingsFields.serverType);
    Logger.logDebug(
        "SettingsHelper", "getServerType", "ServerType: $serverType");
    return serverType;
  }

  /// Server id which is received from server during user activation api call.
  ///
  /// **@return** A string value of Server id.
  ///
  /// **@throw** If an error occurs, throws the error information.
  ///
  /// **Usage:**
  /// ```dart
  ///   try {
  ///     String serverId = await SettingsHelper().getServerId();
  ///   } catch (e) {
  ///   }
  /// ```
  Future<String> getServerId() async {
    String serverId = await FrameworkSettingsManager()
        .getFieldValue(FrameworkSettingsFields.serverId);
    Logger.logDebug("SettingsHelper", "getServerId", "ServerId: $serverId");
    return serverId;
  }

  /// Read current user login type. Eg: ADS
  ///
  /// **@return** A string value of login module type.
  ///
  /// **@throw** If an error occurs, throws the error information.
  ///
  /// **Usage:**
  /// ```dart
  ///   try {
  ///     String loginType = await SettingsHelper().getLoginModule();
  ///   } catch (e) {
  ///   }
  /// ```
  Future<String> getLoginModule() async {
    UnviredAccount? selectedAccount =
        await AuthenticationService().getSelectedAccount();
    if (selectedAccount != null && selectedAccount.getLoginType() != null) {
      Logger.logDebug("SettingsHelper", "getLoginModule",
          "Login Type: ${selectedAccount.getLoginType()}");
      return EnumToString.convertToString(selectedAccount.getLoginType());
    }
    return "";
  }

  /// Activation id for the current device which is received from server.
  ///
  /// **@return** A string value of Activation id.
  ///
  /// **@throw** If an error occurs, throws the error information.
  ///
  /// **Usage:**
  /// ```dart
  ///   try {
  ///     String activationId = await SettingsHelper().getActivationId();
  ///   } catch (e) {
  ///   }
  /// ```
  Future<String> getActivationId() async {
    String activationId = await FrameworkSettingsManager()
        .getFieldValue(FrameworkSettingsFields.activationId);
    Logger.logDebug(
        "SettingsHelper", "getActivationId", "Activation Id: $activationId");
    return activationId;
  }

  /// Read the device id.
  ///
  /// **@return** A string value of device id.
  ///
  /// **@throw** If an error occurs, throws the error information.
  ///
  /// **Usage:**
  /// ```dart
  ///   try {
  ///     String deviceId = await SettingsHelper().getDeviceId();
  ///   } catch (e) {
  ///   }
  /// ```
  Future<String> getDeviceId() async {
    String deviceId = await FrameworkSettingsManager()
        .getFieldValue(FrameworkSettingsFields.frontendId);
    Logger.logDebug("SettingsHelper", "getDeviceId", "DeviceId: $deviceId");
    return deviceId;
  }

  /// Read the type of the current device. For example: iPad.
  ///
  /// **@return** A string value of device type.
  ///
  /// **@throw** If an error occurs, throws the error information.
  ///
  /// **Usage:**
  /// ```dart
  ///   try {
  ///     String deviceType = await SettingsHelper().getDeviceType();
  ///   } catch (e) {
  ///   }
  /// ```
  Future<String> getDeviceType() async {
    String deviceType = await FrameworkSettingsManager()
        .getFieldValue(FrameworkSettingsFields.frontendType);
    Logger.logDebug(
        "SettingsHelper", "getDeviceType", "DeviceType: $deviceType");
    return deviceType;
  }

  /// Read the security level which is recieved from the server.
  ///
  /// **@return** A string value of security level.
  ///
  /// **@throw** If an error occurs, throws the error information.
  ///
  /// **Usage:**
  /// ```dart
  ///   try {
  ///     String securityLevel = await SettingsHelper().getSecutiryLevel();
  ///   } catch (e) {
  ///   }
  /// ```
  Future<String> getSecutiryLevel() async {
    String secutiryLevel = await FrameworkSettingsManager()
        .getFieldValue(FrameworkSettingsFields.secLevel);
    Logger.logDebug(
        "SettingsHelper", "getSecutiryLevel", "Security Level: $secutiryLevel");
    return secutiryLevel;
  }

  /// Read the logged in user's company.
  ///
  /// **@return** A string value of company.
  ///
  /// **@throw** If an error occurs, throws the error information.
  ///
  /// **Usage:**
  /// ```dart
  ///   try {
  ///     String company = await SettingsHelper().getCompany();
  ///   } catch (e) {
  ///   }
  /// ```
  Future<String> getCompany() async {
    String company = await FrameworkSettingsManager()
        .getFieldValue(FrameworkSettingsFields.namespace);
    Logger.logDebug("SettingsHelper", "getCompany", "Company: $company");
    return company;
  }

  /// Read location tracking staus which is received from server.
  ///
  /// **@return** A string value of location tracking staus.
  ///
  /// **@throw** If an error occurs, throws the error information.
  ///
  /// **Usage:**
  /// ```dart
  ///   try {
  ///     String trackingStatus = await SettingsHelper().getLocationTrackingStatus();
  ///   } catch (e) {
  ///   }
  /// ```
  Future<String> getLocationTrackingStatus() async {
    String trackingStatus = await FrameworkSettingsManager()
        .getFieldValue(FrameworkSettingsFields.locationTracking);
    Logger.logDebug("SettingsHelper", "getLocationTrackingStatus",
        "Tracking Status: $trackingStatus");
    return trackingStatus;
  }

  /// Read location tracking days which is received from server.
  ///
  /// **@return** A string value of location tracking days.
  ///
  /// **@throw** If an error occurs, throws the error information.
  ///
  /// **Usage:**
  /// ```dart
  ///   try {
  ///     String trackingDays = await SettingsHelper().getLocationTrackingDays();
  ///   } catch (e) {
  ///   }
  /// ```
  Future<String> getLocationTrackingDays() async {
    String trackingDays = await FrameworkSettingsManager()
        .getFieldValue(FrameworkSettingsFields.locationTrackingDays);
    Logger.logDebug("SettingsHelper", "getLocationTrackingDays",
        "Tracking Days: $trackingDays");
    return trackingDays;
  }

  /// Read location tracking start time which is received from server.
  ///
  /// **@return** A string value of location tracking start time.
  ///
  /// **@throw** If an error occurs, throws the error information.
  ///
  /// **Usage:**
  /// ```dart
  ///   try {
  ///     String trackingStartTime = await SettingsHelper().getLocationTrackingStartTime();
  ///   } catch (e) {
  ///   }
  /// ```
  Future<String> getLocationTrackingStartTime() async {
    String trackingStart = await FrameworkSettingsManager()
        .getFieldValue(FrameworkSettingsFields.locationTrackingStart);
    Logger.logDebug("SettingsHelper", "getLocationTrackingStartTime",
        "Tracking Start Time: $trackingStart");
    return trackingStart;
  }

  /// Read location tracking end time which is received from server.
  ///
  /// **@return** A string value of location tracking end time.
  ///
  /// **@throw** If an error occurs, throws the error information.
  ///
  /// **Usage:**
  /// ```dart
  ///   try {
  ///     String trackingEndTime = await SettingsHelper().getLocationTrackingEndTime();
  ///   } catch (e) {
  ///   }
  /// ```
  Future<String> getLocationTrackingEndTime() async {
    String trackingEnd = await FrameworkSettingsManager()
        .getFieldValue(FrameworkSettingsFields.locationTrackingEnd);
    Logger.logDebug("SettingsHelper", "getLocationTrackingEndTime",
        "Tracking End Time: $trackingEnd");
    return trackingEnd;
  }

  /// Check if the server is reachable.
  ///
  /// **@return** A string value of connection status.
  ///
  /// **@throw** If an error occurs, throws the error information.
  ///
  /// **Usage:**
  /// ```dart
  ///   try {
  ///     String connectionStatus = await SettingsHelper().getServerConnectionStatus();
  ///   } catch (e) {
  ///   }
  /// ```
  Future<String> getServerConnectionStatus() async {
    try {
      final bool isServerReachable = await HTTPConnection.isServerReachable();
      return (isServerReachable) ? "Connected" : "Not Connected";
    } catch (e) {
      return "Not Connected";
    }
  }

  /// Save user selected fetch interval into database.
  ///
  /// **@throw** If an error occurs, throws the error information.
  ///
  /// **@param** [timeInSeconds]
  ///            Call download queued message PA time interval in seconds.
  ///
  /// **Usage:**
  /// ```dart
  ///   try {
  ///     await SettingsHelper().setFetchInterval(600);
  ///   } catch (e) {
  ///   }
  /// ```
  Future<void> setFetchInterval(int timeInSeconds) async {
    Logger.logDebug(
        "SettingsHelper", "setFetchInterval", "Fetch Interval: $timeInSeconds");
    await UserSettingsManager()
        .setFieldValue(UserSettingsFields.fetchInterval, timeInSeconds);
    GetMessageTimerManager().startTimer();
  }

  /// Read stored fetch interval from database.
  ///
  /// **@throw** If an error occurs, throws the error information.
  ///
  /// **Usage:**
  /// ```dart
  ///   try {
  ///     int timeInSeconds = await SettingsHelper().getFetchInterval();
  ///   } catch (e) {
  ///   }
  /// ```
  Future<int> getFetchInterval() async {
    String timeInSeconds = await UserSettingsManager()
        .getFieldValue(UserSettingsFields.fetchInterval);
    Logger.logDebug(
        "SettingsHelper", "getFetchInterval", "Fetch Interval: $timeInSeconds");
    if (timeInSeconds.isEmpty) {
      return 0;
    }
    return int.parse(timeInSeconds);
  }

  /// Validate user entered password with the password stored in the database.
  ///
  /// **@return** A boolean value indicating the validation status.
  ///
  /// **@throw** If an error occurs, throws the error information.
  ///
  /// **@param** [password]
  ///            User entered paswword string.
  ///
  /// **Usage:**
  /// ```dart
  ///   try {
  ///     bool status = await SettingsHelper().validatePassword("TestPassword");
  ///   } catch (e) {
  ///   }
  /// ```
  Future<bool> validatePassword(String password) async {
    String md5Password = FrameworkHelper.getMD5String(password);
    String passwordInFw = await UserSettingsManager()
        .getFieldValue(UserSettingsFields.unviredPassword);
    if (passwordInFw != md5Password) {
      throw ("Incorrect password.");
    }
    return true;
  }

  /// Validate user entered password with the password stored in the database.
  ///
  /// **@return** A boolean value indicating the validation status.
  ///
  /// **@throw** If an error occurs, throws the error information.
  ///
  /// **Usage:**
  /// ```dart
  ///   try {
  ///     List<SystemCredential> systemCredentials = await SettingsHelper().getSystemCredentials();
  ///   } catch (e) {
  ///   }
  /// ```
  Future<List<SystemCredential>> getSystemCredentials() async {
    FrameworkDatabase fwDb = await DatabaseManager().getFrameworkDB();
    return await fwDb.allSystemCredentials;
  }

  /// Update system credentials stored in the database.
  ///
  /// **@return** A boolean value indicating the update system credentials status.
  ///
  /// **@throw** If an error occurs, throws the error information.
  ///
  /// **@param** [systemCredential]
  ///            One of the SystemCredential object which is read from `getSystemCredentials()` api.
  ///
  /// **@param** [userId]
  ///            User entered user id for the `systemCredential` system.
  ///
  /// **@param** [password]
  ///            User entered password for the `systemCredential` system.
  ///
  /// **Usage:**
  /// ```dart
  ///   try {
  ///     bool status = await SettingsHelper().updateSystemCredential(systemCredential, "TestUser", "TestPassword");
  ///   } catch (e) {
  ///   }
  /// ```
  Future<bool> updateSystemCredential(
      SystemCredential systemCredential, String userId, String password,
      {bool doValidate = true}) async {
    // if (userId.length == 0 || password.length == 0) {
    //   throw "Enter valid data.";
    // }
    SystemCredential updated = SystemCredential(
        lid: systemCredential.lid,
        timestamp: systemCredential.timestamp,
        objectStatus: systemCredential.objectStatus,
        syncStatus: systemCredential.syncStatus,
        name: systemCredential.name,
        portName: systemCredential.portName,
        portType: systemCredential.portType,
        portDesc: systemCredential.portDesc,
        systemDesc: systemCredential.systemDesc,
        userId: userId,
        password: password);
    FrameworkDatabase fwDb = await DatabaseManager().getFrameworkDB();
    try {
      await fwDb.updateSystemCredential(updated);
      // For ports other then RFC (SAP), Its only "Save" option.
      if (systemCredential.portType == "RFC" && doValidate) {
        // Authenticate the credentials and show the information to the user.
        List<dynamic> creds = [
          {
            "port": systemCredential.portName,
            "user": userId,
            "password": password
          }
        ];
        String credDetailsString = jsonEncode(creds);
        String functionWithQuery = AdminServiceAuthBackend +
            "?$QueryParamCredentials=$credDetailsString";
        http.Response response =
            await HTTPConnection.makeAdminServicesCall(functionWithQuery);
        dynamic result = jsonDecode(response.body);

        if (result["error"] != null || result["error"].length > 0) {
          throw (result["error"]);
        }
      }
      return true;
    } catch (e) {
      throw (e);
    }
  }

  /// Clear system credentials stored in the database.
  ///
  /// **@return** A boolean value indicating the clear system credentials status.
  ///
  /// **@throw** If an error occurs, throws the error information.
  ///
  /// **@param** [systemCredential]
  ///            One of the SystemCredential object which is read from `getSystemCredentials()` api.
  ///
  /// **Usage:**
  ///   try {
  ///     bool status = await SettingsHelper().clearSystemCredential(systemCredential);
  ///   } catch (e) {
  ///   }
  Future<bool> clearSystemCredential(SystemCredential systemCredential) async {
    SystemCredential updated = SystemCredential(
        lid: systemCredential.lid,
        timestamp: systemCredential.timestamp,
        objectStatus: systemCredential.objectStatus,
        syncStatus: systemCredential.syncStatus,
        name: systemCredential.name,
        portName: systemCredential.portName,
        portType: systemCredential.portType,
        portDesc: systemCredential.portDesc,
        systemDesc: systemCredential.systemDesc,
        userId: "",
        password: "");
    FrameworkDatabase fwDb = await DatabaseManager().getFrameworkDB();
    return await fwDb.updateSystemCredential(updated);
  }

  /// Change the password stored in the database with new password.
  ///
  /// **@return** A boolean value indicating the password change status.
  ///
  /// **@throw** If an error occurs, throws the error information.
  ///
  /// **@param** [newPassword]
  ///            User entered new password for the logged in user.
  ///
  /// **Usage:**
  ///   try {
  ///     bool status = await SettingsHelper().changePassword("NewTestPassword");
  ///   } catch (e) {
  ///   }
  Future<bool> changePassword(String newPassword) async {
    UnviredAccount? account =
        await AuthenticationService().getSelectedAccount();
    if (account == null) {
      throw ("Account not found.");
    }
    account.setPassword(newPassword);
    try {
      http.Response response = await HTTPConnection.authenticateUser(
          AuthenticationService().getAppName(), account);
      Map<String, dynamic> sessionResponseObject = jsonDecode(response.body);
      if (response.statusCode == Status.httpCreated) {
        if (sessionResponseObject[KeySessionId] != null) {
          HTTPConnection.sessionId = sessionResponseObject[KeySessionId];
        }
        // Get jwt token from rest api
        http.Response jwtResponse = await HTTPConnection.getJwtToken(account);
        account.setPassword("");
        AuthenticationService().setSelectedAccount(account);
        // Handle jwt Response
        Map<String, dynamic> jwtResponseObject = jsonDecode(jwtResponse.body);
        if (jwtResponse.statusCode != Status.httpCreated) {
          String errorMsg = "Invalid Credentials: ";
          if (jwtResponseObject[KeyError] != null &&
              jwtResponseObject[KeyError].length > 0) {
            errorMsg = jwtResponseObject[KeyError];
          }
          throw (errorMsg);
        } else {
          await UserSettingsManager().setFieldValue(
              UserSettingsFields.unviredPassword,
              FrameworkHelper.getMD5String(newPassword));
        }
      } else {
        account.setPassword("");
        AuthenticationService().setSelectedAccount(account);
        String errorMsg = "Invalid Credentials.";
        if (sessionResponseObject[KeyError] != null &&
            sessionResponseObject[KeyError].length > 0) {
          errorMsg = sessionResponseObject[KeyError];
        }
        throw (errorMsg);
      }
    } catch (e) {
      throw (e);
    }
    return true;
  }

  /// Download Queued messages from server.
  ///
  /// **@throw** If an error occurs, throws the error information.
  ///
  /// **Usage:**
  ///   try {
  ///     await SettingsHelper().getMessage();
  ///   } catch (e) {
  ///   }
  Future<void> getMessage() async {
    return await SyncEngine().receive();
  }

  /// Clear application data.
  ///
  /// **@throw** If an error occurs, throws the error information.
  ///
  /// **Usage:**
  ///   try {
  ///     await SettingsHelper().clearData();
  ///   } catch (e) {
  ///   }
  Future<bool> clearData() async {
    return await FrameworkHelper.clearData(
        (await AuthenticationService().getSelectedAccount())!);
  }

  /// Save data for key
  ///
  /// **@throw** If an error occurs, throws the error information.
  ///
  /// **@param** [key]
  ///           Pass required key.
  ///
  /// **@param** [value]
  ///           Pass required value.
  ///
  /// **Usage:**
  /// ```dart
  ///   try {
  ///     await SettingsHelper().setValue("username","password");
  ///   } catch (e) {
  ///   }
  /// ```
  Future<void> setValue(String key, dynamic value) async {
    Logger.logDebug("SettingsHelper", "setValue", "Key: $key");
    UserSettingsManager().setFieldValueForKey(key, value);
  }

  /// Get data based on key
  ///
  /// **@throw** If an error occurs, throws the error information.
  ///
  /// **@param** [key]
  ///           Pass the required key.
  ///
  /// **Usage:**
  /// ```dart
  ///   try {
  ///     await SettingsHelper().getValue("username");
  ///   } catch (e) {
  ///   }
  /// ```
  Future<dynamic> getValue(String key) async {
    Logger.logDebug("SettingsHelper", "getValue", "Key: $key");
    return await UserSettingsManager().getFieldValueForKey(key);
  }

  /// Encrypt the given input string
  ///
  /// **@throw** If an error occurs, throws the error information.
  ///
  /// **@param** [input]
  ///           Pass the input string to encrypt.
  ///
  /// **Usage:**
  /// ```dart
  ///   try {
  ///     await SettingsHelper().encrypt("Test string");
  ///   } catch (e) {
  ///   }
  /// ```
  Future<String> encrypt(String input) async {
    Logger.logDebug("SettingsHelper", "encrypt", "Input: $input");
    return await FrameworkHelper.encryptString(input);
  }

  /// Decrypt the given encrypted string
  ///
  /// **@throw** If an error occurs, throws the error information.
  ///
  /// **@param** [input]
  ///           Pass the input as base64 encrypted string.
  ///
  /// **Usage:**
  /// ```dart
  ///   try {
  ///     await SettingsHelper().decrypt("encrypted_string");
  ///   } catch (e) {
  ///   }
  /// ```
  Future<String> decrypt(String input) async {
    Logger.logDebug("SettingsHelper", "decrypt", "Input: $input");
    return await FrameworkHelper.decryptString(input);
  }

  // Private Method
  Future<String> _getAdditionalInfo() async {
    String infoMessageString = "";

    FrameworkDatabase frameworkDatabase =
        await DatabaseManager().getFrameworkDB();
    List<InfoMessageData> infoMessages =
        await frameworkDatabase.allInfoMessages;
    if (infoMessages.length > 0) {
      // Add the Info Message to the end of Data.

      for (int i = 0; i < infoMessages.length; i++) {
        if (i == 0) {
          infoMessageString += "********ALL INFO MESSAGES********";
        }

        InfoMessageData infoMessage = infoMessages[i];
        String category = infoMessage.category;
        String message = infoMessage.message;
        String beName = infoMessage.bename;
        String beLID = infoMessage.belid;
        infoMessageString += "\n${i + 1}";
        infoMessageString += "\n$message";
        infoMessageString += "\n$category";
        infoMessageString += "\n$beName";
        infoMessageString += "\n$beLID";
        infoMessageString += "\n";
        if (i == infoMessages.length - 1) {
          infoMessageString += "********END OF INFO MESSAGES********\n";
        }
      }

      // Display All the Contents from ApplicationVersion.txt.
      infoMessageString += "********VERSION INFORMATION********\n";
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;

      infoMessageString += "Version: $version";
      infoMessageString += "\tBuild: $buildNumber";
    }

    infoMessageString += "\n";

    // Add inbox items, outbox items and sent items details
    List<InObjectData> inboxItems = await frameworkDatabase.allInObjects;
    if (inboxItems.length > 0) {
      String inboxStr = "***** INBOX *****\n";
      for (InObjectData inObj in inboxItems) {
        DateTime currentDate =
            DateTime.fromMillisecondsSinceEpoch(inObj.timestamp);
        DateFormat formatter = DateFormat('dd.MM.yyyy HH:mm:ss');
        String finalDate = formatter.format(currentDate);
        inboxStr += "$finalDate | ${inObj.conversationId}";
        inboxStr += "\n";
      }
      inboxStr += "\n";
      infoMessageString += inboxStr;
    }

    List<OutObjectData> outboxItems = await frameworkDatabase.allOutObjects;
    if (outboxItems.length > 0) {
      String outboxStr = "***** OUTBOX *****\n";
      for (OutObjectData outObj in outboxItems) {
        DateTime currentDate =
            DateTime.fromMillisecondsSinceEpoch(outObj.timestamp);
        DateFormat formatter = DateFormat('dd.MM.yyyy HH:mm:ss');
        String finalDate = formatter.format(currentDate);
        outboxStr += "$finalDate | ${outObj.beName}";
        outboxStr += "\n";
      }
      outboxStr += "\n";
      infoMessageString += outboxStr;
    }

    List<SentItem> sentItems = await frameworkDatabase.allSentItems;

    if (sentItems.length > 0) {
      String sentStr = "***** SENT_ITEMS *****\n";
      for (SentItem sentItem in sentItems) {
        DateTime currentDate =
            DateTime.fromMillisecondsSinceEpoch(sentItem.timestamp);
        DateFormat formatter = DateFormat('dd.MM.yyyy HH:mm:ss');
        String finalDate = formatter.format(currentDate);
        sentStr +=
            "$finalDate | ${sentItem.conversationId} | ${sentItem.beName}";
        sentStr += "\n";
      }
      sentStr += "\n";
      infoMessageString += sentStr;
    }

    return infoMessageString;
  }

  bool isWorkerSupportedInBrowser() {
    return isWorkerSupported();
  }

  queuePingToOutbox() async {
    OutObjectData outObjectData = OutObjectData(
        lid: FrameworkHelper.getUUID(),
        timestamp: DateTime.now().millisecondsSinceEpoch,
        objectStatus: ObjectStatus.global.index,
        syncStatus: SyncStatus.none.index,
        functionName: "",
        beName: "",
        beHeaderLid: "",
        requestType: "",
        syncType: SyncType.ASYNC.toString(),
        conversationId: "",
        messageJson: AdminServicePing,
        companyNameSpace: "",
        sendStatus: "",
        fieldOutObjectStatus: OutObjectStatus.none.index.toString(),
        isAdminServices: true);
    await SyncEngine().checkInOutBoxAndQueue(outObjectData);
    return;
  }

  String convertMapToBase64(Map<String, dynamic> map) {
    return base64Encode(utf8.encode(jsonEncode(map)));
  }

  Map<String, dynamic> convertBase64ToMap(String base64String) {
    return jsonDecode(utf8.decode(base64Decode(base64String)));
  }
}
