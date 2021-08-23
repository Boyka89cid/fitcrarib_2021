import 'package:fitcarib/ui/comments/comments.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'dart:async';
import 'package:timeago/timeago.dart' as timeago;
import 'package:fitcarib/models/activity_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';

class FriendsActivityScreen extends StatefulWidget {
  FriendsActivityScreen({Key? key}) : super(key: key);

  @override
  FriendsActivityScreenState createState() => FriendsActivityScreenState();
}

class FriendsActivityScreenState extends State<FriendsActivityScreen>
{
  final GlobalKey<ScaffoldState> _scaffoldKeyFriendsActivityScreen =  GlobalKey<ScaffoldState>();
  List<ActivityModel> myFriendPost = [];
  List<dynamic> myFriendData = [];
  final ref = FirebaseDatabase.instance.reference();
  SharedPreferences? sharedPreferences;
  String? timeFooter;

  @override
  void dispose(){super.dispose();}

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedPreferences = sp;
      if (sharedPreferences!.getString("userid") != null) {
        dynamic friends = FirebaseDatabase.instance
            .reference()
            .child("friendships")
            .child(sharedPreferences!.getString("userid") as String);
        friends.once().then((DataSnapshot snapshot) {
          if (snapshot.value != null) {
            addFriendDataFunction(
                    snapshot.value, sharedPreferences!.getString("userid") as String)
                .then((_) {
              myFriendData.sort(
                      (e1, e2) => (e2["timestamp"])
                      .compareTo(e1["timestamp"])
              );
              setState(() {
                myFriendPost = myFriendData
                    .map<ActivityModel>((i) => ActivityModel.fromJson(i))
                    .toList();
              });
            });
          }
        });
      }
    });
  }
  @override
  Widget build(BuildContext context)
  {
    var screenWidth = MediaQuery.of(context).size.width;
    return myFriendPost.length == 0
        ? Center(
            child: Text("Searching And Fetching Your Friends Posts"),
          )
        : ListView.builder(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            itemCount: myFriendPost.length,
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
                                  image: new NetworkImage(
                                      myFriendPost[index].userPic)))),
                      Padding(
                        padding: EdgeInsets.only(left: 10.0),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "${myFriendPost[index].userName}",
                              style: TextStyle(
                                  color: Colors.black87, fontSize: 17.0),
                            ),
                            getTime(myFriendPost[index].timestamp)
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          ownFavorites(index, myFriendPost[index].isFavorite);
                        },
                        child: myFriendPost[index].isFavorite == false
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
                  myFriendPost[index].imageUrl == "none"
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
                                          myFriendPost[index].imageUrl)))),
                        ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "${myFriendPost[index].message}",
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                          child: myFriendPost[index].isLiked == true
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
                            ownLikes(index, myFriendPost[index].isLiked);
//                          ownLikes(myFavPosts.keys.elementAt(index), 1);
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 15.0),
                          child: GestureDetector(
                            onTap: () {
                              toComment(myFriendPost[index].postId,myFriendPost[index].userId);
                            },
                            child: Tab(
                                icon: new Image.asset(
                              "assets/images/comment.png",
                              width: 25.0,
                              height: 25.0,
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

  void ownFavorites(var index, var value) {
    myFriendPost[index].setFavoriteValue();
    setState(() {});

    if (value) {
      FirebaseDatabase.instance
          .reference()
          .child("favorites")
          .child(sharedPreferences!.get("userid") as String)
          .child(myFriendPost[index].postId)
          .remove();
    } else {
      Map<String, dynamic> setFavorite = <String, dynamic>{
        "value": true,
      };
      FirebaseDatabase.instance
          .reference()
          .child("favorites")
          .child(sharedPreferences!.get("userid") as String)
          .child(myFriendPost[index].postId)
          .set(setFavorite);
    }
  }

  void ownLikes(var index, var value) {
    myFriendPost[index].setLikedValue();
    setState(() {});
    if (value == true) {
      FirebaseDatabase.instance
          .reference()
          .child("likes")
          .child(myFriendPost[index].postId)
          .child(sharedPreferences!.get("userid") as String)
          .remove();
    } else {
      Map<String, dynamic> setLike = <String, dynamic>{
        "value": true,
      };
      FirebaseDatabase.instance
          .reference()
          .child("likes")
          .child(myFriendPost[index].postId)
          .child(sharedPreferences!.get("userid") as String)
          .set(setLike);
    }
  }


  Future cancelDeletePost(var postId) async {
    Navigator.of(context).pop();
  }

  Future addFriendDataFunction(var favData, var loggedInUserId) async {
    for (dynamic mp in favData.entries) {
      var userId;
      var postId;
      var userPic;
      var userName;
      var message;
      var isLiked;
      var imageUrl;
      var isFavorite;
      var likesCount;
      var timestamp;

      MapEntry<dynamic, dynamic> localMp = mp;

      await ref
          .child("posts")
          .child(localMp.key)
          .once()
          .then((DataSnapshot snapshot) async {
        if (snapshot.value != null) {
          userId = localMp.key;
          userName = localMp.value["name"];
          userPic = localMp.value["profilePic"];
          for (MapEntry<dynamic, dynamic> posts in snapshot.value.entries) {
            print(posts.toString());
            postId = posts.key;
            imageUrl = posts.value["imageUrl"] == null ? "none" : posts.value["imageUrl"];
            message = posts.value["message"];
            timestamp = posts.value["timestamp"];

            await ref
                .child("favorites")
                .child(loggedInUserId)
                .child(postId)
                .once()
                .then((DataSnapshot snap) async {
              if (snap.value == null) {
                isFavorite = false;
              } else {
                isFavorite = true;
              }
            });

            await ref
                .child("likes")
                .child(postId)
                .child(loggedInUserId)
                .once()
                .then((DataSnapshot snap) async {
              if (snap.value == null) {
                isLiked = false;
                likesCount = 0;
              } else {
                isLiked = true;
                await ref
                    .child("likes")
                    .child(postId)
                    .once()
                    .then((DataSnapshot like) {
                  likesCount = like.value.length;
                });
              }
            });
            myFriendData.add({
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
      });
    }
  }

  void toComment(var postId, var postUserId) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CommentsScreen(postId: postId,postUserId: postUserId,)),
    );

  }
}
