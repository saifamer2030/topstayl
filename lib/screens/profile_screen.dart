import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:topstyle/constants/colors.dart';
import 'package:topstyle/helper/appLocalization.dart';
import 'package:topstyle/helper/size_config.dart';
import 'package:topstyle/providers/user_provider.dart';
import 'package:topstyle/screens/customer_support.dart';
import 'package:topstyle/screens/login_screen.dart';
import 'package:topstyle/screens/privacy_policy_screen.dart';
import 'package:topstyle/screens/register_screen.dart';
import 'package:topstyle/widgets/adaptive_progress_indecator.dart';

import '../screens/mywish_list_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/setting_choice_screen.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = 'profile';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    checkLoginStatus();
    super.initState();
  }

  var userData;
  bool _isLoading = true;
  bool _isUserLoggedIn = false;

  checkLoginStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString('userData') == null) {
      // User Not Logged IN
      setState(() {
        _isUserLoggedIn = false;
        _isLoading = false;
      });
    } else {
      // User Is Logged In
      setState(() {
        _isUserLoggedIn = true;
        _isLoading = false;
      });

      userData = jsonDecode(sharedPreferences.getString('userData')) as Map;
    }
//    print("$_isUserLoggedIn and Name is :" + userData['name']);
  }

  ScreenConfig screenConfig;
  WidgetSize widgetSize;
  @override
  Widget build(BuildContext context) {
    screenConfig = ScreenConfig(context);
    widgetSize = WidgetSize(screenConfig);
    return _isLoading
        ? Center(
            child: AdaptiveProgressIndicator(),
          )
        : SingleChildScrollView(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 15.0, bottom: 10.0),
                width: 60.0,
                height: 60.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                        image: AssetImage('assets/images/profile.png'),
                        fit: BoxFit.fitHeight)),
              ),
              Text(
                _isUserLoggedIn
                    ? userData['name']
                    : AppLocalization.of(context).translate('not_logged_in'),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: widgetSize.mainTitle,
                    color: CustomColors.kTabBarIconColor),
              ),
              _isUserLoggedIn
                  ? Text(
                      userData['email'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: widgetSize.subTitle,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                LoginScreen.routeName,
                                arguments: 'home');
                            SharedPreferences.getInstance().then((prefs) {
                              prefs.setString("redirection", 'toHome');
                            });
                          },
                          child: Text(
                            "${AppLocalization.of(context).translate('login_form_title')} ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: widgetSize.subTitle,
                                color: Theme.of(context).accentColor),
                          ),
                        ),
                        Text(" | "),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(RegisterScreen.routeName);
                            SharedPreferences.getInstance().then((prefs) {
                              prefs.setString("redirection", 'toHome');
                            });
                          },
                          child: Text(
                            " ${AppLocalization.of(context).translate('registration_from_title')}",
                            style: TextStyle(
                                fontSize: widgetSize.subTitle,
                                color: Theme.of(context).accentColor),
                          ),
                        )
                      ],
                    ),
              SizedBox(
                height: 15.0,
              ),
              _isUserLoggedIn
                  ? Container(
                      margin: const EdgeInsets.only(
                          left: 16.0, right: 16.0, top: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(MyWishListScreen.routeName);
                        },
                        leading: Icon(Icons.favorite_border,
                            color: CustomColors.kTabBarIconColor),
                        title: Text(
                          AppLocalization.of(context)
                              .translate("wish_list_profile_page"),
                          style: TextStyle(
                              color: CustomColors.kTabBarIconColor,
                              fontSize: widgetSize.content),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios,
                            size: widgetSize.content,
                            color: CustomColors.kTabBarIconColor),
                      ),
                    )
                  : Container(),
              _isUserLoggedIn
                  ? Divider(
                      height: 1.0,
                      color: CustomColors.kPCardColor,
                      thickness: 1.5,
                    )
                  : Container(),
              _isUserLoggedIn
                  ? Container(
                      margin: const EdgeInsets.only(
                          left: 16.0, right: 16.0, top: 10.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white),
                      child: ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, OrdersScreen.routeName);
                        },
                        leading: Icon(Icons.assignment,
                            color: CustomColors.kTabBarIconColor),
                        title: Text(
                          AppLocalization.of(context)
                              .translate("my_order_in_profile_page"),
                          style: TextStyle(
                            color: CustomColors.kTabBarIconColor,
                            fontSize: widgetSize.content,
                          ),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios,
                            size: widgetSize.content,
                            color: CustomColors.kTabBarIconColor),
                      ),
                    )
                  : Container(),
              _isUserLoggedIn
                  ? Divider(
                      height: 1.0,
                      color: CustomColors.kPCardColor,
                      thickness: 1.5,
                    )
                  : Container(),
              Container(
                margin:
                    const EdgeInsets.only(left: 16.0, right: 16.0, top: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                ),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) => SettingChoiceScreen()));
                  },
                  leading: Icon(Icons.settings,
                      color: CustomColors.kTabBarIconColor),
                  title: Text(
                    AppLocalization.of(context).translate("settings"),
                    style: TextStyle(
                      color: CustomColors.kTabBarIconColor,
                      fontSize: widgetSize.content,
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios,
                      size: widgetSize.content,
                      color: CustomColors.kTabBarIconColor),
                ),
              ),
              Divider(
                height: 1.0,
                color: CustomColors.kPCardColor,
                thickness: 1.5,
              ),
              Container(
                margin:
                    const EdgeInsets.only(left: 16.0, right: 16.0, top: 10.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white),
                child: ListTile(
                  onTap: () {
                    final RenderBox box = context.findRenderObject();
                    Share.share(
                        'Download The Top Style App and Enjoy Shopping \n Our App On Apple Store \n https://apps.apple.com/sa/app/topstyle/id1498637876 \nOur App On Google Play Store \n https://play.google.com/store/apps/details?id=com.topstylesa.topstyle \nOur website  https://topstylesa.com',
                        sharePositionOrigin:
                            box.localToGlobal(Offset.zero) & box.size);
                  },
                  leading:
                      Icon(Icons.drafts, color: CustomColors.kTabBarIconColor),
                  title: Text(
                    AppLocalization.of(context).translate("invite_friends"),
                    style: TextStyle(
                      color: CustomColors.kTabBarIconColor,
                      fontSize: widgetSize.content,
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios,
                      size: widgetSize.content,
                      color: CustomColors.kTabBarIconColor),
                ),
              ),
              Divider(
                height: 1.0,
                color: CustomColors.kPCardColor,
                thickness: 1.5,
              ),
              Container(
                margin:
                    const EdgeInsets.only(left: 16.0, right: 16.0, top: 10.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white),
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed(CustomerSupport.routeName);
                  },
                  leading: Icon(Icons.supervisor_account,
                      color: CustomColors.kTabBarIconColor),
                  title: Text(
                    AppLocalization.of(context).translate("customer_support"),
                    style: TextStyle(
                      color: CustomColors.kTabBarIconColor,
                      fontSize: widgetSize.content,
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios,
                      color: CustomColors.kTabBarIconColor,
                      size: widgetSize.content),
                ),
              ),
              Divider(
                height: 1.0,
                color: CustomColors.kPCardColor,
                thickness: 1.5,
              ),
              Container(
                margin:
                    const EdgeInsets.only(left: 16.0, right: 16.0, top: 10.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white),
                child: ListTile(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(PrivacyPolicyScreen.routeName);
                  },
                  leading: SvgPicture.asset(
                    'assets/icons/privacy.svg',
                    width: 25.0,
                    height: 25.0,
                    fit: BoxFit.fitHeight,
                  ),
                  title: Text(
                    AppLocalization.of(context).translate("privacy_policy"),
                    style: TextStyle(
                        color: CustomColors.kTabBarIconColor,
                        fontSize: widgetSize.content),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios,
                      color: CustomColors.kTabBarIconColor,
                      size: widgetSize.content),
                ),
              ),
              Divider(
                height: 1.0,
                color: CustomColors.kPCardColor,
                thickness: 1.5,
              ),
              _isUserLoggedIn
                  ? Container(
                      margin: const EdgeInsets.only(
                          left: 16.0, right: 16.0, top: 10.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white),
                      child: ListTile(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) => Theme.of(context)
                                          .platform ==
                                      TargetPlatform.iOS
                                  ? CupertinoAlertDialog(
                                      content: Text(AppLocalization.of(context)
                                          .translate('logout_hint')),
                                      actions: <Widget>[
                                        FlatButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            AppLocalization.of(context)
                                                .translate('no'),
                                            style: TextStyle(
                                                fontSize: widgetSize.subTitle,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        FlatButton(
                                          onPressed: () {
                                            Provider.of<UserProvider>(context,
                                                    listen: false)
                                                .logout()
                                                .then((_) {
                                              setState(() {
                                                checkLoginStatus();
                                              });
                                            });
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            AppLocalization.of(context)
                                                .translate('logout'),
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: widgetSize.subTitle,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    )
                                  : AlertDialog(
                                      content: Text(AppLocalization.of(context)
                                          .translate('logout_hint')),
                                      actions: <Widget>[
                                        FlatButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            AppLocalization.of(context)
                                                .translate('no'),
                                            style: TextStyle(
                                                fontSize: widgetSize.content,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        FlatButton(
                                          onPressed: () {
                                            Provider.of<UserProvider>(context,
                                                    listen: false)
                                                .logout()
                                                .then((_) {
                                              setState(() {
                                                checkLoginStatus();
                                              });
                                            });
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            AppLocalization.of(context)
                                                .translate('logout'),
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: widgetSize.subTitle,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ));
                        },
                        leading: Icon(Icons.exit_to_app,
                            color: CustomColors.kTabBarIconColor),
                        title: Text(
                          AppLocalization.of(context).translate("logout"),
                          style: TextStyle(
                              color: CustomColors.kTabBarIconColor,
                              fontSize: widgetSize.content),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios,
                            color: CustomColors.kTabBarIconColor,
                            size: widgetSize.content),
                      ),
                    )
                  : Container(),
            ],
          ));
  }
}
