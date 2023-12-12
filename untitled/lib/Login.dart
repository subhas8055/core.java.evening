
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Dto.dart';

class Login extends StatefulWidget {
  Dto dto= Dto.data();
  Login(dto, {super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body:_getBody(),
    );
  }

  _getBody() {
    return  Container(
      color: Colors.blue,
      margin: EdgeInsets.all(20.0),
      height: 34,
      width: 600,
    );
  }
}
