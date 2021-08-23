
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitcarib/ui/welcome/welcome.dart';
import 'package:flutter/material.dart';

final GlobalKey<ScaffoldState> _scaffoldKeyResetPasswordScreen =
    new GlobalKey<ScaffoldState>();

class ResetPasswordScreen extends StatefulWidget {
  @override
  ResetPasswordScreenState createState() => ResetPasswordScreenState();
}

class ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
  }

  void sendOTP(var email) async
  {
    await resetPassword(email);
  }

  @override
  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => WillPopScope(
        onWillPop: () async => false,
        child: new AlertDialog(
          content:
              const Text("Please Check your Email for Password Reset Link"),
          actions: [
            new ElevatedButton(
              child: const Text("OK"),
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => WelcomeScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // void showInSnackBar(String value) {
  //   _scaffoldKeyResetPasswordScreen.currentState.showSnackBar(new SnackBar(content: new Text(value),duration: Duration(seconds: 2),));
  // }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Form(
      key: _formKey,
      child: Scaffold(
        key: _scaffoldKeyResetPasswordScreen,
        body: ListView(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 10.0)),
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(null),
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
            Padding(
              padding: EdgeInsets.only(top: 40.0),
            ),
            Divider(
              color: Colors.grey,
            ),
            Padding(
              padding: EdgeInsets.only(top: 40.0),
            ),
            Center(
              child: Text(
                "Reset Your Password",
                style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.0),
            ),
            Center(
              child: Text(
                "Please enter a registered email address.",
                style: TextStyle(
                    color: Colors.tealAccent[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 80.0, left: 30, right: 30),
              child: TextFormField(
                validator: _validateEmail,
                decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(
                      color: Colors.tealAccent[700],
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    )),
                style: TextStyle(
                  color: Colors.black,
                ),
                controller: emailController,
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 50.0)),
            Center(
              child: FlatButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    sendOTP(emailController.text);
                    FocusScope.of(context).requestFocus(new FocusNode());
                  } else {}
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.tealAccent[700],
                      borderRadius: BorderRadius.circular(100.0)),
                  width: 230,
                  height: 60.0,
                  child: Center(
                    child: Text("Send Request",
                        style: TextStyle(color: Colors.white, fontSize: 20.0)),
                  ),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 30.0)),
          ],
        ),
      ),
    );
  }

  String? _validateEmail(String? value)
  {
    if (value?.trim()?.isEmpty ?? true)
    {
      return 'Please Enter Email Address';
    } else if (!validateEmail(emailController.text.trim() as String))
    {
      return 'Please Enter Valid Email Address';
    }
    // if (value.isEmpty) {
    //   // The form is empty
    //   return null;
    // }
    // // This is just a regular expression for email addresses
    // String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
    //     "\\@" +
    //     "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
    //     "(" +
    //     "\\." +
    //     "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
    //     ")+";
    // RegExp regExp = new RegExp(p);
    //
    // if (regExp.hasMatch(value)) {
    //   // So, the email is valid
    //   return null;
    // }

    // The pattern of the email didn't match the regex above.
    //return 'Email is not valid';
  }

  bool validateEmail(String value) {
    // bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
    bool emailValid = RegExp("[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
            "\\@" +
            "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
            "(" +
            "\\." +
            "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
            ")+")
        .hasMatch(value);
    return emailValid;
  }
}
