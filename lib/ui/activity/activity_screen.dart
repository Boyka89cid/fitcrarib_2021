import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fitcarib/base/ui/base_screen.dart';
import 'package:fitcarib/ui/activity/activity_presenter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:fitcarib/models/activity_model.dart';
import 'package:flutter/cupertino.dart';

class ActivitySecondScreen extends BaseScreen {
  ActivitySecondScreen(String title, listener) : super(title, listener);

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

const List<String> tabNames = const <String>[
  'Friends',
  'Personal',
  'Mentions',
  'Favorites',
  'Groups',
];

class _ActivityScreenState
    extends BaseScreenState<ActivitySecondScreen, ActivityPresenter>
    implements ActivityContract
{
  final GlobalKey<ScaffoldState> _scaffoldKeyActivitySecondScreen = new GlobalKey<ScaffoldState>();
  List<ActivityModel> myPost = [];
  List<ActivityModel> myFavPost = [];
  List<dynamic> myPostData = [];
  List<dynamic> myFavData = [];
  Map<dynamic, dynamic> addDataToModel = Map();
  final ref = FirebaseDatabase.instance.reference();

  int indexPage = 1;
  Map<dynamic, dynamic> myPosts = Map();
  Map<dynamic, dynamic>? postLikes;
  String? timeFooter;

  @override
  Widget build(BuildContext context)
  {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKeyActivitySecondScreen,
        drawer: getDrawerLayout(screenWidth, screenHeight),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            "Activity",
            style: TextStyle(color: Colors.orange),
          ),
          leading: FlatButton.icon(
            onPressed: () => _scaffoldKeyActivitySecondScreen.currentState!.openDrawer(),
            icon: Icon(
              Icons.menu,
              color: Colors.orange,
            ),
            label: Text(""),
            padding: EdgeInsets.only(right: 0.0, left: 24.0),
          ),
          actions: <Widget>[
            FlatButton.icon(
              onPressed: null,
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
        floatingActionButton: getFloatingActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: getBottomNavigation(0),
      ),
    );
  }

  @override
  ActivityPresenter createPresenter() {
    return ActivityPresenter(this);
  }

