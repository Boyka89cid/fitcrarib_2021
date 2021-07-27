import 'package:firebase_database/firebase_database.dart';
import 'package:fitcarib/base/model/base_model.dart';
import 'dart:convert';

class UserData extends BaseModel {
  dynamic uid;
  dynamic name;
  dynamic email;
  dynamic password;
  dynamic username;
  dynamic isSocial;
  dynamic flag;

  UserData(this.uid, this.name, this.email, this.password, this.username,this.isSocial, this.flag);

  UserData.map(dynamic obj) {
    this.uid = obj['uid'];
    this.email = obj['email'];
    this.name = obj['name'];
    this.password = obj['password'];
    this.username = obj['username'];
    this.isSocial = obj['isSocial'];
    this.flag = obj['flag'];
  }

  dynamic get id => uid;
  dynamic get email1 => email;
  dynamic get name1 => name;
  dynamic get password1 => password;
  dynamic get username1 => username;
  dynamic get isSocial1 => isSocial;
  dynamic get flag1 => flag;



  UserData.fromSnapshot(DataSnapshot snapshot) {
    uid = snapshot.value['id'];
    email = snapshot.value['email1'];
    name = snapshot.value['name1'];
    password = snapshot.value['password1'];
    username = snapshot.value['username1'];
    isSocial = snapshot.value['isSocial'];
    flag = snapshot.value['flag1'];
  }
}
