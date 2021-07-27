import 'dart:async';
import 'dart:io';
import 'package:fitcarib/base/presenter/base_presenter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:dbcrypt/dbcrypt.dart';

abstract class SignUpContract extends BaseContract {
  void toLoginScreen();
}

class SignUpPresenter extends BasePresenter {
  SignUpPresenter(BaseContract view) : super(view);

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  DBCrypt dBCrypt = DBCrypt();

  final FitcaribReference = FirebaseDatabase.instance.reference().child('users');

  Reference _reference = FirebaseStorage.instance.ref();

  void toLogin()
  {
    (view as SignUpContract).toLoginScreen();
  }

  void _add(dynamic obj, dynamic username, dynamic fullName, dynamic imageUrl) async{
    Map<String,dynamic> data = <String, dynamic>{
      "name" : fullName,
      "email" : obj.email,
      "profilePic" : imageUrl,
      "username" : username,
      "activity" : 0,
      "friends" : 0,
      "groups" : 0,
      "isSocial" : false,
      "flag" : true,
    };
    FitcaribReference.child(obj.uid).update(data).whenComplete((){
      print("data added");
      toLogin();
    }).catchError((e) => print(e));
  }

  Future<void> SignUp(String username, String email,String choosePassword, String confirmPassword, String fullName, File image) async {
    if(username == null || choosePassword == null || confirmPassword == null || fullName == null || image == null || email == null){
      (view as SignUpContract).showMessage("All Fields must be filled");
    }
    else{
      if(choosePassword == confirmPassword){
        final user = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: choosePassword);
        final String fileName = (user.user!.uid).toString();
        _reference = _reference.child("ProfileImage/$fileName.jpg");
        if(user.user!.uid != null){
          String downloadUrl;
          (view as SignUpContract).showMessage("Account Succesfully Created!\nGo to login.");
          final uploadTask = _reference.putFile(image);
          final taskSnapshot = await uploadTask.whenComplete(() => null);
          downloadUrl = await _reference.getDownloadURL();
          if(downloadUrl != null){
            _add(user,username,fullName,downloadUrl);
          }
          else {
            (view as SignUpContract).showMessage("Unable to upload image.");
          }
        }
        else{
          (view as SignUpContract).showMessage("Email already exists!");
        }
      }
      else{
        (view as SignUpContract).showMessage("Password didn't matched.");
      }
    }
  }

  Future<String> getCurrentUser() async{
    final user = await _firebaseAuth.currentUser;
    return user!.uid;
  }



  Future<void> signOut() async{
    _firebaseAuth.signOut();
  }

}