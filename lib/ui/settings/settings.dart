import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fitcarib/ui/common/common.dart';
import 'package:fitcarib/ui/settings/general/general.dart';

class SettingsScreen extends StatefulWidget{
  SettingsScreen({Key? key,})
      : super(
    key: key,
  );
  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  bool _value1 = false;
  String visibility = "Everyone";
  final GlobalKey<ScaffoldState> _scaffoldKeySettingsScreen = new GlobalKey<ScaffoldState>();

  void _onChanged1(bool value) => setState(() => _value1 = value);

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKeySettingsScreen,
        drawer: CommonDrawer(),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text("Settings"
              "",style: TextStyle(color: Colors.orange),),
          leading: FlatButton.icon(onPressed: () => _scaffoldKeySettingsScreen.currentState!.openDrawer(), icon: Icon(Icons.menu,color: Colors.orange,), label: Text(""),padding: EdgeInsets.only(right: 0.0, left: 24.0),),
        ),

        body: ListView(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 30),),
            FlatButton(

              onPressed: () => Navigator.push(context,MaterialPageRoute(builder: (context) => GeneralScreen()),),
              child: Container(
              padding: EdgeInsets.only(left: 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("General",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize:20.0),),
                        Padding(padding: EdgeInsets.only(top: 5.0),),
                        Text("Update email or change current password",style: TextStyle(color: Colors.grey),),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios,size: 15.0,),
                ],
              ),
            ),
            ),
            Padding(padding: EdgeInsets.only(top: screenHeight/50),),
            Divider(color: Colors.grey,),
            Padding(padding: EdgeInsets.only(top: 20),),
            FlatButton(
//              onPressed: () => presenter.toEmailSettingsScreen(),
              onPressed: () {},
              child: Container(
              padding: EdgeInsets.only(left: screenWidth/50),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Email Settings",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize:20.0),),
                        Padding(padding: EdgeInsets.only(top: 5.0),),
                        Text("Send an email notice when",style: TextStyle(color: Colors.grey),),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios,size: 15.0,),
                ],
              ),
            ),
            ),
            Padding(padding: EdgeInsets.only(top: screenHeight/50),),
            Divider(color: Colors.grey,),
            Padding(padding: EdgeInsets.only(top: screenHeight/30),),
            Row(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(left: screenWidth/15),),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Social Login",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize:20.0),),
                      Padding(padding: EdgeInsets.only(top: 5.0),),
                      Text("Login with facebook account",style: TextStyle(color: Colors.grey),),
                    ],
                  ),
                ),
                CupertinoSwitch(onChanged: _onChanged1,value: false,activeColor: Colors.tealAccent[700]),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: screenHeight/30),),
            Divider(color: Colors.grey,),
            Padding(padding: EdgeInsets.only(top: screenHeight/30),),
            Row(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(left: screenWidth/15),),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Profile Visibility",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize:20.0),),
                      Padding(padding: EdgeInsets.only(top: 5.0),),
                      Text("Your visibility to Everyone",style: TextStyle(color: Colors.grey),),
                    ],
                  ),
                ),
                FlatButton(onPressed: (){_settingModalBottomSheet(context);},
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text("Change",style: TextStyle(color: Colors.grey),),
                      Padding(padding: EdgeInsets.only(top: 5.0),),
                      Text("$visibility",style: TextStyle(color: Colors.orange,fontWeight: FontWeight.bold,fontSize:15.0),)
                    ],
                  ),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: screenHeight/30),),
            Divider(color: Colors.grey,),
            Padding(padding: EdgeInsets.only(top: screenHeight/30),),
            Row(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(left: screenWidth/15),),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Delete Account",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize:20.0),),
                      Padding(padding: EdgeInsets.only(top: 5.0),),
                      Text("Deleting your account will delete all of the\ncontent you have created it will be\ncompletely irrecoverable",style: TextStyle(color: Colors.grey),),
                    ],
                  ),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: screenHeight/50),),
            Row(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(left: screenWidth/15),),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("I understand the consequences.",style: TextStyle(color: Colors.grey,fontSize:16.0),),
                    ],
                  ),
                ),
                CupertinoSwitch(onChanged: _onChanged1,value: false,activeColor: Colors.tealAccent[700]),
              ],
            ),
            Padding(padding: EdgeInsets.only(bottom: 50.0),),
          ],
        ),
        floatingActionButton: CommonFloatingActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: CommonBottomNavigationBar(selectedIndex: 4,),
      ),
    );
  }

  void _settingModalBottomSheet(context){
    showModalBottomSheet(context: context, builder: (BuildContext bc){
      return Container(
        child: Wrap(
          children: <Widget>[
            ListTile(
              title: Text("Everyone"),
              onTap: () {Navigator.pop(context);setState(() => visibility="Everyone");},
            ),
            ListTile(
              title: Text("NoOne"),
              onTap: () {Navigator.pop(context);setState(() => visibility="NoOne");},
            ),
            Padding(padding: EdgeInsets.only(top: 30.0),),
          ],
        ),
      );
    });
  }
}