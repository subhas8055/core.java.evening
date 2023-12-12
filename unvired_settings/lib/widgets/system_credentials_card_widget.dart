import 'dart:async';

import 'package:flutter/material.dart';
import 'package:unvired_sdk/src/database/framework_database.dart';
import 'package:unvired_sdk/src/helper/settings_helper.dart';

import '../utils/bot_toast.dart';

class SystemCredentialWidget extends StatefulWidget {
  BuildContext context;
  List<SystemCredential> result;
  int index;
  PageController controller;

  SystemCredentialWidget(
      {required this.context,
        required this.index,
        required this.result,
        required this.controller});

  @override
  _SystemCredentialWidget createState() => _SystemCredentialWidget();
}

class _SystemCredentialWidget extends State<SystemCredentialWidget> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String loginName = '';
  int currentIndex = 0;
  int _index = 0;
  bool _isObscure = true;
  bool isDisabled = false;

  @override
  Widget build(BuildContext context) {
    currentIndex = widget.index;

    return Container(
        padding: const EdgeInsets.only(
          top: 30,
        ),
        margin: MediaQuery.of(context).size.width > 700
            ? EdgeInsets.symmetric(
            horizontal: (MediaQuery.of(context).size.width * 20) / 100)
            : EdgeInsets.all(0),
        child: Card(
          elevation: 6,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Center(
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.only(right: 10, left: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: Image.asset(
                      _imagePath(currentIndex),
                      package: "unvired_settings",
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      widget.result[currentIndex].name,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 7),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: TextField(
                      controller: userNameController,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        fillColor: Colors.white,
                        hintStyle: const TextStyle(fontSize: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        filled: true,
                        contentPadding: const EdgeInsets.all(10),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: TextField(
                      controller: passwordController,
                      obscureText: _isObscure,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        fillColor: Colors.white,
                        suffixIcon: IconButton(
                            icon: Icon(_isObscure
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            }),
                        hintStyle: const TextStyle(fontSize: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        filled: true,
                        contentPadding: const EdgeInsets.all(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 7),
                  Container(
                    width: double.infinity,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              child: const Text(
                                'Save & Test',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white),
                              ),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      _getButtonColor())),
                              // color: _getButtonColor(),
                              // shape: RoundedRectangleBorder(
                              //   borderRadius: BorderRadius.circular(12.0),
                              // ),
                              onPressed: () async {
                                if (isDisabled == false) {
                                  if (_validateData(userNameController,
                                      passwordController) ==
                                      true) {
                                    BotToastPage().customLoading();
                                    updateSystemCredentials(
                                        userNameController, passwordController);
                                  }
                                } else {
                                  BotToastPage.customSnackbar(context, message:
                                  'Credentials are already updated');
                                }
                              },
                            ),
                          ),
                          TextButton(
                            child: Text(
                              'Clear',
                              style: TextStyle(fontSize: 12, color: Colors.red),
                            ),
                            onPressed: () async {
                              String str =
                                  'This will clear out the system credentials for this system. Are you sure you want to proceed ?';
                              showClearAlertDialog(str, 'Alert');
                            },
                          ),
                          Expanded(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      _getButtonColor())),
                              // color: _getButtonColor(),
                              // shape: RoundedRectangleBorder(
                              //   borderRadius: BorderRadius.circular(12.0),
                              // ),
                              child: const Text(
                                'Skip',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white),
                              ),
                              onPressed: () {
                                setState(() {
                                  if (currentIndex + 1 < widget.result.length) {
                                    currentIndex += 1;
                                  } else {
                                    int count = 0;
                                    Navigator.of(context)
                                        .popUntil((_) => count++ >= 2);
                                  }
                                  if (currentIndex >= widget.result.length) {
                                    BotToastPage.customSnackbar(context, message:
                                    'This is the last page');
                                  } else
                                    widget.controller.jumpToPage(currentIndex);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 7),
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        'Enter your ${widget.result[currentIndex].name} credentials to work with your data',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      )),
                ],
              ),
            ),
          ),
        ));
  }

  bool _validateData(TextEditingController userNameController,
      TextEditingController passwordController) {
    if (userNameController.text.isEmpty || passwordController.text.isEmpty) {
      BotToastPage.customSnackbar(context, message:'Empty fields ');
      return false;
    } else
      return true;
  }

  getStatusDetails() async {
    widget.result = await SettingsHelper().getSystemCredentials();
    widget.result.forEach((element) {
      loginName = element.name;
      if (loginName.isEmpty) loginName = 'Loading...';
    });
  }

  String _imagePath(int index) {
    if (widget.result[index].portType == 'RFC')
      return 'assets/images/sapimage.png';
    else if (widget.result[index].portType == 'SALES_FORCE_PORT')
      return 'assets/images/salesforceimage.png';
    else if (widget.result[index].portType == 'MYSQL')
      return 'assets/images/mysqlimage.png';
    else if (widget.result[index].portType == 'SHAREPOINT_PORT')
      return 'assets/images/sharepointimage.png';
    else
      return 'assets/images/generalimage.png';
  }

  showAlertDialog(BuildContext context, int index) {
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: 200,
            height: 300,
            child: ListView.builder(
                itemCount: 1,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Column(
                      children: [
                        SizedBox(height: 7),
                        Align(
                            alignment: FractionalOffset.centerLeft,
                            child: Text(
                              widget.result[currentIndex].portName,
                              style: TextStyle(fontSize: 14),
                            )),
                        SizedBox(height: 5),
                        Align(
                            alignment: FractionalOffset.centerLeft,
                            child: Text(
                              'Port Name',
                              style: TextStyle(fontSize: 12),
                            )),
                        SizedBox(height: 5),
                        Divider(
                          thickness: 2,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 7),
                        Align(
                            alignment: FractionalOffset.centerLeft,
                            child: Text(
                              widget.result[currentIndex].portType,
                              style: TextStyle(fontSize: 14),
                            )),
                        SizedBox(height: 5),
                        Align(
                            alignment: FractionalOffset.centerLeft,
                            child: Text(
                              'Port Type',
                              style: TextStyle(fontSize: 12),
                            )),
                        SizedBox(height: 5),
                        Divider(
                          thickness: 2,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 7),
                        Align(
                            alignment: FractionalOffset.centerLeft,
                            child: Text(
                              widget.result[currentIndex].portDesc,
                              style: TextStyle(fontSize: 14),
                            )),
                        SizedBox(height: 5),
                        Align(
                            alignment: FractionalOffset.centerLeft,
                            child: Text(
                              'Port Description',
                              style: TextStyle(fontSize: 12),
                            )),
                        SizedBox(height: 5),
                        Divider(
                          thickness: 2,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 7),
                        Align(
                            alignment: FractionalOffset.centerLeft,
                            child: Text(
                              widget.result[currentIndex].systemDesc,
                              style: TextStyle(fontSize: 14),
                            )),
                        SizedBox(height: 5),
                        Align(
                            alignment: FractionalOffset.centerLeft,
                            child: Text(
                              'System Description',
                              style: TextStyle(fontSize: 12),
                            )),
                        SizedBox(height: 5),
                        Divider(
                          thickness: 2,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 7),
                      ],
                    ),
                  );
                }),
          ),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> updateSystemCredentials(
      TextEditingController username, TextEditingController password) async {
    try {
      bool val = await SettingsHelper().updateSystemCredential(
          widget.result[currentIndex], username.text, password.text);
      if (val == true) {
        username.clear();
        password.clear();
        BotToastPage.customSnackbar(context, message:'Updated Successfully');
        setState(() {
          isDisabled = true;
          if (currentIndex + 1 < widget.result.length) {
            currentIndex += 1;
          } else {
            int count = 0;
            Navigator.of(context).popUntil((_) => count++ >= 2);
          }
          if (currentIndex >= widget.result.length) {
            BotToastPage.customSnackbar(context, message:'This is the last page');
          } else
            widget.controller.jumpToPage(currentIndex);
        });
      }
    } on Exception {
      BotToastPage.customSnackbar(context, message:'Failed to Update');
      //BotToastPage().customToastMessage(exception.toString());
    } catch (e) {
      BotToastPage.customSnackbar(context, message:'Failed to Update');
      //BotToastPage().customToastMessage(e.toString());
    }
  }

  showClearAlertDialog(String text, String title) {
    Timer(Duration(seconds: 3), () {});
    // show the dialog
    showDialog(
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
                "Clear",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                await SettingsHelper().clearData();
              },
            ),
          ],
        );
      },
    );
  }

  _getButtonColor() {
    if (isDisabled == false)
      return Theme.of(context).primaryColorDark;
    else
      return Colors.grey;
  }
}
