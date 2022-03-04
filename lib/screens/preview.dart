import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_login_register_ui/screens/home.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_register_ui/api/api.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../constants.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import '../widgets/widget.dart';

class Preview extends StatefulWidget {
  final int situation;
  final String snap;
  final LatLng location;
  Preview({this.situation, this.location, this.snap});

  @override
  _PreviewState createState() => _PreviewState();
}

class _PreviewState extends State<Preview> {

  @override
  Widget build(BuildContext context){
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
          reverse: false,
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context).reportPreview,
                            style: kHeadline,
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Text(
                            AppLocalizations.of(context).situation + " : " + situations[widget.situation].toString(),
                            style: kBodyText,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Location : (lat: " + widget.location.latitude.toString() + " , long: " + widget.location.latitude.toString() + " )" ,
                            style: kBodyText,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Snap : ",
                            style: kBodyText,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Image.file(File(widget.snap))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    MyTextButton(
                      buttonName: AppLocalizations.of(context).submit,
                      onTap: () async {
                        final firebaseStorageRef = FirebaseStorage.instance.ref().child('uploads/snaps/'+ widget.situation.toString()+ "lat:" + widget.location.latitude.toString() + "long:" + widget.location.latitude.toString());
                        final uploadTask = await firebaseStorageRef.putFile(File(widget.snap)).then((p0) async {
                          String snap = await firebaseStorageRef.getDownloadURL();
                          Api api = Api();
                          api.cast(widget.situation, snap , widget.location);
                          Navigator.popUntil(
                            context, 
                            ModalRoute.withName("/")
                          );
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
                        });
                      },
                      bgColor: Colors.white,
                      textColor: Colors.black87,
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
