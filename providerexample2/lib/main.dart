import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartModel(),
      child: const MyApp(),
    ),
  );

}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MyApp"),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              color: Colors.blueAccent,
              child: Row(
                children: [

                ],
              ),
            ),
            Spacer(),
            Container(),
            Spacer(),
            Container()
          ],
        ),
      ),
    );
  }
}
