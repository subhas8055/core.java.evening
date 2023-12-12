import 'package:flutter/material.dart';

class Utils{

  static void showSimpleAlertDialog(BuildContext context,String title,String message){
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text("okay"),
          ),
        ],
      ),
    );
  }

  static showSnackBar(BuildContext context, String content, String label) {

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(content),
      action: SnackBarAction(label: label, onPressed: () => {}),
    ));
  }

  showLoader(BuildContext context,String message){

    showDialog(context: context,barrierDismissible: false, builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.white70,
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
            Container(
              margin: const EdgeInsets.only(left: 10),
              child: Text(message,style: const TextStyle(color: Colors.black,fontSize: 18),),
            )
          ],
        ),
      );
    });


  }

}