import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
//import 'package:path_provider_android/path_provider_android.dart';
//import 'package:path_provider_ios/path_provider_ios.dart';
import 'package:unvired_sdk/src/database/database_manager.dart';
import 'package:unvired_sdk/src/helper/framework_settings_manager.dart';
import 'package:unvired_sdk/src/helper/http_connection.dart';
import 'package:unvired_sdk/src/helper/notification_constants.dart';
import 'package:unvired_sdk/src/helper/path_manager.dart';
import 'package:unvired_sdk/src/helper/unvired_account_manager.dart';
import 'package:unvired_sdk/src/helper/user_settings_manager.dart';
import 'package:unvired_sdk/unvired_sdk.dart';
import 'package:xml2json/xml2json.dart';

import 'notification_service.dart';

//Runs in a separate isolate having its own memory
Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // if (Platform.isAndroid) PathProviderAndroid.registerWith();
  // if (Platform.isIOS) PathProviderIOS.registerWith();
  String applicationDirPath = await PathManager.getUploadLogFolderPath();
  Logger.initialize(applicationDirPath);
  Logger.logInfo("NotificationHelper", "_firebaseMessagingBackgroundHandler",
      "Background Notification call...");
  List<UnviredAccount> availableAccounts =
      await UnviredAccountManager().getAllLoggedInAccounts();
  if ((message.data).isEmpty) {
    Logger.logError('NotificationHelper', '_firebaseMessagingBackgroundHandler',
        'Message data is empty');
    return;
  }
  Notification notification = await NotificationHelper().parseNotification(
      message.data, message.notification?.android?.channelId ?? "",
      showBanner: false);
  UnviredAccount account = availableAccounts
      .where(
          (element) => element.getActivationId() == notification.activationId)
      .first;
  if (account.getIsLastLoggedIn()) {
    //Initialize selectedAccount value in the isolate memory
    AuthenticationService().setSelectedAccount(account);
    await DatabaseManager().getAppDB();
    await DatabaseManager().getFrameworkDB();
    String passwordInFw = await UserSettingsManager()
        .getFieldValue(UserSettingsFields.unviredPassword);
    account.setPassword(passwordInFw);

    //Initialize appName value in the isolate memory
    AuthenticationService().setAppName(account.getAppName());

    //Initialize bearer auth value in the isolate memory
    await HTTPConnection.getJwtToken(account);

    SyncEngine().receive();
  }
}

class NotificationHelper {
  late final FirebaseMessaging _messaging;
  String? token;
  late NotificationService notificationService;

  void listenToNotificationStream() =>
      notificationService.behaviorSubject.listen((payload) {});

