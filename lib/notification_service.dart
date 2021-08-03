
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationService
{

  AndroidNotificationChannel channel=AndroidNotificationChannel('high_importance channel', 'High Importance Notifications', 'This Channel is Used for important notifications.',importance: Importance.high,playSound: true);
  //FlutterLocalNotificationsPlugin().resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>().createNotificationChannel(channel);
  //await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!.createNotificationChannel(channel);
  static Future selectNotification(String? payload) async
  {
    if (payload != null)
      print('notification payload: $payload');
      //await Navigator.push(context, MaterialPageRoute<void>(builder: (context) => SecondScreen(payload)));
  }
}
// SharedPreferences.setMockInitialValues({});
//AndroidNotificationChannel channel=AndroidNotificationChannel('high_importance channel', 'High Importance Notifications', 'This Channel is Used for important notifications.',importance: Importance.high,playSound: true);
//FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin();
//await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!.createNotificationChannel(channel);

//const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
//final InitializationSettings initializationSettings=InitializationSettings(android: initializationSettingsAndroid);