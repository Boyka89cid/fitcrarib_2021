import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddUserToGroup extends StatefulWidget
{
  var roomId;
  AddUserToGroup(this.roomId);
  @override
  State<StatefulWidget> createState()=>AddUserToGroupState();
}

class AddUserToGroupState extends State<AddUserToGroup>
{
  String? search;

  var list;

  final myController = TextEditingController();

  SharedPreferences? sharedPreferences;

  //List<String> litems = [];
  Map<dynamic, dynamic>? allUsers;

  Map foundUsers = Map();
  Map toRemoveUsers = Map();


  final fitcaribReference = FirebaseDatabase.instance.reference();
  final TextEditingController eCtrl = new TextEditingController();

  final String currentUserId=FirebaseAuth.instance.currentUser!.uid;

  @override
  void dispose()
  {
    // Clean up the controller when the Widget is disposed
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text("Add User To Group", style: TextStyle(color: Colors.orange),),
          leading: ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.logout, color: Colors.orange,),
            label: Text(""),
            style: ElevatedButton.styleFrom(padding: EdgeInsets.only(right: 0.0, left: 24.0)),
          ),
        ),
        body : Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 30.0),),
            Padding(padding: EdgeInsets.only(right: 30.0,left: 30.0),child: Container(
              child: TextFormField(
                controller: myController,
                decoration: InputDecoration(
                  contentPadding: new EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(50.0))),
                  suffixIcon: IconButton(icon: Icon(Icons.search), onPressed: ()
                  {
                    search = myController.text;
                    myController.text = "";
                    getPeople(search);
                  }),
                ),
              ),
            ),
            ),
            Padding(padding: EdgeInsets.only(top: 15.0),),
            Expanded(
                child: (foundUsers==null)? Text("Find peoples"): ListView.builder
                  (
                    itemCount: foundUsers.length,
                    itemBuilder: (BuildContext context, int index)
                    {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(top: 5.0),),
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
                                                image: new NetworkImage(foundUsers.values.elementAt(index)["profilePic"])
                                            )
                                        )
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 20.0),
                                      child: Text(foundUsers.values.elementAt(index)["name"]),
                                    ),
                                  ],
                                ),
                              ),
                              ElevatedButton.icon(onPressed: ()
                              {
                                inviteUserToGroup(foundUsers.values.elementAt(index)["name"],foundUsers.values.elementAt(index)["profilePic"],foundUsers.keys.elementAt(index));
                              }, icon: Icon(Icons.add,size: 30.0,), label: Text("")),
//                              Icon(Icons.add,size: 20.0,),
                            ],
                          ),
                          ),
                          Padding(padding: EdgeInsets.only(top: 5.0),),
                          Divider(color: Colors.grey,),
                        ],
                      );
                    }
                )
            ),
          ],
        ),
      ),
    );
  }

  void finalPeoples() {setState(() {foundUsers = allUsers!;});}

  Future getAllPeople(dynamic value1) async
  {
    String name = "";
    if(allUsers != null)
    {
      allUsers!.forEach((k,v)
      {
        name = v["name"];
        name = name.toLowerCase();
        if(!name.contains(value1))
        {
          toRemoveUsers[k] = {"name" : v["name"], "profilePic": v["profilePic"]};
        }
      });
      allUsers!.removeWhere((dynamic k, dynamic v) => toRemoveUsers.containsKey(k));
    }
    finalPeoples();
  }

  Future requested(dynamic value1) async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic requested = fitcaribReference.child(widget.roomId as String).child("groupRequested").child(prefs.get("userid") as String);
    requested.once().then((DataSnapshot snapshot) async
    {
      if(snapshot.value != null)
      {
        Map<dynamic,dynamic> requestedMap= snapshot.value;
        if(requestedMap != null)
          allUsers!.removeWhere((dynamic k, dynamic v) => requestedMap.containsKey(k));
      }
      getAllPeople(value1);
    });
  }

  Future requests(dynamic value1) async
  {  //removing not done from this fxn.
    SharedPreferences prefs = await SharedPreferences.getInstance(); //TODO
    dynamic requests = fitcaribReference.child("groupRequests").child(currentUserId);
    requests.once().then((DataSnapshot snapshot) async
    {
      if(snapshot.value != null)
      {
        Map<dynamic,dynamic> requestMap= snapshot.value;
        if(requestMap != null)
        {
          allUsers!.removeWhere((dynamic k, dynamic v) => requestMap.containsKey(k));
        }
      }
      requested(value1);
    });
  }

  Future<void> removeExistingMembers(dynamic value1) async
  {
    await fitcaribReference.child('groups').child(widget.roomId as String).child('members').once().then((snapshot) async
    {
      List listOfMembersInGroup=snapshot.value;
      Map<dynamic,dynamic> mapOfMembersInGroup={};

      for(int i=0;i <listOfMembersInGroup.length;i++)
          mapOfMembersInGroup['${listOfMembersInGroup[i]}']=i;

      allUsers!.removeWhere((key, value) => mapOfMembersInGroup.containsKey(key));
      requests(value1);
    });
  }

  // ignore: missing_return
  Future<void> getPeople(dynamic value1) async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("user id is ${prefs.get("userid")}");
    if(foundUsers != null)
      foundUsers.clear();

    if(allUsers != null)
      allUsers!.clear();

    if(toRemoveUsers != null)
      toRemoveUsers.clear();

    dynamic users = fitcaribReference.child("users");
    users.once().then((DataSnapshot snapshot) async
    {
      if(snapshot.value == null)
        print("in if");

      else
      {
        print("in else");
        Map<dynamic, dynamic> usersMap = snapshot.value;
        if(usersMap == null)
        {
          print("in child if");
        }
        else{
          print("in child else");
          allUsers = usersMap;
          allUsers!.remove(prefs.get("userid")); //removing current user from mapping.
          removeExistingMembers(value1);
        }
      }
    });
  }



  Future<void> inviteUserToGroup(dynamic name,dynamic profilePic,dynamic id) async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<dynamic,dynamic> data=
    {
      "name": name,
      "profilePic": profilePic,
      "groupId":widget.roomId.toString()
    };
    Map<dynamic,dynamic> data1=
    {
      "name": prefs.get("name"),
      "profilePic": prefs.get("imageId"),
      "groupId":widget.roomId.toString()
    };
        //List<dynamic> allMembersList=snapshot.value;
        //allMembersList.add(id);
    Map<String,dynamic> notificationDetails=
    {
      'userID':id,
      'notificationTopic':''
    };
    await fitcaribReference.child('groupNotifications').child(widget.roomId.toString()).child(id).push().set(notificationDetails).then((_) async
    {
      await fitcaribReference.child('groupNotifications').child(widget.roomId.toString()).child(id).once().then((dataSnapshot) async
      {
        Map<dynamic,dynamic> newMap=dataSnapshot.value;
        String? requiredNotificationKey;
        newMap.keys.forEach((key) {requiredNotificationKey=key; });
        Map<dynamic,dynamic> requiredNotificationDetails=
        {
          'userID':id,
          'notificationTopic':requiredNotificationKey
        };
        await fitcaribReference.child('groupNotifications').child(widget.roomId.toString()).child(id).set(requiredNotificationDetails).then((_) async
        {
          await fitcaribReference.child('groupRequested').child(widget.roomId.toString()).child(currentUserId).child(id).set(data).whenComplete(() async
          {
            await fitcaribReference.child('groupRequests').child(widget.roomId.toString()).child(id).child(currentUserId).set(data1).whenComplete(()
            {
              setState(() {
                foundUsers.remove(id);
              });
            });
          });
        });
      });
    });
  }
}

