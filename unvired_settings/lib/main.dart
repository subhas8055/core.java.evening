import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:unvired_settings/screens/settings_page.dart';

// void main() {
//   runApp(MyApp());
// }

class Settings extends StatelessWidget {
  final ThemeData themeData;
  static const routeName = "/unviredSettings";
  const Settings({Key? key, required this.themeData}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    GlobalKey<NavigatorState> navigatorkey = GlobalKey<NavigatorState>();

    return MaterialApp(
      title: 'Flutter Demo',
      builder: BotToastInit(),
      debugShowCheckedModeBanner: false,
      navigatorObservers: [BotToastNavigatorObserver()],
      navigatorKey: navigatorkey,
      theme: themeData,
      home: SettingsPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
