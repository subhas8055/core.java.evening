import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_ipify/dart_ipify.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:unvired_sdk/src/helper/isolate_helper.dart';
import 'package:unvired_sdk/src/helper/passcode_generator.dart';
import 'package:unvired_sdk/src/helper/user_settings_manager.dart';

import '../authentication_service.dart';
import '../database/database_manager.dart';
import '../database/framework_database.dart';
import '../helper/framework_helper.dart';
import '../helper/framework_settings_manager.dart';
import '../helper/path_manager.dart';
import '../helper/service_constants.dart';
import '../helper/url_service.dart';
import '../inbox/inbox.dart';
import '../outbox/outbox.dart';
import '../unvired_account.dart';
import 'settings_helper.dart';
import 'status.dart';

class HTTPConnection {
  static String sessionId = "";
  static String _jwtToken = "";

  static String get bearerAuth => _jwtToken.isEmpty ? "" : "Bearer $_jwtToken";

  static Future<http.Response> authenticateUser(
      String appName, UnviredAccount account) async {
    if (!(await URLService.isInternetConnected())) {
      Logger.logDebug("HTTPConnection", "authenticateAndActivate",
          "No Internet connection.");
      throw ("No Internet connection. Make sure your device is connected to the network and try again.");
    }

    if (!(await HTTPConnection.isServerReachable())) {
      Logger.logDebug(
          "HTTPConnection", "authenticateUser", "Server not reachable.");
      throw ("Server not reachable. Make sure your device is connected to the valid network and try again.");
    }

    if (account.getUrl().isEmpty) {
      Logger.logError(
          "HTTPConnection", "authenticateAndActivate", "URL is empty.");
      throw ("URL is empty.");
    }
    Logger.logDebug("HTTPConnection", "authenticateAndActivate",
        "Session REST api is called.");
    String basicAuth = (account.getLoginType() == LoginType.saml)
        ? 'Bearer ${account.getToken()}'
        : 'Basic ' +
            base64Encode(utf8.encode(
                '${account.getCompany()}\\${account.getUserName()}:${account.getPassword()}'));

    // Make Session call
    String baseUrl = URLService.getSessionUrl(account.getUrl());
    if (account.getLoginType() == LoginType.ads ||
        account.getLoginType() == LoginType.sap) {
      baseUrl += "/$ServiceApplications/$appName";
      var url = Uri.parse(baseUrl);
      Map<String, String> body = {
        "credentials": jsonEncode([
          {
            "port": "${account.getPort()}",
            "user": "${account.getDomain()}\\${account.getUserName()}",
            "password": "${account.getPassword()}"
          }
        ])
      };
      http.Response sessionResponse = await http.post(url,
          headers: <String, String>{'authorization': basicAuth}, body: body);
      Logger.logDebug("HTTPConnection", "authenticateAndActivate",
          "Session REST api response code: ${sessionResponse.statusCode}");
      return sessionResponse;
    }
    if (account.getLoginType() == LoginType.passwordless) {
      baseUrl = URLService.getBaseUrl(account.getUrl());
      baseUrl += "$ServiceApplications/$appName/$ServicePasswordLess";
      if (account.getToken().isNotEmpty) {
        baseUrl += "/${account.getToken()}?startSession=true";
        var url = Uri.parse(baseUrl);
        http.Response sessionResponse = await http
            .get(url, headers: <String, String>{'authorization': basicAuth});
        Logger.logDebug("HTTPConnection", "authenticateAndActivate",
            "Session REST api response code: ${sessionResponse.statusCode}");
        return sessionResponse;
      }
    }

    var url = Uri.parse(baseUrl);
    http.Response sessionResponse = await http
        .post(url, headers: <String, String>{'authorization': basicAuth});
    Logger.logDebug("HTTPConnection", "authenticateAndActivate",
        "Session REST api response code: ${sessionResponse.statusCode}");
    return sessionResponse;
  }

