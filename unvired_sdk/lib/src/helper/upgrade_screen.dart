import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unvired_sdk/src/authentication_service.dart';
import 'package:unvired_sdk/src/helper/framework_helper.dart';
import 'package:unvired_sdk/src/helper/sync_result.dart';
import 'package:unvired_sdk/src/helper/update_manager.dart';
import 'package:unvired_sdk/src/unvired_account.dart';

class UpgradeScreen extends StatefulWidget {
  final UnviredAccount unviredAccount;

  const UpgradeScreen({Key? key, required this.unviredAccount}) : super(key: key);
  @override
  _UpgradeScreenState createState() => _UpgradeScreenState();
}

class _UpgradeScreenState extends State<UpgradeScreen> {
  String message =
      "Your application has to go through an upgarde process due to data model changes in the new version you received.Please tap on Upgrade to proceed with a smooth upgrade or tap on reset to clear the application data and re-start from the login step";

  bool isUpgrading = false;
  bool isResetting = false;
  String loadingMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).primaryColorDark,
        title: Center(
          child: Text(
            AuthenticationService().getAppName(),
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
            (isUpgrading || isResetting)
                ? FutureBuilder(
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData) {
                        if (isUpgrading) {
                          UpgradeResult upgradeResult = snapshot.data;
                          if (upgradeResult.success) {
                            return Column(
                              children: [
                                Text(
                                  "Updated successfully",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(
                                            Theme.of(context).primaryColorDark)),
                                    onPressed: () {
                                      Navigator.of(context).pop({
                                        "success": true,
                                        "action": "upgrade"
                                      });
                                    },
                                    child: Text(' Okay '))
                              ],
                            );
                          } else {
                            return Column(
                              children: [
                                Text(
                                  upgradeResult.error,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(
                                            Theme.of(context).primaryColorDark)),
                                    onPressed: () {
                                      Navigator.of(context).pop({
                                        "success": false,
                                        "action": "upgrade"
                                      });
                                    },
                                    child: Text(' Okay '))
                              ],
                            );
                          }
                        } else {
                          Future.delayed(Duration(microseconds: 100), () {
                            Navigator.of(context)
                                .pop({"success": true, "action": "reset"});
                          });
                          return Container();
                        }
                      } else if (snapshot.hasError) {
                        return Column(
                          children: [
                            Text(
                              snapshot.error.toString(),
                              textAlign: TextAlign.center,
                            ),
                            ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Theme.of(context).primaryColorDark)),
                                onPressed: () {
                                  Navigator.of(context).pop(
                                      {"success": false, "action": "upgrade"});
                                },
                                child: Text(' Okay '))
                          ],
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Column(
                            children: [
                              CircularProgressIndicator(),
                              Container(
                                margin: EdgeInsets.only(top: 15),
                                child: Text(
                                  isUpgrading
                                      ? "Please wait, app is being updated"
                                      : "Please wait, resetting app",
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          ),
                        );
                      }
                    },
                    future: isUpgrading
                        ? UpdateManager().upgrade()
                        : FrameworkHelper.clearData(
                            widget.unviredAccount),
                  )
                : Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isUpgrading = true;
                          });
                        },
                        child: Text('Upgrade'),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).primaryColorDark)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isResetting = true;
                              });
                            },
                            child: Text(' Reset '),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Theme.of(context).primaryColorDark))),
                      )
                    ],
                  )
          ],
        ),
      ),
    );
  }
}
