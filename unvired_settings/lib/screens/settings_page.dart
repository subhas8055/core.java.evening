import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:unvired_sdk/unvired_sdk.dart';
import 'package:unvired_settings/screens/infoMessages.dart';
import 'package:unvired_settings/screens/new_password.dart';
import 'package:unvired_settings/screens/status_screen.dart';
import 'package:unvired_settings/screens/system_credentials.dart';
import 'package:unvired_settings/utils/bot_toast.dart';
import 'package:unvired_settings/widgets/fetch_new_data_widget.dart';
import 'package:unvired_settings/widgets/http_timeout_widget.dart';
import 'package:unvired_settings/widgets/notifications_widget.dart';

import '../model/config.dart';
import '../model/navigation.dart';
import '../model/theme.dart';
import '../utils/constants.dart';
import 'about_us.dart';
import 'location_tracking.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static const sourceClass = "_SettingsPageState";
  int inboxCount = 0, outBoxCount = 0, sentCount = 0, attachmentsCount = 0, systemCredentialsCount = 0;
  String status = '', connectionStatus = 'Loading...';
  String httpTimeOutStatus = '';
  String notificationStatus = '';
  String fetchNewDataStatus = '';
  List<String> messageItems = [
    'Inbox',
    'OutBox',
    'Sent',
    'Attachments',
  ];
  late List<SystemCredential> result;
  List<String> attachment = <String>[];
  String attachments = "";
  String appBuildVersion = '';
  String? appVersion = '';
  int timeOutValue = 0, fetchTimeOutValue = 0;
  String? _themeName;
  String? _themePrimaryColor;
  String? _themePrimaryColorDark;
  String? _themeToolbarIcon;
  String? _navigateRoute;
  bool popValue = true;

  //late PackageInfo packageInfo;

  @override
  void initState() {
    _getThemeData();
    //_getNavigateData();
    _getTimeValue();
    _getCount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(popValue),
      child: Scaffold(
        appBar: _getAppBar(),
        body: RefreshIndicator(
          onRefresh: () {
            setState(() {});
            return Future.delayed(const Duration(seconds: 0));
          },
          child: Container(
            width: double.infinity,
            height: double.infinity,
            margin: MediaQuery.of(context).size.width > 700 ? EdgeInsets.symmetric(horizontal: (MediaQuery.of(context).size.width * 20) / 100) : EdgeInsets.all(0),
            child: FutureBuilder(
              future: initSettingsConfigJson(),
              builder: (BuildContext context, AsyncSnapshot<Map<String, List<Config>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) if (snapshot.hasData) {
                  Map<String, List<Config>>? data = snapshot.data;
                  //  log(snapshot.data.toString(),);
                  return ListView.builder(
                    itemCount: data!.length,
                    itemBuilder: (context, index) {
                      return Container(
                        child: Card(
                          elevation: 15,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                child: Container(
                                  margin: EdgeInsets.only(left: 10, top: 10),
                                  child: Text(
                                    data.keys.elementAt(index),
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Divider(
                                    thickness: 1.5,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10, bottom: 10),
                                child: Column(
                                  children: _buildGroupItems(data[data.keys.elementAt(index)]!),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  return Center(
                    child: Text(
                      'Configuring settings...',
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                else
                  return Container(
                    height: 50,
                    width: 50,
                    child: Center(
                      child: Text(''),
                    ),
                  );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<Map<String, List<Config>>> initSettingsConfigJson() async {
    String fwSettings = await DefaultAssetBundle.of(context).loadString("assets/json/settings_config_json.json");

    var configObjList = jsonDecode(fwSettings)['Config'];

    List<Config> configList = [];
    for (var configObj in configObjList) {
      configList.add(
        Config.fromJson(configObj),
      );
    }

    Map<String, List<Config>> mapList = {};
    getLocationInfo();
    tempAsyncMethod();

    for (Config config in configList) {
      if (mapList.containsKey(config.group)) {
        List<Config>? availableConfig = mapList[config.group];
        availableConfig!.add(config);
        mapList[config.group] = availableConfig;
      } else {
        List<Config>? availableConfig = [];
        availableConfig.add(config);
        mapList[config.group] = availableConfig;
      }
    }
    return mapList;
  }

  void getLocationInfo() async {
    var locationTrackingStatus = await SettingsHelper().getLocationTrackingStatus();
    if (locationTrackingStatus == false)
      status = 'DISABLED';
    else
      status = 'ENABLED';
  }

  Future getProjectDetails() async {
    List<InfoMessageData> result = await SettingsHelper().getInfoMessages();
    String infoStr = '''<html><body>''';
    int count = 0;
    infoStr = infoStr + '********ALL INFO MESSAGES********\n';
    result.forEach((element) {
      count += 1;
      infoStr = infoStr + '<br>';
      infoStr = infoStr + '//' + count.toString() + '<br>';
      infoStr = infoStr + element.message + '<br>';
      infoStr = infoStr + 'Category: ' + element.category + '<br>';
      infoStr = infoStr + 'Type: ' + element.type + '<br>';
      infoStr = infoStr + 'Subtype: ' + element.subtype + '<br>';
      infoStr = infoStr + 'BE Name: ' + element.bename + '<br>';
      infoStr = infoStr + 'BE LID: ' + element.belid + '<br>';
    });
    infoStr = infoStr + '<br>********END OF INFO MESSAGES********<br>********VERSION INFORMATION********<br>';
    infoStr = infoStr + 'APPLICATION_BUILD_NUMBER: ' + appBuildVersion + '<br>';
    infoStr = infoStr + 'APPLICATION_REVISION_NUMBER: ' + SettingsHelper().getApplicationRevisionNumber() + '<br>';
    infoStr = infoStr + 'APPLICATION_REVISION_URL: ' + SettingsHelper().getFrameworkRevisionNumber() + '<br>';

    /// not yet done, change later
    infoStr = infoStr + 'APPLICATION_VERSION_NUMBER: ' + appVersion! + '<br>';
    infoStr = infoStr + 'UNVIRED_FRAMEWORK_VERSION_NUMBER: ' + SettingsHelper().getFrameworkVersionNumber() + '<br>';
    infoStr = infoStr + 'UNVIRED_FRAMEWORK_REVISION_NUMBER: ' + SettingsHelper().getFrameworkRevisionNumber() + '<br>';

    infoStr = infoStr + '''</body> </html>''';
    return infoStr;
  }

  /// to send mail
  Future<void> send(BuildContext context) async {
    String infoStr = await getProjectDetails();
    String filePath = await SettingsHelper().createAndGetLogZipPath();
    attachment.add(filePath);

    /// Platform messages may fail, so we use a try/catch PlatformException.
    final MailOptions mailOptions = MailOptions(
      body: infoStr,
      subject: 'Logs - Unvired ',
      recipients: <String>[''],
      isHTML: true,
      // bccRecipients: ['other@example.com'],
      //ccRecipients: <String>[''],
      attachments: attachment,
    );

    var platformResponse;

    try {
      final MailerResponse response = await FlutterMailer.send(mailOptions);
      switch (response) {
        case MailerResponse.saved:
          platformResponse = 'mail was saved to draft';
          attachment.clear();
          break;
        case MailerResponse.sent:
          platformResponse = 'mail was sent';
          attachment.clear();
          break;
        case MailerResponse.cancelled:
          platformResponse = 'mail was cancelled';
          attachment.clear();
          break;
        case MailerResponse.android:
          platformResponse = 'intent was success';
          attachment.clear();
          break;
        default:
          platformResponse = 'unknown';
          attachment.clear();
          break;
      }
    } on PlatformException catch (error) {
      platformResponse = error.toString();
      if (!mounted) {
        return;
      }
      await showDialog<void>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Message',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              Text(error.message ?? 'unknown error'),
            ],
          ),
          contentPadding: const EdgeInsets.all(26),
          title: Text(error.code),
        ),
      );
    } catch (error) {
      platformResponse = error.toString();
    }

    if (!mounted) {
      return;
    }
  }

  Container buildGroupItem(Config config) {
    //String dropdownValue = 'Default';
    return Container(
      height: 33,
      margin: EdgeInsets.all(8),
      child: _getChildren(context, config),
    );
  }

  List<Widget> _buildGroupItems(List<Config> configList) {
    List<Widget> widgetList = [];
    for (int i = 0; i < configList.length; i++) {
      widgetList.add(
        buildGroupItem(configList[i]),
      );
    }
    return widgetList;
  }

  Future<int?> _getCount() async {
    inboxCount = await SettingsHelper().getInboxCount();
    log("Inbox Counnt: $inboxCount");
    outBoxCount = await SettingsHelper().getOutboxCount();
    log("Inbox Counnt: $outBoxCount");
    sentCount = await SettingsHelper().getSentItemsCount();
    log("Inbox Counnt: $sentCount");
    attachmentsCount = await SettingsHelper().getAttachmentCount();
    log("Inbox Counnt: $attachmentsCount");
    _getConnectionStatus();
    return null;
  }

  Future<void> _getTimeValue() async {
    var val2 = await SettingsHelper().getFetchInterval();
    if (val2 == 0)
      fetchNewDataStatus = 'Manual';
    else if (val2 == 900)
      fetchNewDataStatus = 'Every 15 Minutes';
    else if (val2 == 1800)
      fetchNewDataStatus = 'Every 30 Minutes';
    else if (val2 == 3600)
      fetchNewDataStatus = 'Every 1 Hour';
    else if (val2 == 86400) fetchNewDataStatus = 'Every Day';

    var val1 = await SettingsHelper().getRequestTimeout();
    if (val1 == 0)
      httpTimeOutStatus = 'Default';
    else if (val1 == 1)
      httpTimeOutStatus = '$val1 minute';
    else
      httpTimeOutStatus = '$val1 minutes';
  }

  void tempAsyncMethod() {
    loadAsset();
  }

  Future<String> loadAsset() async {
    var adv;
    appVersion = await SettingsHelper().getApplicationVersionNumber();
    adv = await SettingsHelper().getApplicationBuildNumber();
    result = await SettingsHelper().getSystemCredentials();
    systemCredentialsCount = result.length;

    adv = await SettingsHelper().getApplicationBuildNumber();

    timeOutValue = await SettingsHelper().getRequestTimeout();

    fetchTimeOutValue = await SettingsHelper().getFetchInterval();

    if (fetchTimeOutValue == 0)
      fetchNewDataStatus = 'Manual';
    else if (fetchTimeOutValue == 900)
      fetchNewDataStatus = 'Every 15 Minutes';
    else if (fetchTimeOutValue == 1800)
      fetchNewDataStatus = 'Every 30 Minutes';
    else if (fetchTimeOutValue == 3600)
      fetchNewDataStatus = 'Every 1 Hour';
    else if (fetchTimeOutValue == 86400) fetchNewDataStatus = 'Every Day';

    if (timeOutValue == 0)
      httpTimeOutStatus = 'Default';
    else if (timeOutValue == 1)
      httpTimeOutStatus = '$timeOutValue minute';
    else
      httpTimeOutStatus = '$timeOutValue minutes';
    return adv;
  }

  void screenReload() {
    setState(() {});
  }

  void _clearData() {
    String str =
        '''This option will clear all the data associated with the application and restore the application to freshly installed state (requires application restart). Deleted data cannot be recovered. Are you sure you want to clear the data in the application ? ''';

    showAlertDialog(str, 'Clear Data');
  }

  showAlertDialog(String text, String title) {
    Timer(Duration(seconds: 3), () {});
    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(text),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                "Clear Data",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                popValue = false;
                String str2 = '''Deleted all the data for this application from device . Please exit the application by pressing the 'Home' button in your device.''';
                await SettingsHelper().clearData();
                Future.delayed(Duration(seconds: 2), () async {
                  if (Platform.isAndroid) {
                    //exit(0);
                  }
                });
                Navigator.of(context).pop();

                /*if(_navigateRoute! == "")
                  Navigator.of(context,).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false,);
                else
                  Navigator.of(context,).pushNamedAndRemoveUntil(_navigateRoute!, (Route<dynamic> route) => false,);*/

                noButtonShowAlertDialog(str2, 'Alert');
              },
            ),
          ],
        );
      },
    );
  }

  noButtonShowAlertDialog(String text, String title) {
    Timer(Duration(seconds: 3), () {});
    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () => Future.value(false),
          child: AlertDialog(
            title: Text(title),
            content: Text(text),
          ),
        );
      },
    );
  }

  getConnectionStatus() {
    if (connectionStatus == 'Not Connected') {
      return TextButton(
        onPressed: () {
          BotToastPage().customLoading();
          connectionStatus = 'Not Connected';
          setState(() {});
          getStatus();
        },
        child: Text(
          connectionStatus,
          style: TextStyle(color: Colors.red),
        ),
      );
    } else if (connectionStatus == 'Connected') {
      return TextButton(
        onPressed: () {
          BotToastPage().customLoading();
          connectionStatus = 'Connected';
          getStatus();
          setState(() {});
        },
        child: Text(
          connectionStatus,
          style: TextStyle(color: Colors.green),
        ),
      );
    } else {
      return TextButton(
        onPressed: () {
          BotToastPage().customLoading();
          connectionStatus = 'Loading...';
          getStatus();
          setState(() {});
        },
        child: Text(
          connectionStatus,
          style: TextStyle(color: Colors.grey),
        ),
      );
    }
  }

  getStatus() {
    Future.delayed(Duration(seconds: 3), () async {
      status = await SettingsHelper().getServerConnectionStatus();
      //setState(() {});
    }).then((value) => setState(() {}));
  }

  _getThemeData() async {
    String fwSettings = await DefaultAssetBundle.of(context).loadString("assets/json/settings_config_json.json");

    var themeObjList = jsonDecode(fwSettings)['Theme'];

    List<ThemeConfig> themeList = [];
    themeList.add(ThemeConfig.fromJson(themeObjList));
    _themeName = themeList[0].name.toString();
    _themePrimaryColor = themeList[0].primaryColor.toString();
    _themePrimaryColorDark = themeList[0].primaryColorDark.toString();
    _themeToolbarIcon = themeList[0].toolbarIcon.toString();
    setState(() {});
    log("Theme List: " + themeList[0].name.toString());
  }

  getCount(String name) {
    if (name == 'Inbox') {
      return inboxCount;
    } else if (name == 'OutBox') {
      return outBoxCount;
    } else if (name == 'Sent') {
      return sentCount;
    } else if (name == 'Attachments') {
      return attachmentsCount;
    }
  }

  _getAppBar() {
    setState(() {});
    return AppBar(
      backgroundColor: _themePrimaryColor == null
          ? Theme.of(context).primaryColor
          : Color(
              int.parse(_themePrimaryColor!),
            ),
      leading: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back),
      ),
      elevation: 0,
      toolbarHeight: 100,
      title: Row(
        children: [
          if (_themeToolbarIcon != null)
            Image.asset(
              _themeToolbarIcon!,
              //package: "unvired_settings",
              height: 150,
              width: 75,
            )
          else
            Image.asset(
              'assets/images/unvired_logo_white.png',
              //package: "unvired_settings",
              height: 150,
              width: 75,
            ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text('Settings'),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 6),
                  child: Text(
                    SettingsHelper().getApplicationName().toString(),
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 3),
                  child: Text(
                    'Version $appVersion',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _getNavigateData() async {
    String fwSettings = await DefaultAssetBundle.of(context).loadString("assets/json/settings_config_json.json");

    var navigateObjList = jsonDecode(fwSettings)['Navigation'];

    List<Navigation> navigateList = [];
    navigateList.add(Navigation.fromJson(navigateObjList));
    _navigateRoute = navigateList[0].onClearData.toString();
    log("Theme List: " + navigateList[0].onClearData.toString());
  }

  _getConnectionStatus() async {
    var val3 = await SettingsHelper().getServerConnectionStatus();
    connectionStatus = val3.toString();
    setState(() {});
    log("connectionStatus: " + connectionStatus.toString());
  }

  Future<String> justDummy() async {
    return "null";
  }

  _getChildren(BuildContext context, Config config) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (config.name == 'Logs')
          Expanded(
            child: InkWell(
                child: Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: Row(
                      children: [
                        Constants.getIconForItem(config.name, context),
                        const SizedBox(
                          width: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: 50,
                            child: Text(
                              config.name,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          child: IconButton(
                            onPressed: () async {
                              try {
                                attachments = await SettingsHelper().createAndGetLogZipPath();
                                send(context);
                              } on Exception {}
                            },
                            icon: Icon(Icons.email_outlined, color: Theme.of(context).hintColor),
                          ),
                        ),
                        Container(
                          child: IconButton(
                            onPressed: () async {
                              try {
                                await SettingsHelper().sendLogsToServer();
                                BotToastPage.customSnackbar(context, message: 'Request Sent Please Wait...');
                              } on Exception {
                                BotToastPage.customSnackbar(context, message: 'Failed to send logs to server');
                              }
                            },
                            icon: Icon(
                              Icons.send,
                              color: _themePrimaryColor == null
                                  ? Theme.of(context).primaryColor
                                  : Color(
                                      int.parse(_themePrimaryColor!),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    )),
                onTap: () {
                  /*Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LogViewerDemo(),
                    ),
                  );*/
                }),
          )
        else if (config.name == 'Send App DB')
          Expanded(
            child: InkWell(
              child: Padding(
                padding: const EdgeInsets.only(left: 2.5),
                child: Row(
                  children: [
                    Constants.getIconForItem(config.name, context),
                    const SizedBox(
                      width: 10,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        config.name,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      child: IconButton(
                        onPressed: () async {
                          try {
                            await SettingsHelper().sendAppDbToServer();
                            //Navigator.push(context, MaterialPageRoute(builder: (context) => TimeOut(),)).then((value) => log(value));
                            BotToastPage.customSnackbar(context, message: 'Request Sent Please Wait...');
                          } on Exception {
                            BotToastPage.customSnackbar(context, message: 'Failed to send App DB to server');
                          }
                        },
                        icon: Icon(
                          Icons.send,
                          color: _themePrimaryColor == null
                              ? Theme.of(context).primaryColor
                              : Color(
                                  int.parse(_themePrimaryColor!),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        else if (config.name == 'Info Messages')
          Expanded(
            child: InkWell(
                child: Padding(
                    padding: const EdgeInsets.only(left: 2.5),
                    child: Row(
                      children: [
                        Constants.getIconForItem(config.name, context),
                        const SizedBox(
                          width: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            config.name,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          child: Icon(Icons.navigate_next),
                        ),
                      ],
                    )),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InfoMessages(),
                    ),
                  );
                }),
          )
        else if (config.name == 'New Password')
          Expanded(
            child: InkWell(
                child: Padding(
                  padding: const EdgeInsets.only(left: 2.5),
                  child: Row(
                    children: [
                      Constants.getIconForItem(config.name, context),
                      const SizedBox(
                        width: 10,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          config.name,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        child: Icon(Icons.navigate_next),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewPassword(),
                    ),
                  );
                }),
          )
        else if (config.name == 'System Credentials')
          Expanded(
            child: InkWell(
                child: Padding(
                    padding: const EdgeInsets.only(left: 2.5),
                    child: Row(
                      children: [
                        Constants.getIconForItem(config.name, context),
                        const SizedBox(
                          width: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            config.name,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          systemCredentialsCount.toString(),
                        ),
                        Container(
                          child: Icon(Icons.navigate_next),
                        ),
                      ],
                    )),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SystemPassword(),
                    ),
                  );
                }),
          )
        else if (config.name == 'Clear data')
          Expanded(
            child: InkWell(
                child: Padding(
                  padding: const EdgeInsets.only(left: 2.5),
                  child: Row(
                    children: [
                      Constants.getIconForItem(config.name, context),
                      const SizedBox(
                        width: 10,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          config.name,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        child: Icon(Icons.navigate_next),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  _clearData();
                }),
          )
        else if (config.name == 'Status')
          Expanded(
            child: InkWell(
                child: Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: Row(
                    children: [
                      Constants.getIconForItem(config.name, context),
                      const SizedBox(
                        width: 10,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          child: Text(
                            config.name,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      const Spacer(),
                      getConnectionStatus(),
                      Container(
                        child: Icon(Icons.navigate_next),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ApplicationStatus(),
                    ),
                  );
                }),
          )
        else if (config.name == 'Password')
          Expanded(
            child: InkWell(
                child: Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: Row(
                    children: [
                      Constants.getIconForItem(config.name, context),
                      const SizedBox(
                        width: 10,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          child: Text(
                            config.name,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InfoMessages(),
                    ),
                  );
                }),
          )
        else if (config.name == 'Clear Data')
          Expanded(
            child: InkWell(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          child: Text(
                            config.name,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {}),
          )
        else if (config.name == 'Request data')
          Expanded(
            child: InkWell(
                child: Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: Row(
                    children: [
                      Constants.getIconForItem(config.name, context),
                      const SizedBox(
                        width: 10,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          child: Text(
                            config.name,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                onTap: () async {
                  await SettingsHelper().requestInitialDataDownload();
                  BotToastPage.customSnackbar(context, message: 'Request Sent. Please wait...');
                }),
          )
        else if (config.name == 'Get message')
          Expanded(
            child: InkWell(
                child: Padding(
                  padding: const EdgeInsets.only(left: 02.5),
                  child: Row(
                    children: [
                      Constants.getIconForItem(config.name, context),
                      const SizedBox(
                        width: 10,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          child: Text(
                            config.name,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                onTap: () {
                  SettingsHelper().getMessage();
                  BotToastPage.customSnackbar(context, message: 'Request Sent. Please wait...');
                }),
          )
        else if (config.name == 'HTTP Timeout')
          Expanded(
            child: InkWell(
                child: Padding(
                  padding: const EdgeInsets.only(left: 2.5),
                  child: Row(
                    children: [
                      Constants.getIconForItem(config.name, context),
                      const SizedBox(
                        width: 10,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          config.name,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        httpTimeOutStatus,
                        style: TextStyle(
                          color: _themePrimaryColor == null
                              ? Theme.of(context).primaryColor
                              : Color(
                                  int.parse(_themePrimaryColor!),
                                ),
                        ),
                      ),
                      Container(
                        child: Icon(Icons.navigate_next),
                      ),
                    ],
                  ),
                ),
                onTap: () async {
                  var res = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TimeOut(),
                    ),
                  );
                  if (res != null)
                    setState(() {
                      httpTimeOutStatus = res;
                    });
                }),
          )
        else if (config.name == 'Notification')
          Expanded(
            child: InkWell(
                child: Padding(
                  padding: const EdgeInsets.only(left: 2.5),
                  child: Row(
                    children: [
                      Constants.getIconForItem(config.name, context),
                      const SizedBox(
                        width: 10,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          config.name,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        child: ElevatedButton(
                          onPressed: () {
                            SettingsHelper().testPushNotification();
                            BotToastPage.customSnackbar(context, message: 'Request Sent. Please wait...');
                          },
                          child: Text('Test'),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              _themePrimaryColor == null
                                  ? Theme.of(context).primaryColor
                                  : Color(
                                      int.parse(_themePrimaryColor!),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () async {
                  var res = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Notifications(),
                    ),
                  );
                  if (res != null)
                    setState(() {
                      notificationStatus = res;
                    });
                }),
          )
        else if (config.name == 'Fetch New Data')
          Expanded(
            child: InkWell(
                child: Padding(
                  padding: const EdgeInsets.only(left: 2.5),
                  child: Row(
                    children: [
                      Constants.getIconForItem(config.name, context),
                      const SizedBox(
                        width: 10,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          config.name,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        fetchNewDataStatus,
                        style: TextStyle(
                          color: _themePrimaryColor == null
                              ? Theme.of(context).primaryColor
                              : Color(
                                  int.parse(_themePrimaryColor!),
                                ),
                        ),
                      ),
                      Container(
                        child: Icon(Icons.navigate_next),
                      ),
                    ],
                  ),
                ),
                onTap: () async {
                  var res = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FetchNewData(),
                    ),
                  );
                  if (res != null)
                    setState(() {
                      fetchNewDataStatus = res;
                    });
                }),
          )
        else if (config.name == 'Location Tracking')
          Expanded(
            child: InkWell(
                child: Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: Row(
                    children: [
                      Constants.getIconForItem(config.name, context),
                      const SizedBox(
                        width: 10,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          child: Text(
                            config.name,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LocationTrackingInfo(),
                              ),
                            );
                          },
                          child: Text(
                            status,
                            style: TextStyle(
                              color: _themePrimaryColor == null
                                  ? Theme.of(context).primaryColor
                                  : Color(
                                      int.parse(_themePrimaryColor!),
                                    ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Icon(Icons.navigate_next),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LocationTrackingInfo(),
                    ),
                  );
                }),
          )
        else if (config.name == 'About Us')
          Expanded(
            child: InkWell(
                child: Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: Row(
                    children: [
                      Constants.getIconForItem(config.name, context),
                      const SizedBox(
                        width: 10,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          child: Text(
                            config.name,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        child: Icon(Icons.navigate_next),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AboutUs(),
                    ),
                  );
                }),
          )
        else
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 0),
              child: Row(
                children: [
                  Constants.getIconForItem(config.name, context),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    config.name,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  Text(getCount(config.name).toString()),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          )
      ],
    );
  }
}