  static Future<http.Response> activateUser(
      String appName, UnviredAccount account) async {
    if (!(await URLService.isInternetConnected())) {
      Logger.logDebug(
          "HTTPConnection", "activateUser", "No Internet connection.");
      throw ("No Internet connection. Make sure your device is connected to the network and try again.");
    }

    if (account.getUrl().isEmpty) {
      Logger.logError("HTTPConnection", "activateUser", "URL is empty.");
      throw ("URL is empty.");
    }

    if (account.getLoginType() != LoginType.saml &&
        account.getFrontendId().isEmpty) {
      Logger.logError("HTTPConnection", "activateUser", "Frontend is not set.");
      throw ("Frontend is not set.");
    }

    // Make activation call
    Logger.logDebug(
        "HTTPConnection", "activateUser", "Activation REST api is called.");
    String appUrl = URLService.getApplicationUrl(account.getUrl());
    appUrl += "/$appName/$ServiceActivate";
    if (account.getLoginType() != LoginType.saml) {
      appUrl += "/${account.getFrontendId()}";
    } else {
      appUrl += "/saml";
    }
    var queryString = "";
    var postParams = await HTTPConnection.getActivatePostParameters();
    postParams.forEach((k, v) =>
        (queryString += (queryString.length == 0 ? "?" : "&") + "$k=$v"));
    appUrl += queryString;

    if (account.getLoginType() != LoginType.saml && sessionId.isEmpty) {
      Logger.logError("HTTPConnection", "activateUser",
          "Session is empty. User is not authenticated.");
      throw ("User is not authenticated.");
    }
    String userName = (account.getLoginType() == LoginType.sap ||
            account.getLoginType() == LoginType.ads)
        ? account.getUnviredUser()
        : account.getUserName();
    String basicAuth = (account.getLoginType() != LoginType.saml)
        ? 'Basic ' +
            base64Encode(
                utf8.encode("${account.getCompany()}\\$userName:$sessionId"))
        : 'Bearer ${account.getToken()}';
    var url = Uri.parse(appUrl);
    http.Response activationResponse = await http
        .post(url, headers: <String, String>{'authorization': basicAuth});
    Logger.logDebug("HTTPConnection", "activateUser",
        "Activation REST api response code: ${activationResponse.statusCode}");
    Map<String, dynamic> jwtResponseObject =
        jsonDecode(activationResponse.body);
    return activationResponse;
  }

  static Future<http.Response> getJwtToken(
      UnviredAccount? selectedAccount) async {
    if (!(await URLService.isInternetConnected())) {
      Logger.logDebug(
          "HTTPConnection", "getJwtToken", "No Internet connection.");
      throw ("No Internet connection. Make sure your device is connected to the network and try again.");
    }

    if (!(await HTTPConnection.isServerReachable())) {
      Logger.logDebug("HTTPConnection", "getJwtToken", "Server not reachable.");
      throw ("Server not reachable. Make sure your device is connected to the valid network and try again.");
    }

    UnviredAccount? account = selectedAccount;
    if (account == null) {
      Logger.logDebug(
          "HTTPConnection", "getJwtToken", "Account data not available.");
      throw ("Account data not available.");
    }

    if (account.getUrl().isEmpty) {
      Logger.logError("HTTPConnection", "getJwtToken", "URL is empty.");
      throw ("URL is empty.");
    }

    if (account.getFrontendId().isEmpty) {
      Logger.logError("HTTPConnection", "activateUser", "Frontend is not set.");
      throw ("Frontend is not set.");
    }

    // Make get JWT Token call
    Logger.logDebug(
        "HTTPConnection", "getJwtToken", "Get JWT Token REST api is called.");
    String unviredAccountPassword = account.getPassword();
    if (unviredAccountPassword.isEmpty) {
      unviredAccountPassword = await UserSettingsManager()
          .getFieldValue(UserSettingsFields.unviredPassword);
    }

    String oneTimeToken = await getOnetimeTokenFromFWSettingsManager();
    if (oneTimeToken.isNotEmpty) {
      oneTimeToken = "&$oneTimeToken";
    }
    String appBaseUrl = URLService.getApplicationUrl(account.getUrl());
    String appUrl =
        "$appBaseUrl/${AuthenticationService().getAppName()}/$ServiceSession?$QueryParamFrontendUser=${account.getFrontendId()}$oneTimeToken";
    String userName = (account.getLoginType() == LoginType.sap ||
            account.getLoginType() == LoginType.ads)
        ? account.getUnviredUser()
        : account.getUserName();
    String password = account.getLoginType() == LoginType.passwordless
        ? account.getUnviredUserPwd()
        : unviredAccountPassword;

    String basicAuth = "";
    Map<String, String> body = {};
    switch (account.getLoginType()) {
      case LoginType.ads:
      case LoginType.sap:
        {
          String inp =
              "${account.getCompany()}\\${account.getDomain()}\\${userName}:${password}";
          basicAuth = 'Basic ' + base64Encode(utf8.encode(inp));
          body = {
            "credentials": jsonEncode([
              {
                "port": "${account.getPort()}",
                "user": "${account.getDomain()}\\${userName}",
                "password": "${password}"
              }
            ])
          };
        }
        break;
      case LoginType.saml:
        {
          basicAuth = 'Bearer ${account.getToken()}';
        }
        break;
      default:
        {
          basicAuth = 'Basic ' +
              base64Encode(utf8
                  .encode('${account.getCompany()}\\${userName}:${password}'));
        }
        break;
    }

    var url = Uri.parse(appUrl);
    http.Response jwtResponse = await http.post(url,
        headers: <String, String>{'authorization': basicAuth}, body: body);
    Logger.logDebug("HTTPConnection", "getJwtToken",
        "Activation REST api response code: ${jwtResponse.statusCode}");
    Map<String, dynamic> jwtResponseObject = jsonDecode(jwtResponse.body);
    _jwtToken = "";
    if (jwtResponse.statusCode == Status.httpCreated) {
      _jwtToken = jwtResponseObject[KeyToken];
    } else if (jwtResponse.statusCode == Status.httpUnauthorized) {
      FrameworkHelper.clearData(
          (await AuthenticationService().getSelectedAccount())!);
    }
    return jwtResponse;
  }

