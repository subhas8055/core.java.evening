import 'dart:convert';
import 'dart:developer';

import 'package:drift/isolate.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:async_task/async_task_extension.dart';
import 'package:flutter/foundation.dart';
import 'package:isolated_worker/isolated_worker.dart';
import 'package:unvired_sdk/src/helper/connectivity_manager.dart';
import 'package:unvired_sdk/src/helper/settings_helper.dart';
import 'package:unvired_sdk/src/notification_center/dart_notification_center.dart';
import 'package:unvired_sdk/src/sync_engine.dart';
import 'package:unvired_sdk/unvired_sdk.dart';

import '../database/database_manager.dart';
import '../helper/framework_settings_manager.dart';
import '../helper/passcode_generator.dart';
import '../helper/status.dart';
import '../application_meta/field_constants.dart';
import '../attachment/attachment_downloader.dart';
import '../database/framework_database.dart';
import '../helper/event_handler_constants.dart';
import '../helper/framework_helper.dart';
import '../helper/http_connection.dart';
import '../helper/isolate_helper.dart';
import '../helper/server_response_handler.dart';
import '../helper/service_constants.dart';
import '../outbox/outbox_service.dart';
import '../unvired_account.dart';
import 'hive_inbox_data_manager.dart';

class DownloadMessageService {
  static bool _isPaused = false;
  static bool _isRunning = false;
  static String _threadStatus = "";

  static String get threadStatus => _threadStatus;

  static bool get isRunning => _isRunning;

  static bool get isPaused => _isPaused;

  DownloadMessageService() {}

  checkAndStartDownloadMessageService() async {
    Logger.logDebug("SyncEngine", "receive", "Receiving messages..");
    Logger.logDebug("SyncEngine", "receive",
        "DownloadMessageService Status -- ${DownloadMessageService.threadStatus}");

    // if (DownloadMessageService.threadStatus !=
    //         ServiceThreadStatus.Running.toString()
    //     //     && AttachmentService.threadStatus!=ServiceThreadStatus.Running.toString()
    //     // && OutBoxService.threadStatus!=ServiceThreadStatus.Running.toString()
    //     ) {
    if (!kIsWeb) {
      bool connectionStatus = await ConnectivityManager().checkConnection();
      if (connectionStatus) {
        start();
      } else {
        Logger.logDebug("SyncEngine", "receive",
            "No internet connection to download message");
        if (!ConnectivityManager().isDownloadMessageListening) {
          ConnectivityManager().isDownloadMessageListening = true;
          ConnectivityManager().notifyConnection();
          DartNotificationCenter.registerChannel(
              channel: EventNameConnectionStatus);
          DartNotificationCenter.subscribe(
              channel: EventNameConnectionStatus,
              observer: this,
              onNotification: (data) async {
                if (data == online) {
                  DownloadMessageService().start();
                  DartNotificationCenter.unsubscribe(observer: this);
                  DartNotificationCenter.unregisterChannel(
                      channel: EventNameConnectionStatus);
                  ConnectivityManager().isDownloadMessageListening = false;
                }
              });
        }
      }
    } else {
      start();
    }

    // } else {
    //   Logger.logDebug("SyncEngine", "receive",
    //       "DownloadMessageService Status -- ${DownloadMessageService.threadStatus}");
    // }
  }

  void start() async {
    if (_isRunning) {
      String message = "Download Message Service is already running....";
      Logger.logInfo("Download Message Service", "start", message);
      return;
    }
    Logger.logInfo("Download Message Service", "start",
        "Started Download Message Service");
    _threadStatus = ServiceThreadStatus.Running.toString();

    Map<String, dynamic> map = await getDownloadMessageServiceMap();
    if (!kIsWeb) {
      try {
        _isRunning = true;
        IsolatedWorker().run(checkAndDownloadMessages, map);
      } catch (e) {
        _isRunning = false;
        Logger.logError("Download Message Service", "start", e.toString());
        stop();
      }
    } else {
      await checkAndDownloadMessages(map);
    }
  }

