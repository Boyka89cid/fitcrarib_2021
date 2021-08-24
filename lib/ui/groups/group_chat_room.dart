import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../main.dart';
import 'add_user_to_group.dart';

class GroupChatRoom extends StatefulWidget
{
  var roomId;
  var currentUserName;
  var groupName;
  GroupChatRoom(this.roomId,this.currentUserName,this.groupName);
  @override
  State<StatefulWidget> createState()=>GroupChatRoomState();

}
class GroupChatRoomState extends State<GroupChatRoom>
{
  Map<dynamic,dynamic>? listAllMessages;
  Map<dynamic,dynamic>? newMessagesMap;
  final String currentUserUid=FirebaseAuth.instance.currentUser!.uid;
  final firebaseReference=FirebaseDatabase.instance.reference();
  bool _isComposingMessage = false;
  bool newMessage = false;
  final _messageController = TextEditingController();
  String? currentUserName;
  Map<dynamic,dynamic>? newUsersMap;
  int notificationCounter=0;
  final Color orangeShadeColor=Colors.orange.shade500;
  @override
  void initState()
  {
    super.initState();
    getUserName();
    FirebaseMessaging.onMessage.listen((RemoteMessage message)
    {
      RemoteNotification? remoteNotification=message.notification;
      AndroidNotification? android=message.notification!.android;
      if (remoteNotification != null && android != null && !kIsWeb)
      {
        print('--->okay');
        flutterLocalNotificationsPlugin!.show(
            remoteNotification.hashCode,
            remoteNotification.title,
            remoteNotification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel!.id,
                channel!.name,
                channel!.description,
                icon: 'launch_background',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message)
    {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb)
      {
        showDialog(context: context, builder: (_)
        {
          return AlertDialog(title: Text(notification.title as String),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text(notification.body as String)],
              ),
            ),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text('${widget.groupName}', style: TextStyle(color: orangeShadeColor)),
        leading: TextButton.icon(
            onPressed:()=>Navigator.pop(context),
            icon: Icon(Icons.arrow_back,color: orangeShadeColor),
            label: Text('')
        ),
        actions: <Widget>[
          Container(
              margin: EdgeInsets.only(right: 5.0),
              child: TextButton.icon(
                  onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>AddUserToGroup(widget.roomId))),
                  icon: Icon(Icons.add,color: orangeShadeColor),
                  label: Text('Add',style: TextStyle(color: orangeShadeColor, fontSize: 16.0))
              )
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Flexible(child: builtListGroupChatMessages()),
          Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer()
  {
    return new IconTheme(
      data: new IconThemeData(
        color: _isComposingMessage ? Theme.of(context).accentColor : Theme.of(context).disabledColor,
      ),
      child: new Row(
        children: <Widget>[
          Flexible(
            child: Padding(
                child: TextField(
                    controller:  _messageController,
                    onChanged: (String messageText) async
                    {
                      setState(() {
                        _isComposingMessage = messageText.length > 0;
                      });
                    },
                    onSubmitted: _textMessageSubmitted,
                    decoration: InputDecoration.collapsed(hintText: "Write your message")),
                    padding: EdgeInsets.only(left: 20)
            ),
          ),
          new Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Theme.of(context).platform == TargetPlatform.iOS ? getIOSSendButton() : getDefaultSendButton(),
          ),
        ],
      ),
    );
  }

  CupertinoButton getIOSSendButton()
  {
    return new CupertinoButton(
      child: new Text("Send"),
      onPressed: _isComposingMessage ? () => _textMessageSubmitted(_messageController.text) : null,
    );
  }

  IconButton getDefaultSendButton()
  {
    return new IconButton(
      icon: new Icon(Icons.send),
      onPressed: _isComposingMessage ? () => _textMessageSubmitted(_messageController.text) : null,
    );
  }

  Future<Null> _textMessageSubmitted(String text) async
  {
    _messageController.clear();

    setState(() {_isComposingMessage = false;});
    sendGroupMessage(text);  //send Msg fxn.
    getAllTopicToSentNotifications().then((listOfTopics)=>sentNotificationToAll(listOfTopics,text.toString()));
  }

  Future<void> sentNotificationToAll(List<String?> listOfTopics,String messageToBeSent) async
  {
    print('-------> $listOfTopics');
    if(listOfTopics.isNotEmpty)
      {
        if(notificationCounter<listOfTopics.length)
          {
            await sendNotificationInGroup(messageToBeSent,listOfTopics.elementAt(notificationCounter)).then((_)
            {
              notificationCounter++;
              sentNotificationToAll(listOfTopics, messageToBeSent);
            });
          }
        else
          {
            notificationCounter=0;
            return;
          }
      }
  }

  Future<List<String?>> getAllTopicToSentNotifications() async
  {
    List<String?> listOfTopics=[];
    await firebaseReference.child('groupNotifications').child(widget.roomId.toString()).once().then((dataSnapshot)
    {

      Map<dynamic,dynamic> allUserIdMap=dataSnapshot.value;
      allUserIdMap.entries.forEach((element)
      {
        if(element.value['userID']!=currentUserUid)
          listOfTopics.add(element.value['notificationTopic']);
      });
    });
    print(listOfTopics);
    return listOfTopics;
  }


  Widget builtListGroupChatMessages()
  {
    return StreamBuilder(
        stream: FirebaseDatabase.instance.reference().child('groups').child(widget.roomId.toString()).child('conversation').onValue,
        builder: (BuildContext buildContext, AsyncSnapshot snapshot)
    {
      if(snapshot.hasData)
        {
          print('*****_____****** ${snapshot.data}');
          if(snapshot.data.snapshot.value!=null)
            {
              print("&&&&&&^^^^^&&&& ${snapshot.data.snapshot.value}");
              listAllMessages=snapshot.data.snapshot.value;
              if(listAllMessages!=null)
                {
                  newMessagesMap=Map.fromEntries(listAllMessages!.entries.toList()..sort((e1,e2)=>(e2.value["timestamp"]).compareTo(e1.value["timestamp"])));
                  //newUsersMap=Map.fromEntries(listAllMessages!.entries.toList()..sort((e1,e2)=>(e2.value["senderId"]).compareTo(e1.value["timestamp"])));
                  //print("++++++++----+++$newMessagesMap");
                }
              return buildMessageList(snapshot.data.snapshot.value);
            }
        }
        return Center(child: Text("Start Conversation!"));
    });
  }

  Widget buildMessageList(var gotList)
  {
    return ListView.builder(
        reverse: true,
        padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 60.0),
        itemBuilder: (context,index) {return buildItem(index,newMessagesMap!.values.elementAt(index));},
        itemCount: gotList.length,
    );
  }

  Widget buildItem(int index,var gotList)
  {

    var msg=gotList["message"];
    return Padding(
        padding: EdgeInsets.only(bottom: 7.0),
        child: Text('${msg.toString()}'),
    );
  }

  void sendGroupMessage(var msg)
  {
    var timestamp=DateTime.now().millisecondsSinceEpoch;
    String senderId=FirebaseAuth.instance.currentUser!.uid.toString();
    Map<String,dynamic> conservationData=
    {
      "message":msg,
      "timestamp":timestamp,
      "senderId":senderId,
    };
    firebaseReference.child("groups").child(widget.roomId.toString()).child('conversation').push().set(conservationData).then((_)
    {
      setState(() {_messageController.text ="";});
    });
  }

  Future<void> getUserName() async
  {
    firebaseReference.child("users").child(currentUserUid).once().then((DataSnapshot dataSnapshot)
    {
      Map<dynamic,dynamic> currentUserMap=dataSnapshot.value;
      currentUserName=currentUserMap['name'];
    });
  }

  Future<void> sendNotificationInGroup(String messageToBeNotified,String? requiredTopic) async //sending notification by API
  {
    print('******-->$requiredTopic');
    {
      final postUrl = 'https://fcm.googleapis.com/fcm/send';
      String toParams = "/topics/"+'${requiredTopic!}';

      final data =
      {
        "notification": {"body":messageToBeNotified, "title":'${widget.currentUserName}'},
        "priority": "high",
        "data":
        {
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
          "id": "1",
          "status": "done",
          "sound": 'default',
          "screen": "yourTopicName",
        },
        "to": "$toParams"
      };

      final headers =
      {
        'content-type': 'application/json',
        'Authorization': 'key=AAAAKi8QjVo:APA91bHUYz7PN_iCioOdT4cSaYs1cKEyzLzZOEZQx7Bd-1kV4zzP5dmSh4G-hKRPT3a5D-cnrrsjYbx6ePiGZ562WfGchWo0guTVmGnUwUrVw2fNXsuQskZm1__DPUfCOxcx66dOt4XF'
      };

      final response = await http.post(Uri.parse(postUrl),
          body: json.encode(data),
          encoding: Encoding.getByName('utf-8'),
          headers: headers);

      if (response.statusCode == 200) // on success do
        print("true");
      else  // on failure do
        print("false");
    }
  }
}