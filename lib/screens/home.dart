import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_register_ui/api/api.dart';
import 'package:flutter_login_register_ui/api/auth_service.dart';
import 'package:flutter_login_register_ui/screens/profile.dart';
import 'package:flutter_login_register_ui/screens/route.dart';
import 'package:flutter_login_register_ui/screens/situation.dart';
import 'package:provider/src/provider.dart';
import '../constants.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import '../widgets/widget.dart';

class Home extends StatefulWidget {
  Home();

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Api api = Api();

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
                    SizedBox(height: 20,),
                    Card(
                      color: Colors.pink[800],
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: InkWell(
                        onTap: (){
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                            builder: (context) => Situation(),
                          ));
                        },
                        child: Container(
                          height: 70,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ListTile(
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(AppLocalizations.of(context).emergency, style: cardTitleText,),
                                    Icon(Icons.add, color: Colors.white, size: 30,)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(AppLocalizations.of(context).waiting, style: kBodyText,)
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      child: FutureWidget(
                        f: api.fetchPostsByUser(),
                        w: card
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(AppLocalizations.of(context).accepted, style: kBodyText,)
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      child: FutureWidget(
                        f: api.fetchAcceptedPostsByUser(),
                        w: card
                      ),
                    ),
                    SizedBox(height: 20,),
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
          color: Colors.pink[800],
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
              )).then((value) => setState((){}));
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
