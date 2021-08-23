import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fitcarib/ui/splash/splash.dart';
import 'package:firebase_core/firebase_core.dart' ;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

AndroidNotificationChannel? channel; // Creating a [AndroidNotificationChannel] for heads up notifications
FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin; //

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async
{
  // it initializes the firebase app when the notification is received in the background.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

void main()async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if(!kIsWeb)  // kIsWeb- a constant which is true when we run pro
    {
    channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        'This channel is used for important notifications.', // description
        importance: Importance.high);

    flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin();
    // We use this channel in the `AndroidManifest.xml` file to override the
    // default FCM channel to enable heads up notifications.
    flutterLocalNotificationsPlugin!.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!.createNotificationChannel(channel!);
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true,badge: true,sound: true);

    }
  runApp(
      MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(fontFamily: 'Schuyler'),
          initialRoute: '/',
          routes: <String, WidgetBuilder>
          {
            '/': (BuildContext context) => SplashScreen()
          }
        ));
}
