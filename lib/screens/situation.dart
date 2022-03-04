import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_register_ui/api/auth_service.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../screens/screen.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import '../widgets/widget.dart';

class Situation extends StatefulWidget {
  @override
  _SituationState createState() => _SituationState();
}

class _SituationState extends State<Situation> {
  
  void _showMap(int situation){
    Navigator.push(context,
      CupertinoPageRoute(builder: (context) => MapPage(situation: situation,)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
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
                      fit: FlexFit.loose,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context).chooseyoursituation,
                            style: kHeadline,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          MyTextButton(
                            buttonName: AppLocalizations.of(context).stuckinsand,
                            onTap: () {
                              _showMap(1);
                            },
                            bgColor: Colors.white,
                            textColor: Colors.black87,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          MyTextButton(
                            buttonName: AppLocalizations.of(context).drowning,
                            onTap: () {
                              _showMap(2);
                            },
                            bgColor: Colors.white,
                            textColor: Colors.black87,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          MyTextButton(
                            buttonName: AppLocalizations.of(context).outoffuel,
                            onTap: () {
                              _showMap(3);
                            },
                            bgColor: Colors.white,
                            textColor: Colors.black87,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          MyTextButton(
                            buttonName: AppLocalizations.of(context).flattire,
                            onTap: () {
                              _showMap(4);
                            },
                            bgColor: Colors.white,
                            textColor: Colors.black87,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          MyTextButton(
                            buttonName: AppLocalizations.of(context).overturned,
                            onTap: () {
                              _showMap(5);
                            },
                            bgColor: Colors.white,
                            textColor: Colors.black87,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          MyTextButton(
                            buttonName: AppLocalizations.of(context).batterycharging,
                            onTap: () {
                              _showMap(6);
                            },
                            bgColor: Colors.white,
                            textColor: Colors.black87,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
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
