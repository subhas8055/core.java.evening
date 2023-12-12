import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

class BotToastPage {
  /*customToastMessage(String message) {
    BotToast.showAttachedWidget(
        allowClick: true,
        attachedBuilder: (_) => Center(
              child: Wrap(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Card(
                      color: Colors.black87,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              message,
                              style: TextStyle(color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        target: Offset(520, 520),
        duration: Duration(seconds: 3));
  }*/

  customLoading() {
    BotToast.showLoading(allowClick: true, duration: Duration(seconds: 3));
  }

  timedCustomLoading(BuildContext context,int seconds) {
    BotToast.showLoading(
        allowClick: false, duration: Duration(seconds: seconds));
  }

  customNormalToast(String message) {
    BotToast.showText(
        text: message,
        textStyle: TextStyle(color: Colors.white),
        align: Alignment.center);
  }

  static void customSnackbar(BuildContext context, {required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
    SnackBar(
      content: Text(message),
    );
  }
}
