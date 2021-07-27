import 'package:flutter/material.dart';
import 'package:fitcarib/base/ui/base_screen.dart';
import 'package:fitcarib/ui/settings/emailsettings/emailsettings_presenter.dart';
import 'package:flutter/cupertino.dart';

class EmailSettingsScreen extends BaseScreen {
  EmailSettingsScreen(String title, listener) : super(title, listener);

  @override
  _EmailSettingsScreenState createState() => _EmailSettingsScreenState();
}

class _EmailSettingsScreenState extends BaseScreenState<EmailSettingsScreen, EmailSettingsPresenter> implements EmailSettingsContract{

  final GlobalKey<ScaffoldState> _scaffoldKeyEmailSettingsScreen = new GlobalKey<ScaffoldState>();
  bool _value1 = false;
  void _onChanged1(bool value) => setState(() => _value1 = value);

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
        key: _scaffoldKeyEmailSettingsScreen,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text("Email Settings", style: TextStyle(color: Colors.orange),),
          leading: FlatButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back, color: Colors.orange,),
            label: Text(""),
            padding: EdgeInsets.only(right: 0.0, left: 24.0),),
          actions: <Widget>[
            FlatButton(onPressed: null,
              child: Text("Save",style: TextStyle(color: Colors.orange),),
              padding: EdgeInsets.only(right: 0.0, left: 24.0),
            ),
          ],
        ),
        body: ListView(
          padding: EdgeInsets.only(top: 30),
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Activity",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize:20.0),),
                  Padding(padding: EdgeInsets.only(top: 10.0),),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("A member mentions you in an update\nusing '@kristina'",style: TextStyle(color: Colors.grey),),
                          ],
                        ),
                      ),
                      CupertinoSwitch(onChanged: _onChanged1,value: false,activeColor: Colors.tealAccent[700]),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: 10.0),),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("A member replies to an update or\ncomment you've posted",style: TextStyle(color: Colors.grey),),
                          ],
                        ),
                      ),
                      CupertinoSwitch(onChanged: _onChanged1,value: false,activeColor: Colors.tealAccent[700]),
                    ],
                  ),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.only(top: screenHeight/50),),
            Divider(color: Colors.grey,),
            Padding(padding: EdgeInsets.only(top: screenHeight/30),),
            Container(
              padding: EdgeInsets.only(left: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Messages",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize:20.0),),
                  Padding(padding: EdgeInsets.only(top: 3.0),),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("A member sends you a new message",style: TextStyle(color: Colors.grey),),
                          ],
                        ),
                      ),
                      CupertinoSwitch(onChanged: _onChanged1,value: false,activeColor: Colors.tealAccent[700]),
                    ],
                  ),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.only(top: screenHeight/50),),
            Divider(color: Colors.grey,),
            Padding(padding: EdgeInsets.only(top: screenHeight/30),),
            Container(
              padding: EdgeInsets.only(left: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Friends",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize:20.0),),
                  Padding(padding: EdgeInsets.only(top: 10.0),),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("A member sends you a friendship\nrequest",style: TextStyle(color: Colors.grey),),
                          ],
                        ),
                      ),
                      CupertinoSwitch(onChanged: _onChanged1,value: false,activeColor: Colors.tealAccent[700]),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: 10.0),),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("A member accepts your friendship\nrequest",style: TextStyle(color: Colors.grey),),
                          ],
                        ),
                      ),
                      CupertinoSwitch(onChanged: _onChanged1,value: false,activeColor: Colors.tealAccent[700]),
                    ],
                  ),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.only(top: screenHeight/50),),
            Divider(color: Colors.grey,),
            Padding(padding: EdgeInsets.only(top: screenHeight/30),),
            Container(
              padding: EdgeInsets.only(left: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Groups",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize:20.0),),
                  Padding(padding: EdgeInsets.only(top: 10.0),),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("A member invites you to join a group",style: TextStyle(color: Colors.grey),),
                          ],
                        ),
                      ),
                      CupertinoSwitch(onChanged: _onChanged1,value: false,activeColor: Colors.tealAccent[700]),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: 5.0),),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Group information is updated",style: TextStyle(color: Colors.grey),),
                          ],
                        ),
                      ),
                      CupertinoSwitch(onChanged: _onChanged1,value: false,activeColor: Colors.tealAccent[700]),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: 5.0),),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("You are promoted to a group\nadministrator or moderator",style: TextStyle(color: Colors.grey),),
                          ],
                        ),
                      ),
                      CupertinoSwitch(onChanged: _onChanged1,value: false,activeColor: Colors.tealAccent[700]),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: 5.0),),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("A member requests to join a private\ngroup for which you are an admin",style: TextStyle(color: Colors.grey),),
                          ],
                        ),
                      ),
                      CupertinoSwitch(onChanged: _onChanged1,value: false,activeColor: Colors.tealAccent[700]),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: 5.0),),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Your request to join a group has been",style: TextStyle(color: Colors.grey),),
                          ],
                        ),
                      ),
                      CupertinoSwitch(onChanged: _onChanged1,value: false,activeColor: Colors.tealAccent[700]),
                    ],
                  ),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 30.0),),
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
  EmailSettingsPresenter createPresenter() {
    return EmailSettingsPresenter(this);
  }
}
