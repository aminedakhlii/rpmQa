import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_login_register_ui/api/api.dart';

class AuthService {
  FirebaseAuth firebaseAuth;
  Stream<User> get authStateChanges => firebaseAuth.authStateChanges();
  AuthService({this.firebaseAuth});

  Future<bool> emailSignIn(String email, String password) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> phoneSignIn(String phone, String password) async {
    try {
      await firebaseAuth.signInWithPhoneNumber(phone);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> signUp(String email, String password) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future signOut() async {
    if(Api.mode == modes.VOLUNTEER){
      FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
      final token = await firebaseMessaging.getToken();
      var collection = FirebaseFirestore.instance.collection('volunteer_tokens');
      var snapshot = await collection.where('token', isEqualTo: token).get();
      for (var doc in snapshot.docs)
        await doc.reference.delete();
    }  
    Api.mode = null;
    await firebaseAuth.signOut();
  }

  Future delete() async {
    User user = await FirebaseAuth.instance.currentUser;
    user.delete();
  }
}