  void stop() async {
    if (_threadStatus == ServiceThreadStatus.Running.toString()) {
      _isRunning = false;
      _threadStatus = ServiceThreadStatus.Done.toString();
      Logger.logDebug("Download Message Service", "stop",
          "Download Message Service finished......");
      await AttachmentDownloader().checkAndStartAttachmentService();
    } else {
      Logger.logError("Download Message Service", "stop",
          "Download Message Service is not running to stop");
      //throw ("Download Message Service is not running");
    }
  }
}

checkAndDownloadMessages(Map<String, dynamic> map) async {
  try {
    String? appBaseUrl = map['appBaseUrl'];
    String? baseUrlAcknowlegement = map['baseUrlAcknowlegement'];
    String? attachmentFolderPath = map['attachmentFolderPath'];
    String? appName = map['appName'];
    String? authToken = map['authToken'];
    String? inboxPath = map['inboxPath'];
    String? appDirPath = map['appDirPath'];
    UnviredAccount? _selectedAccount = map['unviredAccount'];
    selectedAccount = _selectedAccount;
    Logger.initialize(appDirPath!);
    if (!kIsWeb) {
      Logger.initialize(appDirPath);
    }
    if (frameworkDatabaseIsolate == null) {
      frameworkDatabaseIsolate = await getWorkerFrameWorkDatabase(map);
    }
    if (appDatabaseIsolate == null) {
      appDatabaseIsolate = await getWorkerAppDatabase(map);
    }
    await downloadMessage(
        appBaseUrl!,
        baseUrlAcknowlegement!,
        attachmentFolderPath!,
        appName!,
        authToken!,
        inboxPath!,
        appDirPath,
        _selectedAccount!,
        map);
  } catch (e) {
    Logger.logError(
        "Download Message Service", "checkAndDownloadMessages", e.toString());
    stopDownloadMessage(map);
  }
}

