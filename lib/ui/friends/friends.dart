import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitcarib/ui/common/common.dart';
import 'package:fitcarib/ui/chats/chats.dart';

class FriendsScreen extends StatefulWidget
{
  FriendsScreen({Key? key}) : super(key: key,);

  @override
  FriendsScreenState createState() => FriendsScreenState();
}

class FriendsScreenState extends State<FriendsScreen>
{
  final GlobalKey<ScaffoldState> _scaffoldKeyFriendsScreen = new GlobalKey<ScaffoldState>();

  final fitcaribReference = FirebaseDatabase.instance.reference();

  SharedPreferences? sharedPreferences;

  Map<dynamic,dynamic>? val;

  var loggedInUserId;

  String currentUserId=FirebaseAuth.instance.currentUser!.uid;

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
                child: TabBarView(
                    children: [
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
                                  onPressed: ()
                                  {
                                  toChat(friendsMap!.keys.elementAt(index), friendsMap!.values.elementAt(index));
//                                presenter.toChat(friendsMap.values.elementAt(index)["name"],friendsMap.keys.elementAt(index),friendsMap.values.elementAt(index)["profilePic"]);
//                                print(friendsMap.values.elementAt(index).toString());
                                  }
                              )
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
                                    image: AssetImage('assets/images/trueIcon.png'),
                                    fit: BoxFit.cover,
                                    width: 25.0,
                                    height: 25.0,
                                    child: InkWell(
                                      onTap: ()
                                      {
                                        acceptRequest(requestMap!.keys.elementAt(index), requestMap!.values.elementAt(index)["profilePic"], requestMap!.values.elementAt(index)["name"]);
                                      },
                                      child: null,
                                    ),
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(left: 15.0),),
                                Material(
                                  shape: CircleBorder(),
                                  child: Ink.image(
                                    image: AssetImage('assets/images/falseIcon.png'),
                                    fit: BoxFit.cover,
                                    width: 25.0,
                                    height: 25.0,
                                    child: InkWell(
                                      onTap: ()=>rejectRequest(requestMap!.keys.elementAt(index)),
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

  Future<void> rejectRequest(dynamic keyToBeRemoved) async
  {
    await fitcaribReference.child('requests').child(currentUserId).child(keyToBeRemoved).remove().then((_) async
    {
      await fitcaribReference.child("requested").child(keyToBeRemoved).child(currentUserId).remove().then((_) async
      {
        await fitcaribReference.child('requests').child(currentUserId).once().then((snapshot)
        {
          if(snapshot.value!=null)
          {
            setState(() {
              requestMap=snapshot.value;
            });
          }
          else
            setState(() {requestMap=null;});
        }).then((_) async {await fitcaribReference.child("notifications").child(keyToBeRemoved).child(currentUserId).remove();});
      });
    });
  }

  void acceptRequest(dynamic key, dynamic profilePic, dynamic name) async
  {
    var roomId;
    var notificationId;
    setState(()
    {
      requestMap!.remove(key);
    });

    Map<String,dynamic> data = <String,dynamic>
    {
      "name": name,
      "profilePic": profilePic,
    };

    //current user lakshit id=ZZZ kushal id=AAA
    if(currentUserId.compareTo(key) == 1)  // ZZZ compareTo AAA=+1
    {
      roomId = currentUserId+key;  //roomId= ZZZ AAA
      print(currentUserId+key);

      notificationId=roomId as String;
      await FirebaseMessaging.instance.unsubscribeFromTopic(notificationId).whenComplete(() async
      {
        await FirebaseMessaging.instance.subscribeToTopic(reverse(notificationId)).whenComplete(() async {await saveNotificationIdToFirebase(reverse(notificationId),key);});  //notification id=AAA ZZZ.
      });
    }
    else if(currentUserId.compareTo(key) == -1)
    {
      roomId = key+currentUserId;
      print(key+currentUserId);

      notificationId=roomId as String;
      await FirebaseMessaging.instance.subscribeToTopic(reverse(notificationId)).whenComplete(() async {await saveNotificationIdToFirebase(reverse(notificationId),key);});  //notification id=AAA ZZZ.
    }


    SharedPreferences.getInstance().then((SharedPreferences sp)
    {
      sharedPreferences = sp;
      FirebaseDatabase.instance.reference().child("friendships").child(sharedPreferences!.getString("userid") as String).child(key).set(data).whenComplete((){

        Map<String,dynamic> data1 = <String,dynamic>
        {

          "name": sharedPreferences!.getString("name"),
          "profilePic": sharedPreferences!.getString("imageId"),
        };

        FirebaseDatabase.instance.reference().child("friendships").child(key).child(sharedPreferences!.getString("userid") as String).set(data1);
        FirebaseDatabase.instance.reference().child("requested").child(key).child(sharedPreferences!.getString("userid") as String).remove();
        FirebaseDatabase.instance.reference().child("requests").child(sharedPreferences!.getString("userid") as String).child(key).remove().whenComplete(()
        {
          dynamic friends =  FirebaseDatabase.instance.reference().child("friendships").child(sharedPreferences!.getString("userid") as String);
          friends.once().then((DataSnapshot snapshot)
          {
            if(snapshot.value != null)
            {
              setState(()
              {
                friendsMap = snapshot.value;
              });
            }
          });
        });
      });
    });
  }

  Future<void >saveNotificationIdToFirebase(String? notificationId,String? id) async
  {
    Map<dynamic,dynamic> keyMap={"notificationKeyOfUser": notificationId };
    await fitcaribReference.child('notifications').child(id!).child(currentUserId).set(keyMap);
  }

  String reverse(String string)
  {
    if (string.length < 2)
      return string;

    final characters = Characters(string);
    return characters.toList().reversed.join();
  }

  Future<void> toChat(var id, var value) async
  {
    Map<dynamic,dynamic> senderUserDetails = Map();
    Map<dynamic,dynamic> receiverUserDetails = Map();
    var roomId;

    receiverUserDetails["id"] = id;
    receiverUserDetails.addAll(value);

    senderUserDetails["id"] = loggedInUserId;
    senderUserDetails["profilePic"] = sharedPreferences!.getString("imageId");
    senderUserDetails["name"] = sharedPreferences!.getString("name");

    //    print(senderUserDetails.toString());

    if(loggedInUserId.compareTo(id) == 1)  // abc compare def =+1
    {
      roomId = loggedInUserId+id;
      print(loggedInUserId+id);

    }
    else if(loggedInUserId.compareTo(id) == -1)
    {
      roomId = id+loggedInUserId;
      print(id+loggedInUserId);
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) => ChatsScreen(roomId: roomId, receiverUserDetails: receiverUserDetails, senderUserDetails: senderUserDetails)));
  }

  @override
  void initState()
  {
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences sp)
    {
      sharedPreferences = sp;
      loggedInUserId = sharedPreferences!.getString("userid");
      if(loggedInUserId != null)
      {
        dynamic friend = FirebaseDatabase.instance.reference().child("friendships").child(loggedInUserId);
        friend.once().then((DataSnapshot snapshot)
        {
          if(snapshot.value != null)
          {
            setState(() {
              friendsMap = snapshot.value;
            });
          }
        });
        dynamic request =  FirebaseDatabase.instance.reference().child("requests").child(loggedInUserId);
        request.once().then((DataSnapshot snapshot)
        {
          if(snapshot.value != null)
          {
            setState(() {requestMap = snapshot.value;});
          }
        });
      }
    });
  }
}