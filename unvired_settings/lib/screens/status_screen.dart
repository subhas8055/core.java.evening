import 'dart:async';

import 'package:flutter/material.dart';
import 'package:unvired_sdk/unvired_sdk.dart';
import 'package:unvired_settings/utils/bot_toast.dart';

class ApplicationStatus extends StatefulWidget {
  @override
  _ApplicationStatus createState() => _ApplicationStatus();
}

class _ApplicationStatus extends State<ApplicationStatus> {
  String appDBVersion = '', adv = '', appVersion = '';
  String status = 'Loading...',
      userName = '',
      url = '',
      serverType = '',
      loginModule = '',
      serverId = '',
      activationId = '',
      deviceId = '',
      deviceType = '',
      securityLevel = '',
      logLevel = '',
      company = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColorDark,
          leading: null,
          elevation: 0,
          title: Text('Application Status')),
      body: FutureBuilder(
        future: getStatusDetails(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
         return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, top: 10.0),
                          child: Align(
                            child: Text(
                              'STATUS',
                              style:
                              TextStyle(fontSize: 12, color: Colors.white),
                            ),
                            alignment: FractionalOffset.centerLeft,
                          ),
                        ),

                        Card(
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 10.0,
                                top: 10.0,
                                bottom: 10.0,
                                right: 10.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Align(
                                      child: _getStatus(status),
                                      alignment: FractionalOffset.centerLeft,
                                    ),
                                    Expanded(child: Text('')),
                                    Align(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          BotToastPage().customLoading();
                                          status = 'Loading...';
                                          setState(() {});
                                          getStatus();
                                        },
                                        child: Text(
                                          'Test Connection',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white),
                                        ),
                                        style: ButtonStyle(
                                          backgroundColor:
                                          MaterialStateProperty.all(
                                              Theme.of(context)
                                                  .primaryColorLight),
                                          padding: MaterialStateProperty.all<
                                              EdgeInsets>(
                                              const EdgeInsets.symmetric(
                                                  horizontal: 10)),
                                        ),
                                      ),
                                      alignment: FractionalOffset.centerRight,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 7),
                                Align(
                                  child: Text(
                                    'Application Status',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  alignment: FractionalOffset.centerLeft,
                                ),
                                Divider(
                                  thickness: 2,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 5),
                                Align(
                                  child: Text(
                                    userName,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  alignment: FractionalOffset.centerLeft,
                                ),
                                SizedBox(height: 7),
                                Align(
                                  child: Text(
                                    'User Name',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  alignment: FractionalOffset.centerLeft,
                                ),
                                Divider(
                                  thickness: 2,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 5),
                                Align(
                                  child: Text(
                                    url,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  alignment: FractionalOffset.centerLeft,
                                ),
                                SizedBox(height: 7),
                                Align(
                                  child: Text(
                                    'URL',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  alignment: FractionalOffset.centerLeft,
                                ),
                                Divider(
                                  thickness: 2,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 5),
                                Align(
                                  child: Text(
                                    serverType,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  alignment: FractionalOffset.centerLeft,
                                ),
                                SizedBox(height: 7),
                                Align(
                                  child: Text(
                                    'Server type',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  alignment: FractionalOffset.centerLeft,
                                ),
                              ],
                            ),
                          ),
                          elevation: 5,
                          margin: EdgeInsets.all(10),
                        ),

                        ///Versions
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, top: 10.0),
                          child: Align(
                            child: Text(
                              'PROPERTIES',
                              style:
                              TextStyle(fontSize: 12, color: Colors.white),
                            ),
                            alignment: FractionalOffset.centerLeft,
                          ),
                        ),
                        Card(
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 10.0, top: 5.0, bottom: 5.0, right: 10.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      _imagePath(),
                                      package: "unvired_settings",
                                      height: 50,
                                      width: 50,
                                    ),
                                    Column(
                                      children: [
                                        ///1
                                        Align(
                                          child: Text(
                                            appVersion,
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          alignment:
                                          FractionalOffset.centerLeft,
                                        ),
                                        SizedBox(height: 7),
                                        Align(
                                          child: Text(
                                            'Server ID',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          alignment:
                                          FractionalOffset.centerLeft,
                                        ),
                                        Divider(
                                          thickness: 2,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(height: 5),
                                      ],
                                    )
                                  ],
                                ),

                                ///2
                                Align(
                                  child: Text(
                                    serverId,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  alignment: FractionalOffset.centerLeft,
                                ),
                                SizedBox(height: 7),
                                Align(
                                  child: Text(
                                    'Server ID',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  alignment: FractionalOffset.centerLeft,
                                ),
                                Divider(
                                  thickness: 2,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 5),

                                ///3
                                Align(
                                  child: Text(
                                    activationId,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  alignment: FractionalOffset.centerLeft,
                                ),
                                SizedBox(height: 7),
                                Align(
                                  child: Text(
                                    'Activation ID',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  alignment: FractionalOffset.centerLeft,
                                ),
                                SizedBox(height: 5),
                                Divider(
                                  thickness: 2,
                                  color: Colors.grey,
                                ),
                                Align(
                                  child: Text(
                                    deviceId,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  alignment: FractionalOffset.centerLeft,
                                ),
                                SizedBox(height: 7),
                                Align(
                                  child: Text(
                                    'Device ID',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  alignment: FractionalOffset.centerLeft,
                                ),
                                SizedBox(height: 5),
                                Divider(
                                  thickness: 2,
                                  color: Colors.grey,
                                ),
                                Align(
                                  child: Text(
                                    deviceType,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  alignment: FractionalOffset.centerLeft,
                                ),
                                SizedBox(height: 7),
                                Align(
                                  child: Text(
                                    'Device Type',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  alignment: FractionalOffset.centerLeft,
                                ),
                                SizedBox(height: 5),
                                Divider(
                                  thickness: 2,
                                  color: Colors.grey,
                                ),
                                Align(
                                  child: Text(
                                    securityLevel,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  alignment: FractionalOffset.centerLeft,
                                ),
                                SizedBox(height: 7),
                                Align(
                                  child: Text(
                                    'Security Level',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  alignment: FractionalOffset.centerLeft,
                                ),
                                SizedBox(height: 5),
                                Divider(
                                  thickness: 2,
                                  color: Colors.grey,
                                ),
                                Align(
                                  child: Text(
                                    logLevel,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  alignment: FractionalOffset.centerLeft,
                                ),
                                SizedBox(height: 7),
                                Align(
                                  child: Text(
                                    'Log Level',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  alignment: FractionalOffset.centerLeft,
                                ),
                                SizedBox(height: 5),
                                Divider(
                                  thickness: 2,
                                  color: Colors.grey,
                                ),
                                Align(
                                  child: Text(
                                    company,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  alignment: FractionalOffset.centerLeft,
                                ),
                                SizedBox(height: 7),
                                Align(
                                  child: Text(
                                    'Company',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  alignment: FractionalOffset.centerLeft,
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                          elevation: 5,
                          margin: EdgeInsets.all(10),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
        },
      ),
    );
  }

  String _imagePath() {
    if (loginModule == 'unvired')
      return 'assets/images/unviredimage.png';
    else if (loginModule == 'ads')
      return 'assets/images/windowsimage.png';
    else if (loginModule == 'sap')
      return 'assets/images/sapimage.png';
    else if (loginModule == 'email')
      return 'assets/images/mailimage.png';
    else
      return '';
  }

  @override
  void initState() {
    super.initState();
    tempAsyncMethod();
    getStatusDetails();
  }

  void tempAsyncMethod() async {
    appDBVersion = await loadAsset();
  }

  Future<String> loadAsset() async {
    adv = await SettingsHelper().getApplicationDBVersion();
    return adv;
  }

  getStatusDetails() async {
    getStatus();
    userName = await SettingsHelper().getUserName();
    url = await SettingsHelper().getUrl();
    serverType = await SettingsHelper().getServerType();
    serverId = await SettingsHelper().getServerId();
    activationId = await SettingsHelper().getActivationId();
    deviceId = await SettingsHelper().getDeviceId();
    deviceType = await SettingsHelper().getDeviceType();
    securityLevel = await SettingsHelper().getSecutiryLevel();
    logLevel = await SettingsHelper().getLogLevel();
    company = await SettingsHelper().getCompany();
    appVersion = await SettingsHelper().getApplicationVersionNumber();
    loginModule = await SettingsHelper().getLoginModule();
  }

  /*buildShowDialog(BuildContext context) async{
    setState(()  {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          });
    });
    await SettingsHelper().getServerConnectionStatus();
    await Future.delayed(Duration(seconds: 3));
    setState(() {});
  }*/
  bool _loading = false;

  Future _login() async {
    setState(() {
      _loading = false;
    });
  }

  /*void _onLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            width: 50,
            height: 50,
            child:CircularProgressIndicator()
          )
        );
      },
    );
    new Future.delayed(new Duration(seconds: 3), () {
      Navigator.pop(context); //pop dialog
      SettingsHelper().getServerConnectionStatus();
      _login();
    });
  }*/

  _getStatus(String status) {
    if (status == 'Loading...')
      return Text(
        status,
        style: TextStyle(fontSize: 14, color: Colors.grey),
      );
    else if (status == 'Connected') {
      return Text(
        status,
        style: TextStyle(fontSize: 14, color: Colors.green),
      );
    } else {
      return Text(
        status,
        style: TextStyle(fontSize: 14, color: Colors.red),
      );
    }
  }

  screenRefresh() {
    setState(() {});
  }

  getStatus() {
    Future.delayed(Duration(seconds: 3), () async {
      status = await SettingsHelper().getServerConnectionStatus();
      //setState(() {});
    }).then((value) => setState(() {}));

  }
}
