import 'dart:async';

import 'package:flutter/material.dart';
import 'package:unvired_sdk/unvired_sdk.dart';
import 'package:unvired_settings/widgets/system_credentials_widget.dart';

/// SYSTEM CREDENTIALS
class SystemPassword extends StatefulWidget {
  @override
  _SystemPasswords createState() => _SystemPasswords();
}

class _SystemPasswords extends State<SystemPassword> {
  late TextEditingController _controller;
  bool _isObscure = true;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    String str = "Please enter the login password to continue";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        leading: null,
        title: Text('Enter Password'),
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
                        //hintText: 'Enter Password',
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
              ElevatedButton(
                onPressed: () async {
                  try {
                    bool res = await SettingsHelper()
                        .validatePassword(_controller.text);
                    if (_controller.text.isEmpty)
                      showSingleButtonAlertDialog(
                          'Please enter the Login Password to continue',
                          'Alert');
                    else if (res == true)
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SystemCredentialsMain()));
                  } catch (e) {
                    String str =
                        'The entered Password is incorrect. Please enter the correct Password';
                    showSingleButtonAlertDialog(str, 'Error');
                    _controller.clear();
                  }
                },
                child: Text('Submit'),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).primaryColorLight)),
              )
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
