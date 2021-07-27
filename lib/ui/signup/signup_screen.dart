import 'dart:async';
import 'dart:io';
import 'package:fitcarib/ui/signin/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:fitcarib/base/ui/base_screen.dart';
import 'package:fitcarib/ui/signup/signup_presenter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';


class SignUpScreen extends BaseScreen {
  SignUpScreen(String title, listener) : super(title, listener);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends BaseScreenState<SignUpScreen, SignUpPresenter> implements SignUpContract{
  final fulNameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final choosePasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool _userExist = false;



  @override
  Widget buildBody(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(padding: EdgeInsets.only(top: 10.0)),
        Align(
          alignment: Alignment.topLeft,
          child: IconButton(onPressed: () => Navigator.of(context).pop(null), icon: Icon(Icons.arrow_back,color: Colors.orange,size: 35.0,),),
        ),
        Padding(padding: EdgeInsets.only(top: 10.0)),
        Padding(padding: EdgeInsets.only(left: 30.0),child: Text("Create an Account",style: TextStyle(color: Colors.orange,fontSize: 28.0),),),
        Padding(padding: EdgeInsets.only(top: 20.0)),
        Padding(padding: EdgeInsets.only(left: 30.0),child: Text("Join our community of enablers and \nthrive with us.", style: TextStyle(color: Colors.tealAccent[700],fontSize: 18.0),),),

        Padding(padding: EdgeInsets.only(left: 30.0,right: 40.0),
          child: TextFormField(

            style: TextStyle(color: Colors.black),
            controller: fulNameController,
            decoration: InputDecoration(
              labelText: "Full Name",
              labelStyle: TextStyle(color: Colors.tealAccent[700]),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
          ),
        ),


        Padding(padding: EdgeInsets.only(left: 30.0,right: 40.0),
          child: TextFormField(
            controller: usernameController,
            validator: (value) => checkUserValue(value!) ? "Username already taken" : value.isEmpty ? null : "Username Available",
            autovalidate: true,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              labelText: "Username",
              labelStyle: TextStyle(color: Colors.tealAccent[700]),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
//            onChanged: (text) {
//              username = text;
//            },
          ),
        ),

        Padding(padding: EdgeInsets.only(left: 30.0,right: 40.0),
          child: TextFormField(
            validator: _validateEmail,
            autovalidate: true,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              labelText: "Email Address",
              labelStyle: TextStyle(color: Colors.tealAccent[700]),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
//            onChanged: (text){
//              email = text;
//            },
          ),
        ),

        Padding(padding: EdgeInsets.only(left: 30.0,right: 40.0),
          child: TextFormField(
            style: TextStyle(color: Colors.black),
            validator: _validatePassword,
            autovalidate: true,
            obscureText: true,
            controller: choosePasswordController,
            decoration: InputDecoration(
              labelText: "Choose Password",
              labelStyle: TextStyle(color: Colors.tealAccent[700]),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
//            onChanged: (text){
//              choosePassword = text;
//            },
          ),
        ),

        Padding(padding: EdgeInsets.only(left: 30.0,right: 40.0),
          child: TextFormField(
            style: TextStyle(color: Colors.black),
            obscureText: true,
            validator: _validatePassword,
            autovalidate: true,
            controller: confirmPasswordController,
            decoration: InputDecoration(
              labelText: "Confirm Password",
              labelStyle: TextStyle(color: Colors.tealAccent[700]),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
//            onChanged: (text){
//              confirmPassword = text;
//            },
          ),
        ),

        Padding(padding: EdgeInsets.only(left: 30.0,right: 40.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    onPressed: getImage,
                    child: Text('Choose Profile Image'),
                  ),
                ],
              ),
              file == null
                  ? Text('No Image Selected')
                  : Image.file(file!,height: 100.0,width: 100.0,),
            ],
          ),
        ),

        Padding(padding: EdgeInsets.only(top: 40.0),),

        Center(
          child: ButtonTheme(
            minWidth: 235,
            height: 60.0,
            child: new RaisedButton(
              child: const Text('Sign up',style: TextStyle(color: Colors.white,fontSize: 16.0),),
              color: Colors.tealAccent[700],
              onPressed: () { presenter!.SignUp(usernameController.text,emailController.text,choosePasswordController.text,confirmPasswordController.text,fulNameController.text,file!); },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0)),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 15.0),
        ),
      ],
    );
  }

  @override
  SignUpPresenter createPresenter() {
    return SignUpPresenter(this);
  }

  Future getImage() async {
    var tempImage = await FilePicker.platform.pickFiles(type: FileType.image) as File;
    setState(() {
      file = tempImage;
    });
  }

  @override
  void toLoginScreen() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignInScreen()));
   // widget.listener.getRouter().navigateTo(context, '/signin');
  }

  String? _validateEmail(String? value)
  {
    if (value!.isEmpty)
    {
      // The form is empty
      return null;
    }
    // This is just a regular expression for email addresses
    String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
        "\\@" +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
        "(" +
        "\\." +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
        ")+";
    RegExp regExp = new RegExp(p);

    if (regExp.hasMatch(value)) {
      // So, the email is valid
      return null;
    }

    // The pattern of the email didn't match the regex above.
    return 'Email is not valid';
  }

  String? _validatePassword(String? value) {
    if(value!.isEmpty){
      return null;
    }
    if (value.length > 5) {
      return null;
    }

    return 'Password must be upto 6 characters';
  }


  checkUserValue<bool>(String user) {
    doesNameAlreadyExist(user).then((val){
      if(val){
        print ("UserName Already Exits");
        _userExist = val;
      }
      else{
        print ("UserName is Available");
        _userExist = val;
      }
    });
    return _userExist;
  }

  Future<bool> doesNameAlreadyExist(String name) async {
    var haveName;
    await FirebaseDatabase.instance.reference().child("users").once().then((DataSnapshot snapshot){
      Map<dynamic,dynamic> mp= snapshot.value;
      if(mp != null){
        mp.forEach((k,v){
          if(v["username"] == name){
            setState(() {
              haveName = v["username"];
            });
          }
        });
        return false;
      }
    });
    return haveName != null;

  }


}
