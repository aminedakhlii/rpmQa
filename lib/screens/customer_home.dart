import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_register_ui/api/api.dart';
import 'package:flutter_login_register_ui/api/auth_service.dart';
import 'package:flutter_login_register_ui/screens/profile.dart';
import 'package:flutter_login_register_ui/screens/route.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/src/provider.dart';
import '../constants.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import '../widgets/widget.dart';

class CustomerHome extends StatefulWidget {
  CustomerHome();

  @override
  _CustomerHomeState createState() => _CustomerHomeState();
}

class _CustomerHomeState extends State<CustomerHome> {
  Api api = Api();
  AuthService as = AuthService();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        title: Text(AppLocalizations.of(context).home, style: kHeadline,),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(
                context,
                CupertinoPageRoute(
                builder: (context) => Profile(),
              ));
          }, icon: Icon(Icons.person))
        ],
      ),
      body: SafeArea(
        //to make page scrollable
        child: CustomScrollView(
          reverse: false,
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                    Flexible(
                      fit: FlexFit.tight,
                      child: FutureWidget(
                        f: api.fetchPosts(),
                        w: card
                      ),
                    ),
                    SizedBox(
                      height: 20,
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

  Widget card(post){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Container(
        height: 400,
        child: Card(
          color: Colors.teal[800],
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: InkWell(
            onTap: (){
              Navigator.push(
                context,
                CupertinoPageRoute(
                builder: (context) => MapRoute(post: post),
              ));
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                    image: DecorationImage(image: NetworkImage(post.snapUrl), 
                    fit: BoxFit.cover)
                  ),
                  ),
                ListTile(
                  title: Text(situations[post.situation], style: cardTitleText,),
                  subtitle: Text(post.date.toString(), style: cardBodyText,),
                ),
              ],
            ),
          )
        ),
      ),
    );
  } 
}
