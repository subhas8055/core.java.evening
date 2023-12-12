
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:providerexample/example.dart';

import 'Screen1.dart';
import 'asd.dart';

void main() {
  runApp(ChangeNotifierProvider(create: (context)=>ProExample(),
    child:  MyApp(),));

}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   return MaterialApp(
     home:Screen1() ,
   );
  }
}
