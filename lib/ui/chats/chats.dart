import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fitcarib/ui/messages/messages.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../main.dart';

class ChatsScreen extends StatefulWidget
{
  final roomId;
  final Map senderUserDetails;
  final Map receiverUserDetails;
  ChatsScreen({Key? key,this.roomId,required this.senderUserDetails,required this.receiverUserDetails}) : super(key: key);

  @override
  ChatsScreenState createState() => ChatsScreenState(roomId,senderUserDetails,receiverUserDetails);
}

class ChatsScreenState extends State<ChatsScreen>
{
  late var roomId;
  late var senderUserDetails;
  late var receiverUserDetails;
  ChatsScreenState(this.roomId,this.senderUserDetails,this.receiverUserDetails);
  final GlobalKey<ScaffoldState> _scaffoldKeyChatsScreen = new GlobalKey<ScaffoldState>();
  final postUrl = 'https://fcm.googleapis.com/fcm/send';
  Reference _reference = FirebaseStorage.instance.ref();
  bool alreadyGotData = false;
  late var _scaffoldContext;
  String? downloadUrl;
  File? file;
  Map<String,dynamic>? data;
  bool _isComposingMessage = false;
  final _messageController = TextEditingController();
  Map<dynamic,dynamic>? listMessage;
  Map<dynamic,dynamic>? newMap;
  final firebaseReference = FirebaseDatabase.instance.reference();

  Map<dynamic,dynamic>? allMessages;

