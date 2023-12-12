import 'package:flutter/material.dart';
import 'package:unvired_sdk/unvired_sdk.dart';

///Notifications
class Notifications extends StatefulWidget {
  @override
  _Notifications createState() => _Notifications();
}

class _Notifications extends State<Notifications> {
  String str =
  '''Notifications are the custom messages sent from the server which are specific to the user. You can change the notification display timeout by turning ON the notifications.''';
  int selectedIndex = 0;
  bool alreadySaved = false;
  bool isSwitched = false;
  int getTimeOut = 0;
  int setTimeOut = 0;
  List<String> items = ['Default', '5 Seconds', '7 Seconds', '10 Seconds'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColorDark,
          leading: null,
          title: Text('Notifications'),
          elevation: 0,
        ),
        body: FutureBuilder(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            return getDataWid();
          },
        ));
  }

  @override
  void initState() {
    super.initState();
    //getData();
  }

  Future<void> getData() async {
    getTimeOut = await SettingsHelper().getRequestTimeout();
  }

  getDataWid() {
    int val;

    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Card(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      str,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Row(
                    children: [
                      Text('Show Notifications'),
                      Expanded(child: Text('')),
                      Switch(
                          value: isSwitched,
                          onChanged: (value) {
                            setState(() {
                              isSwitched = value;
                            });
                          })
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Visibility(
                    visible: isSwitched,
                    child: Column(
                      children: [
                        Container(
                            width: double.infinity,
                            child: Row(
                              children: [
                                InkWell(
                                  child: Text(items[0]),
                                ),
                                Expanded(
                                  child: Text(''),
                                ),
                                Icon(
                                  Icons.check,
                                  color: Theme.of(context).cardColor,
                                ),
                              ],
                            )),
                        Divider(
                          thickness: 2,
                          color: Colors.grey,
                        ),
                        Container(
                            width: double.infinity,
                            child: Row(
                              children: [
                                InkWell(
                                  child: Text(items[1]),
                                ),
                                Expanded(
                                  child: Text(''),
                                ),
                                Icon(
                                  Icons.check,
                                  color: Theme.of(context).cardColor,
                                ),
                              ],
                            )),
                        Divider(
                          thickness: 2,
                          color: Colors.grey,
                        ),
                        Container(
                            width: double.infinity,
                            child: Row(
                              children: [
                                InkWell(
                                  child: Text(items[2]),
                                ),
                                Expanded(
                                  child: Text(''),
                                ),
                                Icon(
                                  Icons.check,
                                  color: Theme.of(context).cardColor,
                                ),
                              ],
                            )),
                        Divider(
                          thickness: 2,
                          color: Colors.grey,
                        ),
                        Container(
                            width: double.infinity,
                            child: Row(
                              children: [
                                InkWell(
                                  child: Text(items[3]),
                                ),
                                Expanded(
                                  child: Text(''),
                                ),
                                Icon(
                                  Icons.check,
                                  color: Theme.of(context).cardColor,
                                ),
                              ],
                            )),
                        Divider(
                          thickness: 2,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}