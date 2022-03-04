import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_register_ui/api/api.dart';
import 'package:flutter_login_register_ui/constants.dart';

class LoadingDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

class FutureWidget extends StatelessWidget {
  final Function w;
  final Future<dynamic> f;
  FutureWidget({this.w,this.f});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: f,
      builder: (context,snapshot){
        if(snapshot.hasData){
          if(snapshot.data.length == 0)
            return SizedBox();
          return Column(
            children: [
              for(Post post in snapshot.data) w(post)
            ],
          );
        }
        else return LoadingDialog();  
      });
  }
}