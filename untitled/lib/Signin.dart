import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'DB.dart';
import 'Dto.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}
class _SigninState extends State<Signin> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
        centerTitle: true,
              ),
      body:_getBody(),
    );
  }

   save(Dto dto) {
    DbHelper db = DbHelper();
    db.save(dto);
   }

  _getBody() {
    return  Center(
      child: Container(
        width: 800,
        child: const Column(
          children: [
            Form(child: Column(
              children: [
                TextField(

                  decoration: InputDecoration(
                    label:Text('Name'),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    ),
                  ),
                ),
                TextField( decoration: InputDecoration(
                  label:Text('Email'),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                  ),
                ),),
                TextField( decoration: InputDecoration(
                  label:Text('Mobile No'),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                  ),
                ),),
                TextField(
                  decoration: InputDecoration(
                    label:Text('Password'),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    ),
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                    label:Text('Confirm Password'),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    ),
                  ),
                ),

                // ElevatedButton(onPressed:save(), child: Text('Save')),

              ],
            ))
          ],
        ),
      ),
    );
  }

}