  static Future<http.Response> makeSyncCall(String inputQueryData,
      {UnviredAccount? selectedAccount,
      String? appNameInput,
      String? authToken}) async {
    UnviredAccount? account;
    if (selectedAccount != null) {
      account = selectedAccount;
    } else {
      account = await AuthenticationService().getSelectedAccount();
    }
    String appName = "";
    if (appNameInput == null) {
      appName = AuthenticationService().getAppName();
    } else {
      appName = appNameInput;
    }
    String bearer = "";
    if (authToken == null) {
      bearer = bearerAuth;
    } else {
      bearer = authToken;
    }

    if (bearer.isEmpty) {
      await getJwtToken(account);
      bearer = bearerAuth;
    }

    if (account == null) {
      Logger.logDebug(
          "HTTPConnection", "makeSyncCall", "Account data not available.");
      throw ("Account data not available.");
    }
    String appBaseUrl = URLService.getApplicationUrl(account.getUrl());

    inputQueryData = URLService.getURLEncodedData(inputQueryData);

    String appUrl =
        "$appBaseUrl/$appName/$ServiceExecute/$inputQueryData"; //paName?$QueryParamFrontendUser=${account.getFrontendId()}
    var url = Uri.parse(appUrl);
    Map<String, String> headers = <String, String>{
      'authorization': bearer,
      'Content-Type': "application/json",
      "Accept": "application/json",
    };
    //TODO : GZip compression
    // FrameworkSettingsManager frameworkSettingsManager =
    // FrameworkSettingsManager();
    // String compressPostData = await frameworkSettingsManager
    //     .getFieldValue(FrameworkSettingsFields.compressPostData);
    // if (compressPostData == yes) {
    //   headers.putIfAbsent("Content-Encoding", () => "gzip");
    // }
    http.Response syncResponse = await http.post(url, headers: headers);
    String? jwtToken = syncResponse.headers[KeyJwtToken];
    if (jwtToken != null && jwtToken.isNotEmpty) {
      _jwtToken = jwtToken;
    }
    if (syncResponse.statusCode == Status.httpUnauthorized) {
      await getJwtToken(account);
      if (_jwtToken.isNotEmpty) {
        return await makeSyncCall(inputQueryData);
      }
    }
    return syncResponse;
  }

  static Future<http.Response> downloadMessage() async {
    UnviredAccount? account =
        await AuthenticationService().getSelectedAccount();
    if (account == null || ((bearerAuth).isEmpty)) {
      Logger.logDebug(
          "HTTPConnection", "makeSyncCall", "Account data not available.");
      throw ("Account data not available.");
    }
    String oneTimeToken = await getOnetimeTokenFromFWSettingsManager();
    if (oneTimeToken.isNotEmpty) {
      oneTimeToken = "?$oneTimeToken";
    }
    String appBaseUrl = URLService.getApplicationUrl(account.getUrl());
    String appUrl =
        "$appBaseUrl/${AuthenticationService().getAppName()}/$ServiceMessage/${account.getFrontendId()}$oneTimeToken";
    var url = Uri.parse(appUrl);
    http.Response syncResponse = await http.get(url, headers: <String, String>{
      'authorization': (bearerAuth),
      'Content-Type': "application/json",
      "Accept": "application/json"
    });
    if (syncResponse.statusCode == Status.httpUnauthorized) {
      await getJwtToken(await AuthenticationService().getSelectedAccount());
      if (_jwtToken.isNotEmpty) {
        return await downloadMessage();
      }
    }
    return syncResponse;
  }

