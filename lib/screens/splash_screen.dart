import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:topstyle/screens/app_lanugages.dart';
import 'package:topstyle/screens/tabs_screen.dart';
import 'cart_screen.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = 'splash-screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

//db ref
final fcmReference = FirebaseDatabase.instance.reference().child('Fcm-Token');

class _SplashScreenState extends State<SplashScreen> {


  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();

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
    Future.delayed(Duration(seconds: 3), () => init());

    // get Token :
    firebaseMessaging.getToken().then((token) {
      update(token);
    }).then((_) {});


    super.initState();


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

    DatabaseReference databaseReference = new FirebaseDatabase().reference();
    fcmReference.push().set({"Token": token});
  }


}
