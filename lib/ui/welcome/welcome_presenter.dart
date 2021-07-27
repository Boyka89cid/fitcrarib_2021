import 'package:fitcarib/base/presenter/base_presenter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:fitcarib/server/models/login_request.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "dart:convert";
import 'package:flutter/services.dart';
import "dart:async";
import 'package:http/http.dart' as http;

abstract class WelcomeContract extends BaseContract
{
  void toLoginScreen();
  void toSignUpScreen();
  void toActivityPage();
  void toActivityScreen();
}

class WelcomePresenter extends BasePresenter {
  WelcomePresenter(BaseContract view) : super(view);

  bool isLoggedIn = false;
  var jsonData,facebookLoginResult;
  var uuid;

  LoginRequest loginRequest = LoginRequest();

  final FirebaseAuth _fAuth = FirebaseAuth.instance;

  SharedPreferences? prefs;
  

//  final FitcaribReference = FirebaseDatabase.instance.reference();

  final FitcaribReference = FirebaseDatabase.instance.reference().child('users');

  void toWelcome()
  {
    (view as WelcomeContract).toLoginScreen();
  }

  void toSignUp()
  {
    (view as WelcomeContract).toSignUpScreen();
  }

  void isLoginSucessfull(bool check)
  {
    this.isLoggedIn=check;
  }

  void toActivityP(){
    (view as WelcomeContract).toActivityScreen();
  }

  

  void _add(dynamic obj) async{
    Map<String,dynamic> data = <String, dynamic>{
      "name" : obj.displayName,
      "email" : obj.email,
      "password" : "default",
      "username" : obj.email,
      "activity" : 0,
      "profilePic" : obj.photoUrl,
      "friends" : 0,
      "groups" : 0,
      "isSocial" : true,
      "flag" : true,
    };
    FitcaribReference.child(obj.uid).update(data).whenComplete((){
      print("data added");
      toActivityP();
    }).catchError((e) => print(e));
  }

  /*Future<void> initiateLogin() async {
    var facebookLogin = FacebookLogin();
    facebookLoginResult = await facebookLogin.logIn(['email', 'public_profile']);//.logInWithReadPermissions(['email', 'public_profile']);
    FacebookAccessToken myToken = facebookLoginResult.accessToken;
    AuthCredential credential = FacebookAuthProvider.credential(myToken.token);
    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        isLoginSucessfull(false);
        (view as WelcomeContract).showMessage("Error while logging In!");
        print("error");
        break;
      case FacebookLoginStatus.cancelledByUser:
        isLoginSucessfull(false);
        (view as WelcomeContract).showMessage("Error while logging In!");
        print("CancelledByUser");
        isLoginSucessfull(false);
        break;
      case FacebookLoginStatus.loggedIn:
        final user = await _fAuth.signInWithCredential(credential);
        prefs = await SharedPreferences.getInstance();
        int maplength = 0;
          dynamic root = FitcaribReference;
            root.once().then((DataSnapshot snapshot) async{
              if(snapshot.value == null){
                print("in root if");
                prefs!.setString("name", user.user!.displayName as String);
                prefs!.setString("imageId", user.user!.photoURL as String);
                prefs!.setString("username", user.user!.email as String);
                prefs!.setString("uid", user.user!.uid);
                _add(user);
              }
              else{
                print("in root else");
                Map<dynamic, dynamic> values = snapshot.value;
                for(String key in values.keys) {
                  if(key == user.user!.uid){
                    print("uid found");
                    prefs!.setString("name", user.user!.displayName as String);
                    prefs!.setString("imageId", user.user!.photoURL as String);
                    prefs!.setString("username", user.user!.email as String);
                    prefs!.setString("uid", user.user!.uid);
                    maplength = 1;
                    toActivityP();
                  }
                }
                  if(maplength == 0)
                  {
                    prefs!.setString("name", user.user!.displayName as String);
                    prefs!.setString("imageId", user.user!.photoURL  as String);
                    prefs!.setString("username", user.user!.email  as String);
                    prefs!.setString("uid", user.user!.uid);
                    _add(user);
                  }
              }
              });
          break;
    }
  }*/
}

class ClippingClass extends CustomClipper<Path> {
  ClippingClass(this.context);
  final context;
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, MediaQuery.of(context).size.height/2.2);
    path.quadraticBezierTo(
        MediaQuery.of(context).size.width/2, MediaQuery.of(context).size.height/1.5, MediaQuery.of(context).size.width, MediaQuery.of(context).size.height /2.2);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}