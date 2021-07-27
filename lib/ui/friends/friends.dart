import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitcarib/ui/common/common.dart';
import 'package:fitcarib/ui/chats/chats.dart';

class FriendsScreen extends StatefulWidget{
  FriendsScreen({Key? key,})
      : super(
    key: key,
  );
  @override
  FriendsScreenState createState() => FriendsScreenState();
}

class FriendsScreenState extends State<FriendsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKeyFriendsScreen = new GlobalKey<ScaffoldState>();

  final FitcaribReference = FirebaseDatabase.instance.reference();

  SharedPreferences? sharedPreferences;

  Map<dynamic,dynamic>? val;

  var loggedInUserId;

  Map<dynamic,dynamic>? requestMap;
  Map<dynamic,dynamic>? friendsMap;

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKeyFriendsScreen,
        drawer: CommonDrawer(),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text("Friends", style: TextStyle(color: Colors.orange,fontSize: 20.0,fontWeight: FontWeight.bold),),
          leading: ElevatedButton.icon(
            onPressed: () => _scaffoldKeyFriendsScreen.currentState!.openDrawer(),
            icon: Icon(Icons.menu, color: Colors.orange,),
            label: Text(""),
            style:ElevatedButton.styleFrom(padding:  EdgeInsets.only(right: 0.0, left: 24.0),)),
        ),

        floatingActionButton: CommonFloatingActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: CommonBottomNavigationBar(selectedIndex: 3),

        body: DefaultTabController(
          length: 2,
          child: new Column(
            children: <Widget>[
              new Container(
                constraints: BoxConstraints(maxHeight: 150.0),
                padding: EdgeInsets.only(top: 10.0),
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey))),
                child: new Material(
                  child: new TabBar(
                    tabs: [
                      Tab(
                        text: "Friendship",
//                        child: Text("Friendship",style: TextStyle(color: Colors.tealAccent[700],fontSize: 20.0),),
                      ),
                      Tab(
                        text: "Requests",
//                        child: Text("Requests",style: TextStyle(color: Colors.tealAccent[700],fontSize: 20.0),),
                      ),
                    ],
                    indicatorColor: Colors.tealAccent[700],
                    unselectedLabelColor: Colors.grey,
                    labelColor: Colors.tealAccent[700],
                    labelStyle: TextStyle(fontSize: 20.0),
                  ),
                ),
              ),

              Expanded(
                child: TabBarView(children: [
                  friendsMap == null? Center(child: Text("No friends!"),): ListView.builder(
                    itemCount: friendsMap!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(top: 20.0),),
                          Padding(padding: EdgeInsets.only(right: 30.0,left: 30.0),child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                        width: 50.0,
                                        height: 50.0,
                                        decoration: new BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: new DecorationImage(
                                                fit: BoxFit.fill,
                                                image: new NetworkImage(friendsMap!.values.elementAt(index)["profilePic"])
                                            )
                                        )
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 20.0),
                                      child: Text("${friendsMap!.values.elementAt(index)["name"]}"),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(icon: Icon(Icons.message),
                                  onPressed: (){
                                toChat(friendsMap!.keys.elementAt(index), friendsMap!.values.elementAt(index));
//                                presenter.toChat(friendsMap.values.elementAt(index)["name"],friendsMap.keys.elementAt(index),friendsMap.values.elementAt(index)["profilePic"]);
//                                print(friendsMap.values.elementAt(index).toString());
                              })
                            ],
                          ),
                          ),
                          Padding(padding: EdgeInsets.only(top: 5.0),),
                          Divider(color: Colors.grey,),
                        ],
                      );
                    },
                  ),
                  requestMap == null? Center(child: Text("No pending requests!"),): ListView.builder(
                      itemCount: requestMap!.length,
                      itemBuilder: (BuildContext context, int index){
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(padding: EdgeInsets.only(top: 20.0),),
                            Padding(padding: EdgeInsets.only(right: 30.0,left: 30.0),child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                          width: 50.0,
                                          height: 50.0,
                                          decoration: new BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: new DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: new NetworkImage(requestMap!.values.elementAt(index)["profilePic"])
                                              )
                                          )
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 20.0),
                                        child: Text("${requestMap!.values.elementAt(index)["name"]}"),
                                      ),
                                    ],
                                  ),
                                ),
                                Material(
                                  shape: CircleBorder(),
                                  child: Ink.image(
                                    image: AssetImage('assets/images/trueicon.png'),
                                    fit: BoxFit.cover,
                                    width: 20.0,
                                    height: 20.0,
                                    child: InkWell(
                                      onTap: (){
                                        AcceptRequest(requestMap!.keys.elementAt(index), requestMap!.values.elementAt(index)["profilePic"], requestMap!.values.elementAt(index)["name"]);
                                      },
                                      child: null,
                                    ),
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(left: 10.0),),
                                Material(
                                  shape: CircleBorder(),
                                  child: Ink.image(
                                    image: AssetImage('assets/images/falseicon.png'),
                                    fit: BoxFit.cover,
                                    width: 20.0,
                                    height: 20.0,
                                    child: InkWell(
                                      onTap: null,
                                      child: null,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            ),
                            Padding(padding: EdgeInsets.only(top: 5.0),),
                            Divider(color: Colors.grey,),
                          ],
                        );
                      }
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void AcceptRequest(dynamic key, dynamic profilePic, dynamic name){

    setState(() {
      requestMap!.remove(key);
    });

    Map<String,dynamic> data = <String,dynamic>{
      "name": name,
      "profilePic": profilePic,
    };


    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedPreferences = sp;
      FirebaseDatabase.instance.reference().child("friendships").child(sharedPreferences!.getString("userid") as String).child(key).set(data).whenComplete((){

        Map<String,dynamic> data1 = <String,dynamic>{
          "name": sharedPreferences!.getString("name"),
          "profilePic": sharedPreferences!.getString("imageId"),
        };

        FirebaseDatabase.instance.reference().child("friendships").child(key).child(sharedPreferences!.getString("userid") as String).set(data1);
        FirebaseDatabase.instance.reference().child("requested").child(key).child(sharedPreferences!.getString("userid") as String).remove();
        FirebaseDatabase.instance.reference().child("requests").child(sharedPreferences!.getString("userid") as String).child(key).remove().whenComplete((){
          dynamic friends =  FirebaseDatabase.instance.reference().child("friendships").child(sharedPreferences!.getString("userid") as String);
          friends.once().then((DataSnapshot snapshot){
            if(snapshot.value != null){
              setState(() {
                friendsMap = snapshot.value;
              });
            }
          });
        });
      });
    });
  }

  void toChat(var id, var value){

    Map<dynamic,dynamic> senderUserDetails = Map();
    Map<dynamic,dynamic> receiverUserDetails = Map();
    var roomId;

    receiverUserDetails["id"] = id;
    receiverUserDetails.addAll(value);

    senderUserDetails["id"] = loggedInUserId;
    senderUserDetails["profilePic"] = sharedPreferences!.getString("imageId");
    senderUserDetails["name"] = sharedPreferences!.getString("name");

//    print(senderUserDetails.toString());

    if(loggedInUserId.compareTo(id) == 1){
      roomId = loggedInUserId+id;
//      print(loggedInUserId+id);
    }
    else if(loggedInUserId.compareTo(id) == -1){
      roomId = id+loggedInUserId;
//      print(id+loggedInUserId);
    }

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ChatsScreen(
            roomId: roomId,
            receiverUserDetails: receiverUserDetails,
            senderUserDetails: senderUserDetails,
          )),
    );

//  String s1 = id;
//  String s2 = loggedInUserId;
//


//  loggedInUserId.compareTo(id);

//    print(loggedInUserId.compareTo(id).toString());
//    print(s2);

//    if(loggedInUserId.hashCode > id.hashCode){
//      print("if" + loggedInUserId+id);
//    }
//    else{
//      print("else"+id+loggedInUserId);
//    }

//    FirebaseDatabase.instance.reference().child("friendships")
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences sp){
      sharedPreferences = sp;
      loggedInUserId = sharedPreferences!.getString("userid");
      if(loggedInUserId != null){
        dynamic friend = FirebaseDatabase.instance.reference().child("friendships").child(loggedInUserId);
        friend.once().then((DataSnapshot snapshot) {
          if(snapshot.value != null){
            setState(() {
              friendsMap = snapshot.value;
            });
          }
        });
        dynamic request =  FirebaseDatabase.instance.reference().child("requests").child(loggedInUserId);
        request.once().then((DataSnapshot snapshot){
          if(snapshot.value != null){
            setState(() {
              requestMap = snapshot.value;
            });
          }
        });
      }
    });
  }
}