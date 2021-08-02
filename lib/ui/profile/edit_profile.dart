import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fitcarib/ui/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget
{
  //EditProfile({Key? key,}) : super(key: key);
  @override
  State<StatefulWidget> createState()=>EditProfileState();
}
class EditProfileState extends State<EditProfile>
{
  GlobalKey<FormState> checkUserData=GlobalKey<FormState>();
  TextEditingController newFirstName=TextEditingController();
  TextEditingController newLastName=TextEditingController();
  TextEditingController newProfileName=TextEditingController();
  SharedPreferences? sharedPreferences;
  @override
  Widget build(BuildContext context)
  {
    var width=MediaQuery.of(context).size.width;
    var height=MediaQuery.of(context).size.height;
    //GlobalKey<FormState> checkUserData=GlobalKey<FormState>();  //it gets created again and again.
    validateOurFormAndSaveUserData() //validating user input and saving user data in shared preference.
    {
      if(checkUserData.currentState!.validate())
        {
          SharedPreferences.getInstance().then((sp)
          {
            sharedPreferences=sp;
            sharedPreferences!.setString("name", "${newFirstName.text.toString().trim()} ${newLastName.text.toString().trim()}");
            sharedPreferences!.setString("username", "${newProfileName.text.toString().trim()}");
            String name = sharedPreferences!.getString("name") as String;
            print(name);
          }).then((value){print('Data Updated');});
        }
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Edit Your Profile',style: TextStyle(color: Colors.orange)),
          centerTitle: true,
          leading: TextButton.icon(onPressed: ()=>Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ProfileScreen())),
              icon: Icon(Icons.backspace_outlined,color: Colors.orange,),
              label: Text("")
          )
        ),
        body: SingleChildScrollView(
          //physics: ,
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            //mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Form(
                  key: checkUserData,
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: width * .06,right: width * .06,top: height * .1),
                        child: TextFormField(
                          validator: (value)
                          {
                            if(value==null || value.isEmpty)
                              return 'Please Enter Some Text';
                            else
                              return null;
                          },
                          autofocus: true,
                          maxLength: 30,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          controller: newFirstName,
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                                borderRadius:BorderRadius.circular(2.0),
                                borderSide: BorderSide(color: Colors.black)
                            ),
                            focusColor: Colors.deepOrange,
                            hintText: 'Enter Your New First Name Here',
                            hintStyle: TextStyle(color: Colors.deepOrange),
                            labelText: 'First Name',
                            labelStyle: TextStyle(color: Colors.deepOrange)
                          ),
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
                          controller: newLastName,
                          decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                  borderRadius:BorderRadius.circular(2.0),
                                  borderSide: BorderSide(color: Colors.black)
                              ),
                              focusColor: Colors.deepOrange,
                              hintText: 'Enter Your New Last Name Here',
                              hintStyle: TextStyle(color: Colors.deepOrange),
                              labelText: 'Last Name',
                              labelStyle: TextStyle(color: Colors.deepOrange)
                          ),
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
                          controller: newProfileName,
                          decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                  borderRadius:BorderRadius.circular(2.0),
                                  borderSide: BorderSide(color: Colors.black)
                              ),
                              focusColor: Colors.deepOrange,
                              hintText: 'Enter Your New Profile Name Here',
                              hintStyle: TextStyle(color: Colors.deepOrange),
                              labelText: 'Profile Name',
                              labelStyle: TextStyle(color: Colors.deepOrange)
                          ),
                        ),
                      ),
                    ],
                  )
              ),
              Container(
                //constraints:,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0),color: Colors.black),
                child: TextButton.icon(
                    onPressed: () {validateOurFormAndSaveUserData();},
                    icon: Icon(Icons.add_circle_outline_sharp,color: Colors.orange.shade600, size: 30.0),
                    label: Text('Add', style: TextStyle(fontSize: 30.0,color: Colors.orange.shade600))
                ),
              ),
              Container(
                //constraints:,
                margin: EdgeInsets.only(top: 10.0),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0),color: Colors.black),
                child: TextButton.icon(
                    onPressed: () async
                    {
                      String? imageDownloadUrl;
                      User? user=FirebaseAuth.instance.currentUser;
                      String imageFileName=user!.uid.toString();
                      final ImagePicker _picker=ImagePicker();
                      //var imageFile=await FilePicker.platform.pickFiles(type: FileType.image) ;//?
                      var imageXFile=await _picker.pickImage(source: ImageSource.gallery);  //?
                      final Reference imageReference=FirebaseStorage.instance.ref().child("ProfileImage/$imageFileName.jpg");
                      await imageReference.putFile(File(imageXFile!.path)); //imageFile
                      imageDownloadUrl=await imageReference.getDownloadURL();
                      SharedPreferences.getInstance().then((sp)
                      {
                        sharedPreferences=sp;
                        sharedPreferences!.setString("imageId",imageDownloadUrl!);
                        print('image Uploaded');
                      });

                    },
                    icon: Icon(Icons.filter,color: Colors.orange.shade600, size: 30.0),
                    label: Text('Upload Image', style: TextStyle(fontSize: 30.0,color: Colors.orange.shade600))
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}