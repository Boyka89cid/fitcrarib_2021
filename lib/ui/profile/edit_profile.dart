import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fitcarib/ui/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class EditProfile extends StatefulWidget
{
  String? stringImageId;
  String? username;
  String? firstName;
  String? lastName;

  EditProfile(this.firstName,this.lastName,this.username,this.stringImageId);

  @override
  State<StatefulWidget> createState()=>EditProfileState(firstName,lastName,username,stringImageId);
}
class EditProfileState extends State<EditProfile>
{
  User? user=FirebaseAuth.instance.currentUser;

  GlobalKey<FormState> checkUserData=GlobalKey<FormState>();

  SharedPreferences? sharedPreferences;
  DatabaseReference fireBaseDatabaseReference=FirebaseDatabase.instance.reference();
  int updateCounterForName=0;
  int updateCounterForImage=0;
  File? file;
  String? newDownloadUrlImage;
  String? newProfileName;
  String? newFirstName;
  String? newLastName;
  //EasyLoading _easyLoading=EasyLoading.instance;
  EditProfileState(this.newFirstName,this.newLastName,this.newProfileName,this.newDownloadUrlImage);

  @override
  Widget build(BuildContext context)
  {
    dynamic width=MediaQuery.of(context).size.width;
    dynamic height=MediaQuery.of(context).size.height;
    TextEditingController? newFirstNameController;
    TextEditingController? newLastNameController;
    TextEditingController? newProfileNameController;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('Edit Your Profile',style: TextStyle(color: Colors.orange)),
          centerTitle: true,
          leading: TextButton.icon(onPressed: ()=>Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ProfileScreen())),
              icon: Icon(Icons.backspace_outlined,color: Colors.orange,),
              label: Text("")
          )
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: height * .1),
                child: GestureDetector(
                  onTap: () async {await getAndSaveUpdatedImage();},
                  child: CircleAvatar(
                    radius: 60.0,
                    backgroundImage: NetworkImage(newDownloadUrlImage!),
                    //foregroundImage: ExactAssetImage('assets/images/profile_image_outline.png',scale: 2.0),
                  ),
                ),
              ),
              Form(
                  key: checkUserData,
                  child: Column(
                    children: <Widget>[
                      Container(
                        //top: height * .06
                        margin: EdgeInsets.only(left: width * .06,right: width * .06,top: .03),
                        child: TextFormField(
                          validator: (value)
                          {
                            if(value==null || value.isEmpty)
                              return 'Please Enter Some Text';
                            else
                              return null;
                          },
                          maxLength: 30,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          controller: newFirstNameController,
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                                borderRadius:BorderRadius.circular(20.0),
                                //borderSide: BorderSide(color: Colors.black)
                            ),
                            focusColor: Colors.deepOrange,
                            hintText: 'Enter Your New First Name Here',
                            hintStyle: TextStyle(color: Colors.deepOrange),
                            labelText: 'First Name',
                            labelStyle: TextStyle(color: Colors.deepOrange),
                            //prefixText:
                          ),
                          initialValue: widget.firstName,
                          onChanged: (firstNameNow)
                          {
                            //checkUserData.currentState!.validate();
                            print('----111----$firstNameNow');
                            if(newFirstNameController==null)
                              {
                                newFirstNameController=TextEditingController();
                                print("00000000000000000");
                              }
                            newFirstNameController!.text=firstNameNow;
                            newFirstName=firstNameNow;
                            print('^^^^^^^$newFirstName');
                            //newFirstName=firstNameNow;
                            print('@@@@@_____${newFirstNameController!.text}');
                            print('*********_____${newFirstNameController!.text.runtimeType}');
                            widget.firstName=null;
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: width * .06,right: width * .06),
                        child: TextFormField(
                          validator: (value)
                          {
                            if(value==null || value.isEmpty)
                              return 'Please Enter Some Text';
                            else
                              return null;
                          },
                          maxLength: 30,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          controller: newLastNameController,
                          decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                  borderRadius:BorderRadius.circular(20.0),
                                  borderSide: BorderSide(color: Colors.black)
                              ),
                              focusColor: Colors.deepOrange,
                              hintText: 'Enter Your New Last Name Here',
                              hintStyle: TextStyle(color: Colors.deepOrange),
                              labelText: 'Last Name',
                              labelStyle: TextStyle(color: Colors.deepOrange),
                          ),
                          initialValue: widget.lastName,
                          onChanged: (lastNameNow)
                          {

                            if(newLastNameController==null)
                              newLastNameController=TextEditingController();
                            newLastName=lastNameNow;
                            newLastNameController!.text=lastNameNow;
                            widget.lastName=null;
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: width * .06,right: width * .06),
                        child: TextFormField(
                          validator: (value)
                          {
                            if(value==null || value.isEmpty)
                              return 'Please Enter Some Text';
                            else
                              return null;
                          },
                          //autofocus: true,
                          maxLength: 30,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          controller: newProfileNameController,
                          decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                  borderRadius:BorderRadius.circular(2.0),
                                  borderSide: BorderSide(color: Colors.black)
                              ),
                              focusColor: Colors.deepOrange,
                              hintText: 'Enter Your New Profile Name Here',
                              hintStyle: TextStyle(color: Colors.deepOrange),
                              labelText: 'New Profile Name',
                              labelStyle: TextStyle(color: Colors.deepOrange),
                          ),
                          initialValue: widget.username,
                          onChanged: (profileNameNow)
                          {
                            if(newProfileNameController==null)
                              newProfileNameController=TextEditingController();
                            newProfileName=profileNameNow;
                            newProfileNameController!.text=profileNameNow;
                            widget.username=null;
                          },
                        ),
                      ),
                    ],
                  )
              ),
              Container(
                //constraints:,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0),color: Colors.black),
                child: TextButton.icon(
                    onPressed: () async {await validateOurFormAndSaveUserData();},
                    icon: Icon(Icons.add_circle_outline_sharp,color: Colors.orange.shade600, size: 30.0),
                    label: Text('Update', style: TextStyle(fontSize: 30.0,color: Colors.orange.shade600))
                ),
              ),
              // Container(
              //   //constraints:,
              //   margin: EdgeInsets.only(top: 10.0,bottom: 14.0),
              //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0),color: Colors.black),
              //   child: TextButton.icon(
              //       onPressed: () async {await getAndSaveUpdatedImage();},
              //       icon: Icon(Icons.filter,color: Colors.orange.shade600, size: 30.0),
              //       label: Text('Upload Image', style: TextStyle(fontSize: 30.0,color: Colors.orange.shade600))
              //   ),
              // ),
              // file == null
              //     ? Text('No Image Selected !',style: TextStyle(fontSize: 16.0,color: Colors.deepOrange))
              //     : Image.file(
              //   file!,
              //   height: 200.0,
              //   width: 200.0,
              // ),
            ],
          ),
        ),
      ),
    );
  }


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

  Future<void> updateNameInFriendships(List listOfKeys, dynamic newUpdatedNameMap) async
  {
    if(updateCounterForName<listOfKeys.length)
      {
        await fireBaseDatabaseReference.child('friendships').child(listOfKeys[updateCounterForName]).child(user!.uid).update(newUpdatedNameMap).then((value) async
        {
          updateCounterForName++;
          await updateNameInFriendships(listOfKeys, newUpdatedNameMap).then((value) {print("UserName Updated");});
        });
      }
    else
      {
        updateCounterForName=0;
        return;
      }
  }

  Future<void> updateNameInMessages(List listOfKeys, dynamic newUpdatedNameMap) async
  {
    if(updateCounterForName<listOfKeys.length)
    {
      await fireBaseDatabaseReference.child('messages').child(listOfKeys[updateCounterForName]).child(user!.uid).update(newUpdatedNameMap).then((value) async
      {
        updateCounterForName++;
        await updateNameInFriendships(listOfKeys, newUpdatedNameMap).whenComplete(() async {print("UserName Updated");});
      });
    }
    else
    {
      updateCounterForName=0;
      return;
    }
  }

  Future<void> updateImageInFriendships(List listOfKeys, dynamic newUpdatedImageMap) async
  {
    if(updateCounterForImage<listOfKeys.length)
    {
      await fireBaseDatabaseReference.child('friendships').child(listOfKeys[updateCounterForImage]).child(user!.uid).update(newUpdatedImageMap).then((value) async
      {
        updateCounterForImage++;
        await updateImageInFriendships(listOfKeys, newUpdatedImageMap).then((value){print("Image Updated");});
      });
    }
    else
    {
      updateCounterForImage=0;
      return;
    }
  }

  Future<void> updateImageInMessage(List listOfKeys, dynamic newUpdatedImageMap) async
  {
    if(updateCounterForImage<listOfKeys.length)
    {
      await fireBaseDatabaseReference.child('messages').child(listOfKeys[updateCounterForImage]).child(user!.uid).update(newUpdatedImageMap).then((value) async
      {
        updateCounterForImage++;
        await updateImageInFriendships(listOfKeys, newUpdatedImageMap).then((value){print("Image Updated");});
      });
    }
    else
    {
      updateCounterForImage=0;
      return;
    }
  }

  Future<List<String?>>? getListOfKeys() async
  {
    List<String?> listOfKeys=[];
    List<int> positions=[];

    await fireBaseDatabaseReference.child('friendships').once().then((DataSnapshot dataSnapshot)
    {
      Map<dynamic,dynamic> friendMapOfUsers;
      if(dataSnapshot.value !=null)
      {
        friendMapOfUsers=dataSnapshot.value;
        int i=0;
        friendMapOfUsers.values.forEach((element)
        {
          Map<dynamic,dynamic> friendsMapOfASingleUser=element; //print("------>$friendsMapOfASingleUser");
          friendsMapOfASingleUser.keys.forEach((key)
          {
            if(key==user!.uid)
              positions.add(i);
          });
          i++;
        });
        print(positions);
        int j=0,k=0;
        if(positions.isNotEmpty)
        {
          friendMapOfUsers.keys.forEach((keys)
          {
            if(positions[j]==k)
            {
              listOfKeys.add(keys);
              if(j+1<positions.length)
                j++;
            }
            k++;
          });
        }
      }
    });
    return listOfKeys;
  }

  Future<void >validateOurFormAndSaveUserData() async //validating user input and saving user data in shared preference.
  {
    Map<String,dynamic> newUpdatedName={};
    if(checkUserData.currentState!.validate())
    {
      EasyLoading.show(status: 'Updating UserName');
      Map<String,dynamic> newUpdatedNames=
      {
        "name": "${newFirstName.toString().trim()} ${newLastName.toString().trim()}",
        "username":"${newProfileName.toString().trim()}"
      };
      newUpdatedName= {"name": "${newFirstName.toString().trim()} ${newLastName.toString().trim()}",};
      try
          {
            fireBaseDatabaseReference.child('users').child('${user!.uid}').update(newUpdatedNames).then((_) async
            {  //ignore the exception.
              print('Names Updated in users collection');
            });
            await getListOfKeys()!.then((requiredList) async
            {
              print(requiredList);
              await updateNameInFriendships(requiredList,newUpdatedName).whenComplete(() async
              {
                Map<String,dynamic> newUpdatedMap= {  "friendName":newUpdatedName["name"] };
                await updateNameInMessages(requiredList,newUpdatedMap).whenComplete(()
                {
                  EasyLoading.dismiss();
                  EasyLoading.showToast("Username Updated",toastPosition: EasyLoadingToastPosition.bottom,duration: Duration(seconds: 1));
                  print("All Done");
                });
              });
            });
            SharedPreferences.getInstance().then((sp)
            {
              sharedPreferences=sp;
              sharedPreferences!.setString("name", "${newFirstName.toString().trim()} ${newLastName.toString().trim()}");
              sharedPreferences!.setString("username", "${newProfileName.toString().trim()}");
            });
          }catch(exception)
            {
              EasyLoading.dismiss();
              EasyLoading.showToast("Error Occurred. Check your Connection",toastPosition: EasyLoadingToastPosition.bottom,duration: Duration(seconds: 1));
            }
    }
  }

  Future<void> getAndSaveUpdatedImage() async
  {
    String imageFileName=user!.uid;
    final ImagePicker _picker=ImagePicker();
    Map<String,dynamic> newProfilePicDownloadURL={};
    final Reference imageReference=FirebaseStorage.instance.ref().child("ProfileImage/$imageFileName.jpg");
    XFile? imageXFile=await _picker.pickImage(source: ImageSource.gallery);  //var imageFile=await FilePicker.platform.pickFiles(type: FileType.image) ;

    if(imageXFile!=null)
      {
        EasyLoading.show(status: "Uploading Image");
        try
            {
              await imageReference.putFile(File(imageXFile.path)).then((_) async
              {
                await imageReference.getDownloadURL().then((imageURL) async
                {
                  newProfilePicDownloadURL={"profilePic":imageURL};
                  setState((){newDownloadUrlImage=imageURL;});
                  await fireBaseDatabaseReference.child('users').child('${user!.uid}').update(newProfilePicDownloadURL).then((_) async
                  {
                    print('image Uploaded in users collection');
                  });
                  await getListOfKeys()!.then((requiredList) async
                  {
                    print(requiredList);
                    await updateImageInFriendships(requiredList,newProfilePicDownloadURL).whenComplete(() async
                    {
                      Map<String,dynamic> newUpdatedMap=
                      {
                        "friendsPic":newProfilePicDownloadURL["profilePic"]
                      };
                      await updateImageInMessage(requiredList,newUpdatedMap).whenComplete(()
                      {
                        print("All Done");
                        file=null;
                        EasyLoading.dismiss();
                        EasyLoading.showToast("Image Updated",toastPosition: EasyLoadingToastPosition.bottom,duration: Duration(seconds: 1));
                      });
                    });
                  });
                  SharedPreferences.getInstance().then((sp)
                  {
                    sharedPreferences=sp;
                    sharedPreferences!.setString('imageId', imageURL);
                  });
                });
              }); //imageFile
            }catch(exception)
              {
                EasyLoading.dismiss();
                EasyLoading.showToast("Error Occurred. Check your Connection",toastPosition: EasyLoadingToastPosition.bottom,duration: Duration(seconds: 1));
              }
      }
  }

}
