import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fitcarib/ui/myactivity/activity.dart';
import 'dart:ui';

class CommonFloatingActionButton extends StatefulWidget {
  @override
  CommonFloatingActionButtonState createState() => new CommonFloatingActionButtonState();
}

class CommonFloatingActionButtonState extends State<CommonFloatingActionButton> {

  SharedPreferences? sharedPreferences;
  final _messageController = TextEditingController();
  File? file;
  final FitcaribReference = FirebaseDatabase.instance.reference();
  Reference _reference = FirebaseStorage.instance.ref();
  String? downloadUrl;
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((sp) {
      sharedPreferences = sp;
//      setState(() {
//        name = sharedPreferences.getString("name");
//        imageId = sharedPreferences.get("imageId");
//        userName = sharedPreferences.get("username");
//      });
    });
  }

  @override
  Widget build(BuildContext context) {
//    var screenWidth = MediaQuery.of(context).size.width;
//    var screenHeight = MediaQuery.of(context).size.height;
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

  // ignore: missing_return
  Future<Widget>? customDialog() {
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedPreferences = sp;
      return showDialog(
        barrierDismissible: true,
          context: context,
          builder: (_) => new AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: Text(
              "What's new ${sharedPreferences!.getString("name")}?",
              style: TextStyle(color: Colors.grey),
            ),
            content: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
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
                            print("hell");
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
                        file == null ? uploadTextPost(_messageController.text) : uploadImageTextPost(_messageController.text, file);
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
                                Radius.circular(30.0)),
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

  Future getImage() async {
    var tempImage = await FilePicker.platform.pickFiles(type: FileType.image) as File;
    setState(() {
      file = tempImage;
    });
  }

  Future uploadTextPost(var msg) async {
    SharedPreferences.getInstance().then((SharedPreferences sp) {
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
          Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => ActivityScreen()),);
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

        final  downloadUrl =
        (await uploadTask.whenComplete(() => null));

        final String url = (await downloadUrl.ref.getDownloadURL());

//        downloadUrl = await _reference.getDownloadURL();

        if (url != null) {
          Map<String, dynamic> data = <String, dynamic>{
            "timestamp": DateTime.now().millisecondsSinceEpoch,
            "message": msg,
            "imageUrl": url,
          };

          FitcaribReference.child('posts')
              .child(sharedPreferences!.getString("userid") as String)
              .child(postKey)
              .set(data)
              .whenComplete(() {
            print("post saved");
            Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => ActivityScreen()),);
          });
        }
      }
    });
  }

}
