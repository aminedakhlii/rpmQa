import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_register_ui/constants.dart';
import 'package:flutter_login_register_ui/screens/register_page.dart';
import 'package:flutter_login_register_ui/widgets/my_text_field.dart';
import 'package:flutter_login_register_ui/widgets/widget.dart';
import 'package:provider/provider.dart';

import '../api/api.dart';
import '../api/auth_service.dart';

class Verification extends StatefulWidget {
  String id, image;
  bool change = false;
  Verification({this.id});
  @override
  State<StatefulWidget> createState() => VerifState(); 
}

class VerifState extends State<Verification> {
  StringWrapper code = StringWrapper(); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Enter verification code', style: cardBodyText,),
              MyTextField(hintText: 'code', inputType: TextInputType.number, onChanged: code),
              Container(
                width: 120,
                child: MyTextButton(
                  buttonName: 'Verify', 
                  onTap: () async {
                    FirebaseAuth auth = FirebaseAuth.instance;
                    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: widget.id, smsCode: code.value);
                    if(widget.change){
                      User user = FirebaseAuth.instance.currentUser;
                      await user.updatePhoneNumber(credential);
                    }
                    else 
                      await auth.signInWithCredential(credential);
                    Navigator.popUntil(
                      context, 
                      ModalRoute.withName("/")
                    );
                  },
                  bgColor: Colors.white, 
                  textColor: Colors.black
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
}