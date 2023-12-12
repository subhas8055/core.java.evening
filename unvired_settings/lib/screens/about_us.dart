import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unvired_sdk/unvired_sdk.dart';
class AboutUs extends StatefulWidget {
  @override
  _AboutUs createState() => _AboutUs();
}

class _AboutUs extends State<AboutUs> {
  String appDBVersion='',adv='',appVersion='';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColorDark,
          leading: null,
          elevation: 0,
          title: Text('About Us')),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: loadAsset(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            return Column(
              children: [
                Image.asset(
                  'assets/images/unvired_logo_white.png',
                  height: 100,
                ),
                Container(
                  width: double.infinity,
                  child: Column(
                    children: [
                      /// About company
                      Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 10.0, top: 10.0, bottom: 10.0, right: 10.0),
                          child: Column(
                            children: [
                              Align(
                                child: Text(
                                  SettingsHelper().getApplicationName(),
                                  style: TextStyle(fontSize: 16),
                                ),
                                alignment: FractionalOffset.centerLeft,
                              ),
                              SizedBox(height: 7),
                              Align(
                                child: Text(
                                  'Application Name',
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
                                  'Unvired Inc',
                                  style: TextStyle(fontSize: 16),
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
                              Divider(
                                thickness: 2,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 5),
                              Align(
                                child: Text(
                                  '\u00a9'+ DateFormat.y().format(DateTime.now()) +'.All Rights Reserved.',
                                  style: TextStyle(fontSize: 16),
                                ),
                                alignment: FractionalOffset.centerLeft,
                              ),
                              SizedBox(height: 7),
                              Align(
                                child: Text(
                                  'copyright',
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
                            'VERSIONS',
                            style: TextStyle(fontSize: 12, color: Colors.white),
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
                              Align(
                                child: Text(
                                  appVersion,
                                  style: TextStyle(fontSize: 16),
                                ),
                                alignment: FractionalOffset.centerLeft,
                              ),
                              SizedBox(height: 7),
                              Align(
                                child: Text(
                                  'Application Version',
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
                                  SettingsHelper().getApplicationRevisionNumber(),
                                  style: TextStyle(fontSize: 16),
                                ),
                                alignment: FractionalOffset.centerLeft,
                              ),
                              SizedBox(height: 7),
                              Align(
                                child: Text(
                                  'Application Revision',
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
                                  appDBVersion,
                                  style: TextStyle(fontSize: 16),
                                ),
                                alignment: FractionalOffset.centerLeft,
                              ),
                              SizedBox(height: 7),
                              Align(
                                child: Text(
                                  'Application Database Version',
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
                                  SettingsHelper().getFrameworkVersionNumber(),
                                  style: TextStyle(fontSize: 16),
                                ),
                                alignment: FractionalOffset.centerLeft,
                              ),
                              SizedBox(height: 7),
                              Align(
                                child: Text(
                                  'Unvired Framework Version',
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
                                  SettingsHelper().getFrameworkRevisionNumber(),
                                  style: TextStyle(fontSize: 16),
                                ),
                                alignment: FractionalOffset.centerLeft,
                              ),
                              SizedBox(height: 7),
                              Align(
                                child: Text(
                                  'Unvired Framework Revision Number',
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
                                  SettingsHelper().getFrameworkBuildNumber(),
                                  style: TextStyle(fontSize: 16),
                                ),
                                alignment: FractionalOffset.centerLeft,
                              ),
                              SizedBox(height: 7),
                              Align(
                                child: Text(
                                  'Unvired Framework Build Number',
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
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    tempAsyncMethod();
  }

  void tempAsyncMethod() async {
    appDBVersion = await loadAsset();
  }

  Future<String> loadAsset() async {
    adv = await SettingsHelper().getApplicationDBVersion();
    appVersion=await SettingsHelper().getApplicationVersionNumber();
    return adv;
  }
}
