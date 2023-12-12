import 'dart:async';

import 'package:flutter/material.dart';
import 'package:unvired_sdk/unvired_sdk.dart';
import 'package:unvired_settings/utils/bot_toast.dart';

/// NEW PASSWORD
class NewPassword extends StatefulWidget {
  @override
  _NewPassword createState() => _NewPassword();
}

class _NewPassword extends State<NewPassword> {
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  String str =
      "You will be authenticated with the server with your new password. Please enter the new password that has been provided to you and tap on 'Change Password' button.";
  late TextEditingController _controller;
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            int count = 0;
            Navigator.of(context).popUntil((_) => count++ >= 1);
          },
        ),
        title: Text('Enter New Password'),
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                str,
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
              Container(
                  height: 50,
                  width: 300,
                  child: TextField(
                    controller: _controller,
                    obscureText: _isObscure,
                    autofocus: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        suffixIcon: IconButton(
                            icon: Icon(_isObscure
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            })),
                  )),
              TextButton(
                  onPressed: () async {
                    var password = _controller.text;
                    BotToastPage().customLoading();
                    Timer(Duration(seconds: 3), () async {
                      try {
                        bool res =
                        await SettingsHelper().changePassword(password);
                        if (password.isEmpty)
                          showSingleButtonAlertDialog(
                              'Password field is empty', 'Alert');
                        else if (res == true) {
                          int count = 0;
                          Navigator.of(context).popUntil((_) => count++ >= 1);
                          BotToastPage.customSnackbar(context, message:
                          'Password has been successfully Changed in the device');
                        } else
                          BotToastPage
                              .customSnackbar(context,message: 'Unable to Change Password');

                        _controller.clear();
                      } catch (e) {
                        String str = '''Incorrect Password''';
                        showSingleButtonAlertDialog(str, 'Error');
                      }
                    });
                  },
                  child: Text(
                    'Change Password',
                    style:
                    TextStyle(color: Theme.of(context).primaryColorLight),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  showSingleButtonAlertDialog(String text, String title) {
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
}