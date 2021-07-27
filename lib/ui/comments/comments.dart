import 'dart:async';
import 'package:fitcarib/models/comment_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';

class CommentsScreen extends StatefulWidget{

  final postId;
  final postUserId;

  CommentsScreen({Key? key, this.postId, this.postUserId})
      : super(
    key: key,
  );

  @override
  CommentsScreenState createState() => CommentsScreenState(postId,postUserId);
}

class CommentsScreenState extends State<CommentsScreen> {
  var postId;
  var postUserId;
//  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _messageController = TextEditingController();
  Map<dynamic, dynamic>? listMessage;
  SharedPreferences? sharedPreferences;
  PostComments postComments = new PostComments();
  Map<dynamic, dynamic>? newMap;
  var timeStamp;
  CommentsScreenState(this.postId,this.postUserId);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: WillPopScope(
            child: Stack(
              children: <Widget>[
                buildComments(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(right: 0.0, left: 0.0),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                      width: double.infinity,
                      height: 50.0,
                      decoration: BoxDecoration(
                          border: Border(
                              top: new BorderSide(
                                  color: Colors.grey, width: 0.5))),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              controller: _messageController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Write your comment",
                              ),
                            ),
                          ),
                          Material(
                            shape: CircleBorder(),
                            child: Ink.image(
                              image: AssetImage('assets/images/send.png'),
                              fit: BoxFit.cover,
                              width: 35.0,
                              height: 35.0,
                              child: InkWell(
                                onTap: () {
                                  sendComment(_messageController.text);

//                                  sendMessage(_messageController.text, haveID, conversationId);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            onWillPop: onBackPress),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            "Comments",
            style: TextStyle(color: Colors.orange),
          ),
          leading: FlatButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.orange,
            ),
            label: Text(""),
            padding: EdgeInsets.only(right: 0.0, left: 24.0),
          ),
        ),
      ),
    );
  }

  Future<bool> onBackPress() {
    Navigator.pop(context);
    return Future.value(false);
  }

  @override
  void initState(){
    super.initState();
    SharedPreferences.getInstance().then((sp) {
      sharedPreferences = sp;
    });
    postComments.postId = postId;
    postComments.postUserId = postUserId;
  }

  void sendComment(dynamic commentMessage) {
    timeStamp = DateTime.now().millisecondsSinceEpoch;
      if ((sharedPreferences!.getString("name") != null) &&
          (sharedPreferences!.getString("imageId") != null)) {
        Map<String, dynamic> commentData = <String, dynamic>{
          "senderName": sharedPreferences!.getString("name"),
          "senderPic": sharedPreferences!.getString("imageId"),
          "senderId" : sharedPreferences!.getString("userid"),
          "commentMessage": commentMessage,
          "timestamp": timeStamp,
        };
        FirebaseDatabase.instance.reference().child("comments").child(postId).once().then((DataSnapshot snapshot){
          if(snapshot.value == null){
            Map<String, dynamic> postUserIdData = <String, dynamic>{
              "id" : postUserId
            };
            FirebaseDatabase.instance.reference().child("comments").child(postId).child("postUserId").set(postUserIdData).whenComplete((){
              FirebaseDatabase.instance.reference().child("comments").child(postId).child("comments").push().set(commentData).whenComplete((){
                setState(() {
                  _messageController.text = "";
                });
                print("comment added");
              });
            });
          }
          else{
            FirebaseDatabase.instance
                .reference()
                .child("comments")
                .child(postId)
                .child("comments")
                .push()
                .set(commentData)
                .whenComplete(() {
              setState(() {
                _messageController.text = "";
              });
              print("comment added");
            });
          }
        });
      }
  }


  Widget buildComments() {
    return StreamBuilder(
      stream: FirebaseDatabase.instance
          .reference()
          .child("comments")
          .child(postId)
          .child("comments")
          .onValue,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.snapshot.value != null) {
            listMessage = snapshot.data.snapshot.value;
            if (listMessage != null) {
              newMap = Map.fromEntries(listMessage!.entries.toList()
                ..sort((e1, e2) =>
                    (e2.value["timestamp"]).compareTo(e1.value["timestamp"])));
            }
            return buildList(snapshot.data.snapshot.value);
          }
        }
        return Text("");
      },
    );
  }

  Widget buildList(var l) {
    return ListView.builder(
      reverse: false,
      padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 60.0),
      itemCount: l.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: Key(newMap!.keys.elementAt(index).toString()),
          direction: DismissDirection.endToStart,
          background: Container(
              alignment: AlignmentDirectional.centerEnd,
              color: Colors.red,
              child: Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ))),
          child: buildItem(index, newMap!.values.elementAt(index)),
        );
      },
    );
  }


  Widget buildItem(int index, var l) {
    if (l == null) {
      return Container(
        width: 0.0,
        height: 0.0,
      );
    }
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: new NetworkImage(l["senderPic"])))),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 10.0, top: 5.0),
                      child: Text(
                        "${l["senderName"].toString()}",
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0, top: 3.0),
                      child: Text(
                        "${l["commentMessage"].toString()}",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}