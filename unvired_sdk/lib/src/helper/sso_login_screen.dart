import 'package:flutter/material.dart';
import 'package:unvired_sdk/src/authentication_service.dart';
import 'package:unvired_sdk/src/database/database.dart';
import 'package:unvired_sdk/src/helper/service_constants.dart';
import 'package:unvired_sdk/src/helper/sync_result.dart';
import 'package:unvired_sdk/src/helper/unvired_account_manager.dart';
import 'package:unvired_sdk/src/helper/webview.dart';
import 'package:unvired_sdk/src/sync_engine.dart';
import 'package:unvired_sdk/src/unvired_account.dart';

class SSOLoginScreen extends StatefulWidget {
  final UnviredAccount unviredAccount;

  const SSOLoginScreen({Key? key, required this.unviredAccount})
      : super(key: key);

  @override
  _SSOLoginScreenState createState() => _SSOLoginScreenState();
}

class _SSOLoginScreenState extends State<SSOLoginScreen> {
  bool isError = false;
  String? errorMessage;
  bool isSuccess = false;

  Size get screenSize => MediaQuery.of(context).size;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context)
            .pop(SSOResult(SSOStatus.FAILED, "Cancelled SSO login."));
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColorDark,
            title: Text('SSO login')),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: isError
              ? Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        errorMessage!,
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(
                                  SSOResult(SSOStatus.FAILED, errorMessage));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Close",
                                style: TextStyle(color: Colors.redAccent),
                              ),
                            )),
                      )
                    ],
                  ),
                )
              : FutureBuilder(
                  future: getSSOUrl(widget.unviredAccount),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData) {
                      return (getPlatform() != PlatformType.windows)
                          ? WebView(
                              url: snapshot.data,
                              onError: (error) {
                                setState(() {
                                  isError = true;
                                  errorMessage = error;
                                });
                              },
                              onSuccess: (token) async {
                                widget.unviredAccount.setIsLastLoggedIn(true);
                                widget.unviredAccount.setPassword("");
                                await UnviredAccountManager().updateAccount(widget.unviredAccount);
                                isSuccess = true;
                                await SyncEngine().initialize();
                                Navigator.of(context)
                                    .pop(SSOResult(SSOStatus.SUCCESS, token));
                              })
                          : Container();
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          children: [
                            Text(snapshot.error.toString()),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop(SSOResult(
                                      SSOStatus.FAILED, snapshot.error));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Close",
                                    style: TextStyle(color: Colors.redAccent),
                                  ),
                                ))
                          ],
                        ),
                      );
                    } else {
                      return Center(
                        child: Column(
                          children: [
                            Text('Getting SSO url...'),
                            Padding(
                              padding: const EdgeInsets.only(top: 18.0),
                              child: CircularProgressIndicator(),
                            )
                          ],
                        ),
                      );
                    }
                  },
                ),
        ),
      ),
    );
    return Container();
  }

  bool? isDialogLoading = false;

  void showDialogLoading(String message, BuildContext context) {
    isDialogLoading = true;
    showDialog(
        useSafeArea: false,
        barrierDismissible: false,
        context: context,
        builder: (_) => Center(
              child: Card(
                elevation: 10,
                shadowColor: Theme.of(context).hintColor,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                child: SizedBox(
                  height: getHeightPercentage(10, context),
                  width: getWidthPercentage(75, context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const CircularProgressIndicator(),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          message,
                          style: const TextStyle(fontSize: 18),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ));
  }

  getWidthPercentage(double percent, BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return ((screenWidth * percent) / 100);
  }

  getHeightPercentage(double percent, BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return ((screenHeight * percent) / 100);
  }

  Future<String?> getSSOUrl(UnviredAccount unviredAccount) async {
    // String? url = "https://umpdev.unvired.io/UMP";
    // String? url ="https://inspdev.carmeuse.com/UMP/";
    String? url = unviredAccount.getUrl();
    if (url.endsWith("UMP/")) {
      url = url + "sso/saml/dologin";
    } else if (url.endsWith("UMP")) {
      url = url + "/sso/saml/dologin";
    } else {
      url = url + "UMP/sso/saml/dologin";
    }
    String appName = await AuthenticationService().getAppName();
    url = url +
        "?company=" +
        unviredAccount.getCompany() +
        "&application=" +
        appName +
        "&device=android";
    return url;
  }
}
