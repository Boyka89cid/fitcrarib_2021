import 'package:flutter/material.dart';
import 'package:fitcarib/base/ui/base_screen.dart';
import 'package:fitcarib/ui/forgotpassword/newpassword/newpassword_presenter.dart';

class NewPasswordScreen extends BaseScreen {
  NewPasswordScreen(String title, listener) : super(title, listener);

  @override
  _NewPasswordScreenState createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends BaseScreenState<NewPasswordScreen, NewPasswordPresenter> implements NewPasswordContract{


  final GlobalKey<ScaffoldState> _scaffoldKeyNewPasswordScreen = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKeyNewPasswordScreen,
        body: ListView(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 10.0)),
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(onPressed: () => Navigator.of(context).pop, icon: Icon(Icons.arrow_back,color: Colors.orange,size: 35.0,),),
            ),
            Padding(padding: EdgeInsets.only(top: 30.0),),
            Center(
              child: Column(
                children: <Widget>[
                  Text("Choose New Password",style: TextStyle(color: Colors.orange,fontWeight: FontWeight.bold,fontSize: 35.0),),
                  Padding(padding: EdgeInsets.only(top: 5.0),),
                  Text("To change your password please fill\nout the fields below.",style: TextStyle(color: Colors.tealAccent[700],fontSize: 22.0),),
                ],
              ),
            ),

            Padding(padding: EdgeInsets.only(top: 80.0,left: 30,right: 30),child: TextField(
              decoration: InputDecoration(hintText: "ex Hello@1234",labelText: "New password",labelStyle: TextStyle(color : Colors.tealAccent[700],fontSize: 20.0),focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey),)),
              style: TextStyle(color: Colors.black,),
              obscureText: true,
            ),
            ),

            Padding(padding: EdgeInsets.only(top: 20.0,left: 30,right: 30),child: TextField(
              decoration: InputDecoration(hintText: "ex Hello@1234",labelText: "Confirm password",labelStyle: TextStyle(color : Colors.tealAccent[700],fontSize: 20.0),focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey),)),
              style: TextStyle(color: Colors.black,),
              obscureText: true,
            ),
            ),

            Padding(padding: EdgeInsets.only(top: 40.0),),

            Center(
              child: FlatButton(
                onPressed: null,
                child: Container(
                  decoration: BoxDecoration(color: Colors.tealAccent[700],borderRadius: BorderRadius.circular(100.0)),
                  width: 300,
                  height: 60.0,
                  child: Center(
                    child: Text("Change",style: TextStyle(color: Colors.white,fontSize: 20.0)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget buildBody(BuildContext context) {
    return Container();
  }

  @override
  NewPasswordPresenter createPresenter() {
    return NewPasswordPresenter(this);
  }
}
