import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fitcarib/models/group_model.dart';
import 'package:fitcarib/ui/groups/group_chat_room.dart';
import 'package:flutter/material.dart';

class CurrentUserGroups extends StatefulWidget
{
  String? currentUserUid;
  CurrentUserGroups(this.currentUserUid);

  @override
  State<StatefulWidget> createState()=>CurrentUserGroupsState(currentUserUid);
}

class CurrentUserGroupsState extends State<CurrentUserGroups>
{
  String? currentUserUid;
  String? groupID;
  String? groupName;
  String? admin;
  List<GroupModel> myGroups=[];
  final firebaseReference=FirebaseDatabase.instance.reference();
  String? currentUserName;
  static bool fetchedDetails=false;
  CurrentUserGroupsState(this.currentUserUid);

  @override
  void initState()
  {
    super.initState();
    getGroupDetails();
    getUserName();
  }

  @override
  Widget build(BuildContext context)
  {
  return MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          "All Your Groups",
          style: TextStyle(
              color: Colors.orange,
              fontSize: 20.0,
              fontWeight: FontWeight.bold),
        ),
        leading: TextButton.icon(
            onPressed: (){Navigator.pop(context);},
            icon: Icon(Icons.logout,color: Colors.orange),
            label: Text('')
        ),
      ),
      body: ListView.builder(itemBuilder: (BuildContext context, int index) {return builtGroups(index);},itemCount: myGroups.length),
    ),
  );
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
          Padding(padding: EdgeInsets.only(top: 20.0)),
          Padding(padding: EdgeInsets.only(right: 30.0, left: 30.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(left: 20.0),),
                      Container(
                        child: (fetchedDetails==true)? Text('${myGroups[index].groupName}', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0)): Text('')
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
          Divider(color: Colors.grey,),
        ],
      ),
    );
  }

  Future getGroupDetails() async
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
  Future<void> getUserName() async
  {
    firebaseReference.child("users").child(currentUserUid!).once().then((DataSnapshot dataSnapshot)
    {
      Map<dynamic,dynamic> currentUserMap=dataSnapshot.value;
      currentUserName=currentUserMap['name'];
    });
  }
}