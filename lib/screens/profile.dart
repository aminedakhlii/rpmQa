import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_register_ui/api/api.dart';
import 'package:flutter_login_register_ui/api/auth_service.dart';
import 'package:flutter_login_register_ui/screens/image_picker.dart';
import 'package:flutter_login_register_ui/screens/register_page.dart';
import 'package:flutter_login_register_ui/widgets/verification.dart';
import 'package:flutter_login_register_ui/widgets/widget.dart';
import 'package:provider/src/provider.dart';

import '../constants.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  StringWrapper phone = StringWrapper(), password = StringWrapper();
  bool passwordVisibility = false;
  String image;
  User user;
  CurrentUser cu;
  Api api = Api();

  initUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    user = auth.currentUser;
    cu = await api.fetchUser('email', user.email);
  }

  @override
  void initState() {
    super.initState();
    initUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        title: Text(AppLocalizations.of(context).profile, style: kHeadline,),
      ),
      body: SafeArea(
        child: CustomScrollView(
          reverse: false,
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                  SizedBox(height: 20,),
                  FutureBuilder(
                    future: api.fetchUser("email", user.email),
                    builder: (bc,snap) {
                      if(snap.hasData)
                        return Stack(
                          children: [ 
                              Center(
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundImage: NetworkImage(
                                    snap.data.image ?? "",
                                  ),
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: IconButton(
                                      onPressed: () async {
                                        image = await Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                            builder: (context) => Pick(),
                                        ));
                                      },
                                      icon: Icon(Icons.settings),
                                      color: Colors.white,
                                      iconSize: 40,
                                    )),
                                ),
                              ),
                          ]
                        );
                        else return CircleAvatar(radius: 60,); 
                    }),
                  Text(user.email.substring(0,user.email.indexOf('@')) , style: kHeadline,),
                  FutureBuilder(
                    future: api.fetchUser("email", user.email),
                    builder: (bc,snap) {
                      if(snap.hasData)
                        return Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Text(
                            "Phone: " + snap.data.phone,
                            style: kBodyText,
                            textAlign: TextAlign.center,
                          ),
                      );
                     else return Text("Failed!", style: kBodyText,);
                  }
                  ),
                  SizedBox(height: 40,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: 320,
                        child: MyTextField(
                          hintText: AppLocalizations.of(context).newphone,
                          inputType: TextInputType.phone,
                          onChanged: phone,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: 320,
                        child: MyPasswordField(
                          isPasswordVisible: passwordVisibility,
                          onTap: () {
                            setState(() {
                              passwordVisibility = !passwordVisibility;
                            });
                          },
                          onChanged: password,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Container(
                    width: 200,
                    child: MyTextButton(
                        buttonName: AppLocalizations.of(context).confirmch,
                        onTap: () async {
                          if(phone.value != null && phone.value.length == 8)
                            await FirebaseAuth.instance.verifyPhoneNumber(
                              phoneNumber: phone.value,
                              verificationCompleted: (PhoneAuthCredential credential) {
                                
                              },
                              verificationFailed: (FirebaseAuthException e) {
                                print(e);
                                print('failed');
                                Navigator.pop(context);
                              },
                              codeSent: (String verificationId, int resendToken) {
                                print('sent');
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                  builder: (context) => Verification(id: verificationId,),
                                ));
                              },
                              codeAutoRetrievalTimeout: (String verificationId) {
                                print('timeout');
                              },
                            );
                          if(phone.value != null && phone.value.length > 0){
                            await api.modifyUser('email', user.email, {
                              'phone': phone.value,
                            });
                          }
                          if(password.value != null && password.value.length > 5){
                            await user.updatePassword(password.value);
                          }
                          if(image != null && image.length > 0){
                            await api.updateImage(user.email,image);
                          }
                          Navigator.popUntil(
                              context, 
                              ModalRoute.withName("/")
                          );
                        },
                        bgColor: Colors.green,
                        textColor: Colors.white,
                      ),
                  ),
                  SizedBox(height: 80,),
                  Container(
                    width: 150,
                    child: MyTextButton(
                        buttonName: AppLocalizations.of(context).logout,
                        onTap: () async {
                          context.read<AuthService>().signOut().then((value) => 
                            Navigator.popUntil(
                              context, 
                              ModalRoute.withName("/")
                            ));
                        },
                        bgColor: Colors.white,
                        textColor: Colors.black87,
                      ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    width: 190,
                    child: MyTextButton(
                      buttonName: AppLocalizations.of(context).deleteacc,
                      onTap: () async {
                        Api api = Api();
                        api.deleteAccount(user.email); 
                        Navigator.popUntil(
                              context, 
                              ModalRoute.withName("/")
                        );                         
                      },
                      bgColor: Colors.red,
                      textColor: Colors.white,
                    ),
                  ),
                ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}