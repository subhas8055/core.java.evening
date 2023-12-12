
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Reset extends StatefulWidget {
  const Reset({super.key});

  @override
  State<Reset> createState() => _ResetState();
}

class _ResetState extends State<Reset> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,

      ),
      body: _getBody(),
    );
  }

  _getBody() {
    return const Column(
      children: [
       ],
    );
  }


}
