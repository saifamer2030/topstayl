import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:topstyle/screens/app_lanugages.dart';
import 'package:topstyle/screens/tabs_screen.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = 'splash-screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

//db ref
final fcmReference = FirebaseDatabase.instance.reference().child('Fcm-Token');

class _SplashScreenState extends State<SplashScreen> {
  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  init() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getString('language_code') != null) {
      Navigator.of(context).pushReplacementNamed(TabsScreen.routeName);
    } else {
      Navigator.pushReplacementNamed(context, LanguagesScreen.routeName);
    }
  }

  @override
  void initState() {
    registerNotification();
    configLocalNotification();
    // get Token :
    firebaseMessaging.getToken().then((token) {
      update(token);
    }).then((_) {});
    super.initState();
    Future.delayed(Duration(seconds: 2), () => init());
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/splash.jpg'),
                fit: BoxFit.fill)),
//        child: Center(
//          child: Image.asset(
//            'assets/images/logo.jpg',
//            width: deviceSize.size.width / 2,
//            height: deviceSize.size.height / 12,
//            fit: BoxFit.fitHeight,
//          ),
//        ),
      ),
    );
  }



  update(String token) async {
    fcmReference.child(token).set({"Token": token});
  }

  void registerNotification() {
    firebaseMessaging.requestNotificationPermissions();

    firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print('onMessage: $message');
      showNotification(message['notification']);
      return;
    }, onResume: (Map<String, dynamic> message) {
      print('onResume: $message');
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print('onLaunch: $message');
      return;
    });
  }

  void configLocalNotification() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void showNotification(message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid
          ? 'ccom.topstylesa.topstyle'
          : 'com.topstylesa.topstyle',
      'topstyle',
      'your channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, message['title'].toString(),
        message['body'].toString(), platformChannelSpecifics,
        payload: json.encode(message));
  }
}
