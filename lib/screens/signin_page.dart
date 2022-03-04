import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_register_ui/api/api.dart';
import 'package:flutter_login_register_ui/api/auth_service.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../screens/screen.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import '../widgets/widget.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  StringWrapper username = StringWrapper(), password = StringWrapper();
  bool isPasswordVisible = true;
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
        //to make page scrollable
        child: CustomScrollView(
          reverse: true,
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context).welcomeback,
                            style: kHeadline,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "You've been missed!",
                            style: kBodyText2,
                          ),
                          SizedBox(
                            height: 60,
                          ),
                          MyTextField(
                            hintText: AppLocalizations.of(context).username,
                            inputType: TextInputType.text,
                            onChanged: username,
                          ),
                          MyPasswordField(
                            isPasswordVisible: isPasswordVisible,
                            onTap: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                            onChanged: password,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context).dont,
                          style: kBodyText,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => RegisterPage(),
                              ),
                            );
                          },
                          child: Text(
                            AppLocalizations.of(context).register,
                            style: kBodyText.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    MyTextButton(
                      buttonName: AppLocalizations.of(context).signIn,
                      onTap: () async {
                        bool withPhone = false; 
                        CurrentUser user ; 
                        Api api = Api();
                        if (username.value.length == 8 && int.tryParse(username.value) != null ){
                          withPhone = true;
                          user = await api.fetchUser('phone', username.value); 
                          username.value = user.username;
                        }
                        context.read<AuthService>().emailSignIn(username.value + "@rpm.qa", password.value).then((value) => 
                          api.login(username.value + "@rpm.qa").then((value) => 
                          Navigator.popUntil(
                              context, 
                              ModalRoute.withName("/")
                          )
                        ));
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
}