  registerNotification() async {
    try {
      // 1. Initialize the Firebase app
      await Firebase.initializeApp();
      notificationService = NotificationService();
      listenToNotificationStream();
      notificationService.initializePlatformNotifications();
    } catch (e) {
      Logger.logError(
          "NotificationHelper", "registerNotification", "${e.toString()}");
      return;
    }

    // 2. Instantiate Firebase Messaging
    _messaging = FirebaseMessaging.instance;

    Logger.logInfo("NotificationHelper", "registerNotification",
        "Requesting permission...");
    // 3. On iOS, this helps to take the user permissions
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      String? token = await _messaging.getToken();
      Logger.logInfo("NotificationHelper", "registerNotification",
          "PUSH TOKEN: ${token ?? ""}");
      try {
        Response response = await HTTPConnection.registerNotification(token!);
        if (response.statusCode != 204) {
          // Logger.logError("SyncEngine", "_callDownloadMessages", response.body);
          Logger.logDebug("NotificationHelper", "registerNotification",
              "Failed to register pushId in server ${response.body}");
          return;
        }
        await UnviredAccountManager().setActIdForPush(
            await FrameworkSettingsManager()
                .getFieldValue(FrameworkSettingsFields.activationId));
      } catch (e) {
        Logger.logError(
            "NotificationHelper", "registerNotification", "${e.toString()}");
        return;
      }
      _messaging.onTokenRefresh.listen((token) async {
        Logger.logInfo(
            "NotificationHelper", "refreshToken", "Firebase token refreshed");
        Response response = await HTTPConnection.registerNotification(token);
        if (response.statusCode != 204) {
          // Logger.logError("SyncEngine", "_callDownloadMessages", response.body);
          Logger.logDebug("NotificationHelper", "registerNotification",
              "Failed to register pushId in server ${response.body}");
          var responseObject = jsonDecode(response.body);
          if (responseObject["systemError"] != null &&
              responseObject["systemError"] == 13) {
            await SettingsHelper().clearData();
            DartNotificationCenter.post(
                channel: EventNameSystemError, options: responseObject);
          }
          return;
        }
      });

      // For handling notification when the app is in background
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

      // but not terminated
      FirebaseMessaging.onMessageOpenedApp
          .listen((RemoteMessage message) async {
        if ((message.data).isNotEmpty) {
          await processNotification(
              message.data, message.notification?.android?.channelId ?? "",
              showBanner: false);
        }
      });

      // For handling the received notifications (foreground)
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        // await NotificationService().showNotification();
        if ((message.data).isNotEmpty) {
          await processNotification(
              message.data, message.notification?.android?.channelId ?? "");
        }
      });
    } else {
      Logger.logDebug("NotificationHelper", "registerNotification",
          'User declined or has not accepted permission');
    }
  }

  processNotification(Map<String, dynamic> data, String channelId,
      {bool showBanner = true}) async {
    log(data.toString());
    Notification notification =
        await parseNotification(data, channelId, showBanner: showBanner);
    try {
      String applicationDirPath = await PathManager.getUploadLogFolderPath();
      log(applicationDirPath);
      Logger.initialize(applicationDirPath);
      final String currentActIdForPush =
          await UnviredAccountManager().getActIdForPush();
      Logger.logDebug("NotificationHelper", "registerNotification",
          "Current Act Id for push: " + currentActIdForPush);
      if (currentActIdForPush != notification.activationId) {
        Logger.logDebug("NotificationHelper", "registerNotification",
            "Current Act Id for push and Act id from notification do not match");
        return;
      }
    } catch (e) {
      log(e.toString());
      Logger.logInfo(
          "NotificationHelper", "registerNotification", e.toString());
      return;
    }

    Logger.logInfo("NotificationHelper", "registerNotification",
        'Notification type ${notification.notificationType}');
    if (notification.getNotificationType == NotificationConstants.SYSTEM ||
        notification.getNotificationType == NotificationConstants.USER) {
      if (AuthenticationService().isLoggedIn()) {
        SyncEngine().receive();
      }
    } else if (notification.notificationType ==
        NotificationConstants.ATTACHMENT) {}
  }

  Future<Notification> parseNotification(
      Map<String, dynamic> data, String channelId,
      {bool showBanner = true}) async {
    if (data['data'] == null) {
      Logger.logInfo('NotificationHelper', 'parseNotification',
          'Data is null. Returning new notification object.');
      return Notification();
    }
    String notificationDataXML = data['data'];
    final myTransformer = Xml2Json();
    myTransformer.parse(notificationDataXML);
    Map<String, dynamic> notificationDataJson =
        jsonDecode(myTransformer.toParkerWithAttrs());
    DartNotificationCenter.post(
        channel: EventNameNotification,
        options: notificationDataJson["PushNotification"]);
    Map<String, dynamic> jsonData = {};
    if (notificationDataJson
        .containsKey(NotificationConstants.UNVIRED_PUSH_NOTIFICATION)) {
      jsonData =
          notificationDataJson[NotificationConstants.UNVIRED_PUSH_NOTIFICATION];
    } else if (notificationDataJson
        .containsKey(NotificationConstants.INDIENCE_PUSH_NOTIFICATION)) {
      jsonData = notificationDataJson[
          NotificationConstants.INDIENCE_PUSH_NOTIFICATION];
    } else if (notificationDataJson
        .containsKey(NotificationConstants.INDIENCE_PUSH_NOTIFICATION_TEMP)) {
      jsonData = notificationDataJson[
          NotificationConstants.INDIENCE_PUSH_NOTIFICATION_TEMP];
    }
    notificationService = NotificationService();
    listenToNotificationStream();
    notificationService.initializePlatformNotifications();
    String applicationDirPath = await PathManager.getUploadLogFolderPath();
    Logger.initialize(applicationDirPath);
    Logger.logInfo("NotificationHelper", "parseNotification",
        "Before Notification display...");
    if (jsonData[NotificationConstants.TYPE] != null &&
        jsonData[NotificationConstants.TYPE] == NotificationConstants.USER &&
        showBanner) {
      await notificationService.showNotification(
          title: jsonData[NotificationConstants.PUSH_NOTIFICATION_TITLE] ?? "",
          body: jsonData[NotificationConstants.PUSH_NOTIFICATION_MESSAGE] ?? "",
          channelId: channelId);
    }
    Notification notification = Notification();
    if (jsonData.isNotEmpty) {
      notification.setNotificationType(jsonData[NotificationConstants.TYPE]);
      if (jsonData
          .containsKey(NotificationConstants.PUSH_NOTIFICATION_MESSAGE)) {
        notification.setAlert(
            jsonData[NotificationConstants.PUSH_NOTIFICATION_MESSAGE]);
      }
      if (jsonData.containsKey(NotificationConstants.PUSH_NOTIFICATION_TITLE)) {
        notification
            .setTitle(jsonData[NotificationConstants.PUSH_NOTIFICATION_TITLE]);
      }
      if (jsonData
          .containsKey(NotificationConstants.PUSH_NOTIFICATION_ACTION_BUTTON)) {
        notification.setActionButton(
            jsonData[NotificationConstants.PUSH_NOTIFICATION_ACTION_BUTTON]);
      }
      if (jsonData
          .containsKey(NotificationConstants.PUSH_NOTIFICATION_SILENT)) {
        notification.setSilent(
            jsonData[NotificationConstants.PUSH_NOTIFICATION_SILENT]
                    .toString() ==
                'true');
      }
      if (jsonData.containsKey(NotificationConstants.PUSH_NOTIFICATION_COUNT)) {
        notification.setBadge(int.parse(
            jsonData[NotificationConstants.PUSH_NOTIFICATION_COUNT]
                .toString()));
      }
      if (jsonData
          .containsKey(NotificationConstants.PUSH_NOTIFICATION_CATEGORY)) {
        notification.setCategory(
            jsonData[NotificationConstants.PUSH_NOTIFICATION_CATEGORY]);
      }
      if (jsonData.containsKey(NotificationConstants.PUSH_NOTIFICATION_SOUND)) {
        notification
            .setSound(jsonData[NotificationConstants.PUSH_NOTIFICATION_SOUND]);
      }
      if (jsonData
          .containsKey(NotificationConstants.PUSH_NOTIFICATION_ATTACHMENT_ID)) {
        notification.setAttachmentUID(
            jsonData[NotificationConstants.PUSH_NOTIFICATION_ATTACHMENT_ID]);
      }
      if (jsonData
          .containsKey(NotificationConstants.PUSH_NOTIFICATION_CONTEXT)) {
        notification.setNotificationContext(
            jsonData[NotificationConstants.PUSH_NOTIFICATION_CONTEXT]);
      }
      if (jsonData
          .containsKey(NotificationConstants.PUSH_NOTIFICATION_ACTIVATION_ID)) {
        notification.setActivationId(
            jsonData[NotificationConstants.PUSH_NOTIFICATION_ACTIVATION_ID]);
      }
    }
    return notification;
  }
}

