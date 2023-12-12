import 'dart:js';

import 'package:flutter/material.dart';
import 'package:untitled/DB.dart';
import 'package:untitled/Forgot.dart';
import 'Dto.dart';
import 'Login.dart';
import 'Signin.dart';


void main() {
  runApp( MyApp());

}

class MyApp extends StatelessWidget {
   MyApp({super.key});
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Demo'),
          centerTitle: true,
          backgroundColor: Colors.green ,
          ),
        body:_getBody(context),
      ),);}

  _getBody(BuildContext context){
    return Form(
      child: Center(
        child: Container(
          width: 800,
          child: Column(
              children: [
                Spacer(),
                  TextField(
                  controller: emailController,
                    decoration: InputDecoration(
                      label: Text('Email'),
                      enabledBorder: OutlineInputBorder(borderRadius:BorderRadius.all(Radius.circular(40.0)) ),
                      disabledBorder: OutlineInputBorder(borderRadius:BorderRadius.all(Radius.circular(40.0)) ),
                    ),
                  ),
                Spacer(),
                 TextField(
                  controller: passwordController,
                      decoration: InputDecoration(
                          label: Text('Password'),
                          enabledBorder: OutlineInputBorder(borderRadius:BorderRadius.all(Radius.circular(40.0)) )

                      )),
Spacer(),
                ElevatedButton(onPressed: ()async{
                  if(emailController != null && passwordController != null){
                    DbHelper db= DbHelper();
                   Dto dto=await db.getByEmail(emailController as String, passwordController as String);
                   if(dto != null){
                     Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Login(dto)));

                   }else{
                      const Text('invalid email Id or Password');
                   }
                  }
                }, child: const Text('Login')),
                Spacer(),
                Row(
                  children: [
                    TextButton(onPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const Signin()));}, child: Text('Create Account')),
                    Spacer(),
                    TextButton(onPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Forgot()));}, child: Text('Forgot password')),
                    ],),
                Spacer(), Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     IconButton(
                       onPressed: (){},
                       icon: Icon(Icons.facebook),
                     ),
                     IconButton(
                       onPressed: (){},
                       icon: Icon(Icons.mail),
                     ),
                     IconButton(
                       onPressed: (){},
                       icon: Icon(Icons.mail),
                     ),
                     IconButton(
                       onPressed: (){},
                       icon: Icon(Icons.home),
                     )
                   ],
                  ),
                ), Spacer(), Spacer(), Spacer(), Spacer(), Spacer(), Spacer(),  Spacer(),  Spacer(),
              ] ),),),);
  }
 }


