import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:unvired_sdk/unvired_sdk.dart';
import 'package:unvired_settings/widgets/system_credentials_card_widget.dart';

import '../utils/bot_toast.dart';

/// SYSTEM CREDENTIALS MAIN
class SystemCredentialsMain extends StatefulWidget {
  @override
  _SystemCredentialsMain createState() => _SystemCredentialsMain();
}

class _SystemCredentialsMain extends State<SystemCredentialsMain> {
  late List<SystemCredential> result;
  int _index = 0;
  int currentIndex = 0;
  PageController _pageController = PageController(viewportFraction: 0.8);
  bool _isObscure = true;

  var currentPage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            int count = 0;
            Navigator.of(context).popUntil((_) => count++ >= 2);
          },
        ),
        title: Text('System Credentials'),
        elevation: 0,
        actions: [
          TextButton(
              onPressed: () {
                showAlertDialog(currentIndex);
              },
              child: Text(
                'More',
                style: TextStyle(color: Colors.white),
              )),
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              result = snapshot.data;
              return Column(
                children: [
                  Container(
                    height: 550, // card height
                    child: PageView.builder(
                      itemCount: result.length,
                      controller: _pageController,
                      onPageChanged: (int index) {
                        setState(() {
                          _index = index;
                          currentIndex = index;
                        });
                      },
                      itemBuilder: (_, i) {
                        return Transform.scale(
                          scale: i == _index ? 1.0 : 0.8,
                          child: SystemCredentialWidget(
                              context: context,
                              index: i,
                              result: result,
                              controller: _pageController),
                        );
                      },
                    ),
                  ),
                  new DotsIndicator(
                    dotsCount: result.length,
                    position: currentIndex,
                    decorator: DotsDecorator(
                      size: const Size.square(9.0),
                      activeSize: const Size(18.0, 9.0),
                      activeShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                  ),
                ],
              );
            } else {
              return Container(
                height: 550,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);
    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page;
      });
    });
    getStatusDetails();
  }

  bool getIsBoscured() {
    return _isObscure;
  }

  getStatusDetails() async {
    result = await SettingsHelper().getSystemCredentials();
  }

  Future<List<SystemCredential>> getData() async {
    List<SystemCredential> result =
    await SettingsHelper().getSystemCredentials();
    result.forEach((element) {});
    return result;
  }

  /*Widget _getCredentialsCard(BuildContext context, int index) {
    return Container(
      margin: const EdgeInsets.only(top: 20, right: 20, left: 20, bottom: 20),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
                width: double.infinity,
                child: Align(
                    alignment: Alignment.topRight, child: Icon(Icons.more))),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Image.asset(
                _imagePath(index),
              ),
            ),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  loginName,
                  style: const TextStyle(color: Colors.black),
                )),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Username',
                  fillColor: Colors.white,
                  hintStyle: const TextStyle(fontSize: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.solid,
                    ),
                  ),
                  filled: true,
                  contentPadding: const EdgeInsets.all(10),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Password',
                  fillColor: Colors.white,
                  hintStyle: const TextStyle(fontSize: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.solid,
                    ),
                  ),
                  filled: true,
                  contentPadding: const EdgeInsets.all(10),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).primaryColorDark),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.symmetric(horizontal: 5)),
                      ),
                      child: const Text('Save & Test'),
                      onPressed: () {
                        setState(() {});
                      },
                    )),
                    TextButton(
                      child: const Text('Clear'),
                      onPressed: () {
                        setState(() {});
                      },
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).primaryColorDark),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              const EdgeInsets.symmetric(horizontal: 5)),
                        ),
                        child: const Text('Skip'),
                        onPressed: () {
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Center(
                    child: Text(
                  'Enter your $loginName credentials to work with your data',
                  style: TextStyle(color: Colors.black, fontSize: 12),
                  maxLines: 2,
                ))),
          ],
        ),
      ),
    );
  }*/

  bool _validateData(TextEditingController userNameController,
      TextEditingController passwordController) {
    if (userNameController.text.isEmpty || passwordController.text.isEmpty) {
      BotToastPage.customSnackbar(context, message:'Empty fields ');
      return false;
    } else
      return true;
  }

  Future<void> updateSystemCredentials(String username, String password) async {
    try {
      bool val = await SettingsHelper()
          .updateSystemCredential(result[currentIndex], username, password);
      if (val == true) {
        BotToastPage.customSnackbar(context, message:'Updated Successfully');
      }
    } on Exception catch (exception) {
      BotToastPage.customSnackbar(context, message:exception.toString());
    } catch (e) {
      BotToastPage.customSnackbar(context, message:e.toString());
    }
  }

  showAlertDialog(int index) {
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
                              result[currentIndex].portName,
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
                              result[currentIndex].portType,
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
                              result[currentIndex].portDesc,
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
                              result[currentIndex].systemDesc,
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

  /*showClearAlertDialog(BuildContext context,String text,String title) {
    Timer(Duration(seconds: 3), () {});
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Clear",style: TextStyle(color: Colors.red),),
      onPressed:  () async {
        await SettingsHelper().clearData();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(text),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }*/

  String _imagePath(int index) {
    if (result[index].portType == 'RFC')
      return 'assets/images/sapimage.png';
    else if (result[index].portType == 'SALES_FORCE_PORT')
      return 'assets/images/salesforceimage.png';
    else if (result[index].portType == 'MYSQL')
      return 'assets/images/mysqlimage.png';
    else if (result[index].portType == 'SHAREPOINT_PORT')
      return 'assets/images/sharepointimage.png';
    else
      return 'assets/images/generalimage.png';
  }
}