downloadMessage(
    String appBaseUrl,
    String baseUrlAcknowlegement,
    String attachmentFolderPath,
    String appName,
    String authToken,
    String inboxPath,
    String appDirPath,
    UnviredAccount selectedAccount,
    Map<String, dynamic> map) async {
  try {
    Logger.logInfo("Download Message Service", "downloadMessage",
        "downloadMessageService");
    http.Response result = await downloadMessageService(
        selectedAccount, authToken, appBaseUrl, appName);
    if (result.statusCode == Status.httpOk) {
      try {
        Logger.logInfo("Download Message Service", "downloadMessage",
            "downloadMessageService result");
        Map<String, dynamic> responseData =
            jsonDecode(jsonDecode(result.body.replaceAll('\"', '"')));
        String? conversationId =
            result.headers[HeaderConstantConversationId.toLowerCase()];
        String? requestType =
            result.headers[HeaderConstantRequestType.toLowerCase()];
        dynamic pendingMessageCount =
            result.headers[HeaderConstantNumberOfPendingMessages.toLowerCase()];
        int type = -1;
        int subType = -1;
        String appId = "";
        String serverId = "";
        String applicationName = "";

        if (responseData.containsKey(Type) &&
            responseData.containsKey(Subtype)) {
          type = responseData[Type];
          subType = responseData[Subtype];
          appId = responseData[ApplicationId];
          serverId = responseData[ServerId];
          applicationName = responseData[AppName];
        }
        if (conversationId != null && requestType != null) {
          List<SentItem>? sentItems =
              await (await DatabaseManager().getFrameworkDB()).allSentItems;
          String entityName = "";
          String beLid = "";
          if (sentItems != null && sentItems.length > 0) {
            for (SentItem sentItem in sentItems) {
              if (sentItem.conversationId.toString() == conversationId) {
                entityName = sentItem.beName;
                beLid = sentItem.beHeaderLid;
              }
            }
          }
          int inboxCount =
              (await frameworkDatabaseIsolate!.allInObjects).length;
          int outboxCount =
              (await frameworkDatabaseIsolate!.allOutObjects).length;
          int sentItemsCount =
              (await frameworkDatabaseIsolate!.allSentItems).length;
          Map<String, dynamic> data = {
            messageServiceType: EventNameSyncStatus,
            EventSyncStatusFieldType: EventSyncStatusTypeReceived,
            EventSyncStatusFieldConversationId: conversationId,
            EventSyncStatusFieldInboxCount: inboxCount,
            EventSyncStatusFieldOutboxCount: outboxCount,
            EventSyncStatusFieldSentItemsCount: sentItemsCount
          };
          notifyDownloadMessage(data, map);
          InObjectData inObjectData = InObjectData(
              lid: FrameworkHelper.getUUID(),
              timestamp: DateTime.now().millisecondsSinceEpoch,
              objectStatus: ObjectStatus.global.index,
              syncStatus: SyncStatus.none.index,
              conversationId: conversationId,
              requestType: requestType,
              jsonData: entityName,
              beLid: beLid,
              subtype: subType,
              serverId: serverId,
              type: type,
              appName: applicationName,
              appId: appId);
          try {
            Logger.logInfo("Download Message Service", "downloadMessage",
                "acknowledgeMessageService");
            int isConversationIdPresent =
                (await frameworkDatabaseIsolate!.allInObjects).indexWhere(
                    (element) => element.conversationId == conversationId);
            if (isConversationIdPresent == (-1)) {
              //conv iD does not exist in in object

              await frameworkDatabaseIsolate!.transaction(() async {
                return await frameworkDatabaseIsolate!
                    .addInObject(inObjectData);
              });
              if (!responseData.containsKey(Type) &&
                  !responseData.containsKey(Subtype)) {
                // Add inbox data only if the response has BE data, Do not add in case of type and subtype messages(log request/data export)
                await addInBoxData(
                    inboxPath, selectedAccount, conversationId, responseData);
                await frameworkDatabaseIsolate!.deleteSentItem(conversationId);
              }
            }
            http.Response response = await acknowledgeMessageService(
                conversationId,
                selectedAccount,
                authToken,
                baseUrlAcknowlegement,
                appName);
            if (response.statusCode != 204) {
              // Logger.logError("SyncEngine", "_callDownloadMessages", response.body);
              Logger.logDebug("Download Message Service", "downloadMessage",
                  "${response.body}");
              // stopDownloadMessage(map);
              if (result.statusCode == Status.httpGone) {
                var responseObject = jsonDecode(response.body);
                if (responseObject["systemError"] != null &&
                    responseObject["systemError"] == 13) {
                  responseObject[messageServiceType] = EventNameSystemError;
                  notifyDownloadMessage(responseObject, map);
                  stopDownloadMessage(map);
                  return;
                }
              }
              await downloadMessage(
                  appBaseUrl,
                  baseUrlAcknowlegement,
                  attachmentFolderPath,
                  appName,
                  authToken,
                  inboxPath,
                  appDirPath,
                  selectedAccount,
                  map);
            }
          } catch (e) {
            Logger.logError("Download Message Service", "downloadMessage",
                "Failed to add InObjectData to Inbox ${e.toString()}");
            if (frameworkDatabaseIsolate == null) {
              Logger.logError("Download Message Service", "downloadMessage",
                  "frameworkDatabaseIsolate is null");
              frameworkDatabaseIsolate = await getWorkerFrameWorkDatabase(map);
            } else {
              Logger.logInfo("Download Message Service", "downloadMessage",
                  "frameworkDatabaseIsolate is not null");
            }

            if (appDatabaseIsolate == null) {
              Logger.logError("Download Message Service", "downloadMessage",
                  "appDatabaseIsolate is null");
              appDatabaseIsolate = await getWorkerAppDatabase(map);
            } else {
              Logger.logInfo("Download Message Service", "downloadMessage",
                  "appDatabaseIsolate is not null");
            }
            stopDownloadMessage(map);
            // throw ("Failed to add InObjectData to Inbox ${e.toString()}");
          }
        }
        if (pendingMessageCount != null && int.parse(pendingMessageCount) > 0) {
          await downloadMessage(
              appBaseUrl,
              baseUrlAcknowlegement,
              attachmentFolderPath,
              appName,
              authToken,
              inboxPath,
              appDirPath,
              selectedAccount,
              map);
        } else {
          await startInboxProcessing(selectedAccount, inboxPath, map);
          stopDownloadMessage(map);
        }
      } catch (e) {
        Logger.logError("Download Message Service", "downloadMessage",
            "downloadMessageService result - Failed ${e.toString()}");
        if (frameworkDatabaseIsolate == null) {
          Logger.logError("Download Message Service", "downloadMessage",
              "frameworkDatabaseIsolate is null");
          frameworkDatabaseIsolate = await getWorkerFrameWorkDatabase(map);
        } else {
          Logger.logInfo("Download Message Service", "downloadMessage",
              "frameworkDatabaseIsolate is not null");
        }

        if (appDatabaseIsolate == null) {
          Logger.logError("Download Message Service", "downloadMessage",
              "appDatabaseIsolate is null");
          appDatabaseIsolate = await getWorkerAppDatabase(map);
        } else {
          Logger.logInfo("Download Message Service", "downloadMessage",
              "appDatabaseIsolate is not null");
        }
        stopDownloadMessage(map);
      }
    } else if (result.statusCode == Status.httpGone) {
      Map<String, dynamic> response =
          jsonDecode(result.body.replaceAll('\"', '"'));
      response[messageServiceType] = EventNameSyncStatus;
      if (response["systemError"] != null && response["systemError"] == 13) {
        response[messageServiceType] = EventNameSystemError;
      }
      notifyDownloadMessage(response, map);
      stopDownloadMessage(map);
    } else {
      Map<String, dynamic> response = result.body.isEmpty
          ? {}
          : jsonDecode(result.body.replaceAll('\"', '"'));
      Logger.logError("Download Message Service", "downloadMessage",
          "checkAndDownloadMessages ${response.toString()}");
      stopDownloadMessage(map);
    }
  } catch (e) {
    Logger.logError("Download Message Service", "downloadMessage",
        "downloadMessageService - Failed ${e.toString()}");
    if (frameworkDatabaseIsolate == null) {
      Logger.logError("Download Message Service", "downloadMessage",
          "frameworkDatabaseIsolate is null");
      frameworkDatabaseIsolate = await getWorkerFrameWorkDatabase(map);
    } else {
      Logger.logInfo("Download Message Service", "downloadMessage",
          "frameworkDatabaseIsolate is not null");
    }

    if (appDatabaseIsolate == null) {
      Logger.logError("Download Message Service", "downloadMessage",
          "appDatabaseIsolate is null");
      appDatabaseIsolate = await getWorkerAppDatabase(map);
    } else {
      Logger.logInfo("Download Message Service", "downloadMessage",
          "appDatabaseIsolate is not null");
    }
    stopDownloadMessage(map);
  }
}

