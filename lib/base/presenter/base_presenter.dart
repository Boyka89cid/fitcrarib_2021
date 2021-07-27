import 'dart:async';

import 'package:fitcarib/base/model/base_model.dart';
import 'package:fitcarib/base/model/error_response.dart';
import 'package:fitcarib/server/server_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:simple_permissions/simple_permissions.dart';
//import'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';

abstract class BaseContract {
  void onError(String messageError);
  void showMessage(String message);
}

abstract class BasePresenter {
  final BaseContract? view;
  ServerAPI? api;
  bool isDispose = false;
  final FirebaseAuth _fAuth = FirebaseAuth.instance;
  late SharedPreferences sharedPreferences;
  final FitcaribReference = FirebaseDatabase.instance.reference();


  BasePresenter(this.view) {
    api = ServerAPI();
  }

  /*Future signout() async
  {
    var facebookLogin = FacebookLogin();
    var data =   _fAuth.currentUser;
      if(data != null){
        facebookLogin.logOut();
        _fAuth.signOut();
        print("signed out");
      }

  }*/

  void dispose() {
    isDispose = true;
  }

  void handleResponse(String message) {
    if (!isDispose) {
      if (message == "Success" || message == "Updated")
        view!.showMessage(message);
      else
        view!.onError(message);
    }
  }

  bool checkAuthorized(String message) {
    if (message == "Not Authorized") {
      return false;
    }
    return true;
  }

  void checkError(res) {
    if (res != null) {
      if (res is ErrorResponse)
        view!.onError(res.message ?? "Some Error has occurred");
      else if (res is String)
        view!.onError(res ?? "Some Error has occurred");
      else
        view!.onError("Some Error has occurred");
    } else
      view!.onError("Some Error has occurred");
  }

  String encode(BaseModel model) {
    return api!.encode(model);
  }


  dynamic decode(String data) {
    return api!.decode(data);
  }

  // Future<bool> requestPermission(PermissionGroup permission) async {
  //   final List<PermissionGroup> permissions = <PermissionGroup>[permission];
  //   final Map<PermissionGroup, PermissionStatus> permissionRequestResult =
  //       await PermissionHandler().requestPermissions(permissions);
  //   PermissionStatus _permissionStatus = permissionRequestResult[permission];
  //   return _permissionStatus == PermissionStatus.granted;
  // }
//  Future<bool> requestPermission(Permission permission) async {
//    final res = await SimplePermissions.requestPermission(permission);
//    print("RE-> $res");
//    return res == PermissionStatus.authorized;
//  }



  Future<String?> getName()async
  {
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return prefs.getString("name");
  }

  dynamic getImage() async
  {
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return await prefs.get("imageId");
  }

  dynamic getUsername() async
  {
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return await prefs.get("username");
  }

  void clearData() async {
    SharedPreferences prefs=await SharedPreferences.getInstance();
    prefs.clear();
  }

}
