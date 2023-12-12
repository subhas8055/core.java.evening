import 'package:flutter/material.dart';
import 'package:unvired_sdk/unvired_sdk.dart';

class LoginPage extends StatefulWidget {
  bool selectFromMultipleAccounts;
  List<UnviredAccount>? accountList;
  UnviredAccount? selectedAccount;
  String error;

  LoginPage(
      {Key? key,
        required this.selectFromMultipleAccounts,
        required this.accountList,
        required this.error,
        this.selectedAccount})
      : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController urlController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  String? selectedFrontEndId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userNameController.text = "MADHU";
    passwordController.text = "unvired";
    companyNameController.text = "unvired";
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            color: Theme.of(context).primaryColorDark,
            child: FutureBuilder(
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  if (!snapshot.data) {
                    //There is no multiple account in the device
                    if (widget.selectedAccount != null) {
                      urlController.text = widget.selectedAccount!.getUrl();
                      companyNameController.text =
                          widget.selectedAccount!.getCompany();
                      userNameController.text =
                          widget.selectedAccount!.getUserName();
                      passwordController.text = '';
                      if (widget.selectedAccount!.getAvailableFrontendIds().length >
                          1) {
                        // Multiple frontend ID available, show dialog to select one Frontend ID
                        Future.delayed(const Duration(seconds: 1), () {
                          showMyDialog(
                              "Select one ID",
                              widget.selectedAccount!.getAvailableFrontendIds(),
                              onFrontEndIdSelected);
                        });
                      }
                    }
                    urlController.text = "http://192.168.98.160:8080";
                  } else {
                    _showMultipleAccounts(context);
                  }
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          child: Image.asset("assets/images/unvired_logo.png"),
                          height: 200,
                          width: double.infinity,
                        ),
                        _getCredentialsCard(context),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
              future: checkMultipleAvailableAccounts(),
            ),
          ),
        ));
  }

  Widget _getCredentialsCard(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Card(
      color: Theme.of(context).cardColor,
      margin: width > 500
          ? EdgeInsets.only(
          top: (10 * height) / 100,
          right: (30 * width) / 100,
          left: (30 * width) / 100)
          : const EdgeInsets.only(top: 20, right: 20, left: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /*Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                controller: urlController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'URL',
                  fillColor: Colors.white,
                  hintStyle: const TextStyle(fontSize: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  filled: true,
                  contentPadding: const EdgeInsets.all(10),
                ),
              ),
            ),*/
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                controller: companyNameController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Company',
                  fillColor: Colors.white,
                  hintStyle: const TextStyle(fontSize: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
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
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                controller: userNameController,
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
                      style: BorderStyle.none,
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
                controller: passwordController,
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
                      style: BorderStyle.none,
                    ),
                  ),
                  filled: true,
                  contentPadding: const EdgeInsets.all(10),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).primaryColorDark),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.all(20)),
                ),
                child: const Text('Login'),
                onPressed: () {
                  _validateData();
                },
              ),
            ),
            InkWell(
              onTap: () async {
                UnviredAccount unviredAccount = UnviredAccount()
                  ..setUserName(userNameController.text.toString())
                  ..setPassword("")
                  ..setCompany(companyNameController.text.toString())
                  ..setUrl(urlController.text.toString())
                  ..setLoginType(LoginType.saml);
                Navigator.pop(context, unviredAccount);
              },
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                child: const Center(
                  child: Text(
                    'Login with SSO',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
            Visibility(
                visible: widget.error.isEmpty ? false : true,
                child: Container(
                  margin: const EdgeInsets.only(
                      top: 15, left: 15, right: 15, bottom: 10),
                  child: Text(
                    widget.error.toString(),
                    style: const TextStyle(color: Colors.redAccent),
                    textAlign: TextAlign.center,
                  ),
                ))
          ],
        ),
      ),
    );
  }

  _showSnackBar(BuildContext context, String content, String label) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(content),
      action: SnackBarAction(label: label, onPressed: () => {}),
    ));
  }

  Future<bool?> checkMultipleAvailableAccounts() async {
    if (widget.accountList!.isEmpty) {
      return false;
    } else {
      if (widget.accountList!.length == 1) {
        widget.selectedAccount = widget.accountList![0];
        return false;
      } else {
        return true;
      }
    }
  }

  void _showMultipleAccounts(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          title: Text("Wifi"),
          content: Text("Wifi not detected. Please activate it."),
        ));
  }

  void _validateData() {
    if (urlController.text.isEmpty) {
      _showSnackBar(context, "Url field cannot be empty", "Ok");
    } else if (companyNameController.text.isEmpty) {
      _showSnackBar(context, "Company field cannot be empty", "Ok");
    } else if (userNameController.text.isEmpty) {
      _showSnackBar(context, "Username field cannot be empty", "Ok");
    } else if (passwordController.text.isEmpty) {
      _showSnackBar(context, "Password field cannot be empty", "Ok");
    } else {
      if (widget.selectedAccount == null) {

        //First time loggingIn construct a new UnviredAccount object

        widget.selectedAccount = UnviredAccount()
          ..setUserName(userNameController.text.toString())
          ..setPassword(passwordController.text.toString())
          ..setCompany(companyNameController.text.toString())
          ..setUrl(urlController.text.toString())
          ..setLoginType(LoginType.unvired);
      } else {

        //UnviredAccount already constructed update the fields

        widget.selectedAccount!.setUrl(urlController.text.toString());
        widget.selectedAccount!.setUserName(userNameController.text.toString());
        widget.selectedAccount!.setPassword(passwordController.text.toString());
        widget.selectedAccount!
            .setCompany(companyNameController.text.toString());
        widget.selectedAccount!.setLoginType(LoginType.unvired);
      }
      Navigator.pop(context, widget.selectedAccount);
    }
  }

  void onFrontEndIdSelected(String frontEndId) {
    selectedFrontEndId = frontEndId;
    widget.selectedAccount!.setFrontendId(selectedFrontEndId!);
  }
}
