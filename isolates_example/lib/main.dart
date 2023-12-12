import 'package:flutter/material.dart';
import 'package:isolates_example/provider.dart';
import 'package:provider/provider.dart';
import 'dart:isolate';

import 'asd.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Counter(), // Providing the Counter instance
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text('Provider Example'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Using Consumer to listen to Counter changes and rebuild UI
                Consumer<Counter>(
                  builder: (context, counter, child) => Text(
                    'Count: ${counter.count}',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    // Using Provider.of to directly access the Counter instance
                    ElevatedButton(
                      onPressed: () =>
                          Provider.of<Counter>(context, listen: false)
                              .increment(),
                      child: Text('Increment'),
                    ),
                    ElevatedButton(
                      onPressed: () =>
                          Provider.of<Counter>(context, listen: false)
                              .decrement(),
                      child: Text('Decrement'),
                    ),
                    ElevatedButton(
                      onPressed: () =>
                         Navigator.of(context).push(MaterialPageRoute(builder: (context)=>IsolateExample())),
                      child: Text('Isolate Example'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



