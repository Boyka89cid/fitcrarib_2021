import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fitcarib/base/ui/base_screen.dart';
import 'package:fitcarib/ui/activity/favoritesactivity/favoritesactivity_presenter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:fitcarib/models/activity_model.dart';
import 'package:flutter/cupertino.dart';

class FavoritesActivityScreen extends BaseScreen {
  FavoritesActivityScreen(String title, listener) : super(title, listener);

  @override
  _FavoritesActivityScreenState createState() => _FavoritesActivityScreenState();
}

class _FavoritesActivityScreenState
    extends BaseScreenState<FavoritesActivityScreen, FavoritesActivityPresenter>
    implements FavoritesActivityContract {
  final GlobalKey<ScaffoldState> _scaffoldKeyFavoritesActivityScreen = new GlobalKey<ScaffoldState>();
  Map<dynamic, dynamic> myPosts = Map();
  List<ActivityModel> myPost = [];
  List<dynamic> myPostData = List<dynamic>.filled(10,dynamic,growable: true );

  @override
  Widget build(BuildContext context)
  {
    return Center(
      child: Text("Favorites"),
    );
  }

  @override
  Widget buildBody(BuildContext context)
  {
    // TODO: implement buildBody
    return Container();
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences sp)
    {
      sharedPreferences = sp;
      if (sharedPreferences!.getString("userid") != null) {
        dynamic favorites = FirebaseDatabase.instance
            .reference()
            .child("favorites")
            .child(sharedPreferences!.getString("userid") as String);
        favorites.once().then((DataSnapshot snapshot) {
          if (snapshot.value != null)
          {
            Map<dynamic, dynamic> temp = snapshot.value;
//            temp = snapshot.value;
            if (temp != null) {
              for (dynamic mp in temp.entries)
              {
                print(mp.toString());
              }
//              setState(() {
//                myPosts = Map.fromEntries(temp.entries.toList()
//                  ..sort((e1, e2) => (e2.value["timestamp"])
//                      .compareTo(e1.value["timestamp"])));
//              });
//
//              addDataFunction(myPosts, sharedPreferences.getString("userid"))
//                  .then((_) {
//                setState(() {
//                  myPost = myPostData
//                      .map<ActivityModel>((i) => ActivityModel.fromJson(i))
//                      .toList();
//                });
//              });
            }
          }
        });
      }
    });
  }

  @override
  createPresenter() {
    // TODO: implement createPresenter
    return FavoritesActivityPresenter(this);
  }

//  Future addDataFunction(var allData, var userId) async {
//    Map<dynamic, dynamic> mp = allData;
//
//    for (dynamic mp1 in mp.entries) {
//      MapEntry<dynamic, dynamic> localMp = mp1;
//      var postId;
//      var userPic;
//      var userName;
//      var message;
//      var isLiked;
//      var imageUrl;
//      var isFavorite;
//      var likesCount;
//      var timestamp;
//
//      postId = localMp.key;
//
//      dynamic likesData =
//      FirebaseDatabase.instance.reference().child("likes").child(postId);
//      await likesData.once().then((DataSnapshot snapshot) {
//        if (snapshot.value == null) {
//          isLiked = false;
//          likesCount = 0;
//        } else {
//          Map<dynamic, dynamic> data = snapshot.value;
//          if (data[userId] != null) {
//            isLiked = true;
//          } else {
//            isLiked = false;
//          }
//          likesCount = data.length;
//        }
//      });
//
//      dynamic favoritesData = FirebaseDatabase.instance
//          .reference()
//          .child("favorites")
//          .child(userId)
//          .child(postId);
//      await favoritesData.once().then((DataSnapshot snapshot) {
//        if (snapshot.value == null) {
//          isFavorite = false;
//        } else {
//          isFavorite = true;
//        }
//      });
//
//      if (localMp.value["imageUrl"] != null) {
//        imageUrl = localMp.value["imageUrl"];
//      } else {
//        imageUrl = "none";
//      }
//
//      userPic = sharedPreferences.getString("imageId");
//      message = localMp.value["message"];
//      userName = sharedPreferences.getString("name");
//      timestamp = localMp.value["timestamp"];
//
//      myPostData.add({
//        "userId": userId,
//        "postId": postId,
//        "userPic": userPic,
//        "message": message,
//        "isFavorite": isFavorite,
//        "userName": userName,
//        "timestamp": timestamp,
//        "imageUrl": imageUrl,
//        "likesCount": likesCount,
//        "isLiked": isLiked
//      });
//    }
//  }

  @override
  void toWelcome() {
    // TODO: implement toWelcome
  }
}