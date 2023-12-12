
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task1_login/InitializationPage.dart';
import 'package:http/http.dart'
    '';

class SplashSreenPage extends StatefulWidget {
  const SplashSreenPage({super.key});

  @override
  State<SplashSreenPage> createState() => _SplashSreenPageState();
}

class _SplashSreenPageState extends State<SplashSreenPage> {

  List list =["as","sd","df"];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("APP"),

      ),

      body: Container(
        child: ElevatedButton(
          onPressed: ()async{
            String result = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

            Navigator.of(context).push(MaterialPageRoute(builder: (context)=> InitializationPage.data(result)));
          },
          child: Text(list.toString()),
        ),
      ),
    );
  }


}
