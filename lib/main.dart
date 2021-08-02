import 'package:fitcarib/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:fitcarib/ui/splash/splash.dart';
import 'package:firebase_core/firebase_core.dart' ;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


void main()async
{
 // SharedPreferences.setMockInitialValues({});
  AndroidNotificationChannel channel=AndroidNotificationChannel('high_importance channel', 'High Importance Notifications', 'This Channel is Used for important notifications.',importance: Importance.high,playSound: true);
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!.createNotificationChannel(channel);

  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  final InitializationSettings initializationSettings=InitializationSettings(android: initializationSettingsAndroid);


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
