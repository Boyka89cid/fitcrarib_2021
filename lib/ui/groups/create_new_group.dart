import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fitcarib/base/ui/base_listener.dart';
import 'package:fitcarib/ui/groups/groups_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class CreateGroup extends StatefulWidget
{
  String? currentUserId;
  CreateGroup(this.currentUserId);
  @override
  State<StatefulWidget> createState()=>CreateGroupState();
}


class CreateGroupState extends State<CreateGroup>
{
  String title='not used';
  BaseListener? listener;
  TextEditingController groupNameController=TextEditingController();
  var currentDateTime=DateTime.now();
  GlobalKey<FormState> groupKey=GlobalKey<FormState>();
  CreateGroupState();


  @override
  void initState()
  {
    super.initState();
    configLoading();
  }

  void configLoading()
  {
    EasyLoading.instance
      ..loadingStyle=EasyLoadingStyle.custom
      ..userInteractions=false
      ..indicatorType=EasyLoadingIndicatorType.fadingCircle
      ..indicatorColor=Colors.orange.shade300
      ..progressColor=Colors.orange.shade300
      ..backgroundColor=Colors.black54
      ..textColor=Colors.orange.shade300
      ..textStyle=TextStyle(fontSize: 16.0,color: Colors.orange.shade300);
    //..maskColor=Colors.blue.withOpacity(0.5)
  }


  @override
  Widget build(BuildContext context)
  {
    //var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return MaterialApp(
      builder: EasyLoading.init(),
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            "Create Your Group",
            style: TextStyle(
                color: Colors.orange,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          ),
          leading: TextButton.icon(
              onPressed: ()=> Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GroupsScreen(title,listener))),
              icon: Icon(Icons.arrow_back,color: Colors.orange),
              label: Text('')
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          //mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Form(
              key: groupKey,
              child: Container(
                margin: EdgeInsets.only(left: width * .06,right: width * .06),
                child: TextFormField(
                  validator: (value)
                  {
                    if(value==null || value.isEmpty)
                      return 'Please Enter Some Name';
                    if(value.length<=2)
                      return 'Group Name too Short';
                    else
                      return null;
                  },
                  onChanged: (value){groupKey.currentState!.validate();},
                  controller: groupNameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.black,width: 6.0)
                    ),
                    hintText: 'Enter your Group Name Here',
                    focusColor: Colors.orange,
                    hintStyle: TextStyle(color: Colors.orange),
                    labelStyle: TextStyle(color: Colors.orange),
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.black12,
              margin: EdgeInsets.only(top: 20.0),
              child: TextButton.icon(
                icon: Icon(Icons.group,color: Colors.orange),
                label: Text('Create',style: TextStyle(color: Colors.orange)),
                  onPressed: () async
                  {
                    if(groupKey.currentState!.validate())
                      {
                        final fitcaribReference=FirebaseDatabase.instance.reference();
                        //String? currentUserUid=FirebaseAuth.instance.currentUser!.uid;

                        try
                          {
                            if(groupNameController.text.toString().isNotEmpty)
                            {
                              EasyLoading.show(status: "Creating Room");
                              Map<String,dynamic> data=
                              {
                                'groupId':widget.currentUserId,
                                'groupName':groupNameController.text.toString(),
                                'timeWhenCreated':currentDateTime.toString(),
                              };
                              List<String?>? allGroupId=[];
                              String? requiredRoomKey;
                              Map<String,dynamic> keyMap={};
                              allGroupId.add(widget.currentUserId);

                              await fitcaribReference.child('groups').push().set(data).then((_) async
                              {
                                await fitcaribReference.child('groups').once().then((DataSnapshot dataSnapshot) async
                                {
                                  Map<dynamic,dynamic> newMap=dataSnapshot.value;
                                  newMap.entries.forEach((element)
                                  {
                                    if(element.value['groupId']==widget.currentUserId)
                                    {
                                      requiredRoomKey=element.key;
                                      keyMap={'groupId':requiredRoomKey};
                                    }
                                  });

                                  await fitcaribReference.child('groups').child(requiredRoomKey as String).update(keyMap).then((_) async
                                  {
                                    await fitcaribReference.child('groups').child(requiredRoomKey as String).child('members').set(allGroupId).then((_) async
                                    {
                                      Map<String,dynamic> notificationDetails=
                                      {
                                        'userID':widget.currentUserId,
                                        'notificationTopic':''
                                      };
                                      await fitcaribReference.child('groupNotifications').child(requiredRoomKey as String).child(widget.currentUserId as String).push().set(notificationDetails).then((_) async
                                      {
                                        await fitcaribReference.child('groupNotifications').child(requiredRoomKey as String).child(widget.currentUserId as String).once().then((dataSnapshot) async
                                        {
                                          Map<dynamic,dynamic> newMap=dataSnapshot.value;
                                          String? requiredNotificationKey;
                                          newMap.keys.forEach((key) {requiredNotificationKey=key; });
                                          Map<dynamic,dynamic> requiredNotificationDetails=
                                          {
                                            'userID':widget.currentUserId,
                                            'notificationTopic':requiredNotificationKey
                                          };
                                          await fitcaribReference.child('groupNotifications').child(requiredRoomKey as String).child(widget.currentUserId as String).set(requiredNotificationDetails).then((_) async
                                          {
                                            await FirebaseMessaging.instance.subscribeToTopic(requiredNotificationKey!).whenComplete(()
                                            {
                                              //fetchedDetails=false;
                                              EasyLoading.dismiss();
                                              EasyLoading.showToast("New Group Created",toastPosition: EasyLoadingToastPosition.bottom,duration: Duration(seconds: 1));
                                            });
                                          });
                                        });
                                      });
                                    });
                                  });
                                });
                              });
                            }
                          }catch(exception){
                          EasyLoading.dismiss();
                          EasyLoading.showToast("Error Occurred. Check your Connection",toastPosition: EasyLoadingToastPosition.bottom,duration: Duration(seconds: 1));
                            };
                      }

                  },
              ),
            )
          ],
        ),
      ),
    );
  }
}