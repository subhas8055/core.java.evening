
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SnackBarUtils{
  showSnackBar(BuildContext context, String content, String label) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(content),
      action: SnackBarAction(label: label, onPressed: () => {}),
    ));
  }
}