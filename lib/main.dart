import 'package:flutter/material.dart';
import 'package:fitcarib/ui/splash/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart' ;


void main()async{
 // SharedPreferences.setMockInitialValues({});
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp();
  runApp(new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Schuyler'),
      initialRoute: '/',
      routes: <String, WidgetBuilder>
      {
        '/': (BuildContext context) => SplashScreen()
      }
      ));
}
