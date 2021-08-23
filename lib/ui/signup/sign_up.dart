import 'dart:async';
import 'dart:io';

import 'package:dbcrypt/dbcrypt.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fitcarib/ui/signin/sign_in.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

final GlobalKey<ScaffoldState> _scaffoldKeySignUpScreen = GlobalKey<ScaffoldState>();

class SignUpScreen extends StatefulWidget {
  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final fulNameController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final choosePasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool _userExist = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File? file;
  bool agree = false;

  Color errorColor = Colors.red;
  bool confirmPasswordToggle = true;
  bool passwordToggle = true;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  DBCrypt dBCrypt = DBCrypt();

  final FitcaribReference =
      FirebaseDatabase.instance.reference().child('users');

  Reference _reference = FirebaseStorage.instance.ref();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        return Future.value(true);
      },
      child: Form(
        key: _formKey,
        child: Scaffold(
          key: _scaffoldKeySignUpScreen,
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
              Padding(padding: EdgeInsets.only(top: 10.0)),
              Padding(
                padding: EdgeInsets.only(left: 30.0),
                child: Text(
                  "Create an Account",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                      fontSize: 28.0),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 20.0)),
              Padding(
                padding: EdgeInsets.only(left: 30.0),
                child: Text(
                  "Welcome! We can’t wait to meet you.",
                  style:
                      TextStyle(color: Colors.tealAccent[700], fontSize: 18.0),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 30.0, right: 40.0),
                child: TextFormField(
                  style: TextStyle(color: Colors.black),
                  validator: (value) {
                    if (value?.trim().isEmpty ?? true) {
                      return 'Please Enter First Name';
                    }
                    return null;
                  },
                  controller: firstNameController,
                  decoration: InputDecoration(
                    labelText: "First Name",
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
              Padding(
                padding: EdgeInsets.only(left: 30.0, right: 40.0),
                child: TextFormField(
                  style: TextStyle(color: Colors.black),
                  validator: (value) {
                    if (value?.trim().isEmpty ?? true) {
                      return 'Please Enter Last Name';
                    }
                    return null;
                  },
                  controller: lastNameController,
                  decoration: InputDecoration(
                    labelText: "Last Name",
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
              Padding(
                padding: EdgeInsets.only(left: 30.0, right: 40.0),
                child: TextFormField(
                  controller: usernameController,
                  // ignore: missing_return
                  validator: (value) {
                    if (value?.trim().isEmpty ?? true) {
                      // errorColor = Colors.red;
                      // setState(() {});
                      return "Enter UserName";
                    } else if (checkUserValue(value!)) {
                      // errorColor = Colors.red;
                      setState(() {});
                      return "Username already taken";
                    }
                  },
                  //autovalidate: true,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    errorStyle: TextStyle(
                      color: errorColor,
                    ),
                    labelText: "Username",
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
              Padding(
                padding: EdgeInsets.only(left: 30.0, right: 40.0),
                child: TextFormField(
                  validator: _validateEmail,
                  //autovalidate: true,
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
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
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 30.0, right: 40.0),
                child: TextFormField(
                  style: TextStyle(color: Colors.black),
                  validator: _validatePassword,
                  //autovalidate: true,
                  obscureText: passwordToggle,
                  controller: choosePasswordController,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: passwordToggle
                          ? Icon(Icons.visibility_off, color: Colors.grey)
                          : Icon(Icons.visibility, color: Colors.grey),
                      onPressed: () {
                        setState(() {
                          passwordToggle = !passwordToggle;
                        });
                      },
                    ),
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
              Padding(
                padding: EdgeInsets.only(left: 30.0, right: 40.0),
                child: TextFormField(
                  style: TextStyle(color: Colors.black),
                  obscureText: confirmPasswordToggle,
                  validator: _validateConfirmPassword,
                  //autovalidate: true,
                  controller: confirmPasswordController,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: confirmPasswordToggle
                          ? Icon(Icons.visibility_off, color: Colors.grey)
                          : Icon(Icons.visibility, color: Colors.grey),
                      onPressed: () {
                        setState(() {
                          confirmPasswordToggle = !confirmPasswordToggle;
                        });
                      },
                    ),
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
              Padding(
                padding: EdgeInsets.only(left: 15.0, right: 40.0),
                child: Row(
                  children: [
                    Material(
                      child: Checkbox(
                        value: agree,
                        onChanged: (value) {
                          setState(() {
                            agree = value!;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                            text: '',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'I have accept FitCarib',
                                //'I have accept Health Affixed',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.035),
                              ),
                              TextSpan(
                                  text: ' Terms & Policy',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.035),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      launch(
                                          'https://healthaffixed.com/terms-policy-of-use/');
                                    })
                            ]),
                      ),
                      // Text(
                      //   'I have accept Health Affixed Terms & Policy',
                      // ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 30.0, right: 40.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: getImage,
                          style: ElevatedButton.styleFrom(primary: Colors.orange),
                          child: Text('Choose Profile Image'),
                        ),
                      ],
                    ),
                    file == null
                        ? Text('No Image Selected')
                        : Image.file(
                            file!,
                            height: 100.0,
                            width: 100.0,
                          ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 40.0),
              ),
              Center(
                child: ButtonTheme(
                  minWidth: 235,
                  height: 60.0,
                  child: new ElevatedButton(
                    child: const Text(
                      'Sign up',
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                    style: ElevatedButton.styleFrom(primary: Colors.tealAccent[700],shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100.0))),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // If the form is valid.
                        if (agree)
                          signUp(
                              usernameController.text,
                              emailController.text,
                              choosePasswordController.text,
                              confirmPasswordController.text,
                              firstNameController.text.trim() +
                                  " " +
                                  lastNameController.text.trim(),
                              //fulNameController.text,
                              file!);
                        else
                          showInSnackBar("Must accept Terms & Policy");
                      } else {}
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future getImage() async
  {
    final ImagePicker _picker=ImagePicker();
    var imageXFile=await _picker.pickImage(source: ImageSource.gallery);
    //var tempImage = await FilePicker.platform.pickFiles(type: FileType.image);
    setState(() {
      file = File(imageXFile!.path);
    });
  }

  String? _validateEmail(String? value) {
    if (value?.trim().isEmpty ?? true) {
      return 'Please Enter Email Address';
    } else if (!validateEmail(emailController.text.trim())) {
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

  String? _validatePassword(String? value)
  {
    if (value?.trim().isEmpty ?? true) {
      choosePasswordController.clear();
      return 'Please Enter Password';
    } else if (!validatePassword(choosePasswordController.text.trim())) {
      showDialog(
        context: context,
          builder: (BuildContext context) =>  AlertDialog(
          content: const Text(
              "Passwords should be at least 8 characters long with a number, special character, capital letter and lowercase letter. "),
          actions: [
            new ElevatedButton(
              child: const Text("OK"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
      return 'Please Enter Valid Password';
    }
    //
    // if(value.isEmpty){
    //   return null;
    // }
    // if (value.length > 5) {
    //   return null;
    // }
    //
    // return 'Password must be upto 6 characters';
  }

  String? _validateConfirmPassword(String? value) {
    if (value?.trim().isEmpty ?? true) {
      confirmPasswordController.clear();
      return 'Please Confirm Password';
    } else if (confirmPasswordController.text !=
        choosePasswordController.text) {
      return 'Confirm Password Did Not Match';
    }
    //
    // if(value.isEmpty){
    //   return null;
    // }
    // if (value.length > 5) {
    //   return null;
    // }
    //
    // return 'Password must be upto 6 characters';
  }

  bool validatePassword(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  checkUserValue<bool>(String user) {
    doesNameAlreadyExist(user).then((val) {
      if (val) {
        print("UserName Already Exits");
        _userExist = val;
      } else {
        print("UserName is Available");
        _userExist = val;
      }
    });
    return _userExist;
  }

  Future<bool> doesNameAlreadyExist(String name) async {
    var haveName;
    await FirebaseDatabase.instance
        .reference()
        .child("users")
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> mp = snapshot.value;
      if (mp != null) {
        mp.forEach((k, v) {
          if (v["username"] == name) {
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

  void _add(dynamic obj, dynamic username, dynamic fullName, dynamic imageUrl) async
  {
    Map<String, dynamic> data = <String, dynamic>
    {
      "name": fullName,
      "email": obj.email,
      "profilePic": imageUrl,
      "username": username,
      "activity": 0,
      "friends": 0,
      "groups": 0,
      "isSocial": false,
      "flag": true,
    };
    FitcaribReference.child(obj.uid).update(data).whenComplete(() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignInScreen()),
      );
    }).catchError((e) => print(e));
  }

  Future<void> signUp(String username, String email, String choosePassword,
      String confirmPassword, String fullName, File image) async {
    if (username == null ||
        choosePassword == null ||
        confirmPassword == null ||
        fullName == null ||
        image == null ||
        email == null) {
      showInSnackBar("All Fields must be filled");
    } else {
      if (choosePassword == confirmPassword) {
        final user = await _firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: choosePassword);
        print("userid" + user.toString());
        final String fileName = (user.user!.uid).toString();
        print(fileName);
        _reference = _reference.child("ProfileImage/$fileName.jpg");
        if (user.user!.uid != null)
        {
          String downloadUrl;
          showInSnackBar("Account Succesfully Created!\nGo to login.");
          final uploadTask = _reference.putFile(image);
          final taskSnapshot = await uploadTask.whenComplete(() => null);
          downloadUrl = await _reference.getDownloadURL();
          if (downloadUrl != null)
          {
            _add(user.user, username, fullName, downloadUrl);
          } else {
            showInSnackBar("Unable to upload image.");
          }
        } else {
          showInSnackBar("Email already exists!");
        }
      } else {
        showInSnackBar("Password didn't matched.");
      }
    }
  }

  Future<String> getCurrentUser() async {
    final user = await _firebaseAuth.currentUser;
    return user!.uid;
  }

  Future<void> signOut() async {
    _firebaseAuth.signOut();
  }

  void showInSnackBar(String value) {
    _scaffoldKeySignUpScreen.currentState!.showSnackBar(new SnackBar(
      content: new Text(value),
      duration: Duration(seconds: 2),
    ));
  }
}
