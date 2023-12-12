import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/src/response.dart';

class InitializationPage extends StatefulWidget {
   InitializationPage({super.key});

  String? result;
  InitializationPage.data(String result)
  {
    this.result=result;
  }  @override
  State<InitializationPage> createState() => _InitializationPageState();
}

class _InitializationPageState extends State<InitializationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("APp"),
      ),
      body: Container(
        color: Colors.green,

      ),
    );
}
}
