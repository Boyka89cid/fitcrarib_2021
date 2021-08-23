import 'package:fitcarib/ui/comments/comments.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:core';
import 'package:timeago/timeago.dart' as timeago;
import 'package:fitcarib/models/activity_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';

class MyActivityScreen extends StatefulWidget {
  MyActivityScreen({Key? key}) : super(key: key);

  @override
  MyActivityScreenState createState() => MyActivityScreenState();
}

class MyActivityScreenState extends State<MyActivityScreen> {

  List<ActivityModel> myPost = [];
  List<ActivityModel> myFavPost = [];
  List<dynamic> myPostData =[];
  List<dynamic> myFavData = [];
  Map<dynamic, dynamic> addDataToModel = Map();
  final ref = FirebaseDatabase.instance.reference();
  SharedPreferences? sharedPreferences;
  Map<dynamic, dynamic> myPosts = Map();
  int indexPage = 1;
  String? timeFooter;
  var gotData = false;

//  final _list = List();
//  // ignore: close_sinks
//  final _listController = StreamController<List>.broadcast();
//  Stream<List<Event>> get listStream => _listController.stream;

  @override
  void dispose() {
    super.dispose();
  }

//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//    SharedPreferences.getInstance().then((SharedPreferences sp) {
//      sharedPreferences = sp;
//      if (sharedPreferences.getString("userid") != null) {
//        dynamic activity = FirebaseDatabase.instance
//            .reference()
//            .child("posts")
//            .child(sharedPreferences.getString("userid")).limitToLast(5);
//        activity.once().then((DataSnapshot snapshot){
//          if(snapshot.value != null){
//            Map<dynamic, dynamic> temp;
//            temp = snapshot.value;
//
//            myPosts = Map.fromEntries(temp.entries.toList()
//              ..sort((e1, e2) => (e2.value["timestamp"])
//                  .compareTo(e1.value["timestamp"])));
//
////            _list.addAll(snapshot.value);
////            _listController.sink.add(_list);
//
////            print("list data"+_list.toString());
//
//            myPosts.forEach((k,v){
//              _list.add(v);
//            });
//            _listController.sink.add(_list);
//
//            _list.forEach((v){
//              print(v.toString());
//            });
//          }
//        });
//      }
//    });
//  }

//  @override
//  Widget build(BuildContext context) {
//    return Center(
//      child: CircularProgressIndicator(),
//    );
//  }

//  _fetchMore() {
//
//
//    dynamic activity = FirebaseDatabase.instance
//        .reference()
//        .child("posts")
//        .child(sharedPreferences.getString("userid")).limitToLast(5);
//
//    myPosts = Map.fromEntries(temp.entries.toList()
//      ..sort((e1, e2) => (e2.value["timestamp"])
//          .compareTo(e1.value["timestamp"])));
//
//    _list.addAll(snapList);
//    _listController.sink.add(_list);
//
//  }


