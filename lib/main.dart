import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:topstyle/models/products_model.dart';
import 'package:topstyle/providers/brands_provider.dart';
import 'package:topstyle/providers/payment_provider.dart';
import 'package:topstyle/providers/search_provider.dart';
import 'package:topstyle/screens/customer_support.dart';
import 'package:topstyle/screens/phone_opt_in_delivery.dart';

import './constants/colors.dart';
import './providers/cart_provider.dart';
import './providers/languages_provider.dart';
import './providers/order_provider.dart';
import './providers/products_provider.dart';
import './providers/user_provider.dart';
import './screens/app_lanugages.dart';
import './screens/cart_screen.dart';
import './screens/categories_screen.dart';
import './screens/change_password_otp.dart';
import './screens/confirm_otp.dart';
import './screens/forget_password.dart';
import './screens/home_screen.dart';
import './screens/login_screen.dart';
import './screens/mywish_list_screen.dart';
import './screens/orders_screen.dart';
import './screens/profile_screen.dart';
import './screens/register_screen.dart';
import './screens/splash_screen.dart';
import './screens/tabs_screen.dart';
import 'helper/appLocalization.dart';
import 'models/product_details_model.dart';

void main() async {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: ProductsProvider()),
          ChangeNotifierProvider.value(value: CartItemProvider()),
          ChangeNotifierProvider.value(value: OrdersProvider()),
          ChangeNotifierProvider.value(value: UserProvider()),
          ChangeNotifierProvider.value(value: AppLanguageProvider()),
          ChangeNotifierProvider.value(value: ProductsModel()),
          ChangeNotifierProvider.value(value: ProductDetailsModel()),
          ChangeNotifierProvider.value(value: PaymentProvider()),
          ChangeNotifierProvider.value(value: BrandsProvider()),
          ChangeNotifierProvider.value(value: SearchProvider()),
        ],
        child: Consumer<AppLanguageProvider>(builder: (context, model, child) {
          return MaterialApp(
            locale: model.fetchLocale() ?? Locale('ar', ''),
            supportedLocales: [
              Locale('en', 'US'),
              Locale('ar', ''),
            ],
            localizationsDelegates: [
              AppLocalization.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              DefaultCupertinoLocalizations.delegate
            ],
            debugShowCheckedModeBanner: false,
            title: "TOP STYLE",
            theme: ThemeData(
              primaryColor: CustomColors.kPrimaryColor,
              accentColor: CustomColors.kAccentColor,
              scaffoldBackgroundColor: CustomColors.kScaffoldBGColor,
              dividerColor: Color(0xff868686),
              indicatorColor: CustomColors.kAccentColor,
              fontFamily: 'tajawal',
              textTheme: TextTheme(
                caption: TextStyle(fontSize: 16.0),
                title: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                body1: TextStyle(fontSize: 14),
                body2: TextStyle(fontSize: 12),
                button: TextStyle(fontSize: 16),
                headline: TextStyle(
                  fontSize: 16,
                ),
                subhead: TextStyle(fontSize: 14),
              ),
            ),
            initialRoute: SplashScreen.routeName,
            routes: {
              SplashScreen.routeName: (ctx) => SplashScreen(),
              TabsScreen.routeName: (ctx) => TabsScreen(),
              HomeScreen.routeName: (ctx) => HomeScreen(),
              CategoriesScreen.routeName: (ctx) => CategoriesScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              ProfileScreen.routeName: (ctx) => ProfileScreen(),
              LoginScreen.routeName: (ctx) => LoginScreen(),
              RegisterScreen.routeName: (ctx) => RegisterScreen(),
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              MyWishListScreen.routeName: (ctx) => MyWishListScreen(),
              LanguagesScreen.routeName: (ctx) => LanguagesScreen(),
              ForgetPasswordScreen.routeName: (ctx) => ForgetPasswordScreen(),
              ConfirmOtpScreen.routeName: (ctx) => ConfirmOtpScreen(),
              PhoneOtpInDelivery.routeName: (ctx) => PhoneOtpInDelivery(),
              CustomerSupport.routeName: (ctx) => CustomerSupport(),
              ChangePasswordOtpScreen.routeName: (ctx) =>
                  ChangePasswordOtpScreen(),
            }, //end route
          );
        })); //multi provider
  }
}