startInboxProcessing(UnviredAccount? selectedAccount, String inboxPath,
    Map<String, dynamic> map) async {
  Logger.logDebug("Download Message Service", "startInboxProcessing",
      "starting inbox processing....");
  List<InObjectData> inObjectData =
      await frameworkDatabaseIsolate!.allInObjects;
  if (inObjectData.isEmpty) {
    Logger.logDebug("Download Message Service", "startInboxProcessing",
        "Inbox is empty stopping service...");
    // sendPort.send("stopInbox");
    return;
  }
  Logger.logDebug("Download Message Service", "startInboxProcessing",
      "Total inbox items : ${inObjectData.length.toString()}");
  for (int i = 0; i < inObjectData.length; i++) {
    Logger.logDebug("Download Message Service", "startInboxProcessing",
        "Processing LID : ${inObjectData[i].lid} Processing INBOX ITEM :  ${i.toString()}");

    InObjectData inObject = inObjectData[i];

    try {
      if (inObject.type != -1 && inObject.subtype != -1) {
        await handleMessageTypes(inObject, map);
        await frameworkDatabaseIsolate!.transaction(() async {
          return await frameworkDatabaseIsolate!
              .deleteInObject(inObject.conversationId);
        });
      } else {
        Map<String, dynamic> jsonData = await getInboxData(
            selectedAccount, inboxPath, inObject.conversationId);
        // await appDatabaseIsolate!.transaction(() async{
        await ServerResponseHandler.handleResponseData(jsonData,
            requestType:
                FrameworkHelper.getRequestTypeFromString(inObject.requestType),
            isFromIsolate: true,
            map: map,
            entityName: inObject.jsonData,
            lid: inObject.beLid);

        await frameworkDatabaseIsolate!.transaction(() async {
          return await frameworkDatabaseIsolate!
              .deleteInObject(inObject.conversationId);
        });
      }

      //});
    } catch (e) {
      stopDownloadMessage(map);
      Logger.logError(
          "Download Message Service", "startInboxProcessing", e.toString());
    }
    if (i == (inObjectData.length - 1)) {
      int inboxCount = (await frameworkDatabaseIsolate!.allInObjects).length;
      int outboxCount = (await frameworkDatabaseIsolate!.allOutObjects).length;
      int sentItemsCount =
          (await frameworkDatabaseIsolate!.allSentItems).length;
      Map<String, dynamic> data = {
        messageServiceType: EventNameSyncStatus,
        EventSyncStatusFieldType: EventSyncStatusTypeInboxProcessingComplete,
        EventSyncStatusFieldConversationId: "",
        EventSyncStatusFieldInboxCount: inboxCount,
        EventSyncStatusFieldOutboxCount: outboxCount,
        EventSyncStatusFieldSentItemsCount: sentItemsCount
      };
      notifyDownloadMessage(data, map);
      List<InObjectData>? inObjectData =
          await frameworkDatabaseIsolate!.allInObjects;
      if (inObjectData != null && inObjectData.isNotEmpty) {
        await startInboxProcessing(selectedAccount, inboxPath, map);
      } else {
        return;
      }
    }
  }
}

