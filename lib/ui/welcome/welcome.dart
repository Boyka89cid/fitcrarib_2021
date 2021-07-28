import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:fitcarib/ui/signin/sign_in.dart';
import 'package:fitcarib/ui/signup/sign_up.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
class WelcomeScreen extends StatefulWidget {
  @override
  WelcomeScreenState createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {
  final FitcaribReference = FirebaseDatabase.instance.reference().child('users');

  FirebaseAuth? _firebaseAuth;

  /*void _signinfb()async{
    //FacebookLogin facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(['email']);
    final token = result.accessToken.token;
    final graphResponse = await http.get(Uri.parse('https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}'));
    print(graphResponse.body);
    if(result.status==FacebookLoginStatus.loggedIn){
      final credentials = FacebookAuthProvider.credential(token);
      _firebaseAuth!.signInWithCredential(credentials);
    }
  }*/

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
        onWillPop: () => Future.value(false),
     child: Scaffold(
      body: Stack(
        children: [
          ListView(
            children: <Widget>[
              new ClipPath(
                clipper: ClippingClass(context),
                child: Container(
                  padding: EdgeInsets.only(bottom: screenHeight/6,),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.1,0.15,0.25],
                      colors: [Colors.orange.shade800, Colors.orange.shade700, Colors.amber.shade600],
                    ),
                  ),
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Image.asset(
                          'assets/images/logo.png',
                          height: screenHeight/3.5,
                          width: screenWidth/2.5,
                        ),
                        Image.asset(
                          'assets/images/logo_text_new_1.png',
                           height: screenHeight/6.4,
                           width: screenWidth/2,
                        ),
                        new Text("we encourage purposeful living\n",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 22.0)),
                        // new Text("The THA Community provides a space\nfor shared ideas, support,\nencouragement, motivation,\naccountability, and empathy to those\nembarking on a journey to health.",
                        //   textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              Center(
                child:ButtonTheme(
                  minWidth: 230.0,
                  height: 60.0,
                  child: new ElevatedButton(
                    child: const Text('Sign In',style: TextStyle(color: Colors.white,fontSize: 16.0),),
                    style: ElevatedButton.styleFrom(primary:Colors.tealAccent[700]
                    ,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0))),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SignInScreen()))
                          // ModalRoute.withName("")
//                          Navigator.push(context,MaterialPageRoute(builder: (context) => SignUpScreen()),)
//                        Navigator.popUntil(context, ModalRoute.withName(MaterialPageRoute(builder: (context) => SignUpScreen())))
                    ),
                  ),
                ),
//                 RichText(
//                   text: TextSpan(
//                     children: [
//                       TextSpan(
//                         text: 'Already have account? ',
//                         style: TextStyle(fontSize: 16,color: Colors.black),
//                       ),
//                       TextSpan(
//                         text: 'Sign in',
//                         style: new TextStyle(color: Colors.orange,fontWeight: FontWeight.bold,fontSize: 16),
//                         recognizer: new TapGestureRecognizer()
//                           ..onTap = () =>
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => SignInScreen(),
//                                 ),
//                                 // ModalRoute.withName("")
//                               )
// //                          Navigator.push(context,MaterialPageRoute(builder: (context) => SignInScreen()),)
//                         ,
//                       ),
//                     ],
//                   ),
//                 ),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              Divider(color: Colors.grey,),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              Center(
                child: Column(
                  children: <Widget>[
                    new Text('Don\'t have an account?', style: TextStyle(fontSize: 16,color: Colors.black),),
                    Padding(padding: EdgeInsets.only(top: 10.0)),
                    ButtonTheme(
                      minWidth: 230.0,
                      height: 60.0,
                      child: new RaisedButton(
                        child: const Text('Get Started',style: TextStyle(color: Colors.white,fontSize: 16.0),),
                        color: Colors.tealAccent[700],
                        onPressed: () =>
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignUpScreen(),
                              ),
                              //ModalRoute.withName("")
                            )
//                          Navigator.push(context,MaterialPageRoute(builder: (context) => SignUpScreen()),)
//                        Navigator.popUntil(context, ModalRoute.withName(MaterialPageRoute(builder: (context) => SignUpScreen())))
                        ,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0)),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10.0)),
//                 OutlineButton(
//                   onPressed: () {
//                     _signinfb();
//                   },
//                   child: ButtonTheme(
//                       minWidth: 200.0,
//                       height: 55.0,
//                       child: new FlatButton(
// //                        onPressed: toActivityPage,
//                           child: Text("Login with facebook",style: TextStyle(color: Colors.black,fontSize: 16.0),))
//                   ),
//                   borderSide: BorderSide(color: Colors.tealAccent[700]),
//                   shape: StadiumBorder(),
//                 ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child:Text("\u00a9 ${DateTime.now().year} FitCarib, LLC"),)
        ],
      ),
     ),
    );
  }
}

class ClippingClass extends CustomClipper<Path> {
  ClippingClass(this.context);
  final context;
  @override
  Path getClip(Size size)
  {
    var path = Path();
    path.lineTo(0.0, MediaQuery.of(context).size.height/2.2);
    path.quadraticBezierTo(MediaQuery.of(context).size.width/2, MediaQuery.of(context).size.height/1.5, MediaQuery.of(context).size.width, MediaQuery.of(context).size.height /2.2);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}