  static Future<http.StreamedResponse> uploadAttachment(
      Map<String, dynamic> attachmentItem) async {
    UnviredAccount? account =
        await AuthenticationService().getSelectedAccount();
    if (account == null || (bearerAuth).isEmpty) {
      Logger.logError(
          "HTTPConnection", "uploadAttachment", "Account data not available.");
      throw ("Account data not available.");
    }

    String gUid = attachmentItem[AttachmentItemFieldUid];
    String attachmentFolderPath = await PathManager.getAttachmentFolderPath(
        (await AuthenticationService().getSelectedAccount())!.getUserId());
    attachmentFolderPath += "/${attachmentItem[AttachmentItemFieldFileName]}";

    String attachmentId = gUid;
    String filePath = attachmentFolderPath;
    String appBaseUrl = URLService.getApplicationUrl(account.getUrl());
    String appUrl =
        "$appBaseUrl/${AuthenticationService().getAppName()}/$ServiceAttachments/$attachmentId";
    var url = Uri.parse(appUrl);

    // create multipart request
    var request = new http.MultipartRequest("POST", url);
    var fileObject = File(filePath);
    var stream = fileObject.readAsBytes().asStream();
    // get file length
    int length = fileObject.lengthSync();
    // multipart that takes file
    var multipartFileSign = new http.MultipartFile(
        QueryParamFile, stream, length,
        filename: filePath.split("/").last);

    // add file to multipart
    request.files.add(multipartFileSign);

    //add headers
    request.headers.addAll({'authorization': (bearerAuth)});

    //adding params
    // request.fields['loginId'] = '12';
    // request.fields['firstName'] = 'abc';
    // request.fields['lastName'] = 'efg';

    // send
    http.StreamedResponse response = await request.send();
    return response;
  }

  static Future<http.Response> downloadAttachment(String attachmentUid,
      {required UnviredAccount? account,
      required String appBaseUrl,
      required String appName,
      required String bearerAuth}) async {
    Logger.logDebug("HTTPConnection", "downloadAttachment",
        "Processing UID : ${attachmentUid}");
    if (account == null || (bearerAuth).isEmpty) {
      Logger.logError(
          "HTTPConnection", "uploadAttachment", "Account data not available.");
      throw ("Account data not available.");
    }

    String appUrl = "$appBaseUrl/$appName/$ServiceAttachments/$attachmentUid";
    Logger.logInfo(
        "HTTPConnection", "downloadAttachment", "downloading  URL : $appUrl");
    var url = Uri.parse(appUrl);

    http.Response response = await http
        .get(url, headers: <String, String>{'authorization': (bearerAuth)});
    return response;
  }

  static Future<bool> isServerReachable() async {
    final UnviredAccount? account =
        await AuthenticationService().getSelectedAccount();

    if (account == null) {
      Logger.logError(
          "HTTPConnection", "isServerReachable", "Account data not available.");
      return false;
    }

    final String pingUrl = URLService.getPingUrl(account.getUrl());
    var url = Uri.parse(pingUrl);
    try {
      final http.Response response =
          await http.get(url).timeout(Duration(seconds: 10));
      return response.statusCode == Status.httpOk;
    } on TimeoutException catch (e) {
      Logger.logError("HTTPConnection", "isServerReachable",
          "Server not reachable within 10 seconds.");
      return false;
    }

    return false;
  }

  static Future<http.StreamedResponse> uploadLogOrData(
      String filePath, String action) async {
    UnviredAccount? account =
        await AuthenticationService().getSelectedAccount();
    if (account == null || (bearerAuth).isEmpty) {
      Logger.logError(
          "HTTPConnection", "uploadAttachment", "Account data not available.");
      throw ("Account data not available.");
    }

    String appBaseUrl = account.getUrl();
    String appUrl = "$appBaseUrl/$ServiceAttachment";
    var url = Uri.parse(appUrl);

    // create multipart request
    var request = new http.MultipartRequest("POST", url);
    var fileObject = File(filePath);
    var stream = fileObject.readAsBytes().asStream();
    // get file length
    int length = fileObject.lengthSync();
    // multipart that takes file
    var multipartFileSign = new http.MultipartFile(
        QueryParamFile, stream, length,
        filename: filePath.split("/").last);

    // add file to multipart
    request.files.add(multipartFileSign);

    //add headers
    String basicAuth = 'Basic ' +
        base64Encode(utf8.encode(
            '${account.getCompany()}\\${account.getUserName()}:$sessionId'));
    request.headers.addAll({
      'authorization': basicAuth,
      'Content-Type': "multipart/form-data",
      "Accept": "application/zip"
    });

    //adding common params
    request = await _getCommonMultipartFields(request);

    //adding specifi params
    request.fields[ParamAction] = action;
    request.fields[ParamMimeType] = "application/zip";

    // send
    http.StreamedResponse response = await request.send();
    return response;
  }

