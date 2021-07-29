
import 'package:fitcarib/ui/profile/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitcarib/ui/common/common.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key,}) : super(key: key,);

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen>
{
  final GlobalKey<ScaffoldState> _scaffoldKeyProfileScreen = new GlobalKey<ScaffoldState>();

  SharedPreferences? sharedPreferences;
  String? stringName;
  String? stringImageId;
  String? username;
  String? firstName;
  dynamic activity;
  dynamic friends;
  dynamic groups;
  String? lastName;

  @override
  Widget build(BuildContext context)
  {
    //var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKeyProfileScreen,
        drawer: CommonDrawer(),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            "Profile",
            style: TextStyle(color: Colors.orange),
          ),
          leading: Container(
            //padding: EdgeInsets.only(right: 0.0, left: 24.0),
            child: TextButton.icon(
              onPressed: () => _scaffoldKeyProfileScreen.currentState!.openDrawer(),
              icon: Icon(
                Icons.menu,
                color: Colors.orange,
              ),
              label: Text(""),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {Navigator.push(context,MaterialPageRoute(builder: (context)=>EditProfile()));},
              child: Container(
                padding: EdgeInsets.only(right: 0.0, left: 24.0),
                child: Text(
                  "Edit",
                  style: TextStyle(color: Colors.orange),
                ),
              ),
            ),
          ],
        ),
        body: ListView(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.tealAccent[700],
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(
                    top: 20.0,
                  )),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 30.0),
                      ),
                      Container(
                        width: 130.0,
                        height: 130,
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: new NetworkImage('$stringImageId'))),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20.0),
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "$stringName",
                              style: TextStyle(color: Colors.white),
                              textScaleFactor: 1.5,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "@$username",
                              style: TextStyle(color: Colors.white),
                              textScaleFactor: 1.2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 100.0),
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Text(
                              "$activity",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25.0),
                            ),
                            Text("Activity",
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
//                      VerticalDivider(color: Colors.white,width: 5.0,),
                      Container(
                        height: 50.0,
                        width: 1.0,
                        color: Colors.white,
                        margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Text(
                              "$friends",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25.0),
                            ),
                            Text(
                              "Friends",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 50.0,
                        width: 1.0,
                        color: Colors.white,
                        margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Text(
                              "$groups",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25.0),
                            ),
                            Text("Groups",
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: screenWidth,
              height: 70.0,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20.0),
                  bottomLeft: Radius.circular(20.0),
                ),
              ),
              child: TextButton(
                onPressed: () => print("hello"),
                child: Container(
                  width: screenWidth,
                  height: 60.0,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20.0),
                      bottomLeft: Radius.circular(20.0),
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(60),
                      ),
                      Icon(
                        Icons.message,
                        color: Colors.white,
                        size: 25,
                      ),
                      Text(
                        "Message",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 30.0, left: 30.0),
              child: Text(
                "First Name",
                style: TextStyle(color: Colors.black, fontSize: 15.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5.0, left: 30.0),
              child: Text(
                "$firstName",
                style: TextStyle(color: Colors.black, fontSize: 20.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 30.0, left: 30.0),
              child: Text(
                "Last Name",
                style: TextStyle(color: Colors.black, fontSize: 15.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5.0, left: 30.0),
              child: Text(
                "$lastName",
                style: TextStyle(color: Colors.black, fontSize: 20.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
            ),
            Divider(
              color: Colors.grey,
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0, left: 30.0),
              child: Text(
                "Profile Name",
                style: TextStyle(color: Colors.black, fontSize: 15.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5.0, left: 30.0),
              child: Text(
                "@$username",
                style: TextStyle(color: Colors.black, fontSize: 20.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() 
  {
    super.initState();
    SharedPreferences.getInstance().then((sp)
    {
      sharedPreferences = sp;
      String name = sharedPreferences!.getString("name") as String;
      List<String> names = name.split(' ');
      firstName = names[0];
      lastName = names[(names.length - 1)];
      print('$name " " $firstName " " $lastName');
      setState(()
      {
        stringName = name;
        stringImageId = sharedPreferences!.get("imageId") as String;
        activity = sharedPreferences!.get("activity");
        groups = sharedPreferences!.get("groups");
        friends = sharedPreferences!.get("friends");
        username = sharedPreferences!.get("username") as String;
      });
    });
  }
}