handleMessageTypes(InObjectData inObject, Map<String, dynamic> map) async {
  int messageType = inObject.type;
  int subType = inObject.subtype;
  switch (messageType) {
    case MESSAGE_TYPE_SYSTEM:
      await systemMessageHandler(subType, map);
      return;
      break;

    default:
      return;
  }

  return;
}

systemMessageHandler(int subType, Map<String, dynamic> map) async {
  switch (subType) {
    case MESSAGE_SUBTYPE_SYSTEM_PING:
      Map<String, dynamic> data = {
        messageServiceType: MESSAGE_SUBTYPE_SYSTEM_PING.toString(),
      };
      notifyDownloadMessage(data, map);
      return;

    case MESSAGE_SUBTYPE_SYSTEM_LOG:
      Map<String, dynamic> data = {
        messageServiceType: MESSAGE_SUBTYPE_SYSTEM_LOG.toString(),
      };
      notifyDownloadMessage(data, map);
      return;
      break;

    case MESSAGE_SUBTYPE_SYSTEM_LOG_RESET:
      Map<String, dynamic> data = {
        messageServiceType: MESSAGE_SUBTYPE_SYSTEM_LOG_RESET.toString(),
      };
      notifyDownloadMessage(data, map);
      return;

    case MESSAGE_SUBTYPE_SYSTEM_LOG_SET_DEBUG:
      Map<String, dynamic> data = {
        messageServiceType: MESSAGE_SUBTYPE_SYSTEM_LOG_SET_DEBUG.toString(),
      };
      notifyDownloadMessage(data, map);
      return;

    case MESSAGE_SUBTYPE_SYSTEM_LOG_SET_ERROR:
      Map<String, dynamic> data = {
        messageServiceType: MESSAGE_SUBTYPE_SYSTEM_LOG_SET_ERROR.toString(),
      };
      notifyDownloadMessage(data, map);
      return;

    case MESSAGE_SUBTYPE_SYSTEM_DATA_DUMP:
      Map<String, dynamic> data = {
        messageServiceType: MESSAGE_SUBTYPE_SYSTEM_DATA_DUMP.toString(),
      };
      notifyDownloadMessage(data, map);
      return;
      break;

    default:
      return;
  }
}

