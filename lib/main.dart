import 'package:cleanx/Splash/Splash.dart';
import 'package:cleanx/const/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  importance: Importance.max,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

var initializationSettingsAndroid;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  initializationSettingsAndroid = new AndroidInitializationSettings('splash1');
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification notification = message.notification;
    AndroidNotification android = message.notification?.android;
    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              icon: android?.smallIcon,
              styleInformation: BigTextStyleInformation(''),
              importance: Importance.max,
            ),
          ));
    }
  });

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);
  runApp(MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.custom
    ..maskColor = Color.fromARGB(255, 0, 222, 233).withOpacity(0.5)
    ..displayDuration = const Duration(milliseconds: 2000)
    // ..indicatorSize = 45.0
    ..radius = 100
    // ..errorWidget

    ..backgroundColor = Colors.white
    ..progressColor = Colors.white
    ..indicatorColor = mainColor
    ..textColor = Colors.black
    ..animationStyle = EasyLoadingAnimationStyle.scale
    ..userInteractions = false
    ..dismissOnTap = false
    ..indicatorType = EasyLoadingIndicatorType.circle;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
      title: 'Cleanx',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: "Raleway"),
      home: Splash(),
    );
  }
}
