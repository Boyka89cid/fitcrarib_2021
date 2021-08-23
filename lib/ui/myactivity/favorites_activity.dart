import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:collection';
import 'dart:async';
import 'package:timeago/timeago.dart' as timeago;
import 'package:fitcarib/models/activity_model.dart';
import 'package:fitcarib/ui/comments/comments.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';

class FavoritesActivityScreen extends StatefulWidget {
  FavoritesActivityScreen({Key? key}) : super(key: key);

  @override
  FavoritesActivityScreenState createState() => FavoritesActivityScreenState();
}

class FavoritesActivityScreenState extends State<FavoritesActivityScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKeyFavoritesActivityScreen = new GlobalKey<ScaffoldState>();
  List<ActivityModel> myFavPost = [];
  List<dynamic> myFavData = [];
  final ref = FirebaseDatabase.instance.reference();
  late SharedPreferences sharedPreferences;
  String? timeFooter;
  var gotDataFinal = true;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences sp)
    {
      sharedPreferences = sp;
      if (sharedPreferences.getString("userid") != null) {
        dynamic favorites = FirebaseDatabase.instance
            .reference()
            .child("favorites")
            .child(sharedPreferences.getString("userid") as String);
        favorites.once().then((DataSnapshot snapshot) {
          if (snapshot.value != null) {
            addFavDataFunction(
                    snapshot.value, sharedPreferences.getString("userid"))
                .then((_) {
              myFavData.sort(
                  (e1, e2) => (e2["timestamp"]).compareTo(e1["timestamp"]));
              setState(() {
                myFavPost = myFavData
                    .map<ActivityModel>((i) => ActivityModel.fromJson(i))
                    .toList();
              });
              if (myFavPost.length == 0) {
                setVal();
              }
            });
          }
        });
      }
    });
  }

  Widget gotNoData() {
    return Center(
      child: Text("No Favorite Posts"),
    );
  }

  Widget loadingData() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    if (myFavPost.length == 0) {
      if (gotDataFinal == false) {
        return Center(
          child: Text("No Favorite Posts"),
        );
      } else {
        return Center(
          child: Text("Searching And Fetching Your Favorite Posts"),
        );
//        return Center(child: CircularProgressIndicator(),);
      }
    } else {
      return ListView.builder(
        padding: EdgeInsets.only(left: 10.0, right: 10.0),
        itemCount: myFavPost.length,
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
                                  new NetworkImage(myFavPost[index].userPic)))),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "${myFavPost[index].userName}",
                          style:
                              TextStyle(color: Colors.black87, fontSize: 17.0),
                        ),
                        getTime(myFavPost[index].timestamp)
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      ownFavorites(index);
                    },
                    child: myFavPost[index].isFavorite == false
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
              myFavPost[index].imageUrl == "none"
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
                                      myFavPost[index].imageUrl)))),
                    ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "${myFavPost[index].message}",
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    InkWell(
                      child: myFavPost[index].isLiked == true
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
                        ownLikes(index, myFavPost[index].isLiked);
//                          ownLikes(myFavPosts.keys.elementAt(index), 1);
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15.0),
                      child: InkWell(
                        onTap: (){
                          toComment(myFavPost[index].postId,myFavPost[index].userId);
                        },
                        child: Tab(
                          icon: Image.asset(
                            "assets/images/comment.png",
                            width: 25.0,
                            height: 25.0,
                          ),
                        ),
                      ),

