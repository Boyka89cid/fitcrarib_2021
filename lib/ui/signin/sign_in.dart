import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'dart:core';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fitcarib/ui/myactivity/activity.dart';
import 'package:fitcarib/ui/forgotpassword/forgot_password.dart';
import 'package:flutter/gestures.dart';
import 'package:fitcarib/ui/signup/sign_up.dart';

final GlobalKey<ScaffoldState> _scaffoldKeySignInScreen = new GlobalKey<ScaffoldState>();

class SignInScreen extends StatefulWidget {
  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  SharedPreferences? prefs;

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final FitcaribReference = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      prefs = sp;
    });
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Form(
      key: _formKey,
      child: Scaffold(
        key: _scaffoldKeySignInScreen,
        body: ListView(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 10.0)),
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop(null);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.orange,
                  size: 35.0,
                ),
              ),
            ),
            Center(
              child: Image.asset(
                'assets/images/logo_orange.png',
                height: screenHeight / 7,
                width: screenWidth / 2,
              ),
            ),
            Padding(padding: EdgeInsets.only(top: screenHeight / 15)),
            Divider(
              color: Colors.grey,
            ),
            Padding(padding: EdgeInsets.only(top: screenHeight / 20)),
            Padding(
              padding: EdgeInsets.only(left: 30.0),
              child: Text(
                "Sign In",
                style:
                TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                textScaleFactor: 2.0,
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 20.0)),

            Padding(
              padding: EdgeInsets.only(left: 30.0, right: 30.0),
              child: TextFormField(
                style: TextStyle(color: Colors.black),
                validator: _validateEmail,
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle:
                    TextStyle(color: Colors.tealAccent[700], fontSize: 20.0),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    )),
              ),
            ),

            Padding(padding: EdgeInsets.only(top: screenHeight / 180)),

            Padding(
              padding: EdgeInsets.only(left: 30.0, right: 30.0),
              child: TextFormField(
                style: TextStyle(color: Colors.black),
                obscureText: true,
                validator: _validatePassword,
                controller: passwordController,
                decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle:
                    TextStyle(color: Colors.tealAccent[700], fontSize: 20.0),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    )),
              ),
            ),

            Padding(padding: EdgeInsets.only(top: screenHeight / 40)),
            Padding(
              padding: EdgeInsets.only(left: 30.0),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Forgot Password',
                      style: new TextStyle(color: Colors.orange, fontSize: 20,fontWeight: FontWeight.bold),
                      recognizer: new TapGestureRecognizer()
                        ..onTap = () => Navigator.push(context,MaterialPageRoute(builder: (context) => ResetPasswordScreen()),),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: Center(
                child: ButtonTheme(
                  minWidth: 280,
                  height: 60.0,
                  child: new RaisedButton(
                    child: const Text(
                      'Sign In',
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                    color: Colors.tealAccent[700],
                    onPressed: (){
                      if (_formKey.currentState!.validate()) {
                        // If the form is valid.
                        FocusScope.of(context).requestFocus(new FocusNode());
                        signIn(emailController.text, passwordController.text);
                      } else {

                      }

                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100.0)),
                  ),
                ),
              ),
            ),

            Padding(padding: EdgeInsets.only(top: 30.0)),
            Center(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Don\'t have an account? ',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    TextSpan(
                      text: 'Sign Up',
                      style: new TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                      recognizer: new TapGestureRecognizer()
                        ..onTap = () => Navigator.push(context,MaterialPageRoute(builder: (context) => SignUpScreen()),),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.0),
            ),
          ],
        ),
      ),
    );
  }

  String? _validateEmail(String? value) {

    if (value?.trim()?.isEmpty ?? true) {
      return 'Please Enter Email Id';
    } else if (!validateEmail(emailController?.text?.trim() as String)) {
      return 'Please Enter Valid Email Id';
    }
  }
  bool validateEmail(String value) {
    // bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
    bool emailValid = RegExp(
        "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
            "\\@" +
            "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
            "(" +
            "\\." +
            "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
            ")+")
        .hasMatch(value);
    return emailValid;
  }
  String? _validatePassword(String? value)
  {
    if (value?.trim()?.isEmpty ?? true)
    {
      passwordController.clear();
      return 'Please Enter Password';
    }
  }

  bool validatePassword(String value) {
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  void showInSnackBar(String value) {
    _scaffoldKeySignInScreen.currentState!.showSnackBar(new SnackBar(content: new Text(value),duration: Duration(seconds: 2),));
  }


  Future<void> signIn(String email, String password) async {


    _firebaseAuth.signInWithEmailAndPassword(email: email, password: password).then((user) async {
      prefs!.setString("userid", user.user!.uid);
      _firebaseMessaging.getToken().then((token){
        Map<String, dynamic> data = <String,dynamic>{
          "deviceToken" : token,
        };

        FitcaribReference.child('tokens').child(user.user!.uid).update(data).whenComplete(() async {
          dynamic root = FitcaribReference.child('users').child(user.user!.uid);
          root.once().then((DataSnapshot snapshot) async {
            Map<dynamic, dynamic> values = snapshot.value;

            values.forEach((k,v){
              if(k == "name")
                prefs!.setString("name", v);
              if(k == "email")
                prefs!.setString("email", v);
              if(k == "activity")
                prefs!.setInt("activity", v);
              if(k == "friends")
                prefs!.setInt("friends", v);
              if(k == "groups")
                prefs!.setInt("groups", v);
              if(k == "isSocial")
                prefs!.setBool("isSocial", v);
              if(k == "username")
                prefs!.setString("username", v);
              if(k == "profilePic")
                prefs!.setString("imageId", v);
            });
            if(values != null){
              Navigator.push(context,MaterialPageRoute(builder: (context) => ActivityScreen()),);
            }

          });
        });

      });
    }).catchError((error){
      //PlatformException exception = error;
      print("err "+error.toString());
      if(error.code == "wrong-password"){
        showInSnackBar("Email Id or Password is incorrect.");
      }
      else{
        showInSnackBar("User does not exist.");
      }
    });
  }
}