import 'package:flutter/material.dart';
import 'package:fitcarib/base/ui/base_screen.dart';
import 'package:fitcarib/ui/forgotpassword/resetpassword/resetpassword_presenter.dart';

class ResetPasswordScreen extends BaseScreen {
  ResetPasswordScreen(String title, listener) : super(title, listener);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends BaseScreenState<ResetPasswordScreen, ResetPasswordPresenter> implements ResetPasswordContract{
  @override
  Widget buildBody(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return ListView(
      children: <Widget>[
        Padding(padding: EdgeInsets.only(top: 10.0)),
        Align(
          alignment: Alignment.topLeft,
          child: IconButton(onPressed: () => Navigator.of(context).pop(null), icon: Icon(Icons.arrow_back,color: Colors.orange,size: 35.0,),),
        ),
        Center(
          child: Image.asset(
            'assets/images/logo_orange.png',
            height: screenHeight/7,
            width: screenWidth/2,
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 40.0),),
        Divider(color: Colors.grey,),
        Padding(padding: EdgeInsets.only(top: 40.0),),
        Center(
          child: Text("Reset Your Password",style: TextStyle(color: Colors.orange,fontWeight: FontWeight.bold,fontSize: 30.0),),
        ),
        Padding(padding: EdgeInsets.only(top: 15.0),),
        Center(
          child: Text("Please enter a registered email address.",style: TextStyle(color: Colors.tealAccent[700],fontWeight: FontWeight.bold,fontSize: 18),),
        ),
        Padding(padding: EdgeInsets.only(top: 80.0,left: 30,right: 30),child: TextField(
          decoration: InputDecoration(labelText: "Email",labelStyle: TextStyle(color : Colors.tealAccent[700],),focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey),)),
          style: TextStyle(color: Colors.black,),
        ),
        ),
        Padding(padding: EdgeInsets.only(top: 50.0)),
        Center(
          child: FlatButton(
              onPressed: null,
              child: Container(
                decoration: BoxDecoration(color: Colors.tealAccent[700],borderRadius: BorderRadius.circular(100.0)),
                width: 230,
                height: 60.0,
                child: Center(
                  child: Text("Sign in",style: TextStyle(color: Colors.white,fontSize: 20.0)),
                ),
              ),
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 30.0)),
      ],
    );
  }

  @override
  ResetPasswordPresenter createPresenter() {
    return ResetPasswordPresenter(this);
  }
}
