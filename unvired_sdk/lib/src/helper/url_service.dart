import 'package:connectivity_plus/connectivity_plus.dart';

import '../authentication_service.dart';
import '../helper/service_constants.dart';

class URLService {
  static String sanitizeLoginURL(String loginURL) {
    if (loginURL.endsWith("UMP") ||
        loginURL.endsWith("UMP/") ||
        loginURL.endsWith("?local")) {
      return loginURL;
    }
    if (!loginURL.endsWith("/")) {
      loginURL += "/";
    }
    loginURL += "UMP";
    return loginURL;
  }

  static String getBaseUrl(String baseUrl) {
    if (baseUrl.isEmpty) {
      return "";
    }
    if (!baseUrl.endsWith("/")) {
      baseUrl += "/";
    }
    baseUrl += ServiceApiVersion;
    return baseUrl;
  }

  static String getSessionUrl(String baseUrl) {
    String sessionUrl = getBaseUrl(baseUrl);
    sessionUrl += ServiceSession;
    return sessionUrl;
  }

  static String getApplicationUrl(String baseUrl) {
    String appUrl = getBaseUrl(baseUrl);
    appUrl += ServiceApplications;
    return appUrl;
  }

  static String getPingUrl(String baseUrl) {
    String appUrl = getBaseUrl(baseUrl);
    appUrl += ServiceStatus + "/" + AdminServicePing;
    return appUrl;
  }

  static String getLoginTypeString(LoginType loginType) {
    String loginTypeString = "";
    switch (loginType) {
      case LoginType.unvired:
        loginTypeString = LoginTypeUnviredId;
        break;
      case LoginType.ads:
        loginTypeString = LoginTypeADS;
        break;
      case LoginType.sap:
        loginTypeString = LoginTypeSAP;
        break;
      case LoginType.email:
        loginTypeString = LoginTypeEmail;
        break;
      case LoginType.custom:
        loginTypeString = LoginTypeCustom;
        break;
      default:
    }
    return loginTypeString;
  }

  static Future<bool> isInternetConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else if (connectivityResult == ConnectivityResult.ethernet) {
      return true;
    }
    return false;
  }

  static String getURLEncodedData(String data) {
    const start = "&$QueryParamInputMessage=";
    const end = "&$QueryParamRequestType=";

    if (!data.contains(start)) {
      return data;
    }

    if (!data.contains(end)) {
      return data;
    }

    final startIndex = data.indexOf(start);
    final endIndex = data.indexOf(end, startIndex + start.length);

    var startString = data.substring(0, startIndex + start.length);

    var content = data.substring(startIndex + start.length, endIndex);

    var endString = data.substring(endIndex);

    return startString + Uri.encodeQueryComponent(content) + endString;
  }
}