  @override
  Widget build(BuildContext context)
  {
    var screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
        onWillPop: () => Future.value(false),
     child: myPost.length == 0 ? Center(child: Text("Searching And Fetching Your Personal Posts"),) :
      ListView.builder(
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      itemCount: myPost.length,
      itemBuilder: (context, index) {
        return Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                            fit: BoxFit.fill,
                            image:
                            new NetworkImage(myPost[index].userPic)))),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "${myPost[index].userName}",
                        style: TextStyle(
                            color: Colors.black87, fontSize: 17.0),
                      ),
                      getTime(myPost[index].timestamp)
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    ownFavorites(index, myPost[index].isFavorite);
                  },
                  child: myPost[index].isFavorite == false
                      ? Tab(
                      icon: new Image.asset(
                        "assets/images/favoritesFalse.png",
                        width: 25.0,
                        height: 25.0,
                      ))
                      : Tab(
                      icon: new Image.asset(
                        "assets/images/favoritesTrue.png",
                        width: 25.0,
                        height: 25.0,
                      )),
                ),
              ],
            ),
            myPost[index].imageUrl == "none"
                ? Text("")
                : Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Container(
                  width: screenWidth,
                  height: 200.0,
                  decoration: new BoxDecoration(
                      shape: BoxShape.rectangle,
                      image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: new NetworkImage(
                              myPost[index].imageUrl)))),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "${myPost[index].message}",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  InkWell(
                    child: myPost[index].isLiked == true
                        ? Tab(
                        icon: new Image.asset(
                          "assets/images/likeTrue.png",
                          width: 25.0,
                          height: 25.0,
                        ))
                        : Tab(
                        icon: new Image.asset(
                          "assets/images/likeFalse.png",
                          width: 25.0,
                          height: 25.0,
                        )),
                    onTap: () {
                      ownLikes(index, myPost[index].isLiked);
//                          ownLikes(myPosts.keys.elementAt(index), 1);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: GestureDetector(
                      onTap: () {
                        toComment(myPost[index].postId,myPost[index].userId);
                      },
                      child: Tab(
                          icon: new Image.asset(
                            "assets/images/comment.png",
                            width: 25.0,
                            height: 25.0,
                          )),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => CupertinoAlertDialog(
                            title: new Column(
                              children: <Widget>[
                                new Text("Delete this Post?"),
                              ],
                            ),
                            actions: <Widget>[
                              FlatButton(
                                  onPressed: () {
                                    deletePost(
                                        myPost[index].postId, index);
                                  },
                                  child: new Text("Yes")),
                              FlatButton(
                                  onPressed: () => cancelDeletePost(
                                      myPost[index].postId),
                                  child: new Text("No")),
                            ],
                          ),
                        );
//                            deletePost(myPosts.keys.elementAt(index));
                      },
                      child: Tab(
                          icon: new Image.asset(
                            "assets/images/delete.png",
                            width: 25.0,
                            height: 23.0,
                          )),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.grey,
            ),
          ],
        );
      },
      ),
    );
  }



  Widget getTime(var time) {
    var receivedDatetime = DateTime.fromMillisecondsSinceEpoch(time);
    var currentDatetime = DateTime.now();
    var difference = currentDatetime.difference(receivedDatetime).inMinutes;
    var ago = currentDatetime.subtract(Duration(minutes: difference));
    timeFooter = timeago.format(ago);
    return Text(
      "$timeFooter",
      style: TextStyle(color: Colors.grey, fontSize: 10.0),
    );
  }

    @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedPreferences = sp;
      if (sharedPreferences!.getString("userid") != null) {
        dynamic activity = FirebaseDatabase.instance
            .reference()
            .child("posts")
            .child(sharedPreferences!.getString("userid") as String);
        activity.once().then((DataSnapshot snapshot) {
          if (snapshot.value != null) {
            Map<dynamic, dynamic> temp;
            temp = snapshot.value;
            if (temp != null) {
              setState(() {
                myPosts = Map.fromEntries(temp.entries.toList()
                  ..sort((e1, e2) => (e2.value["timestamp"])
                      .compareTo(e1.value["timestamp"])));
              });

              addDataFunction(myPosts, sharedPreferences!.getString("userid"))
                  .then((_) {
                setState(() {
                  myPost = myPostData
                      .map<ActivityModel>((i) => ActivityModel.fromJson(i))
                      .toList();
                });
              });
            }
          }
        });
      }
    });
  }

  void ownFavorites(var index, var value) {
    myPost[index].setFavoriteValue();
    setState(() {});

    if (value) {
      FirebaseDatabase.instance
          .reference()
          .child("favorites")
          .child(sharedPreferences!.getString("userid") as String)
          .child(myPost[index].postId)
          .remove();
    } else {
      Map<String, dynamic> setFavorite = <String, dynamic>{
        "value": true,
      };
      FirebaseDatabase.instance
          .reference()
          .child("favorites")
          .child(sharedPreferences!.getString("userid") as String)
          .child(myPost[index].postId)
          .set(setFavorite);
    }
  }

  void ownLikes(var index, var value) {
    myPost[index].setLikedValue();
    setState(() {});
    if (value == true) {
      FirebaseDatabase.instance
          .reference()
          .child("likes")
          .child(myPost[index].postId)
          .child(sharedPreferences!.getString("userid") as String)
          .remove();
    } else {
      Map<String, dynamic> setLike = <String, dynamic>{
        "value": true,
      };
      FirebaseDatabase.instance
          .reference()
          .child("likes")
          .child(myPost[index].postId)
          .child(sharedPreferences!.getString("userid") as String)
          .set(setLike);
    }
  }

  void deletePost(var postId, var index) {
    myPost.removeAt(index);
    Navigator.of(context).pop();
    setState(() {
      gotData = true;
    });
    ref.child("likes").child(postId).remove();
    ref.child("favorites").once().then((DataSnapshot snapshot) {
      snapshot.value.forEach((k, v) {
        if (v.containsKey(postId)) {
          ref.child("favorites").child(k).child(postId).remove();
        }
      });
    });
    ref.child("posts")
        .child(sharedPreferences!.getString("userid") as String)
        .child(postId)
        .remove();
  }

  Future cancelDeletePost(var postId) async {
    Navigator.of(context).pop();
  }

  void toComment(var postId, var postUserId) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CommentsScreen(postId: postId,postUserId: postUserId,)),
    );

  }



  Future addDataFunction(var allData, var userId) async {
    for (dynamic mp1 in allData.entries) {
      MapEntry<dynamic, dynamic> localMp = mp1;
      var postId;
      var userPic;
      var userName;
      var message;
      var isLiked;
      var imageUrl;
      var isFavorite;
      var likesCount;
      var timestamp;

      postId = localMp.key;

      dynamic likesData =
      FirebaseDatabase.instance.reference().child("likes").child(postId);
      await likesData.once().then((DataSnapshot snapshot) {
        if (snapshot.value == null) {
          isLiked = false;
          likesCount = 0;
        } else {
          Map<dynamic, dynamic> data = snapshot.value;
          if (data[userId] != null) {
            isLiked = true;
          } else {
            isLiked = false;
          }
          likesCount = data.length;
        }
      });

      dynamic favoritesData = FirebaseDatabase.instance
          .reference()
          .child("favorites")
          .child(userId)
          .child(postId);
      await favoritesData.once().then((DataSnapshot snapshot) {
        if (snapshot.value == null) {
          isFavorite = false;
        } else {
          isFavorite = true;
        }
      });

      if (localMp.value["imageUrl"] != null) {
        imageUrl = localMp.value["imageUrl"];
      } else {
        imageUrl = "none";
      }

      userPic = sharedPreferences!.getString("imageId");
      message = localMp.value["message"];
      userName = sharedPreferences!.getString("name");
      timestamp = localMp.value["timestamp"];

      myPostData.add({
        "userId": userId,
        "postId": postId,
        "userPic": userPic,
        "message": message,
        "isFavorite": isFavorite,
        "userName": userName,
        "timestamp": timestamp,
        "imageUrl": imageUrl,
        "likesCount": likesCount,
        "isLiked": isLiked
      });
    }
  }



}