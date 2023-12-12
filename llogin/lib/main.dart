import 'package:flutter/material.dart';
import 'package:llogin/Login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(selectFromMultipleAccounts: true, accountList: [], error: '',),
    );
  }
}
