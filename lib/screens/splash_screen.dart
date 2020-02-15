import 'package:flutter/material.dart';
import 'package:topstyle/providers/languages_provider.dart';
import 'package:topstyle/screens/tabs_screen.dart';

import '../screens/app_lanugages.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = 'splash-screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AppLanguageProvider _languages = AppLanguageProvider();

  _isLanguageChosen() async {
    var locale = _languages.fetchLocale();
    if (locale != null) {
      Navigator.of(context).pushReplacementNamed(TabsScreen.routeName);
    } else {
      Navigator.pushReplacementNamed(context, LanguagesScreen.routeName);
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () => _isLanguageChosen());
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context);
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
