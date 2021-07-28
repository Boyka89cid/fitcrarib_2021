import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitcarib/base/ui/base_listener.dart';
import 'package:fitcarib/ui/groups/groups_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'package:fitcarib/ui/myactivity/activity.dart';
import 'package:fitcarib/ui/notifications/notifications.dart';
import 'package:fitcarib/ui/messages/messages.dart';
import 'package:fitcarib/ui/friends/friends.dart';
import 'package:fitcarib/ui/settings/settings.dart';
import 'package:fitcarib/ui/findpeople/find_people.dart';
import 'package:fitcarib/ui/profile/profile.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:fitcarib/ui/welcome/welcome.dart';

class CommonDrawer extends StatefulWidget
{
  @override
  DrawerState createState() => new DrawerState();
}

class DrawerState extends State<CommonDrawer>
{
  SharedPreferences? sharedPreferences;
  List<dynamic> vehicleList = [];
  var name;
  var imageId;
  var userName;
  final FirebaseAuth _fAuth = FirebaseAuth.instance;

  List<dynamic> data1 =[];

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((sp) {
      sharedPreferences = sp;
      setState(() {
        name = sharedPreferences!.getString("name");
        imageId = sharedPreferences!.get("imageId");
        userName = sharedPreferences!.get("username");
      });
    });
  }

  @override
  Widget build(BuildContext context)
  {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.only(right: screenWidth / 5, top: 0.0),
//          padding: EdgeInsets.only(bottom: screenHeight/1.3),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(20.0)),
          color: Colors.orange),
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.tealAccent[700],
            ),
            child: Row(
              children: <Widget>[
                Flexible(
                  child: Container(
                      width: 130.0,
                      height: 130,
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: new NetworkImage(imageId ?? 'https://i.stack.imgur.com/l60Hf.png')
                          )
                      )
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15.0),
                ),
                Flexible(
                  child: new Container(
                    padding: new EdgeInsets.only(top: screenHeight / 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "$name",
                          style: TextStyle(color: Colors.white),
                          textScaleFactor: 1.4,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "@$userName",
                          style: TextStyle(color: Colors.white),
                          textScaleFactor: 1.4,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20.0),
              ),
              TextButton.icon(
                  onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ActivityScreen()),
                      ),
                  icon: Icon(
                    Icons.note,
                    color: Colors.white,
                    size: 35.0,
                  ),
                  label: Text(
                    "Activity",
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  )),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20.0),
              ),
              TextButton.icon(
                  onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileScreen()),
                      ),
                  icon: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 35.0,
                  ),
                  label: Text(
                    "Profile",
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  )),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20.0),
              ),
              TextButton.icon(
                  onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NotificationsScreen()),
                      ),
                  icon: Icon(
                    Icons.notifications,
                    color: Colors.white,
                    size: 35.0,
                  ),
                  label: Text(
                    "Notification",
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  )),
              Padding(
                padding: EdgeInsets.only(left: screenWidth / 50),
              ),
              CircleAvatar(
                backgroundColor: Colors.tealAccent[700],
                child: Text(
                  "1",
                  style: TextStyle(color: Colors.white),
                ),
                radius: 15.0,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20.0),
              ),
              TextButton.icon(
                  onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MessageScreen()),
                      ),
                  icon: Icon(
                    Icons.message,
                    color: Colors.white,
                    size: 35.0,
                  ),
                  label: Text(
                    "Messages",
                    style: TextStyle(color: Colors.white, fontSize: 20.0))
              ),
              Padding(
                padding: EdgeInsets.only(left: screenWidth / 18),
              ),
              CircleAvatar(
                backgroundColor: Colors.tealAccent[700],
                child: Text(
                  "1",
                  style: TextStyle(color: Colors.white),
                ),
                radius: 15.0,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20.0),
              ),
              TextButton.icon(
                  onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FriendsScreen()),
                      ),
                  icon: Icon(
                    Icons.people,
                    color: Colors.white,
                    size: 35.0,
                  ),
                  label: Text(
                    "Friends",
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  )),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20.0),
              ),
              TextButton.icon(
                  onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FindPeopleScreen()),
                      ),
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 35.0,
                  ),
                  label: Text(
                    "Find People",
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  )
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20.0),
              ),
              TextButton.icon(
                  onPressed: ()
                  {
                    BaseListener? listner;
                    Navigator.push(context, MaterialPageRoute(builder: (context) => GroupsScreen("title", listner)));
                  },
                  //  onPressed: () => widget.listener
                  //      .getRouter()
                  //      .navigateTo(context, '/groups', clearStack: true),
                  icon: Image.asset(
                    "assets/images/three-people-3258999-2718117.png",
                    color: Colors.white,
                    height: 35,
                    width: 35,
                  ),
                  label: Text("Groups", style: TextStyle(color: Colors.white, fontSize: 20.0))
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20.0),
              ),
              TextButton.icon(
                  onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingsScreen()),
                      ),
                  icon: Icon(
                    Icons.settings,
                    color: Colors.white,
                    size: 35.0,
                  ),
                  label: Text(
                    "Settings",
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  )),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20.0),
              ),
              TextButton.icon(
                  onPressed: ()
                  {
                      sharedPreferences!.clear().then((_) {Navigator.push(context, MaterialPageRoute(builder: (context) => WelcomeScreen()));});
                  },
                  icon: Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                    size: 35.0,
                  ),
                  label: Text(
                    "Logout",
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  )),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 40.0),
          ),
        ],
      ),
    );
  }

  Future _showAlert(BuildContext context, String message) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
          title: Center(
              child: Text(
            message,
            style: TextStyle(fontWeight: FontWeight.bold))
          ),
          actions: <Widget>[
            Row(
              children: <Widget>[
                TextButton(
                  onPressed: () {Navigator.pop(context);},
                  child: Text("OK", style: TextStyle(color: Color(0xFF0076B5), fontWeight: FontWeight.w900, fontSize: 15))
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  /*Future signOut() async
  {
    var facebookLogin = FacebookLogin();
    var data = _fAuth.currentUser;
    if (data != null)
    {
      facebookLogin.logOut();
      _fAuth.signOut();
      print("signedout");
    }
  }*/
}
