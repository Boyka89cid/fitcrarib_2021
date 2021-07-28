import 'package:flutter/material.dart';
import 'package:fitcarib/base/ui/base_screen.dart';
import 'package:fitcarib/ui/groups/groups_presenter.dart';

class GroupsScreen extends BaseScreen
{
  GroupsScreen(String title, listener) : super(title, listener);

  @override
  _GroupsScreenState createState() => _GroupsScreenState();
}

class _GroupsScreenState extends BaseScreenState<GroupsScreen, GroupsPresenter> implements GroupsContract
{
  final GlobalKey<ScaffoldState> _scaffoldKeyGroupsScreen = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context)
  {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKeyGroupsScreen,
        drawer: getDrawerLayout(screenWidth, screenHeight),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            "Groups",
            style: TextStyle(
                color: Colors.orange,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          ),
          leading: FlatButton.icon(
            onPressed: () => _scaffoldKeyGroupsScreen.currentState!.openDrawer(),
            icon: Icon(
              Icons.menu,
              color: Colors.orange,
            ),
            label: Text(""),
            padding: EdgeInsets.only(right: 0.0, left: 24.0),
          ),
        ),
        floatingActionButton: getFloatingActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: getBottomNavigation(0),
        body: DefaultTabController(
          length: 3,
          child: new Column(
            children: <Widget>[
              new Container(
                constraints: BoxConstraints(maxHeight: 150.0),
                padding: EdgeInsets.only(top: 10.0),
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.grey))),
                child: new Material(
                  child: new TabBar(
                    tabs: [
                      Tab(
                        text: "All Groups",
//                        child: Text("Friendship",style: TextStyle(color: Colors.tealAccent[700],fontSize: 20.0),),
                      ),
                      Tab(
                        text: "Memberships",
//                        child: Text("Friendship",style: TextStyle(color: Colors.tealAccent[700],fontSize: 20.0),),
                      ),
                      Tab(
                        text: "Invitation",
//                        child: Text("Requests",style: TextStyle(color: Colors.tealAccent[700],fontSize: 20.0),),
                      ),
                    ],
                    indicatorColor: Colors.tealAccent[700],
                    unselectedLabelColor: Colors.grey,
                    labelColor: Colors.tealAccent[700],
                    labelStyle: TextStyle(fontSize: 17.0),
                  ),
                ),
              ),
              new Expanded(
                child: new TabBarView(
                  children: [
                    new Icon(Icons.directions_car),
                    new Icon(Icons.directions_transit),
                    new Icon(Icons.directions_bike),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {return Container();}

  @override
  GroupsPresenter createPresenter() {return GroupsPresenter(this);}
}
