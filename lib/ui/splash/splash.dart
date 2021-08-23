import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:fitcarib/ui/myactivity/activity.dart';
import 'package:fitcarib/ui/welcome/welcome.dart';

class SplashScreen extends StatefulWidget
{
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
{
  SharedPreferences? sharedPreferences;
  List<dynamic> vehicleList = [];
  var name;
  var imageId;
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: const DecorationImage(
                fit: BoxFit.fill,
                image: const AssetImage("assets/images/splash.png"),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child:Text("Copyright \u00a9 ${DateTime.now().year} · FitCarib, LLC"),)
        ],
      ),
    );
  }

  @override
  void initState()
  {
    super.initState();
    timer();
  }


  void timer()
  {
    SharedPreferences.getInstance().then((sp)
    {
      sharedPreferences = sp;

        name = sharedPreferences!.getString("name");
        imageId = sharedPreferences!.get("imageId");

    });
    Timer(Duration(seconds: 2),()
    {
      if(name == null || imageId == null)
        Navigator.push(context,MaterialPageRoute(builder: (context) => WelcomeScreen()));
      else
        Navigator.push(context,MaterialPageRoute(builder: (context) => ActivityScreen()));
    });
  }

}