class Notification {
  String? notificationType = "";

  // The message
  String? alert = "";

  // The title
  String? title = "";

  // The text for the button in case of an action
  String? actionButton = "";

  // Silent notification or to be displayed
  bool? silent = false;

  // The count of messages for the badge
  int? badge = 0;

  // The category for actions
  String? category = "";

  // The sound file to play, else default
  String? sound = "default";

  // The attachment ID if its an attachment notification
  String? attachmentUID = "";

  // The business context data to be sent to the device
  String? notificationContext = "";

  // Activation Id
  String? activationId = "";

  Notification(
      {this.notificationType,
      this.alert,
      this.title,
      this.actionButton,
      this.silent,
      this.badge,
      this.category,
      this.sound,
      this.attachmentUID,
      this.notificationContext,
      this.activationId});

  setNotificationType(String? notificationType) {
    this.notificationType = notificationType;
  }

  setAlert(String? alert) {
    this.alert = alert;
  }

  setTitle(String? title) {
    this.title = title;
  }

  setActionButton(String? actionButton) {
    this.actionButton = actionButton;
  }

  setSilent(bool? silent) {
    this.silent = silent;
  }

  setBadge(int? badge) {
    this.badge = badge;
  }

  setCategory(String? category) {
    this.category = category;
  }

  setSound(String? sound) {
    this.sound = sound;
  }

  setAttachmentUID(String? attachmentUID) {
    this.attachmentUID = attachmentUID;
  }

  setNotificationContext(String? notificationContext) {
    this.notificationContext = notificationContext;
  }

  setActivationId(String? activationId) {
    this.activationId = activationId;
  }

  String? get getNotificationType => this.notificationType;

  String? get getAlert => this.alert;

  String? get getTitle => this.title;

  String? get getActionButton => this.actionButton;

  bool? get getSilent => this.silent;

  int? get getBadge => this.badge;

  String? get getCategory => this.category;

  String? get getSound => this.sound;

  String? get getAttachmentUID => this.attachmentUID;

  String? get getNotificationContext => this.notificationContext;

  String? get getActivationId => this.activationId;
}
