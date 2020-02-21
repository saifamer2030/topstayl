import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import './constants/colors.dart';
import './helper/appLocalization.dart';
import './models/products_model.dart';
import './providers/brands_provider.dart';
import './providers/cart_provider.dart';
import './providers/languages_provider.dart';
import './providers/order_provider.dart';
import './providers/payment_provider.dart';
import './providers/products_provider.dart';
import './providers/search_provider.dart';
import './providers/user_provider.dart';
import './screens/app_lanugages.dart';
import './screens/cart_screen.dart';
import './screens/categories_screen.dart';
import './screens/change_password_otp.dart';
import './screens/confirm_otp.dart';
import './screens/customer_support.dart';
import './screens/forget_password.dart';
import './screens/home_screen.dart';
import './screens/login_screen.dart';
import './screens/mywish_list_screen.dart';
import './screens/orders_screen.dart';
import './screens/otp_screen_in_address.dart';
import './screens/otp_screen_in_forget_pass.dart';
import './screens/phone_otp_in_delivery.dart';
import './screens/privacy_policy_screen.dart';
import './screens/profile_screen.dart';
import './screens/register_screen.dart';
import './screens/splash_screen.dart';
import './screens/tabs_screen.dart';
import 'models/product_details_model.dart';

void main() async {
  runApp(MyApp());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AppLanguageProvider()),
        ChangeNotifierProvider.value(value: ProductsProvider()),
        ChangeNotifierProvider.value(value: CartItemProvider()),
        ChangeNotifierProvider.value(value: OrdersProvider()),
        ChangeNotifierProvider.value(value: UserProvider()),
        ChangeNotifierProvider.value(value: ProductsModel()),
        ChangeNotifierProvider.value(value: ProductDetailsModel()),
        ChangeNotifierProvider.value(value: PaymentProvider()),
        ChangeNotifierProvider.value(value: BrandsProvider()),
        ChangeNotifierProvider.value(value: SearchProvider()),
      ],
      child: Consumer<AppLanguageProvider>(
        builder: (context, model, child) {
          return MaterialApp(
            color: Colors.white,
            locale: model.fetchLocale() ?? Locale('ar', ''),
            supportedLocales: [
              const Locale('ar'),
              const Locale('en', 'US'),
            ],
            localizationsDelegates: [
              AppLocalization.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              DefaultCupertinoLocalizations.delegate
            ],
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
            debugShowCheckedModeBanner: false,
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
              CustomOtpScreen.routeName: (ctx) => CustomOtpScreen(),
              CustomOtpScreenInForgetPass.routeName: (ctx) =>
                  CustomOtpScreenInForgetPass(),
              CustomerSupport.routeName: (ctx) => CustomerSupport(),
              PrivacyPolicyScreen.routeName: (ctx) => PrivacyPolicyScreen(),
              ChangePasswordOtpScreen.routeName: (ctx) =>
                  ChangePasswordOtpScreen(),
            },
          );
        },
      ),
    );
  }
}
