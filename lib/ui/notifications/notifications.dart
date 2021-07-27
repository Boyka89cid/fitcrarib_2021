import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fitcarib/ui/common/common.dart';

class NotificationsScreen extends StatefulWidget {
  NotificationsScreen({Key? key,})
      : super(
    key: key,
  );

  @override
  NotificationsScreenState createState() => NotificationsScreenState();
}

class NotificationsScreenState extends State<NotificationsScreen>{


  final GlobalKey<ScaffoldState> _scaffoldKeyNotificationsScreen = new GlobalKey<ScaffoldState>();

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState(){
    super.initState();
    _firebaseMessaging.getToken().then((token){
      print("token is $token");
    });
    // _firebaseMessaging.configure(
    //   onMessage: (Map<String,dynamic> message) async{
    //     print("on message $message");
    //   },
    //   onResume: (Map<String,dynamic> message) async{
    //     print("on Resume $message");
    //   },
    //   onLaunch: (Map<String,dynamic> message) async{
    //     print("on Launch $message");
    //   },
    // );
  }

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
        key: _scaffoldKeyNotificationsScreen,
        drawer: CommonDrawer(),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text("Notifications", style: TextStyle(color: Colors.orange),),
          leading: FlatButton.icon(
            onPressed: () => _scaffoldKeyNotificationsScreen.currentState!.openDrawer(),
            icon: Icon(Icons.menu, color: Colors.orange,),
            label: Text(""),
            padding: EdgeInsets.only(right: 0.0, left: 24.0),),
          actions: <Widget>[
            FlatButton(onPressed: null,
              child: Text("Clear",style: TextStyle(color: Colors.orange),),
              padding: EdgeInsets.only(right: 0.0, left: 24.0),)
          ],
        ),
        floatingActionButton: CommonFloatingActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: CommonBottomNavigationBar(selectedIndex: 0,),
      ),
    );
  }
}
