import 'package:fitcarib/ui/signin/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:fitcarib/base/ui/base_screen.dart';
import 'package:flutter/services.dart';
import 'package:fitcarib/ui/settings/general/general_presenter.dart';

class GeneralScreen extends BaseScreen {
  GeneralScreen(String title, listener) : super(title, listener);

  @override
  _GeneralScreenState createState() => _GeneralScreenState();
}

class _GeneralScreenState extends BaseScreenState<GeneralScreen, GeneralPresenter> implements GeneralContract{

  final GlobalKey<ScaffoldState> _scaffoldKeyGeneralScreen = new GlobalKey<ScaffoldState>();
  dynamic email2;
  final _currentPasswordController = TextEditingController();
  final _changePasswordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();



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
              presenter!.changePassword(email2,_currentPasswordController.text,_changePasswordController.text,_repeatPasswordController.text);},
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




  @override
  Widget buildBody(BuildContext context) {
    return Container();
  }

  @override
  GeneralPresenter createPresenter() {
    return GeneralPresenter(this);
  }

  initialValue(val) {
    return TextEditingController(text: val);
  }


  @override
  void initState(){
    super.initState();
    presenter!.email1().then((email) {
      print("email is $email");
      setState(() {
        email2 = email;
      });
    });
  }

  @override
  void toLoginScreen() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignInScreen()));
   // widget.listener.getRouter().navigateTo(context, '/signin');
  }
}
