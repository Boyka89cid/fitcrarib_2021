import 'package:fitcarib/base/ui/base_screen.dart';
import 'package:fitcarib/ui/myactivity/activity.dart';
import 'package:fitcarib/ui/signin/sign_in.dart';
import 'package:fitcarib/ui/signup/sign_up.dart';
import 'package:fitcarib/ui/welcome/welcome_presenter.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';

class WelcomeScreen extends BaseScreen
{
  WelcomeScreen(String title, listener) : super(title, listener);
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends BaseScreenState<WelcomeScreen, WelcomePresenter> implements WelcomeContract
{
  final FitcaribReference = FirebaseDatabase.instance.reference().child('users');
  @override
  Widget buildBody(BuildContext context)
  {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
      return ListView(
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
                        'assets/images/logo_white.png',
                        height: screenHeight/4,
                        width: screenWidth/2.5,
                      ),
                      new Text("HEALTH IS LIMITLESS©\n",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 22.0)),
                      new Text("The THA Community provides a space\nfor shared ideas, support,\nencouragement, motivation,\naccountability, and empathy to those\nembarking on a journey to health.",
                      textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),),
                    ],
                  ),
                ),
              ),
            ),
          Center(
            child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Already have account? ',
                      style: TextStyle(fontSize: 16,color: Colors.black),
                    ),
                    TextSpan(
                      text: 'Sign in',
                      style: new TextStyle(color: Colors.orange,fontWeight: FontWeight.bold,fontSize: 16),
                      recognizer: new TapGestureRecognizer()
                        ..onTap = () => presenter!.toWelcome(),
                    ),
                  ],
                ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 30.0)),
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
                    onPressed: () => presenter!.toSignUp(),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0)),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 10.0)),
                OutlineButton(
                  onPressed: () {},
                  child: ButtonTheme(
                    minWidth: 200.0,
                    height: 55.0,
                    child: new FlatButton(onPressed: toActivityPage, child: Text("Login with facebook",style: TextStyle(color: Colors.black,fontSize: 16.0),))
                  ),
                  borderSide: BorderSide(color: Colors.tealAccent.shade700),
                  shape: StadiumBorder(),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15.0),
          ),
        ],
      );
  }

  @override
  WelcomePresenter createPresenter()
  {
    return WelcomePresenter(this);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void toActivityPage() async {
    //await presenter!.initiateLogin(); edited.
  }

  @override
  void toLoginScreen() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignInScreen()));
   // widget.listener.getRouter().navigateTo(context, '/signin');
  }

  @override
  void toSignUpScreen() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUpScreen()));
    //widget.listener.getRouter().navigateTo(context, '/signup');
  }

  @override
  void toActivityScreen()
  {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ActivityScreen()));  //widget.listener.getRouter().navigateTo(context, '/activity');
  }
}