  SharedPreferences? sharedPreferences;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text("${receiverUserDetails["name"]}", style: TextStyle(color: Colors.orange),),
          leading: FlatButton.icon(
            onPressed: () {toMessageScreen();},
            icon: Icon(Icons.arrow_back, color: Colors.orange,),
            label: Text(""),
            padding: EdgeInsets.only(right: 0.0, left: 24.0),),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Flexible(
                child: buildListMessage(),
              ),
              Divider(height: 1.0),
              Container(
                decoration:
                new BoxDecoration(color: Theme.of(context).cardColor),
                child: _buildTextComposer(),
              ),
              Builder(builder: (BuildContext context)
              {
                _scaffoldContext = context;
                return new Container(width: 0.0, height: 0.0);
              })
            ],
          ),
          decoration: Theme.of(context).platform == TargetPlatform.iOS ? new BoxDecoration(border: new Border(top: new BorderSide(color: Colors.grey.shade200))) : null,
        ),
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
              IconButton(
                  icon: new Icon(Icons.photo_camera, color: Theme.of(context).accentColor,),
                  onPressed: () async
                  {
                    File imageFile = await FilePicker.platform.pickFiles(type: FileType.image) as File; //edited
                    int timestamp = new DateTime.now().millisecondsSinceEpoch;
                    _reference = _reference.child("Chats/img_" + timestamp.toString() + ".jpg");

                    final uploadTask = _reference.putFile(imageFile);

                    final downloadUrl = (await uploadTask.whenComplete(() => null));

                    final String url = (await downloadUrl.ref.getDownloadURL());
                    print('URL Is $url');
                    sendMessage(url);
                  }),
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
                child: Theme.of(context).platform == TargetPlatform.iOS
                    ? getIOSSendButton()
                    : getDefaultSendButton(),
              ),
            ],
          ),
        );
  }

  Future<Null> _textMessageSubmitted(String text) async
  {
    _messageController.clear();

    setState(()
    {
      _isComposingMessage = false;
    });
    sendMessage(text);
    print(receiverUserDetails);
    sendNotification(text.toString());
  }

  Future sendNotification(String messageToBeNotified) async //sending notification by API
  {
    {
      final postUrl = 'https://fcm.googleapis.com/fcm/send';
      String toParams = "/topics/"+'${receiverUserDetails['id'].toString()}';

      final data =
      {
        "notification": {"body":messageToBeNotified, "title":'${senderUserDetails['name']}'},
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

      if (response.statusCode == 200)
      {// on success do
        print("true");
      }
      else
        {// on failure do
          print("false");
        }
    }
  }

  int _messageCount = 0;

  /*String constructFCMPayload(String token)
  {
    return jsonEncode(
        {
      'token': token,
      'data':
      {
        'via': 'FlutterFire Cloud Messaging!!!',
        'count': _messageCount.toString(),
      },
      'notification':
      {
        'title': 'Hello FlutterFire!',
        'body': 'This notification (#$_messageCount) was created via FCM!',
      },
    });
  }*/
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

  Widget buildListMessage()
  {
    return StreamBuilder(
      stream: FirebaseDatabase.instance.reference().child("rooms").child(roomId).child("conversation").onValue,
      builder: (BuildContext context, AsyncSnapshot snapshot)
      {
        if(snapshot.hasData)
        {
          if(snapshot.data.snapshot.value != null){
            listMessage = snapshot.data.snapshot.value;
            if(listMessage != null)
            {
              newMap = Map.fromEntries(listMessage!.entries.toList()..sort((e1,e2) => (e2.value["timestamp"]).compareTo(e1.value["timestamp"])));
            }

            return buildList(snapshot.data.snapshot.value);
          }
        }
        return Center(
          child: Text("Start Conversation!"),
        );
      },
    );
  }

  Widget buildList(var gotList){
    return ListView.builder(
      reverse: true,
      padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 60.0),
      itemCount: gotList.length,
      itemBuilder: (context, index)  {return buildItem(index, newMap!.values.elementAt(index));},
    );
  }

  Widget buildItem(int index, var gotList){
    String mes = gotList["message"];
    return gotList["senderId"] == senderUserDetails["id"] ? Padding(
      padding: EdgeInsets.only(bottom: 5.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: mes.contains(".jpg") == true ? Image.network(gotList["message"], width: 250.0,) :  Text("${gotList["message"].toString()}"),
      ),
    ) : Padding(
      padding: EdgeInsets.only(bottom: 5.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: mes.contains(".jpg") == true ? Image.network(gotList["message"], width: 250.0,) :  Text("${gotList["message"].toString()}"),
      ),
    );
  }

  void sendMessage(var message)
  {
    var timeStamp = DateTime.now().millisecondsSinceEpoch;
    data!["message"]= message;
    data!["status"] = true;
    data!["timestamp"] = timeStamp;
    data!["friendName"] = senderUserDetails["name"];
    data!["friendsPic"] = senderUserDetails["profilePic"];
    Map<String,dynamic> conversationData = <String,dynamic>{
      "senderId" : senderUserDetails["id"],
      "timestamp" : timeStamp,
      "message" : message
    };
    firebaseReference.child("messages").child(receiverUserDetails["id"]).child(senderUserDetails["id"]).update(data!);

    data!["status"] = false;
    data!["friendName"] = receiverUserDetails["name"];
    data!["friendsPic"] = receiverUserDetails["profilePic"];

    firebaseReference.child("messages").child(senderUserDetails["id"]).child(receiverUserDetails["id"]).update(data!);

    firebaseReference.child("rooms").child(roomId).child("conversation").push().set(conversationData).then((_){
      setState(() {
        _messageController.text ="";
        alreadyGotData = true;
      });
    });
  }

  @override
  void dispose()
  {
    super.dispose();
  }

  @override
  void initState()
  {
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences sp){sharedPreferences = sp;});
    print(senderUserDetails.toString());
    print(receiverUserDetails.toString());

    FirebaseMessaging.onMessage.listen((RemoteMessage message) //notification Recieved when app is closed.
    {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb)
      {
        print('--->ooooo');
        flutterLocalNotificationsPlugin!.show(
            notification.hashCode,
            notification.title,
            notification.body,
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
            ),);
          });
        }
    });

    data = <String,dynamic>{
      "roomId" : roomId
    };

    firebaseReference.child("rooms").child(roomId).once().then((DataSnapshot data){
      if(data.value != null){
        firebaseReference.child("messages").child(senderUserDetails["id"]).child(receiverUserDetails["id"]).child("status").set(false);
        setState(() {
          alreadyGotData = true;
        });
      }
    });
  }

  void toMessageScreen()
  {
    if(alreadyGotData)
    {
      firebaseReference.child("messages").child(senderUserDetails["id"]).child(receiverUserDetails["id"]).child("status").set(false).then((_){
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MessageScreen()),

        );
      });
    }
    else{
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MessageScreen()),
      );
    }
  }
  Future<bool> onBackPress()
  {
    Navigator.pop(context);
    return Future.value(false);
  }
}