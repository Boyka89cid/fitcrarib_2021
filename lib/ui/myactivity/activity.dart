import 'package:flutter/cupertino.dart';
import 'package:fitcarib/ui/common/common.dart';
import 'all_activity.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';

class ActivityScreen extends StatefulWidget {
  ActivityScreen({Key? key}) : super(key: key);

  @override
  ActivityScreenState createState() => ActivityScreenState();
}

const List<String> tabNames = const <String>[
  'Friends',
  'Personal',
  'Mentions',
  'Favorites',
  'Groups',
];

class ActivityScreenState extends State<ActivityScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKeyActivityScreen = new GlobalKey<ScaffoldState>();
  List<dynamic> myPostData = [];
  final ref = FirebaseDatabase.instance.reference();
  late SharedPreferences sharedPreferences;
  Map<dynamic, dynamic> myPosts = Map();
  int indexPage = 1;
  late String timeFooter;
  var gotData = false;

  @override
  void dispose(){
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedPreferences = sp;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
        onWillPop: () => Future.value(false),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKeyActivityScreen,
        drawer: CommonDrawer(),
//        drawer: CommonFunctions().getDrawerLayout(screenWidth, screenHeight,sharedPreferences),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            "Activity",
            style: TextStyle(color: Colors.orange),
          ),
          leading: FlatButton.icon(
            onPressed: () => _scaffoldKeyActivityScreen.currentState!.openDrawer(),
            icon: Icon(
              Icons.menu,
              color: Colors.orange,
            ),
            label: Text(""),
            padding: EdgeInsets.only(right: 0.0, left: 24.0),
          ),
          actions: <Widget>[
            FlatButton.icon(
              onPressed: (){},
              icon: Icon(
                Icons.note,
                color: Colors.orange,
              ),
              label: Text(""),
              padding: EdgeInsets.only(right: 0.0, left: 24.0),
            )
          ],
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 15.0),
            ),
            Container(
              height: 30.0,
              width: screenWidth,
              padding: EdgeInsets.only(left: 5.0, right: 5.0),
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: tabNames.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.only(left: 5.0, right: 5.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            indexPage = index;
                          });
                        },
                        child: indexPage == index
                            ? Container(
                                width: screenWidth / 4,
                                child: Center(
                                  child: Text("${tabNames[index]}",
                                      style: new TextStyle(
                                        color: Colors.white,
                                      )),
                                ),
                                decoration: new BoxDecoration(
                                    borderRadius: new BorderRadius.all(
                                        new Radius.circular(30.0)),
                                    color: Colors.tealAccent),
                              )
                            : Container(
                                width: screenWidth / 4,
                                child: Center(
                                  child: Text("${tabNames[index]}",
                                      style: new TextStyle(
                                        color: Colors.white,
                                      )),
                                ),
                                decoration: new BoxDecoration(
                                    borderRadius: new BorderRadius.all(
                                        new Radius.circular(30.0)),
                                    color: Colors.grey),
                              ),
                      ),
                    );
                  }),
            ),
            Divider(
              color: Colors.grey,
            ),
//        builtItem(indexPage),
            Expanded(
              child: builtItem(indexPage),
            ),
          ],
        ),
        floatingActionButton: CommonFloatingActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: CommonBottomNavigationBar(selectedIndex: 0,),
      ),
    ),
    );
  }

  Widget builtItem(int index) {
    if (index == 0) {
      return FriendsActivityScreen();
    } else if (index == 2) {
      return Center(
        child: Text("Mentions"),
      );
    } else if (index == 3) {
      return FavoritesActivityScreen();
    } else if (index == 4) {
      return Center(
        child: Text("groups"),
      );
    } else {
      return MyActivityScreen();
    }
  }
}
