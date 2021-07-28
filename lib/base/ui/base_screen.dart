import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:fitcarib/constants.dart';
import 'package:fitcarib/ui/findpeople/find_people.dart';
import 'package:fitcarib/ui/friends/friends.dart';
//import 'package:fitcarib/ui/groups/groups_presenter.dart';
//import 'package:fitcarib/ui/groups/groups_screen.dart';
import 'package:fitcarib/ui/messages/messages.dart';
import 'package:fitcarib/ui/myactivity/activity.dart';
import 'package:fitcarib/ui/notifications/notifications.dart';
import 'package:fitcarib/ui/profile/profile.dart';
import 'package:fitcarib/ui/settings/settings.dart';
import 'package:fitcarib/ui/welcome/welcome.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:fitcarib/base/presenter/base_presenter.dart';
import 'package:fitcarib/base/ui/base_listener.dart';
import 'package:fitcarib/utils/prefs.dart';
import 'package:fitcarib/server/models/login_request.dart';
import 'dart:core';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';

abstract class BaseScreen extends StatefulWidget
{
  final BaseListener? listener;
  final String title;
  BaseScreen(this.title, this.listener, {Key? key}) : super(key: key);
}

abstract class BaseScreenState<T extends BaseScreen, P extends BasePresenter> extends State<T> with TickerProviderStateMixin implements BaseContract
{
  SharedPreferences? sharedPreferences;
  final FitcaribReference = FirebaseDatabase.instance.reference();
  Reference _reference = FirebaseStorage.instance.ref();

  final _messageController = TextEditingController();
  LoginRequest loginRequest = LoginRequest();
  String? stringName;
  String? stringImageId;
  String? username;
  String? firstName;
  File? file; //edited
  String? downloadUrl;

  var scaffoldKey = GlobalKey<ScaffoldState>();
  Prefs? prefs;
  double? screenHeight;
  double? screenWidth;

  Color? primaryColor;

  // AppBar appBar;

  TextTheme? textTheme;

  //Presenter
  P? presenter;

  final actions = <Widget>[];

  P createPresenter();

//AnimatedButtonController
  AnimationController? animationController;

  BaseScreenState()
  {
    animationController = AnimationController(vsync: this, duration: Duration(seconds: 1));
    presenter = createPresenter();
  }

