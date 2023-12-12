import 'package:flutter/material.dart';
import 'package:untitled/DB.dart';

import 'Reset.dart';

class Forgot extends StatefulWidget {
  const Forgot({super.key});

  @override
  State<Forgot> createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
  TextEditingController emailConroller = TextEditingController();
  TextEditingController confirmPasswordConroller = TextEditingController();
  TextEditingController newPasswordConroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Apbar',style: TextStyle(color: Colors.black ),),
        centerTitle: true,

      ),
      body: _getBody(),
    );
  }

  _getBody() {
    return  Column(
      children: [
Row(
  children: [

    TextField(
      controller: emailConroller,
      // onEditingComplete: ,
      decoration: InputDecoration(
          label: Text('Email'),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(40.0)),
          )
      ),
    ),
    // ElevatedButton(onPressed:(){getData();} , child: const Text('Reset')),
  ],
),

         TextField(
           controller: newPasswordConroller,
          decoration: InputDecoration(
              label: Text('New Passwrd'),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(40.0)),
              )
          ),
        ),
        TextField(
          controller:confirmPasswordConroller ,
          decoration: InputDecoration(
              label: Text('Old Passwrd'),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(40.0)),
              )
          ),
        ),
        ElevatedButton(onPressed: (){
          if(confirmPasswordConroller == newPasswordConroller){
            DbHelper db= DbHelper();
            db.updateByEmail1(emailConroller as String, newPasswordConroller as String);
          }
        }, child: Text('Reset Password')),
      ],
    );
  }
  Future getData(String email) async{
    DbHelper db =DbHelper();
    db.getByEmail1(email);
  }
}