//                      child: GestureDetector(
//                        onTap: () {
//                          toComment(myFavPost[index].postId,myFavPost[index].userId);
//                        },
//                        child: Tab(
//                            icon: new Image.asset(
//                          "assets/images/comment.png",
//                          width: 25.0,
//                          height: 25.0,
//                        )),
//                      ),
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
//    return myFavPost.length == 0 ? Center(child: CircularProgressIndicator(),) : gotData == true ? Center(child: Text("No Favorite Posts"),) :
//    ListView.builder(
//      padding: EdgeInsets.only(left: 10.0, right: 10.0),
//      itemCount: myFavPost.length,
//      itemBuilder: (context, index) {
//        return Column(
//          children: <Widget>[
//            Row(
//              children: <Widget>[
//                Container(
//                    width: 50.0,
//                    height: 50.0,
//                    decoration: new BoxDecoration(
//                        shape: BoxShape.circle,
//                        image: new DecorationImage(
//                            fit: BoxFit.fill,
//                            image:
//                            new NetworkImage(myFavPost[index].userPic)))),
//                Padding(
//                  padding: EdgeInsets.only(left: 10.0),
//                ),
//                Expanded(
//                  child: Column(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    children: <Widget>[
//                      Text(
//                        "${myFavPost[index].userName}",
//                        style: TextStyle(
//                            color: Colors.black87, fontSize: 17.0),
//                      ),
//                      getTime(myFavPost[index].timestamp)
//                    ],
//                  ),
//                ),
//                GestureDetector(
//                  onTap: () {
//                    ownFavorites(index);
//                  },
//                  child: myFavPost[index].isFavorite == false
//                      ? Tab(
//                      icon: new Image.asset(
//                        "assets/images/favoritesFalse.png",
//                        width: 25.0,
//                        height: 25.0,
//                      ))
//                      : Tab(
//                      icon: new Image.asset(
//                        "assets/images/favoritesTrue.png",
//                        width: 25.0,
//                        height: 25.0,
//                      )),
//                ),
//              ],
//            ),
//            myFavPost[index].imageUrl == "none"
//                ? Text("")
//                : Padding(
//              padding: EdgeInsets.only(top: 10.0),
//              child: Container(
//                  width: screenWidth,
//                  height: 200.0,
//                  decoration: new BoxDecoration(
//                      shape: BoxShape.rectangle,
//                      image: new DecorationImage(
//                          fit: BoxFit.fill,
//                          image: new NetworkImage(
//                              myFavPost[index].imageUrl)))),
//            ),
//            Align(
//              alignment: Alignment.centerLeft,
//              child: Text(
//                "${myFavPost[index].message}",
//                style: TextStyle(fontSize: 18.0),
//              ),
//            ),
//            Padding(
//              padding: EdgeInsets.only(top: 10.0),
//              child: Row(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: <Widget>[
//                  InkWell(
//                    child: myFavPost[index].isLiked == true
//                        ? Tab(
//                        icon: new Image.asset(
//                          "assets/images/likeTrue.png",
//                          width: 25.0,
//                          height: 25.0,
//                        ))
//                        : Tab(
//                        icon: new Image.asset(
//                          "assets/images/likeFalse.png",
//                          width: 25.0,
//                          height: 25.0,
//                        )),
//                    onTap: () {
//                      ownLikes(index, myFavPost[index].isLiked);
////                          ownLikes(myFavPosts.keys.elementAt(index), 1);
//                    },
//                  ),
//                  Padding(
//                    padding: EdgeInsets.only(left: 15.0),
//                    child: GestureDetector(
//                      onTap: () {
//                        createOwnCommentMap(myFavPost[index].postId);
//                      },
//                      child: Tab(
//                          icon: new Image.asset(
//                            "assets/images/comment.png",
//                            width: 25.0,
//                            height: 25.0,
//                          )),
//                    ),
//                  ),
////                  Padding(
////                    padding: EdgeInsets.only(left: 15.0),
////                    child: GestureDetector(
////                      onTap: () {
////                        showDialog(
////                          context: context,
////                          builder: (_) => CupertinoAlertDialog(
////                            title: new Column(
////                              children: <Widget>[
////                                new Text("Delete this Post?"),
////                              ],
////                            ),
////                            actions: <Widget>[
////                              FlatButton(
////                                  onPressed: () {
////                                    deletePost(myFavPost[index].postId);
////                                  },
////                                  child: new Text("Yes")),
////                              FlatButton(
////                                  onPressed: () => cancelDeletePost(
////                                      myFavPost[index].postId),
////                                  child: new Text("No")),
////                            ],
////                          ),
////                        );
//////                            deletePost(myFavPosts.keys.elementAt(index));
////                      },
////                      child: Tab(
////                          icon: new Image.asset(
////                            "assets/images/delete.png",
////                            width: 25.0,
////                            height: 23.0,
////                          )),
////                    ),
////                  ),
//                ],
//              ),
//            ),
//            Divider(
//              color: Colors.grey,
//            ),
//          ],
//        );
//      },
//    );
  }

  setVal() {
    setState(() {
      gotDataFinal = false;
    });
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

  Future ownFavorites(var index) async {
    await FirebaseDatabase.instance
        .reference()
        .child("favorites")
        .child(sharedPreferences.getString("userid") as String)
        .child(myFavPost[index].postId)
        .remove();

    myFavPost.removeAt(index);
    setState(() {
      gotDataFinal = false;
    });
  }

  void ownLikes(var index, var value) {
    myFavPost[index].setLikedValue();
    setState(() {});
    if (value == true) {
      FirebaseDatabase.instance
          .reference()
          .child("likes")
          .child(myFavPost[index].postId)
          .child(sharedPreferences.getString("userid") as String)
          .remove();
    } else {
      Map<String, dynamic> setLike = <String, dynamic>{
        "value": true,
      };
      FirebaseDatabase.instance
          .reference()
          .child("likes")
          .child(myFavPost[index].postId)
          .child(sharedPreferences.getString("userid") as String)
          .set(setLike);
    }
  }

  Future cancelDeletePost(var postId) async {
    Navigator.of(context).pop();
  }

  Future addFavDataFunction(var favData, var loggedInUser) async {
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

      isFavorite = true;

      MapEntry<dynamic, dynamic> localMp = mp;

      await ref.child("posts").once().then((DataSnapshot snapshot) async {
        for (MapEntry<dynamic, dynamic> posts in snapshot.value.entries) {
          if (posts.value.containsKey(localMp.key)) {
            userId = posts.key;
            postId = localMp.key;
            imageUrl = posts.value[localMp.key]["imageUrl"] == null
                ? "none"
                : posts.value[localMp.key]["imageUrl"];
            message = posts.value[localMp.key]["message"];
            timestamp = posts.value[localMp.key]["timestamp"];

            await ref
                .child("users")
                .child(userId)
                .once()
                .then((DataSnapshot snap) {
              userPic = snap.value["profilePic"];
              userName = snap.value["name"];
            });

            await ref
                .child("likes")
                .child(postId)
                .child(loggedInUser)
                .once()
                .then((DataSnapshot snap) async {
              if (snap.value == null) {
                isLiked = false;
                likesCount = 0;
              }
              else {
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
            myFavData.add({
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

  @override
  void dispose(){
    super.dispose();
  }

  void toComment(var postId, var postUserId) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CommentsScreen(postId: postId,postUserId: postUserId,)),
    );

  }
}
