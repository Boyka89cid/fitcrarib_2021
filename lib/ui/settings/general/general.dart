import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fitcarib/ui/common/common.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitcarib/ui/signin/sign_in.dart';


class GeneralScreen extends StatefulWidget{
  GeneralScreen({Key? key,})
      : super(
    key: key,
  );
  @override
  GeneralScreenState createState() => GeneralScreenState();
}

class GeneralScreenState extends State<GeneralScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKeyGeneralScreen = new GlobalKey<ScaffoldState>();
  dynamic email2;
  final _currentPasswordController = TextEditingController();
  final _changePasswordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  SharedPreferences? prefs;

  void showInSnackBar(String value) {
    _scaffoldKeyGeneralScreen.currentState!.showSnackBar(new SnackBar(content: new Text(value),duration: Duration(seconds: 2),));
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    var screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKeyGeneralScreen,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text("General", style: TextStyle(color: Colors.orange),),
          leading: FlatButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back, color: Colors.orange,),
            label: Text(""),
            padding: EdgeInsets.only(right: 0.0, left: 24.0),),
          actions: <Widget>[
            FlatButton(onPressed: () {
              changePassword(email2,_currentPasswordController.text,_changePasswordController.text,_repeatPasswordController.text);},
              child: Text("Save",style: TextStyle(color: Colors.orange),),
              padding: EdgeInsets.only(right: 0.0, left: 24.0),
            ),
          ],
        ),

        body: ListView(
          padding: EdgeInsets.only(top: 30),
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 30,right: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Current Password",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize:20.0),),
                  Padding(padding: EdgeInsets.only(top: 10.0),),
                  Text("\(required to update email or change current\npassword\)",style: TextStyle(color: Colors.grey),),
                  Padding(padding: EdgeInsets.only(top: 10.0),),
                  TextField(decoration: InputDecoration(border: OutlineInputBorder()),controller: _currentPasswordController,obscureText: true,),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.only(top: screenHeight/50),),
            Divider(color: Colors.grey,),
            Padding(padding: EdgeInsets.only(top: 20),),
            Container(
              padding: EdgeInsets.only(left: 30,right: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Account Email",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize:20.0),),
                  Padding(padding: EdgeInsets.only(top: 10.0),),
                  TextFormField(enabled: false,decoration: InputDecoration(border: OutlineInputBorder()),controller: initialValue(email2),),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 20),),
            Divider(color: Colors.grey,),
            Padding(padding: EdgeInsets.only(top: 20),),
            Container(
              padding: EdgeInsets.only(left: 30,right: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Change Password",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize:20.0),),
                  Padding(padding: EdgeInsets.only(top: 10.0),),
                  Text("\(leave blank for no change\)",style: TextStyle(color: Colors.grey),),
                  Padding(padding: EdgeInsets.only(top: 10.0),),
                  TextFormField(decoration: InputDecoration(border: OutlineInputBorder()),obscureText: true,controller: _changePasswordController,),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 20),),
            Divider(color: Colors.grey,),
            Padding(padding: EdgeInsets.only(top: 20),),
            Container(
              padding: EdgeInsets.only(left: 30,right: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Repeat Password",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize:20.0),),
                  Padding(padding: EdgeInsets.only(top: 10.0),),
                  TextFormField(decoration: InputDecoration(border: OutlineInputBorder()),obscureText: true,controller: _repeatPasswordController,),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 30),),
          ],
        ),
      ),
    );
  }

  initialValue(val) {
    return TextEditingController(text: val);
  }

  @override
  void initState(){
    super.initState();
    SharedPreferences.getInstance().then((sp){
      prefs = sp;
      email2 = prefs!.get("email");
    });
  }

  Future changePassword(dynamic email, dynamic currentPassword, dynamic changePassword, dynamic repeatPassword) async {
    SharedPreferences prefs=await SharedPreferences.getInstance();
    final user = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: currentPassword);
    if(user.user!.uid != null){
      if(changePassword == repeatPassword){
        user.user!.updatePassword(changePassword).whenComplete((){
          _firebaseAuth.signOut().whenComplete((){
            prefs.clear().whenComplete((){
              Navigator.push(context,MaterialPageRoute(builder: (context) => SignInScreen()),);
            });
          });
        });
      }
      else{
        showInSnackBar("New password didn't matched! Try again");
      }
    }
    else{
      showInSnackBar("Wrong Password! Try Again!");
    }
  }

}