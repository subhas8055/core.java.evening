import 'dart:isolate';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IsolateExample extends StatefulWidget {
  @override
  _IsolateExampleState createState() => _IsolateExampleState();
}

class _IsolateExampleState extends State<IsolateExample> {
  ReceivePort? _receivePort;
  ReceivePort? _receivePort1;

  int? _result ;
  String? result1;

  @override
  void initState() {
    super.initState();
    _receivePort = ReceivePort();
    _receivePort1 = ReceivePort();
    _startIsolate();
  }

  void _startIsolate() async {
    Isolate isolate = await Isolate.spawn(_isolateFunction, _receivePort!.sendPort);
    isolate.addOnExitListener(_receivePort!.sendPort);

    Isolate isolate2 = await Isolate.spawn(_isolateFunctionTwo, _receivePort1!.sendPort);
    isolate2.addOnExitListener(_receivePort1!.sendPort);

  }

  static void _isolateFunction(SendPort sendPort) {
    print("running  in new thread");
    int result =0;


    for (int i = 0; i < 10; i++) {
      result += i;
      print(result);
    }
    sendPort.send(result!);
    print("thread complete");
  }

  static void _isolateFunctionTwo(SendPort sendPort) {
    print("running  in Second new thread");
    String result1 ="Name";

    for (int i = 0; i < 10; i++) {
      result1 = result1+'$i';
      print(result1);
    }

    sendPort.send(result1!);
    print("Second thread complete");
  }

  @override
  void dispose() {
    _receivePort!.close();
    _receivePort1!.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Isolate Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Result :',
            ),
            Text(
              '$_result .. $result1',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(onPressed: (){
              _receivePort1!.listen((message1) {
                     _receivePort!.listen((message) {
                          setState(() {
                             _result = message as int;
                             result1 = message1 as String?;
                                  });
                           });
                      });
            }, child: Text("isolate")),
          ],
        ),
      ),


    );
  }
}