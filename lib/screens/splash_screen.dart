import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:topstyle/screens/app_lanugages.dart';
import 'package:topstyle/screens/tabs_screen.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = 'splash-screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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
}
