import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fitcarib/base/ui/base_listener.dart';
import 'package:fitcarib/models/group_model.dart';
import 'package:fitcarib/ui/groups/create_new_group.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fitcarib/base/ui/base_screen.dart';
import 'package:fitcarib/ui/groups/groups_presenter.dart';
//import 'current_user_groups.dart';
import 'group_chat_room.dart';

class GroupsScreen extends BaseScreen
{
  BaseListener? baseListener;
  GroupsScreen(String title,this.baseListener) : super(title,baseListener);

  @override
  _GroupsScreenState createState() => _GroupsScreenState();
}

class _GroupsScreenState extends BaseScreenState<GroupsScreen, GroupsPresenter> implements GroupsContract
{
  final GlobalKey<ScaffoldState> _scaffoldKeyGroupsScreen = new GlobalKey<ScaffoldState>();

  final fitcaribReference=FirebaseDatabase.instance.reference();
  bool groupsPresent=false;
  String? currentUserID=FirebaseAuth.instance.currentUser!.uid.toString();
  Map<dynamic,dynamic>? friendsMap;
  Map<dynamic,dynamic>? groupRequestMap;
  String? groupID;
  String? groupName;
  String? admin;
  bool fetchedDetails=false;
  List<GroupModel> myGroups=[];
  final firebaseReference=FirebaseDatabase.instance.reference();
  String? currentUserName;


