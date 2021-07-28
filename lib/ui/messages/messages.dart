import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:fitcarib/ui/common/common.dart';
import 'package:fitcarib/ui/chats/chats.dart';

class MessageScreen extends StatefulWidget
{
  MessageScreen({Key? key,}) : super(key: key);

  @override
  MessageScreenState createState() => MessageScreenState();
}

class MessageScreenState extends State<MessageScreen>
{
  final GlobalKey<ScaffoldState> _scaffoldKeyMessageScreen = new GlobalKey<ScaffoldState>();

  final fitcaribReference = FirebaseDatabase.instance.reference();

  String? timeFooter;

  Map<dynamic, dynamic>? myMessages;

  SharedPreferences? sharedPreferences;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKeyMessageScreen,
        drawer: CommonDrawer(),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            "Messages",
            style: TextStyle(
                color: Colors.orange,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          ),
          leading: FlatButton.icon(
            onPressed: () => _scaffoldKeyMessageScreen.currentState!.openDrawer(),
            icon: Icon(
              Icons.menu,
              color: Colors.orange,
            ),
            // ignore: missing_required_param
            label: Text(""),
            padding: EdgeInsets.only(right: 0.0, left: 24.0),
          ),
          actions: <Widget>[
            FlatButton.icon(
              onPressed: () {},//presenter.newMessage();
              icon: Icon(
                Icons.add,
                color: Colors.orange,
                size: 40.0,
              ),
              label: Text(""),
              padding: EdgeInsets.only(right: 0.0, left: 24.0),
            )
          ],
        ),
        body: myMessages == null
            ? Center(
                child: Text("No Messages!"),
              )
            : ListView.builder(
                itemCount: myMessages!.length,
                itemBuilder: (BuildContext context, int index) {
                  return builtFriends(index);
                },
              ),
        floatingActionButton: CommonFloatingActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: CommonBottomNavigationBar(
          selectedIndex: 1,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences sp)
    {
      sharedPreferences = sp;

      if (sharedPreferences!.getString("userid") != null)
      {
        dynamic friend =FirebaseDatabase.instance.reference().child("messages").child(sharedPreferences!.getString("userid") as String);
        friend.once().then((DataSnapshot snapshot) {
          if (snapshot.value != null) {
            setState(() {
              myMessages = snapshot.value;
            });
          }
        });
      }
    });
  }

  void toChat(var id, var value){

    Map<dynamic,dynamic> senderUserDetails = Map();
    Map<dynamic,dynamic> receiverUserDetails = Map();
    var roomId = value["roomId"];

    receiverUserDetails["id"] = id;
    receiverUserDetails["profilePic"] = value["friendsPic"];
    receiverUserDetails["name"] = value["friendName"];

    senderUserDetails["id"] = sharedPreferences!.getString("userid");
    senderUserDetails["profilePic"] = sharedPreferences!.getString("imageId");
    senderUserDetails["name"] = sharedPreferences!.getString("name");

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ChatsScreen(
            roomId: roomId,
            receiverUserDetails: receiverUserDetails,
            senderUserDetails: senderUserDetails,
          )),
    );
  }

  Widget builtFriends(var index) {
    var status = myMessages!.values.elementAt(index)["status"];

    var receivedDatetime = DateTime.fromMillisecondsSinceEpoch(
        myMessages!.values.elementAt(index)["timestamp"]);

    var currentDatetime = DateTime.now();
    var difference = currentDatetime.difference(receivedDatetime).inMinutes;
    var ago = currentDatetime.subtract(Duration(minutes: difference));
    timeFooter = timeago.format(ago);

    return GestureDetector(
      onTap: () {
        toChat(myMessages!.keys.elementAt(index), myMessages!.values.elementAt(index));
        print(myMessages!.values.elementAt(index).toString());
        print(myMessages!.keys.elementAt(index).toString());
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 20.0),
          ),
          Padding(
            padding: EdgeInsets.only(right: 30.0, left: 30.0),
            child: Row(
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
                                  image: new NetworkImage(myMessages!.values.elementAt(index)["friendsPic"])
                              )
                          )
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20.0),
                      ),
                      Expanded(
                        child: status == true
                            ? Text(
                                "${myMessages!.values.elementAt(index)["friendName"]}\n${myMessages!.values.elementAt(index)["message"].contains(".jpg") == true ? "Sent An Attachment" : myMessages!.values.elementAt(index)["message"]}",
                                style: TextStyle(fontWeight: FontWeight.bold))
                            : Text(
                                "${myMessages!.values.elementAt(index)["friendName"]}\n${myMessages!.values.elementAt(index)["message"].contains(".jpg") == true ? "Sent An Attachment" : myMessages!.values.elementAt(index)["message"]}"),
                      ),
                      Text(
                        timeFooter!,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5.0),
          ),
          Divider(
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
