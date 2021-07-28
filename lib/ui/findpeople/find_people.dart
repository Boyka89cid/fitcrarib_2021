import 'dart:async';
import 'package:flutter/services.dart';
import 'package:fitcarib/ui/common/common.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FindPeopleScreen extends StatefulWidget {
  FindPeopleScreen({Key? key,}) : super(key: key);

  @override
  FindPeopleScreenState createState() => FindPeopleScreenState();
}

class FindPeopleScreenState extends State<FindPeopleScreen>
{
  final GlobalKey<ScaffoldState> _scaffoldKeyFindPeopleScreen = new GlobalKey<ScaffoldState>();

  String search="";

  var list;

  final myController = TextEditingController();

  SharedPreferences? sharedPreferences;



  List<String> litems = [];
  Map<dynamic, dynamic>? allusers;


  Map foundUsers = Map();
  Map toRemoveUsers = Map();


  final FitcaribReference = FirebaseDatabase.instance.reference();
  final TextEditingController eCtrl = new TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKeyFindPeopleScreen,
        drawer: CommonDrawer(),
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
                              ElevatedButton.icon(onPressed: () {
                                sendToRequested(foundUsers.values.elementAt(index)["name"],foundUsers.values.elementAt(index)["profilePic"],foundUsers.keys.elementAt(index));
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
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text("Find People", style: TextStyle(color: Colors.orange),),
          leading: ElevatedButton.icon(
            onPressed: () => _scaffoldKeyFindPeopleScreen.currentState!.openDrawer(),
            icon: Icon(Icons.menu, color: Colors.orange,),
            label: Text(""),
            style: ElevatedButton.styleFrom(padding: EdgeInsets.only(right: 0.0, left: 24.0)),
            ),
        ),
      ),
    );
  }

  void finalPeoples() {
    setState(() {
      foundUsers = allusers!;
    });
  }

  Future getallpeople(dynamic value1) async{
    String name = "";
    bool val = false;
    if(allusers != null){
      allusers!.forEach((k,v){
        name = v["name"];
        name = name.toLowerCase();
        if(!name.contains(value1)){
          toRemoveUsers[k] = {"name" : v["name"], "profilePic": v["profilePic"]};
        }
      });
      allusers!.removeWhere((dynamic k, dynamic v) => toRemoveUsers.containsKey(k));
    }
    finalPeoples();
  }

  Future requested(dynamic value1) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic requested = FitcaribReference.child("requested").child(prefs.get("userid") as String);
    requested.once().then((DataSnapshot snapshot) async{
      if(snapshot.value != null){
        Map<dynamic,dynamic> requestedMap= snapshot.value;
        if(requestedMap != null){
          allusers!.removeWhere((dynamic k, dynamic v) => requestedMap.containsKey(k));
        }
      }
      getallpeople(value1);
    });
  }

  Future requests(dynamic value1) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic requests = FitcaribReference.child("requests").child(prefs.get("userid") as String);
    requests.once().then((DataSnapshot snapshot) async{
      if(snapshot.value != null){
        Map<dynamic,dynamic> requestMap= snapshot.value;
        if(requestMap != null){
          allusers!.removeWhere((dynamic k, dynamic v) => requestMap.containsKey(k));
        }
      }
      requested(value1);
    });
  }

  Future friends(dynamic value1) async{

    SharedPreferences.getInstance().then((SharedPreferences sp){
      sharedPreferences = sp;
      if(sharedPreferences!.get("userid") != null){
        dynamic friendship = FitcaribReference.child("friendships").child(sharedPreferences!.get("userid") as String);
        friendship.once().then((DataSnapshot snapshot) async{
          if(snapshot.value != null){
            Map<dynamic,dynamic> friendsMap= snapshot.value;
            if(friendsMap != null){
              allusers!.removeWhere((dynamic k, dynamic v) => friendsMap.containsKey(k));
            }
          }
          requests(value1);
        });
      }

    });
  }

  // ignore: missing_return
  Future<void> getPeople(dynamic value1) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("user id is ${prefs.get("userid")}");
    if(foundUsers != null){
      foundUsers.clear();
    }
    if(allusers != null){
      allusers!.clear();
    }

    if(toRemoveUsers != null){
      toRemoveUsers.clear();
    }

    dynamic users = FitcaribReference.child("users");
    users.once().then((DataSnapshot snapshot) async{
      if(snapshot.value == null){
        print("in if");
      }
      else{
        print("in else");
        Map<dynamic, dynamic> usersMap = snapshot.value;
        if(usersMap == null){
          print("in child if");
        }
        else{
          print("in child else");
          allusers = usersMap;
          allusers!.remove(prefs.get("userid"));
          friends(value1);
        }
      }
    });
  }

  void sendToRequested(dynamic name,dynamic profilePic,dynamic id) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String,dynamic> data = <String,dynamic>{
      "name": name,
      "profilePic": profilePic,
    };

    Map<String,dynamic> data1 = <String,dynamic>{
      "name": prefs.get("name"),
      "profilePic": prefs.get("imageId"),
    };

    FitcaribReference.child("requested").child(prefs.get("userid") as String).child(id).set(data).whenComplete((){
      FitcaribReference.child("requests").child(id).child(prefs.get("userid") as String).set(data1).whenComplete((){
        setState(() {
          foundUsers.remove(id);
        });
      });
    });
  }
}