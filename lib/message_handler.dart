import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_register_ui/main.dart';
import 'package:flutter_login_register_ui/screens/route.dart';
import 'dart:io';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class MessageHandler extends StatefulWidget {
  final Widget child;
  MessageHandler({this.child});
  @override
  State createState() => MessageHandlerState();
}

class MessageHandlerState extends State<MessageHandler> {
  final FirebaseMessaging fm = FirebaseMessaging.instance;
  Widget child;

  @override
  void initState() {
    super.initState();
    child = widget.child;
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      LatLng position = LatLng(message.data['lat'], message.data['long']);
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => MapRoute.fromDestination(position,),
        ));                
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      LatLng position = LatLng(message.data['lat'], message.data['long']);
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => MapRoute.fromDestination(position,),
        ));                
    });
    FirebaseMessaging.instance.getInitialMessage().then((message) async {
      print("onMessage: ${message.data['screen']}");
      LatLng position = LatLng(message.data['lat'], message.data['long']);
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => MapRoute.fromDestination(position),
        ));
    });
    FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
      LatLng position = LatLng(message.data['lat'], message.data['long']);
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => MapRoute.fromDestination(position,),
        ));                
    });
    fm.getToken().then((token){
      print(token);
    });

  }

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

Future<dynamic> _handleNotification (Map<String, dynamic> message) async {
  print("onMessage: ${message['data']['screen']}");
  LatLng position = LatLng(message['data']['lat'], message['data']['long']);
  navigatorKey.currentState.push(
    CupertinoPageRoute(
      builder: (context) => MapRoute.fromDestination(position,),
  ));
}