Future<http.Response> downloadMessageService(UnviredAccount? account,
    String bearerAuth, String appBaseUrl, String appName) async {
  if (account == null) {
    Logger.logDebug("Download Message Service", "downloadMessageService",
        "Account data not available.");
    throw ("Account data not available.");
  }
  if (bearerAuth.isEmpty) {
    String _jwtToken = await getJwtTokenService(account, appBaseUrl, appName);
    if (_jwtToken.isNotEmpty) {
      bearerAuth = "Bearer $_jwtToken";
    }
  }
  if (bearerAuth.isEmpty) {
    Logger.logDebug("Download Message Service", "downloadMessageService",
        "bearerAuth data not available.");
    throw ("Auth data not available.");
  }
  String oneTimeToken = await getOnetimeToken();
  if (oneTimeToken.isNotEmpty) {
    oneTimeToken = "?$oneTimeToken";
  }
  String appUrl =
      "$appBaseUrl/$appName/$ServiceMessage/${account.getFrontendId()}$oneTimeToken";
  var url = Uri.parse(appUrl);
  http.Response syncResponse = await http
      .get(url, headers: <String, String>{'authorization': bearerAuth});
  if (syncResponse.statusCode == Status.httpUnauthorized) {
    String _jwtToken = await getJwtTokenService(account, appBaseUrl, appName);
    if (_jwtToken.isNotEmpty) {
      bearerAuth = "Bearer $_jwtToken";
      return await downloadMessageService(
          account, bearerAuth, appBaseUrl, appName);
    }
  }
  return syncResponse;
}

