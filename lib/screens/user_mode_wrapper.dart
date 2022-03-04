import 'package:flutter/cupertino.dart';
import 'package:flutter_login_register_ui/api/api.dart';
import 'package:flutter_login_register_ui/screens/customer_home.dart';
import 'package:flutter_login_register_ui/screens/home.dart';
import 'package:flutter_login_register_ui/screens/map.dart';
import 'package:flutter_login_register_ui/screens/situation.dart';

class UserModeWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if(Api.mode == modes.VOLUNTEER)
      return CustomerHome();
    else if(Api.mode == modes.CUSTIOMER)
      return Home();  
  }
  
}