  static Future<http.Response> acknowledgeMessage(
      String convId, UnviredAccount account) async {
    if (!(await URLService.isInternetConnected())) {
      Logger.logDebug(
          "HTTPConnection", "acknowledgeMessage", "No Internet connection.");
      throw ("No Internet connection. Make sure your device is connected to the network and try again.");
    }

    if (account.getUrl().isEmpty) {
      Logger.logError("HTTPConnection", "acknowledgeMessage", "URL is empty.");
      throw ("URL is empty.");
    }

    if ((bearerAuth).isEmpty) {
      Logger.logError("HTTPConnection", "acknowledgeMessage",
          "Account data not available.");
      throw ("Account data not available.");
    }

    String appBaseUrl = URLService.getBaseUrl(account.getUrl());
    var queryString = "";
    var postParams = await HTTPConnection.getCommonPostParameters();
    postParams.forEach((k, v) =>
        (queryString += (queryString.length > 0 ? "&" : "") + "$k=$v"));
    String appUrl =
        "$appBaseUrl$ServiceMessages/$ServiceFrontendUsers/${account.getFrontendId()}/$ServiceConversation/$convId?$queryString";
    var url = Uri.parse(appUrl);

    Logger.logDebug("HTTPConnection", "acknowledgeMessage",
        "Acknowledge message api is called.");

    http.Response sessionResponse = await http
        .delete(url, headers: <String, String>{'authorization': (bearerAuth)});
    Logger.logDebug("HTTPConnection", "acknowledgeMessage",
        "Acknowledge message api response code: ${sessionResponse.statusCode}");
    return sessionResponse;
  }

  static Future<http.MultipartRequest> _getCommonMultipartFields(
      request) async {
    FrameworkSettingsManager frameworkSettingsManager =
        FrameworkSettingsManager();
    FrameworkDatabase fwDb = await DatabaseManager().getFrameworkDB();
    String deviceModel = "";
    String deviceOsVersion = "";
    String appVersion = "";
    try {
      appVersion = await SettingsHelper().getApplicationVersionNumber();
    } catch (e) {}
    String ipString = await Ipify.ipv4();

    if (getPlatform() == PlatformType.android) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      var release = androidInfo.version.release;
      var sdkInt = androidInfo.version.sdkInt;
      var manufacturer = androidInfo.manufacturer;
      var model = androidInfo.model;
      deviceModel = "$manufacturer $model";
      deviceOsVersion = 'Android $release (SDK $sdkInt)';
    }

    if (getPlatform() == PlatformType.ios) {
      var iosInfo = await DeviceInfoPlugin().iosInfo;
      deviceModel = iosInfo.name ?? "";
      deviceOsVersion = '${iosInfo.systemName} ${iosInfo.systemVersion}';
    }

    if (getPlatform() == PlatformType.macOs) {
      var macOsInfo = await DeviceInfoPlugin().macOsInfo;
      deviceModel = macOsInfo.model;
      deviceOsVersion = '${macOsInfo.hostName} ${macOsInfo.osRelease}';
    }

    if (getPlatform() == PlatformType.windows) {
      var windowsOsInfo = await DeviceInfoPlugin().windowsInfo;
      deviceModel = windowsOsInfo.computerName;
    }

    if (getPlatform() == PlatformType.linux) {
      var linuxInfo = await DeviceInfoPlugin().linuxInfo;
      deviceModel = linuxInfo.name;
      deviceOsVersion = linuxInfo.prettyName;
    }

    if (kIsWeb) {
      var webBrowserInfo = await DeviceInfoPlugin().webBrowserInfo;
      deviceModel = webBrowserInfo.appName ?? "";
      deviceOsVersion = webBrowserInfo.appVersion ?? "";
    }

    int outboxCount = await Outbox().outboxCount();
    int sentItemsCount = await Outbox().sentItemsCount();
    int inboxCount = await Inbox().inboxCount();
    String activationId = await frameworkSettingsManager
        .getFieldValue(FrameworkSettingsFields.activationId);
    String companyAlias = await frameworkSettingsManager
        .getFieldValue(FrameworkSettingsFields.namespace);
    String serverId = await frameworkSettingsManager
        .getFieldValue(FrameworkSettingsFields.serverId);
    String feUserId = await frameworkSettingsManager
        .getFieldValue(FrameworkSettingsFields.feUser);
    String oneTimeToken = await frameworkSettingsManager
        .getFieldValue(FrameworkSettingsFields.oneTimeToken);
    String deviceType = await frameworkSettingsManager
        .getFieldValue(FrameworkSettingsFields.frontendType);
    String deviceState =
        "O-$outboxCount S-$sentItemsCount I-$inboxCount IP-$ipString ACT-$activationId";

