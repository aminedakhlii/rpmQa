import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_register_ui/api/api.dart';
import 'package:flutter_login_register_ui/api/auth_service.dart';
import 'package:flutter_login_register_ui/screens/image_picker.dart';
import 'package:flutter_login_register_ui/screens/signin_page.dart';
import 'package:flutter_login_register_ui/widgets/verification.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import '../widgets/widget.dart';
import '../constants.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  StringWrapper username = StringWrapper(),phone = StringWrapper(),password = StringWrapper();
  bool passwordVisibility = true;
  bool customer = true , photo = false, passLength = false, phoneLength = false, existant = false;
  String image;
  File carPhoto;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image(
            width: 24,
            color: Colors.white,
            image: Svg('assets/images/back_arrow.svg'),
          ),
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Column(
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context).register,
                            style: kHeadline,
                          ),
                          Text(
                            AppLocalizations.of(context).createanewaccount,
                            style: kBodyText2,
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: MyTextButton(
                                  bgColor: (customer) ? Colors.white : Colors.transparent,
                                  buttonName: AppLocalizations.of(context).customer,
                                  onTap: () {
                                    setState(() {
                                      customer = true;
                                    });
                                  },
                                  textColor: (customer) ? Colors.black87 : Colors.white,
                                ),
                              ),
                              Expanded(
                                child: MyTextButton(
                                  bgColor: (!customer) ? Colors.white : Colors.transparent,
                                  buttonName: AppLocalizations.of(context).volunteer,
                                  onTap: () {
                                    setState(() {
                                      customer = false;
                                    });
                                  },
                                  textColor: (customer) ? Colors.white : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          (customer) ? customerRegister() : volunteerRegister(),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context).already,
                          style: kBodyText,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => SignInPage(),
                              ),
                            );
                          },
                          child: Text(
                            AppLocalizations.of(context).signIn,
                            style: kBodyText.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    MyTextButton(
                      buttonName: AppLocalizations.of(context).register,
                      onTap: () async {
                        print(customer);
                        Api api = Api();
                        existant = await api.checkUser(username.value);
                        if(phone.value.length == 8 && password.value.length >= 6 && !existant){
                          register(api);
                        } else {
                          if(phone.value.length != 8)
                          setState(() {
                            phoneLength = true;
                          });
                          if(password.value.length < 6)
                          setState(() {
                            passLength = true;
                          });
                          if(existant)
                          setState(() {
                            existant = true;
                          });
                        }
                      },
                      bgColor: Colors.white,
                      textColor: Colors.black87,
                    ),
                    SizedBox(height: 5,)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget customerRegister() {
    return Column(
      children: [
        MyTextField(
          hintText: AppLocalizations.of(context).name,
          inputType: TextInputType.name,
          onChanged: username,
        ),
        (existant) ? Text('username already used', style: errorText) : SizedBox(),
        IntlPhoneField(
          dropdownTextStyle: kBodyText,
          style: kBodyText.copyWith(color: Colors.white),
          cursorColor: Colors.white,
          decoration: InputDecoration(
            hintStyle: kBodyText,
            hintText: AppLocalizations.of(context).phone,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 1
                ),
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(
                  color: Colors.white,
                  width: 1
                ),
            ),
          ),
        initialCountryCode: 'QA',
        onChanged: (p) {
            phone.value = p.completeNumber;
        },
        ),
        (phoneLength) ? Text('Phone number length must be 8', style: errorText) : SizedBox(),
        MyPasswordField(
          isPasswordVisible: passwordVisibility,
          onTap: () {
            setState(() {
              passwordVisibility = !passwordVisibility;
            });
          },
          onChanged: password,
        ),
        (passLength) ? Text('Password length must be greater than 6', style: errorText) : SizedBox()
      ],
    );
  }

  Widget volunteerRegister() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyTextField(
          hintText: 'Name',
          inputType: TextInputType.name,
          onChanged: username,
        ),
        (existant) ? Text('username already used', style: errorText) : SizedBox(),
        IntlPhoneField(
          dropdownTextStyle: kBodyText,
          style: kBodyText.copyWith(color: Colors.white),
          cursorColor: Colors.white,
          decoration: InputDecoration(
            hintStyle: kBodyText,
            hintText: 'Phone Number',
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 1
                ),
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(
                  color: Colors.white,
                  width: 1
                ),
            ),
          ),
        initialCountryCode: 'QA',
        onChanged: (p) {
            phone.value = p.completeNumber;
        },
        ),
        (phoneLength) ? Text('Phone number length must be 8', style: errorText) : SizedBox(),
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  "Equipped car photo",
                  style: kBodyText,
                ),
                SizedBox(width: 5,),
                (photo) ? Icon(Icons.check, color: Colors.green[300],) : SizedBox()
              ],
            ),
            IconButton(
              color: kBackgroundColor,
              icon: Icon(Icons.image, color: Colors.white,),
              onPressed: () async {
                image = await Navigator.push(
                    context,
                    CupertinoPageRoute(
                    builder: (context) => Pick(),
                ));
            }),
          ],
        ),
        SizedBox(height: 10,),
        MyPasswordField(
          isPasswordVisible: passwordVisibility,
          onTap: () {
            setState(() {
              passwordVisibility = !passwordVisibility;
            });
          },
          onChanged: password,
        ),
        (passLength) ? Text('Password length must be greater than 6', style: errorText) : SizedBox()
      ],
    );
  }

  verifyPhone(api) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone.value,
      verificationCompleted: (PhoneAuthCredential credential) {
        register(api);
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e);
        print('failed');
        //Navigator.pop(context);
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
  }

  register(api) {
    if(customer) {
      context.read<AuthService>().signUp(username.value + "@rpm.qa", password.value).then((value) => 
        api.customerSignUp(username.value, phone.value).then((value) => 
        Api.mode = modes.CUSTIOMER)
      ).then((value) => Navigator.popUntil(
          context,
          ModalRoute.withName("/")
        ));
    }
    else {
      context.read<AuthService>().signUp(username.value + "@rpm.qa", password.value).then((value) => 
        api.volunteerSignUp(username.value, phone.value, image).then((value) => 
        Api.mode = modes.VOLUNTEER)
      ).then((value) => Navigator.popUntil(
          context,
          ModalRoute.withName("/")
        ));
    }
  }
}

class StringWrapper {
  String value; 
}