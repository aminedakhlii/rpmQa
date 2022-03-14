import "dart:io";

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_login_register_ui/api/auth_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

enum modes  {CUSTIOMER,VOLUNTEER}

class Api {
  String url = "http://149.202.43.22:5000/";
  String firebaseToken;
  static modes mode;
  static String username;
  AuthService service = AuthService();

  Api() {
    FirebaseMessaging.instance.getToken().then((value) => firebaseToken = value);
  }

  Future getUserMode(username) async {
    var collection = FirebaseFirestore.instance.collection('volunteer');
    var snapshot = await collection.where('email', isEqualTo: username).get();
    if(snapshot.docs.isEmpty)
      Api.mode = modes.CUSTIOMER;
    else
      Api.mode = modes.VOLUNTEER;
    return true;
  }

  Future<bool> checkUser(String username) async {
    CollectionReference customers = FirebaseFirestore.instance.collection('customer');
    CollectionReference volunteers = FirebaseFirestore.instance.collection('volunteer');
    QuerySnapshot customerSnapshot = await customers.get();
    QuerySnapshot volunteerSnapshot = await volunteers.get();
    for (var user in customerSnapshot.docs){
      if(user.get("name") == username)
        return true;
    }
    for (var user in volunteerSnapshot.docs){
      if(user.get("name") == username)
        return true;
    }
    return false;
  }

  Future cast(int situation, String snap, LatLng location) async {
    final body = {
      "situation": situation.toString(),
      "snap": snap,
      "lat": location.latitude.toString(),
      "long": location.longitude.toString(),
      "date": DateTime.now().millisecondsSinceEpoch.toString(),
      "user": username
    }; 
    CollectionReference posts = FirebaseFirestore.instance.collection('post');
    posts.add(
      body
    ).then((value) async { http.Response res = await http.post(Uri.parse(url + "broadcast"), body: body);
      print(res.statusCode); 
    });
  }
  
  Future login(String username) async {
    getUserMode(username).then((value) {
      if(mode == modes.VOLUNTEER){
        CollectionReference tokens = FirebaseFirestore.instance.collection('volunteer_tokens');
        tokens.add({
          "username": username,
          "token": firebaseToken
        });
      }
    });
  }

  Future uploadImage(String path) async {
    String url;
    final firebaseStorageRef = FirebaseStorage.instance.ref().child('uploads/cars/' + path);
    final uploadTask = await firebaseStorageRef.putFile(File(path)).then((p0) async {
      url = await firebaseStorageRef.getDownloadURL();
    });
    return url;
  }

  Future volunteerSignUp(String username,  String phone,  String image) async {
    uploadImage(image).then((value) async {
      CollectionReference tokens = FirebaseFirestore.instance.collection('volunteer_tokens');
      CollectionReference volunteers = FirebaseFirestore.instance.collection('volunteer');
      tokens.add(
          { "username": username,
            "token": firebaseToken,
          }
        ).then((v) => volunteers.add({
          "name": username,
          "phone": phone,
          "image": value,
          "email": username + "@rpm.qa"
        })).then((v) => print("added"))
        .onError((error, stackTrace) => print(error)
        );
      }); 
  }

  Future customerSignUp(String username, String phone) async {
    CollectionReference customers = FirebaseFirestore.instance.collection('customer');
    customers.add(
        { 
          "name": username,
          "phone": phone,
          "email": username + "@rpm.qa"
        }
      ).then((value) => print("added"))
      .onError((error, stackTrace) => print(error)
    );
  }

  Future fetchUser(key,value) async {
    CollectionReference customers = FirebaseFirestore.instance.collection('customer');
    CollectionReference volunteers = FirebaseFirestore.instance.collection('volunteer');
    QuerySnapshot customerSnapshot = await customers.get();
    QuerySnapshot volunteerSnapshot = await volunteers.get();
    CurrentUser ret; 
    for (var user in customerSnapshot.docs){
      print(user.data());
      if(user.get(key) == value)
        ret = CurrentUser(username: user.get("name"), phone: user.get("phone"));
    }
    for (var user in volunteerSnapshot.docs){
      print(user.get(key) == value);
      if(user.get(key) == value){
        ret = CurrentUser(username: user.get("name"), phone: user.get("phone"));
        try {
          ret.image = user.get('image');
          print(ret.image);
        } catch (e){

        }
      }
    }
    print(ret);
    return ret; 
  }