    Map<String, String> params = {};
    if (!kIsWeb) {
      List<String> passCodeAndTime =
          PassCodeGenerator().computePin(oneTimeToken, feUserId);
      request.fields[ParamOneTimeToken] = passCodeAndTime[0];
      request.fields[ParamMessageTime] = passCodeAndTime[1];
    }

    //adding params
    request.fields[ParamAttachmentGuid] = FrameworkHelper.getUUID();
    request.fields[ParamJwtToken] = HTTPConnection._jwtToken;
    request.fields[ParamMessageTime] = FrameworkHelper.getTimeStamp();
    request.fields[ParamApplication] = AuthenticationService().getAppName();
    request.fields[ParamFrameworkVersion] = FrameworkVersionNumber;
    request.fields[ParamAppVersion] = appVersion;
    request.fields[ParamDeviceOsVersion] = deviceOsVersion;
    request.fields[ParamDeviceModel] = deviceModel;
    request.fields[ParamDeviceState] = deviceState;
    request.fields[ParamCompanyNamespace] = companyAlias;
    request.fields[ParamCompanyAlias] = companyAlias;
    request.fields[ParamServerId] = serverId;
    request.fields[ParamFeUserId] = feUserId;
    // request.fields[ParamOneTimeToken] = oneTimeToken;
    request.fields[ParamDeviceType] = deviceType;
    return request;
  }

  static Future<Map<String, String>> getCommonPostParameters() async {
    FrameworkSettingsManager frameworkSettingsManager =
        FrameworkSettingsManager();
    FrameworkDatabase fwDb = await DatabaseManager().getFrameworkDB();
    String deviceModel = "";
    String deviceOsVersion = "";
    String appVersion = "";
    try {
      appVersion = await SettingsHelper().getApplicationVersionNumber();
    } catch (e) {}
    //String ipString = await Ipify.ipv4();

    if (getPlatform() == PlatformType.android) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      var release = androidInfo.version.release;
      var sdkInt = androidInfo.version.sdkInt;
      var manufacturer = androidInfo.manufacturer;
      var model = androidInfo.model;
      deviceModel = "$manufacturer $model";
      deviceOsVersion = 'Android $release (SDK $sdkInt)';
    }

    if (getPlatform() == PlatformType.ios) {
      var iosInfo = await DeviceInfoPlugin().iosInfo;
      deviceModel = iosInfo.name ?? "";
      deviceOsVersion = '${iosInfo.systemName} ${iosInfo.systemVersion}';
    }

    if (getPlatform() == PlatformType.macOs) {
      var macOsInfo = await DeviceInfoPlugin().macOsInfo;
      deviceModel = macOsInfo.model;
      deviceOsVersion = '${macOsInfo.hostName} ${macOsInfo.osRelease}';
    }

    if (getPlatform() == PlatformType.windows) {
      var windowsOsInfo = await DeviceInfoPlugin().windowsInfo;
      deviceModel = windowsOsInfo.computerName;
    }

    if (getPlatform() == PlatformType.linux) {
      var linuxInfo = await DeviceInfoPlugin().linuxInfo;
      deviceModel = linuxInfo.name;
      deviceOsVersion = linuxInfo.prettyName;
    }

    if (kIsWeb) {
      var webBrowserInfo = await DeviceInfoPlugin().webBrowserInfo;
      deviceModel = webBrowserInfo.appName ?? "";
      deviceOsVersion = webBrowserInfo.appVersion ?? "";
    }

    int outboxCount = await Outbox().outboxCount();
    int sentItemsCount = await Outbox().sentItemsCount();
    int inboxCount = await Inbox().inboxCount();
    String activationId = await frameworkSettingsManager
        .getFieldValue(FrameworkSettingsFields.activationId);
    String companyAlias = await frameworkSettingsManager
        .getFieldValue(FrameworkSettingsFields.namespace);
    String serverId = await frameworkSettingsManager
        .getFieldValue(FrameworkSettingsFields.serverId);
    String feUserId = await frameworkSettingsManager
        .getFieldValue(FrameworkSettingsFields.feUser);
    String oneTimeToken = await frameworkSettingsManager
        .getFieldValue(FrameworkSettingsFields.oneTimeToken);
    String deviceType = await frameworkSettingsManager
        .getFieldValue(FrameworkSettingsFields.frontendType);
    // String deviceState =
    //   "O-$outboxCount S-$sentItemsCount I-$inboxCount IP-$ipString ACT-$activationId";

    String userId =
        await UserSettingsManager().getFieldValue(UserSettingsFields.unviredId);
    String password = await UserSettingsManager()
        .getFieldValue(UserSettingsFields.unviredPassword);
    LoginType? loginType =
        (await AuthenticationService().getSelectedAccount())!.getLoginType();

    if (loginType == LoginType.unvired || loginType == LoginType.email) {
      if (password == null || password.isEmpty) {
      } else {}
    }
    Map<String, String> params = {};
    if (!kIsWeb) {
      List<String> passCodeAndTime =
          PassCodeGenerator().computePin(oneTimeToken, feUserId);
      password = FrameworkHelper.getMD5String(password + passCodeAndTime[1]);
      params[ParamOneTimeToken] = passCodeAndTime[0];
      params[ParamMessageTime] = passCodeAndTime[1];
    }
    params[ParamServerUserId] = userId;
    params[ParamPassword] = password;
    params[ParamApplication] = AuthenticationService().getAppName();
    params[ParamFrameworkVersion] = FrameworkVersionNumber;
    params[ParamAppVersion] = appVersion;
    params[ParamDeviceOsVersion] = deviceOsVersion;
    params[ParamDeviceModel] = deviceModel;
    params[ParamFeUserId] = feUserId;
    params[ParamServerId] = serverId;
    params[ParamDeviceType] = deviceType;
    params[ParamCompanyAlias] = companyAlias;
    params[ParamLoginType] = EnumToString.convertToString(loginType);
    return params;
  }

  static Future<Map<String, String>> getActivatePostParameters() async {
    String deviceModel = "";
    String deviceOsVersion = "";
    String appVersion = "";
    try {
      appVersion = await SettingsHelper().getApplicationVersionNumber();
    } catch (e) {}
    //String ipString = await Ipify.ipv4();

    if (getPlatform() == PlatformType.android) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      var release = androidInfo.version.release;
      var sdkInt = androidInfo.version.sdkInt;
      var manufacturer = androidInfo.manufacturer;
      var model = androidInfo.model;
      deviceModel = "$manufacturer $model";
      deviceOsVersion = 'Android $release (SDK $sdkInt)';
    }

    if (getPlatform() == PlatformType.ios) {
      var iosInfo = await DeviceInfoPlugin().iosInfo;
      deviceModel = iosInfo.name ?? "";
      deviceOsVersion = '${iosInfo.systemName} ${iosInfo.systemVersion}';
    }

    if (getPlatform() == PlatformType.macOs) {
      var macOsInfo = await DeviceInfoPlugin().macOsInfo;
      deviceModel = macOsInfo.model;
      deviceOsVersion = '${macOsInfo.hostName} ${macOsInfo.osRelease}';
    }

    if (getPlatform() == PlatformType.windows) {
      var windowsOsInfo = await DeviceInfoPlugin().windowsInfo;
      deviceModel = windowsOsInfo.computerName;
    }

    if (getPlatform() == PlatformType.linux) {
      var linuxInfo = await DeviceInfoPlugin().linuxInfo;
      deviceModel = linuxInfo.name;
      deviceOsVersion = linuxInfo.prettyName;
    }

    if (kIsWeb) {
      var webBrowserInfo = await DeviceInfoPlugin().webBrowserInfo;
      deviceModel = webBrowserInfo.appName ?? "";
      deviceOsVersion = webBrowserInfo.appVersion ?? "";
    }

    Map<String, String> params = {};
    params[ParamApplication] = AuthenticationService().getAppName();
    params[ParamFrameworkVersion] = FrameworkVersionNumber;
    params[ParamAppVersion] = appVersion;
    params[ParamDeviceOsVersion] = deviceOsVersion;
    params[ParamDeviceModel] = deviceModel;
    return params;
  }

  static Future<http.Response> makeAdminServicesCall(String inputQueryData,
      {UnviredAccount? selectedAccount,
      String? appNameInput,
      String? authToken}) async {
    Logger.logInfo(
        "HTTPConnection", "makeAdminServicesCall", "Calling admin services...");
    if (!kIsWeb) {
      if (selectedAccount != null) {
        //check if called from isolate
        if (!(await checkConnectionInIsolate())) {
          Logger.logDebug("HTTPConnection", "makeAdminServicesCall",
              "No Internet connection.");
          throw ("No Internet connection. Make sure your device is connected to the network and try again.");
        }
      } else {
        if (!(await URLService.isInternetConnected())) {
          Logger.logDebug("HTTPConnection", "makeAdminServicesCall",
              "No Internet connection.");
          throw ("No Internet connection. Make sure your device is connected to the network and try again.");
        }
      }
    }

    UnviredAccount? account;
    if (selectedAccount != null) {
      account = selectedAccount;
    } else {
      account = await AuthenticationService().getSelectedAccount();
    }
    String appName = "";
    if (appNameInput == null) {
      appName = AuthenticationService().getAppName();
    } else {
      appName = appNameInput;
    }
    String bearer = "";
    if (authToken == null) {
      bearer = (bearerAuth);
    } else {
      bearer = authToken;
    }
    if (account == null || bearer.isEmpty) {
      if (account == null) {
        Logger.logDebug("HTTPConnection", "makeAdminServicesCall",
            "Account data not available.");
        throw ("Account data not available.");
      } else {
        Logger.logDebug(
            "HTTPConnection", "makeAdminServicesCall", "token not available.");
        await getJwtToken(account);
        bearer = (bearerAuth);
      }
    }
    String appBaseUrl = URLService.getApplicationUrl(account.getUrl());
    var queryString = "";
    var postParams = await HTTPConnection.getCommonPostParameters();
    postParams.forEach((k, v) =>
        (queryString += (queryString.length > 0 ? "&" : "") + "$k=$v"));
    String appUrl =
        "$appBaseUrl/$appName/$ServiceAdminServices/$inputQueryData?$queryString"; //paName?$QueryParamFrontendUser=${account.getFrontendId()}
    var url = Uri.parse(appUrl);
    http.Response syncResponse = await http.post(url, headers: <String, String>{
      'authorization': bearer,
      'Content-Type': "application/json",
      "Accept": "application/json"
    });
    String? jwtToken = syncResponse.headers[KeyJwtToken];
    if (jwtToken != null && jwtToken.isNotEmpty) {
      _jwtToken = jwtToken;
    }
    if (syncResponse.statusCode == Status.httpUnauthorized) {
      await getJwtToken(account);
      if (_jwtToken.isNotEmpty) {
        return await makeAdminServicesCall(inputQueryData);
      }
    }
    return syncResponse;
  }

  Future _printIps() async {
    for (var interface in await NetworkInterface.list()) {
      for (var addr in interface.addresses) {
        print(
            '${addr.address} ${addr.host} ${addr.isLoopback} ${addr.rawAddress} ${addr.type.name}');
      }
    }
  }

  static Future<http.Response> registerNotification(String token) async {
    Logger.logInfo("HTTPConnection", "registerNotification",
        "Calling register notification api...");
    if (!kIsWeb) {
      if (!(await URLService.isInternetConnected())) {
        Logger.logDebug("HTTPConnection", "registerNotification",
            "No Internet connection.");
        throw ("No Internet connection. Make sure your device is connected to the network and try again.");
      }
    }

    UnviredAccount? account =
        await AuthenticationService().getSelectedAccount();

    String appName = AuthenticationService().getAppName();

    String bearer = bearerAuth;

    if (account == null || bearer.isEmpty) {
      Logger.logDebug("HTTPConnection", "makeAdminServicesCall",
          "Account data not available.");
      throw ("Account data not available.");
    }
    String appBaseUrl = URLService.getApplicationUrl(account.getUrl());
    var queryString = "";
    var postParams = await HTTPConnection.getCommonPostParameters();
    postParams.forEach((k, v) =>
        (queryString += (queryString.length > 0 ? "&" : "") + "$k=$v"));
    String appUrl =
        "$appBaseUrl/$appName/frontendusers/${account.getFrontendId()}/registerforpush/$token?$queryString"; //paName?$QueryParamFrontendUser=${account.getFrontendId()}
    var url = Uri.parse(appUrl);
    http.Response syncResponse = await http.post(url, headers: <String, String>{
      'authorization': bearer,
      'Content-Type': "application/json",
      "Accept": "application/json"
    });
    String? jwtToken = syncResponse.headers[KeyJwtToken];
    if (jwtToken != null && jwtToken.isNotEmpty) {
      _jwtToken = jwtToken;
    }
    if (syncResponse.statusCode == Status.httpUnauthorized) {
      await getJwtToken(account);
      if (_jwtToken.isNotEmpty) {
        return await registerNotification(token);
      }
    }
    return syncResponse;
  }
}

Future<String> getOnetimeTokenFromFWSettingsManager() async {
  try {
    if (!kIsWeb) {
      FrameworkSettingsManager frameworkSettingsManager =
          FrameworkSettingsManager();
      String oneTimeToken = await frameworkSettingsManager
          .getFieldValue(FrameworkSettingsFields.oneTimeToken);
      String feUserId = await frameworkSettingsManager
          .getFieldValue(FrameworkSettingsFields.feUser);

      if (oneTimeToken.isEmpty || feUserId.isEmpty) {
        return "";
      }
      List<String> passCodeAndTime =
          PassCodeGenerator().computePin(oneTimeToken, feUserId);
      return "$ParamOneTimeToken=${passCodeAndTime[0]}&$ParamMessageTime=${passCodeAndTime[1]}";
    }
  } catch (e) {}
  return "";
}
