import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("App"),
        ),
        body: Container(
          color: Colors.greenAccent,
          width: 400,
          height: 400,
          margin: EdgeInsets.all(20.0),
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              BackButton(color: Colors.red,),


            ],
          ),
        ),
      ),
    );
  }
}