  Future fetchPosts() async {
    //await deleteOutdated();
    List<Post> retPosts = []; 
    var collection = FirebaseFirestore.instance.collection('post');
    QuerySnapshot snapshot = await collection.get();
    for( var post in snapshot.docs){
      if(post.id != "init"){
        int situation = int.parse(post.get("situation"));
        String snap = post.get("snap");
        double long = double.parse(post.get("long")), lat = double.parse(post.get("lat"));
        DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(post.get("date")));
        retPosts.add(Post(situation: situation,lat: lat, long: long, snapUrl: snap, date: date));
      }
    }
    return retPosts;
  }

  Future fetchPostsByUser() async {
    List<Post> retPosts = [];
    var collection = FirebaseFirestore.instance.collection('post');
    QuerySnapshot snapshot = await collection.where("user", isEqualTo: username).get();
    for( var post in snapshot.docs){
      if(post.id != "init"){
        int situation = int.parse(post.get("situation"));
        String snap = post.get("snap");
        double long = double.parse(post.get("long")), lat = double.parse(post.get("lat"));
        DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(post.get("date")));
        retPosts.add(Post(situation: situation,lat: lat, long: long, snapUrl: snap, date: date));
      }
    }
    return retPosts;
  }

  Future fetchAcceptedPostsByUser() async {
    List<Post> retPosts = [];
    var collection = FirebaseFirestore.instance.collection('accepted');
    QuerySnapshot snapshot = await collection.where("user", isEqualTo: username).get();
    for(var post in snapshot.docs){
      if(post.id != "init"){
        int situation = (post.get("situation"));
        String snap = post.get("snap");
        double long = double.parse(post.get("long")), lat = double.parse(post.get("lat"));
        DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(post.get("date")));
        Post p = Post(situation: situation,lat: lat, long: long, snapUrl: snap, date: date);
        p.accepted = true;
        retPosts.add(p);
      }
    }
    return retPosts;
  }

  Future deleteOutdated() async {
    var collection = FirebaseFirestore.instance.collection('post');
    await collection.get().then((value) {
      if(value.docs.length > 0)
        for (DocumentSnapshot ds in value.docs){
          if(ds.get("id") != 'init'){
            if(DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(int.parse(ds.get("date")))).inDays > 1)
              ds.reference.delete();
          }
        }
    });
  }

  Future accept(Post p) async {
    CollectionReference collection = FirebaseFirestore.instance.collection('post');
    CollectionReference accepted = FirebaseFirestore.instance.collection('accepted');
    await collection.where("date", isEqualTo: p.date.millisecondsSinceEpoch.toString()).where("lat", isEqualTo: p.position.latitude.toString()).get().then((value) {
      if(value.docs.length > 0)
        for (DocumentSnapshot ds in value.docs){
          if(ds.get('lat') == p.position.latitude.toString()){
            ds.reference.delete();
            accepted.add(
              {
                "date": p.date.millisecondsSinceEpoch.toString(),
                "lat": p.position.latitude.toString(),
                "long": p.position.longitude.toString(),
                "snap": p.snapUrl,
                "situation": p.situation,
                "user": ds.get('user'),
                "volunteer": username
              }
            ).then((value) => print("accepted"));
          }
        }
      else throw Error();  
    });
  }

  Future doneAccepted(Post p) async {
    CollectionReference collection = FirebaseFirestore.instance.collection('accepted');
    await collection.where("date", isEqualTo: p.date.millisecondsSinceEpoch.toString()).where("lat", isEqualTo: p.position.latitude.toString()).get().then((value) {
      if(value.docs.length > 0)
        for (DocumentSnapshot ds in value.docs){
          print(ds.data());
          if(ds.get('lat') == p.position.latitude.toString()){
            ds.reference.delete();
          }
        }
      else throw Error();  
    });
  }

  Future done(Post p) async {
    CollectionReference collection = FirebaseFirestore.instance.collection('post');
    await collection.where("date", isEqualTo: p.date.millisecondsSinceEpoch.toString()).where("lat", isEqualTo: p.position.latitude.toString()).get().then((value) {
      if(value.docs.length > 0)
        for (DocumentSnapshot ds in value.docs){
          if(ds.get('lat') == p.position.latitude.toString()){
            ds.reference.delete();
          }
        }
      else throw Error();  
    });
  }

  Future modifyUser(key,value,data) async {
    CollectionReference customers = FirebaseFirestore.instance.collection('customer');
    CollectionReference volunteers = FirebaseFirestore.instance.collection('volunteer');
    QuerySnapshot customerSnapshot = await customers.get();
    QuerySnapshot volunteerSnapshot = await volunteers.get();
    for (var user in customerSnapshot.docs){
      if(user.get(key) == value)
        user.reference.update(data);
    }
    for (var user in volunteerSnapshot.docs){
      if(user.get(key) == value)
        user.reference.update(data);
    }
  }

  Future updateImage(email,image) async {
    uploadImage(image).then((value) async {
      CollectionReference volunteers = FirebaseFirestore.instance.collection('volunteer');
      QuerySnapshot volunteerSnapshot = await volunteers.get();
      for (var user in volunteerSnapshot.docs){
        if(user.get('email') == email)
          user.reference.update({
            'image': value
        });
      }
    });
  }

  Future deleteUserPosts(email) async {
    var post_collection = FirebaseFirestore.instance.collection('post');
    var accepted_collection = FirebaseFirestore.instance.collection('accepted');
    QuerySnapshot snapshot = await post_collection.where("user", isEqualTo: email).get();
    QuerySnapshot accepted_snapshot = await accepted_collection.where("user", isEqualTo: email).get();
    for( var post in snapshot.docs){
      if(post.id != "init"){
        post.reference.delete();
      }
    }
    for( var post in accepted_snapshot.docs){
      if(post.id != "init"){
        post.reference.delete();
      }
    }
  }

  Future deleteAccount(email) async {
    CollectionReference customers = FirebaseFirestore.instance.collection('customer');
    CollectionReference volunteers = FirebaseFirestore.instance.collection('volunteer');
    QuerySnapshot customerSnapshot = await customers.get();
    QuerySnapshot volunteerSnapshot = await volunteers.get();
    for (var user in customerSnapshot.docs){
      if(user.get("email") == email)
        user.reference.delete();
    }
    for (var user in volunteerSnapshot.docs){
      if(user.get("email") == email)
        user.reference.delete();
    }
    deleteUserPosts(email);
    service.delete();
    service.signOut();
  }
}

class Post {
  double long, lat;
  int situation;
  String snapUrl, username; 
  DateTime date;
  bool accepted = false;

  LatLng position;

  Post({this.situation, this.long, this.lat, this.snapUrl, this.date, this.username}){
    this.position = LatLng(lat, long);
  }
}

class CurrentUser {
  String username, phone, image;
  CurrentUser({this.username, this.phone});
}