  void showSnackBar(String message) {
    if (message == null) {
      return;
    }
    scaffoldKey.currentState!.showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 1),
    ));
  }

  Widget buildBody(BuildContext context);

  bool isIOS() {return Theme.of(context).platform == TargetPlatform.iOS;}

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    primaryColor = Theme.of(context).primaryColor;
    textTheme = Theme.of(context).textTheme;
    return Scaffold(
      key: scaffoldKey,
      appBar: getAppBar(),
      body: buildBody(context),
    );
  }

  @override
  void initState() {
    super.initState();
    initSharedPrefs();
    presenter!.getName().then((name)
    {
      print(name);
      List<String> names = name!.split(' ');
      firstName = names[0];
      setState(() {
        stringName = name;
      });
    });
    presenter!.getImage().then((name) {
      print(name);
      setState(() {
        stringImageId = name;
      });
    });
    presenter!.getUsername().then((name) {
      print(name);
      setState(() {
        username = name;
      });
    });
    WidgetsBinding.instance!.addPostFrameCallback((_) => onBuildComplete(context));
  }

  void hideKeyboard() {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  AppBar getAppBar() {
    return (widget.title == null) ? AppBar()
        : AppBar(
            title: Text(
              widget.title != null ? widget.title : "",
              style: TextStyle(fontSize: 16.0, color: Colors.white),
            ),
            leading: Material(
              color: primaryColor,
              child: InkWell(
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  Navigator.of(context).pop();
                },
                splashColor: primaryColor,
              ),
            ),
            backgroundColor: primaryColor,
            centerTitle: true,
            elevation: 0.0,
            actions: actions,
          );
  }

  @override
  void showMessage(String message) {  showSnackBar(message);  }

  @override
  void onError(String messageError) { showSnackBar(messageError); }

  @override
  void dispose() {
    super.dispose();
    presenter!.dispose();
  }

  Future getImage() async {
    FilePickerResult? tempImage = await FilePicker.platform.pickFiles(type: FileType.image);//edited.
    setState(() {
      file = tempImage as File; //edited.
    });
  }

  void onBuildComplete(BuildContext context) {}

  void initSharedPrefs()
  {
    Prefs? getPrefs;
    //this.prefs = getPrefs!;
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => NotificationsScreen()));
      //widget.listener.getRouter().navigateTo(context, '/notifications');
    } else if (index == 1) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => MessageScreen()));
      //widget.listener.getRouter().navigateTo(context, '/messages');
    } else if (index == 3) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => FriendsScreen()));
      //widget.listener.getRouter().navigateTo(context, '/friends');
    } else if (index == 4) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => SettingsScreen()));
      // widget.listener.getRouter().navigateTo(context, '/settings');
    }
  }

  Widget getBottomNavigation(int _selectedIndex) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.notifications), title: Text(''),),
        BottomNavigationBarItem(icon: Icon(Icons.message), title: Text('')),
        BottomNavigationBarItem(icon: Text(''), title: Text('')),
        BottomNavigationBarItem(icon: Icon(Icons.people), title: Text('')),
        BottomNavigationBarItem(icon: Icon(Icons.settings), title: Text('')),
      ],
      currentIndex: _selectedIndex,
      fixedColor: Colors.tealAccent[700],
      onTap: _onItemTapped,
    );
  }

  Widget getFloatingActionButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FloatingActionButton(
          child: new Icon(Icons.note_add),
          backgroundColor: Colors.tealAccent[700],
          onPressed: () {
            customDialog();
          },
        )
      ],
    );
  }

  dynamic dismiss() {
    return true;
  }

  // ignore: missing_return
  Future<Widget>? customDialog()
  {
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedPreferences = sp;
      return showDialog(
//        barrierDismissible: dismiss().then((_){
//          SystemChrome.setEnabledSystemUIOverlays([]);
//        }),
          context: context,
          builder: (_) => new AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                title: Text(
                  "What's new ${sharedPreferences!.getString("name")}?",
                  style: TextStyle(color: Colors.grey),
                ),
                content: Container(
                  width: 100.0,
                  height: 200.0,
                  child: ListView(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                borderSide: BorderSide(color: Colors.black)),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1.0),
                            ),
                            border: InputBorder.none),
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        controller: _messageController,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              getImage();
                            },
                            child: Tab(
                                icon: new Image.asset(
                              "assets/images/image_icon.png",
                              width: 25.0,
                              height: 25.0,
                            )),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5.0),
                            child: GestureDetector(
                              onTap: () {
                                print("h");
                              },
                              child: Tab(
                                  icon: new Image.asset(
                                "assets/images/video_icon.png",
                                width: 25.0,
                                height: 25.0,
                              )),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5.0),
                            child: GestureDetector(
                              onTap: () {
                                print("hello");
                              },
                              child: Tab(
                                  icon: new Image.asset(
                                "assets/images/pin_icon.png",
                                width: 25.0,
                                height: 23.0,
                              )),
                            ),
                          ),
                        ],
                      ),
                      file == null
                          ? Text("")
                          : Image.file(
                              file!,
                              height: 100.0,
                              width: 100.0,
                            ),
                      Padding(
                        padding: EdgeInsets.only(left: 50.0, right: 50.0),
                        child: GestureDetector(
                          onTap: () {
                            file == null
                                ? uploadTextPost(_messageController.text)
                                : uploadImageTextPost(
                                    _messageController.text, file);
                            print("hello");
                          },
                          child: Container(
                            height: 40.0,
                            child: Center(
                              child: Text("Post Update",
                                  style: new TextStyle(
                                    color: Colors.white,
                                  )),
                            ),
                            decoration: new BoxDecoration(
                                borderRadius: new BorderRadius.all(
                                    new Radius.circular(30.0)),
                                color: Colors.tealAccent[700]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ));
    });
  }

  Widget getDrawerLayout(double screenWidth, double screenHeight)
  {
    return Container(
      margin: EdgeInsets.only(right: screenWidth / 5, top: 0.0),
//          padding: EdgeInsets.only(bottom: screenHeight/1.3),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(20.0)),
          color: Colors.orange),
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.tealAccent[700],
            ),
            child: Row(
              children: <Widget>[
                Flexible(
                  child: Container(
                      width: 130.0,
                      height: 130,
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: new NetworkImage('$stringImageId')))),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15.0),
                ),
                Flexible(
                  child: new Container(
                    padding: new EdgeInsets.only(top: screenHeight / 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "$stringName",
                          style: TextStyle(color: Colors.white),
                          textScaleFactor: 1.4,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "@$username",
                          style: TextStyle(color: Colors.white),
                          textScaleFactor: 1.4,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20.0),
              ),
              TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => ActivityScreen()));
                  },
                  // widget.listener
                  //     .getRouter()
                  //     .navigateTo(context, '/activity', clearStack: true),
                  icon: Icon(
                    Icons.note,
                    color: Colors.white,
                    size: 35.0,
                  ),
                  label: Text(
                    "Activity",
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  )),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20.0),
              ),
              TextButton.icon(
                  onPressed: () {Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ProfileScreen()));},
                  // widget.listener
                  //     .getRouter()
                  //     .navigateTo(context, '/profile', clearStack: true),
                  icon: Icon(
                    Icons.person_outline,
                    color: Colors.white,
                    size: 35.0,
                  ),
                  label: Text("Profile", style: TextStyle(color: Colors.white, fontSize: 20.0))
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20.0),
              ),
              TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => NotificationsScreen()));
                  },
                  // widget.listener
                  //                   .getRouter()
                  //                   .navigateTo(context, '/notifications', clearStack: true),
                  icon: Icon(
                    Icons.notifications,
                    color: Colors.white,
                    size: 35.0,
                  ),
                  label: Text(
                    "Notification",
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  )),
              Padding(
                padding: EdgeInsets.only(left: screenWidth / 50),
              ),
              CircleAvatar(
                backgroundColor: Colors.tealAccent[700],
                child: Text(
                  "1",
                  style: TextStyle(color: Colors.white),
                ),
                radius: 15.0,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20.0),
              ),
              TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => MessageScreen()));
                  },
                  // widget.listener
                  // .getRouter()
                  // .navigateTo(context, '/messages', clearStack: true),
                  icon: Icon(
                    Icons.message,
                    color: Colors.white,
                    size: 35.0,
                  ),
                  label: Text(
                    "Messages",
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  )),
              Padding(
                padding: EdgeInsets.only(left: screenWidth / 18),
              ),
              CircleAvatar(
                backgroundColor: Colors.tealAccent[700],
                child: Text(
                  "1",
                  style: TextStyle(color: Colors.white),
                ),
                radius: 15.0,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20.0),
              ),
              TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => FriendsScreen()));
                  },
                  // => widget.listener
                  //     .getRouter()
                  //     .navigateTo(context, '/friends', clearStack: true),
                  icon: Icon(
                    Icons.people,
                    color: Colors.white,
                    size: 35.0,
                  ),
                  label: Text(
                    "Friends",
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  )),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20.0),
              ),
              TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => FindPeopleScreen()));
                  },
                  // => widget.listener
                  //     .getRouter()
                  //     .navigateTo(context, '/findpeople', clearStack: true),
                  icon: Icon(
                    Icons.people,
                    color: Colors.white,
                    size: 35.0,
                  ),
                  label: Text(
                    "Find People",
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  )),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20.0),
              ),
              TextButton.icon(
                  //onPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (context) => GroupsScreen()));},
                  // => widget.listener
                  //     .getRouter()
                  //     .navigateTo(context, '/groups', clearStack: true),
                  icon: Icon(
                    Icons.group,
                    color: Colors.white,
                    size: 35.0,
                  ),
                  label: Text(
                    "Groups",
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ), onPressed: () {},),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20.0),
              ),
              TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => SettingsScreen()));
                  },
                  // => widget.listener
                  //     .getRouter()
                  //     .navigateTo(context, '/settings', clearStack: true),
                  icon: Icon(
                    Icons.settings,
                    color: Colors.white,
                    size: 35.0,
                  ),
                  label: Text(
                    "Settings",
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  )),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20.0),
              ),
              TextButton.icon(
                  onPressed: () {
                    //presenter!.signout();
                    presenter!.clearData();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => WelcomeScreen()));
                    // widget.listener
                    //     .getRouter()
                    //     .navigateTo(context, '/welcome', clearStack: true);
                  },
                  icon: Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                    size: 35.0,
                  ),
                  label: Text(
                    "Logout",
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  )
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 40.0),
          ),
        ],
      ),
    );
  }

  Future uploadTextPost(var msg) async {
    SharedPreferences.getInstance().then((SharedPreferences sp)
    {
      sharedPreferences = sp;
      if (sharedPreferences!.getString("userid") != null) {
        dynamic postKey = FirebaseDatabase.instance
            .reference()
            .child("posts")
            .child(sharedPreferences!.getString("userid") as String)
            .push()
            .key;
        Map<String, dynamic> data = <String, dynamic>{
          "timestamp": DateTime.now().millisecondsSinceEpoch,
          "message": msg,
        };
        FitcaribReference.child('posts')
            .child(sharedPreferences!.getString("userid") as String)
            .child(postKey)
            .set(data)
            .whenComplete(() {
          print("post saved");
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => ActivityScreen()));
          // widget.listener
          //     .getRouter()
          //     .navigateTo(context, '/activity', clearStack: true);
        });
      }
    });
  }

  uploadImageTextPost(var msg, var image) {
    SharedPreferences.getInstance().then((SharedPreferences sp) async {
      sharedPreferences = sp;
      if (sharedPreferences!.getString("userid") != null) {
        dynamic postKey = FirebaseDatabase.instance
            .reference()
            .child("posts")
            .child(sharedPreferences!.getString("userid") as String)
            .push()
            .key;
        final String fileName = (postKey).toString();
        _reference = _reference.child("Posts/$fileName.jpg");

        final uploadTask = _reference.putFile(image);
        final taskSnapshot = await uploadTask.whenComplete(() => null);
        downloadUrl = await _reference.getDownloadURL();

        if (downloadUrl != null) {
          Map<String, dynamic> data = <String, dynamic>{
            "timestamp": DateTime.now().millisecondsSinceEpoch,
            "message": msg,
            "imageUrl": downloadUrl,
          };

          FitcaribReference.child('posts')
              .child(sharedPreferences!.getString("userid") as String)
              .child(postKey)
              .set(data)
              .whenComplete(() {
            print("post saved");
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => ActivityScreen()));
            // widget.listener
            //     .getRouter()
            //     .navigateTo(context, '/activity', clearStack: true);
          });
        }
      }
    });
  }
}
