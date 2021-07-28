import 'package:fitcarib/base/presenter/base_presenter.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';


abstract class SplashContract extends BaseContract
{
  void toWelcomeScreen();
  void toActivityScreen();
}

class SplashPresenter extends BasePresenter
{
  SplashPresenter(BaseContract view) : super(view);




  void timer() async
  {
    SharedPreferences prefs= await  SharedPreferences.getInstance();
    Timer(Duration(milliseconds: 3000),(){
      if(prefs.getString("name") == null || prefs.getString("imageId") == null){
        (view as SplashContract).toWelcomeScreen();
      }
      else{
        (view as SplashContract).toActivityScreen();
      }
    });
  }

  void hideStatusBar()
  {
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

}