  Widget builtItem(int index)
  {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    if (index == 0) {
      return Center(
        child: Text("friends"),
      );
    }
    else if (index == 2) {
      return Center(
        child: Text("Mentions"),
      );
    } else if (index == 3) {
      if (myFavPost == null) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else {
        return ListView.builder(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            itemCount: myFavPost.length,
            reverse: true,
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
                              style: TextStyle(
                                  color: Colors.black87, fontSize: 17.0),
                            ),
                            getTime(myFavPost[index].timestamp)
                          ],
                        ),
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
//                          ownLikes(myPosts.keys.elementAt(index), 1);
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 15.0),
                          child: GestureDetector(
                            onTap: () {
                              createOwnCommentMap(myFavPost[index].postId);
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
            }
        );
      }
    }
    else if (index == 4) {
      return Center(
        child: Text("groups"),
      );
    }
    else {
      if (myPost == null)
      {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      else
        {
        return ListView.builder(
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
                            "Kusss ${myPost[index].userName}",
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
                    ? Text("WHY?")
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
                            createOwnCommentMap(myPost[index].postId);
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
                                            deletePost(myPost[index].postId);
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
        );
      }
    }
  }

  @override
  Widget buildBody(BuildContext context) {
    return Container();
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

  void deletePost(var postId) {
    ref.child("likes").child(postId).remove();
    ref.child("favorites").once().then((DataSnapshot snapshot) {
      snapshot.value.forEach((k, v) {
        if (v.containsKey(postId)) {
          ref.child("favorites").child(k).child(postId).remove();
        }
      });
    });
    ref
        .child("posts")
        .child(sharedPreferences!.getString("userid") as String)
        .child(postId)
        .remove()
        .whenComplete(() {
      //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ActivityScreen()));
      // widget.listener
      //     .getRouter()
      //     .navigateTo(context, '/activity', clearStack: true);
    });
  }

  Future cancelDeletePost(var postId) async {
    Navigator.of(context).pop();
  }

  @override
  void toWelcome() {
    //Navigator.of(context).push(MaterialPageRoute(builder: (context) => WelcomeScreen()));
    //widget.listener.getRouter().navigateTo(context, '/welcome');
  }

  // ignore: missing_return
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

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedPreferences = sp;
      if (sharedPreferences!.getString("userid") != null) {
        dynamic favorites = FirebaseDatabase.instance
            .reference()
            .child("favorites")
            .child(sharedPreferences!.getString("userid") as String);
        favorites.once().then((DataSnapshot snapshot) {
          if (snapshot.value != null) {
            addFavDataFunction(
                    snapshot.value, sharedPreferences!.getString("userid"))
                .then((_) {
//              print("gotvalues"+myFavData.toString());
              setState(() {
                myFavPost = myFavData
                    .map<ActivityModel>((i) => ActivityModel.fromJson(i))
                    .toList();
              });
            });
          }
        });

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

  Future addFavDataFunction(var favData, var userId) async {
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
//        print(localMp.key.toString());

      await ref.child("posts").once().then((DataSnapshot snapshot) async {
        for (MapEntry<dynamic, dynamic> mp1 in snapshot.value.entries) {
          userId = mp1.key;
//            if(mp1.value.containsKey(localMp.key)){
//              print(mp1.value.toString());
//            }
          if (mp1.value.containsKey(localMp.key)) {
//              userId = mp1;
            await ref
                .child("users")
                .child(userId)
                .once()
                .then((DataSnapshot snap) {
              userPic = snap.value["profilePic"];
              userName = snap.value["name"];
            });
            await ref
                .child("posts")
                .child(userId)
                .child(localMp.key)
                .once()
                .then((DataSnapshot snap) {
              postId = snap.key;
//                print("snapshot" + snap.value.toString());
              message = snap.value["message"];
              timestamp = snap.value["timestamp"];
              imageUrl = snap.value["imageUrl"] != null
                  ? snap.value["imageUrl"]
                  : "none";
            });

            await ref
                .child("likes")
                .child(postId)
                .child(userId)
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
//                    print("likescount"+likesCount.toString());
                });
              }
            });
          }
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

//          snapshot.value.forEach((k, v) {
//            if (v.containsKey(localMp.key)) {
//              userId = k;
//               ref.child("users").child(userId).once().then((DataSnapshot snap){
//                userPic = snap.value["profilePic"];
//                userName = snap.value["name"];
//              });
//              ref.child("posts").child(k).child(localMp.key).once().then((DataSnapshot snap){
//                postId = snap.key;
////                print("snapshot" + snap.value.toString());
//                message = snap.value["message"];
//                timestamp = snap.value["timestamp"];
//                imageUrl = snap.value["imageUrl"] != null ? snap.value["imageUrl"] : "none";
//              });
//
//               ref.child("likes").child(postId).child(userId).once().then((DataSnapshot snap){
//                if(snap.value == null){
//                  isLiked = false;
//                  likesCount = 0;
//                }
//                else{
//                  isLiked = true;
//                  ref.child("likes").child(postId).once().then((DataSnapshot like){
//                    likesCount =  like.value.length;
////                    print("likescount"+likesCount.toString());
//                  });
//                }
//              });
//            }
//
//            myFavData.add({
//              "userId": userId,
//              "postId": postId,
//              "userPic": userPic,
//              "message": message,
//              "isFavorite": isFavorite,
//              "userName": userName,
//              "timestamp": timestamp,
//              "imageUrl": imageUrl,
//              "likesCount": likesCount,
//              "isLiked": isLiked
//            });
//          });
      });
    }
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

  void createOwnCommentMap(var postId) {
    Map<String, dynamic> commentMap = <String, dynamic>{
      "postId": postId,
    };
    //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => WelcomeScreen()));
    // widget.listener
    //     .getRouter()
    //     .navigateTo(context, '/comments/${jsonEncode(commentMap)}');
  }
}