Future<String> getOnetimeToken() async {
  try {
    if (!kIsWeb) {
      FrameworkSetting? frameworkSettingForOneTimeToken =
          await frameworkDatabaseIsolate!.getFrameworkSetting("oneTimeToken");
      String oneTimeToken = frameworkSettingForOneTimeToken!.fieldValue;
      FrameworkSetting? frameworkSettingForfeUserId =
          await frameworkDatabaseIsolate!.getFrameworkSetting("feUser");
      String feUserId = frameworkSettingForfeUserId!.fieldValue;
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

Future<String> getJwtTokenService(
    UnviredAccount? selectedAccount, String appBaseUrl, String appName) async {
  if (!kIsWeb) {
    if (!(await checkConnectionInIsolate())) {
      Logger.logDebug("Download Message Service", "getJwtTokenService",
          "No Internet connection.");
      throw ("No Internet connection. Make sure your device is connected to the network and try again.");
    }
  }

  UnviredAccount? account = selectedAccount;
  if (account == null) {
    Logger.logDebug("Download Message Service", "getJwtTokenService",
        "Account data not available.");
    throw ("Account data not available.");
  }

  if (account.getUrl().isEmpty) {
    Logger.logError(
        "Download Message Service", "getJwtTokenService", "URL is empty.");
    throw ("URL is empty.");
  }

  if (account.getFrontendId().isEmpty) {
    Logger.logError("Download Message Service", "getJwtTokenService",
        "Frontend is not set.");
    throw ("Frontend is not set.");
  }

// Make get JWT Token call
  Logger.logDebug("Download Message Service", "getJwtTokenService",
      "Get JWT Token REST api is called.");

  String unviredAccountPassword = account.getPassword();
  if (unviredAccountPassword.isEmpty) {
    FrameworkSetting? fwUnviredPwd =
        await frameworkDatabaseIsolate!.getFrameworkSetting("unviredPassword");
    if (fwUnviredPwd != null) {
      unviredAccountPassword = fwUnviredPwd.fieldValue;
    }
  }

  String oneTimeToken = await getOnetimeToken();
  if (oneTimeToken.isNotEmpty) {
    oneTimeToken = "&$oneTimeToken";
  }

  if (oneTimeToken.isNotEmpty) {
    oneTimeToken = "&$oneTimeToken";
  }
  String appUrl =
      "$appBaseUrl/$appName/$ServiceSession?$QueryParamFrontendUser=${account.getFrontendId()}$oneTimeToken";

  String userName = (account.getLoginType() == LoginType.sap ||
          account.getLoginType() == LoginType.ads)
      ? account.getUnviredUser()
      : account.getUserName();
  String password = account.getLoginType() == LoginType.passwordless
      ? account.getUnviredUserPwd()
      : unviredAccountPassword;

  String basicAuth = "";
  switch (account.getLoginType()) {
    case LoginType.ads:
    case LoginType.sap:
      {
        String inp =
            "${account.getCompany()}\\${account.getDomain()}\\${userName}:${password}";
        basicAuth = 'Basic ' + base64Encode(utf8.encode(inp));
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
  http.Response jwtResponse = await http
      .post(url, headers: <String, String>{'authorization': basicAuth});
  Logger.logDebug("Download Message Service", "getJwtTokenService",
      "Activation REST api response code: ${jwtResponse.statusCode}");
  Map<String, dynamic> jwtResponseObject = jsonDecode(jwtResponse.body);
  String _jwtToken = "";
  if (jwtResponse.statusCode == Status.httpCreated) {
    _jwtToken = jwtResponseObject[KeyToken];
  } else if (jwtResponse.statusCode == Status.httpUnauthorized) {
    //FrameworkHelper.clearData((await AuthenticationService().getSelectedAccount())!);
    Logger.logError("Download Message Service", "getJwtTokenService",
        "Unauthorized error. Error - ${jwtResponseObject.toString()}");
  } else {
    Logger.logError("Download Message Service", "getJwtTokenService",
        "Error while getting jwt token. Error - ${jwtResponseObject.toString()}");
  }
  return _jwtToken;
}

Future<http.Response> acknowledgeMessageService(
    String convId,
    UnviredAccount account,
    String bearerAuth,
    String appBaseUrl,
    String appName) async {
  if (!kIsWeb) {
    if (!(await checkConnectionInIsolate())) {
      Logger.logDebug("Download Message Service", "acknowledgeMessageService",
          "No Internet connection.");
      throw ("No Internet connection. Make sure your device is connected to the network and try again.");
    }
  }

  if (account.getUrl().isEmpty) {
    Logger.logError("Download Message Service", "acknowledgeMessageService",
        "URL is empty.");
    throw ("URL is empty.");
  }

  if (bearerAuth.isEmpty) {
    String _jwtToken = await getJwtTokenService(account, appBaseUrl, appName);
    if (_jwtToken.isNotEmpty) {
      bearerAuth = "Bearer $_jwtToken";
    }
  }

  if (bearerAuth.isEmpty) {
    Logger.logDebug("Download Message Service", "acknowledgeMessageService",
        "bearerAuth data not available.");
    throw ("Auth data not available.");
  }

  String oneTimeToken = await getOnetimeToken();
  if (oneTimeToken.isNotEmpty) {
    oneTimeToken = "?$oneTimeToken";
  }
  String appUrl =
      "$appBaseUrl$ServiceMessages/$ServiceFrontendUsers/${account.getFrontendId()}/$ServiceConversation/$convId$oneTimeToken";
  var url = Uri.parse(appUrl);

  Logger.logDebug("Download Message Service", "acknowledgeMessageService",
      "Acknowledge message api is called.");

  http.Response sessionResponse = await http
      .delete(url, headers: <String, String>{'authorization': bearerAuth});
  Logger.logDebug("Download Message Service", "acknowledgeMessageService",
      "Acknowledge message api response code: ${sessionResponse.statusCode}");
  return sessionResponse;
}