  @override
  Widget build(BuildContext context)
  {
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKeyGroupsScreen,
        drawer: getDrawerLayout(screenWidth, screenHeight),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            "Groups",
            style: TextStyle(
                color: Colors.orange,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          ),
          leading: TextButton.icon(
            onPressed: () => _scaffoldKeyGroupsScreen.currentState!.openDrawer(),
            icon: Icon(
              Icons.menu,
              color: Colors.orange,
            ),
            label: Text(""),
          ),
          actions: [
            TextButton.icon(
                onPressed:() {Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateGroup(currentUserID)));},
                icon: Icon(Icons.add_circle,size: 20.0,color: Colors.orange),
                label: Text('New Group',style: TextStyle(color: Colors.orange))
            ),
          ],
        ),
        floatingActionButton: getFloatingActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: getBottomNavigation(0),
        body: DefaultTabController(
          length: 2,
          child: Column(
            children: <Widget>[
              Container(
                constraints: BoxConstraints(maxHeight: 150.0),
                padding: EdgeInsets.only(top: 10.0),
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.grey))),
                child: Material(
                  child: TabBar(
                    tabs: [
                      Tab(
                        text: "View",
//                        child: Text("Friendship",style: TextStyle(color: Colors.tealAccent[700],fontSize: 20.0),),
                      ),
                      Tab(
                        text: "Invitation",
//                        child: Text("Requests",style: TextStyle(color: Colors.tealAccent[700],fontSize: 20.0),),
                      ),
                    ],
                    indicatorColor: Colors.tealAccent[700],
                    unselectedLabelColor: Colors.grey,
                    labelColor: Colors.tealAccent[700],
                    labelStyle: TextStyle(fontSize: 17.0),
                  ),
                ),
              ),
               Expanded(
                child: TabBarView(
                  children: <Widget>[
                    (fetchedDetails==false)? Center(child: Text("No Groups Yet!", style: TextStyle(color: Colors.orange.shade400,fontSize: 16.0))):
                    ListView.builder(itemBuilder: (BuildContext context, int index) {return builtGroups(index);},itemCount: myGroups.length,padding: EdgeInsets.only(top: 3.0),),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Container(
                    //       color: Colors.black12,
                    //       child: TextButton.icon(onPressed:() async
                    //       {
                    //         String? currentUserUid=FirebaseAuth.instance.currentUser!.uid;
                    //             Navigator.push(context, MaterialPageRoute(builder: (context)=>CurrentUserGroups(currentUserUid)));
                    //       },
                    //           icon: Icon(Icons.group,size: 36.0,color: Colors.orange.shade400,),
                    //           label: Text('View Groups', style: TextStyle(color: Colors.orange.shade400),)),
                    //     )
                    //   ],
                    // ),
                    groupRequestMap == null? Center(child: Text("No pending requests!", style: TextStyle(color: Colors.orange.shade400,fontSize: 16.0))): ListView.builder(
                        itemCount: groupRequestMap!.length,
                        itemBuilder: (BuildContext context, int index)
                        {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(top: 20.0),),
                              Padding(padding: EdgeInsets.only(right: 30.0,left: 30.0),child: Row(
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
                                                    image: new NetworkImage(groupRequestMap!.values.elementAt(index)["profilePic"])
                                                )
                                            )
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 20.0),
                                          child: Text("${groupRequestMap!.values.elementAt(index)["name"]}"),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Material(
                                    shape: CircleBorder(),
                                    child: Ink.image(
                                      image: AssetImage('assets/images/trueIcon.png'),
                                      fit: BoxFit.cover,
                                      width: 20.0,
                                      height: 20.0,
                                      child: InkWell(
                                        onTap: ()
                                        {
                                          acceptGroupRequest(groupRequestMap!.keys.elementAt(index), groupRequestMap!.values.elementAt(index)["profilePic"], groupRequestMap!.values.elementAt(index)["name"]);
                                        },
                                        child: null,
                                      ),
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.only(left: 10.0),),
                                  Material(
                                    shape: CircleBorder(),
                                    child: Ink.image(
                                      image: AssetImage('assets/images/falseIcon.png'),
                                      fit: BoxFit.cover,
                                      width: 20.0,
                                      height: 20.0,
                                      child: InkWell(
                                        onTap: null,
                                        child: null,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              ),
                              Padding(padding: EdgeInsets.only(top: 5.0),),
                              Divider(color: Colors.grey,),
                            ],
                          );
                        }
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {return Container();}

  @override
  GroupsPresenter createPresenter() {return GroupsPresenter(this);}

  @override
  void initState()
  {
    super.initState();
    getGroupDetails();
    dynamic r=fitcaribReference.child("groupRequests").once().then((snapshot)
    {
      Map<dynamic, dynamic> allGroupRequests={};
      List<int> positionList=[];
      List<String> requiredRoomKeys=[];
      int position=0;
      if(snapshot.value!=null)
        {
          allGroupRequests=snapshot.value;
          //allGroupRequests.values.elementAt(0);
          allGroupRequests.values.forEach((value)
          {
            Map<dynamic,dynamic> map=value;
            //if((value as String.contains(currentUserID!))
              //allGroupRequests=map.
          });
          allGroupRequests.entries.forEach((entry)
          {
            Map<dynamic,dynamic> x;
            if((entry as String).contains(currentUserID!))
              {
                x=entry.value;
                allGroupRequests.addAll(x);
              }
              positionList.add(position);
            position++;
          });
          if(positionList.isNotEmpty)
            {
              int j=0;
              int k=0;
              allGroupRequests.keys.forEach((key)
              {
                if(positionList[j]==k)
                  {
                    requiredRoomKeys.add(key);
                    if(j+1<positionList.length)
                      j++;
                  }
                k++;
              });
              //TODO
            }
        }
    });
    dynamic request =  FirebaseDatabase.instance.reference().child("groupRequests").child(currentUserID!);
    request.once().then((DataSnapshot snapshot)
    {
      if(snapshot.value != null)
      {
        setState(() {groupRequestMap = snapshot.value;});
      }
    });
  }

  Future<void> acceptGroupRequest(dynamic key, dynamic profilePic, dynamic name) async
  {
    String? invitedGroupID;
    List<dynamic> newList;
    Map<dynamic,dynamic> map={};
    Map<dynamic,dynamic> mapForNotificationKey={};
    String? requiredNotificationTopic;

    fitcaribReference.child('groupRequests').child(currentUserID!).child(key).once().then((dataSnapshot) async
    {
      map=dataSnapshot.value;
      invitedGroupID=map['groupId'];

      print(invitedGroupID);
      await fitcaribReference.child('groups').child(invitedGroupID!).child('members').once().then((dataSnapshot) async
      {
        newList=dataSnapshot.value;
        newList.add(currentUserID!);
        await fitcaribReference.child('groups').child(invitedGroupID!).child('members').set(newList).then((_) async
        {
          await fitcaribReference.child('groupNotifications').child(invitedGroupID!).child(currentUserID!).once().then((dataSnapshot) async
          {
            mapForNotificationKey=dataSnapshot.value;
            requiredNotificationTopic=mapForNotificationKey['notificationTopic'];
            await FirebaseMessaging.instance.subscribeToTopic(requiredNotificationTopic!).whenComplete(()
            {
              FirebaseDatabase.instance.reference().child("groupRequests").child(currentUserID!).child(key).remove().whenComplete(() async
              {  //TODO
                await FirebaseDatabase.instance.reference().child("groupRequested").child(key).child(currentUserID!).remove().whenComplete(() async
                {
                  FirebaseDatabase.instance.reference().child("groupRequests").child(currentUserID!).once().then((DataSnapshot snapshot)
                  {
                    if(snapshot.value == null)
                    {
                      setState(() {groupRequestMap = snapshot.value;});
                    }
                    else if(snapshot.value != null)
                    {
                      setState(() {groupRequestMap = snapshot.value;});
                    }
                  });
                });
              });
            });
          });
        });
      });
    });
  }

  Future getGroupDetails() async //for view groups
  {

    final fitcaribReference=FirebaseDatabase.instance.reference();
    String? currentUserUid=FirebaseAuth.instance.currentUser!.uid;
    await fitcaribReference.child('groups').once().then((DataSnapshot snapshot)
    {
      if(snapshot.value!=null)
      {
        myGroups.clear();
        print('-----***---->${snapshot.value.toString()}'); //print('---> ${snapshot.value['key']}');
        Map<dynamic,dynamic> groupsMap=snapshot.value; //print('--**&&--> ${groupsMap}');
        print('--@@@@--->${groupsMap.keys}');

        groupsMap.values.forEach((element)
        {
          try
          {
            Map<String,dynamic>? groupsMap=
            {
              "groupName":element["groupName"],
              "groupId":element["groupId"],
              "members":element["members"],
              "timeWhenCreated":element["timeWhenCreated"],
            };

            GroupModel groupModel=GroupModel.fromMap(groupsMap);
            if(groupModel.members.contains(currentUserUid))
              myGroups.add(groupModel);
          }catch(e)
          {
            print(e.toString());
          }
        });
        setState(() {
          fetchedDetails=true;
        });
      }
    });
  }

  Widget builtGroups(var index)
  {
    return GestureDetector(
      onTap: ()
      {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>GroupChatRoom(myGroups[index].groupId,currentUserName,myGroups[index].groupName)));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 15.0)),
          Padding(padding: EdgeInsets.only(right: 30.0, left: 30.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(left: 20.0),),
                      Container(
                          child: (fetchedDetails==true)? Text('${myGroups[index].groupName}', style: TextStyle(fontWeight: FontWeight.normal,fontSize: 20.0)): Text('')
                      ),
                      Padding(padding: EdgeInsets.only(top: 10.0)),
                      Container(
                        child: (fetchedDetails==true)? Text(''):Text(''),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 5.0),),
          Container(
              margin: EdgeInsets.only(left: 50.0),
              child: (fetchedDetails==true)? Text('Total Members: ${myGroups[index].members.length}',style: TextStyle(fontWeight: FontWeight.normal,fontSize: 14.0)):Text('')
          ),
          Divider(color: Colors.grey,),
        ],
      ),
    );
  }
}
