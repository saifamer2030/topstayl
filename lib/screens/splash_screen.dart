import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topstyle/models/home_page_model.dart';
import 'package:topstyle/providers/languages_provider.dart';
import 'package:topstyle/providers/products_provider.dart';
import 'package:topstyle/providers/user_provider.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = 'splash-screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AppLanguageProvider _languages = AppLanguageProvider();
  final UserProvider userProvider = UserProvider();
  HomePageModel homePageModel;
  fetchHomeData() async {
    print('Home calling');
    var token = await userProvider.isAuthenticated();
    var lang = _languages.appLocal.toString();
    Provider.of<ProductsProvider>(context, listen: false)
        .fetchAllProducts(lang, token['Authorization'])
        .then((data) {
      homePageModel = data;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchHomeData();
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
