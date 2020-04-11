import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:topstyle/constants/colors.dart';
import 'package:topstyle/helper/common_component.dart';
import 'package:topstyle/helper/size_config.dart';
import 'package:topstyle/screens/change_name_pass_email_screen.dart';
import 'package:topstyle/screens/reset_password_screen.dart';
import 'package:topstyle/widgets/adaptive_progress_indecator.dart';

import '../helper/appLocalization.dart';

class AccountSettingScreen extends StatefulWidget {
  @override
  _AccountSettingScreenState createState() => _AccountSettingScreenState();
}

class _AccountSettingScreenState extends State<AccountSettingScreen> {
  var userData;
  bool _isUserLoggedIn = false, _isLoading = true;

  checkLoginStatus() async {
    userData = await CommonComponent.checkLoginStatus();
    if (userData == null || userData == {}) {
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
    }
//    print("$_isUserLoggedIn and Name is :" + userData['name']);
  }

  _drawListTile(String title, IconData icon, Function action) {
    return Container(
      margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        onTap: action,
        leading: Icon(icon, color: CustomColors.kTabBarIconColor),
        title: Text(
          title,
          style: TextStyle(
              color: CustomColors.kTabBarIconColor,
              fontSize: widgetSize.content),
        ),
        trailing: Icon(Icons.arrow_forward_ios,
            size: widgetSize.content, color: CustomColors.kTabBarIconColor),
      ),
    );
  }

  _drawDivider() {
    return Divider(
      height: 1.0,
      color: CustomColors.kPCardColor,
      thickness: 1.5,
    );
  }

  ScreenConfig screenConfig;
  WidgetSize widgetSize;

  @override
  void initState() {
    checkLoginStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenConfig = ScreenConfig(context);
    widgetSize = WidgetSize(screenConfig);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalization.of(context)
              .translate("account_setting_in_settings_page"),
          style: TextStyle(
              fontSize: widgetSize.mainTitle, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _isLoading
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
                        : AppLocalization.of(context)
                            .translate('not_logged_in'),
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
                      : Text(''),
                  SizedBox(height: 30.0),
                  _drawDivider(),
                  _drawListTile(
                      AppLocalization.of(context).translate('change_name'),
                      Icons.account_box, () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            ChangeNamePassEmailScreen('change_name')));
                  }),
                  _drawDivider(),
                  _drawListTile(
                      AppLocalization.of(context).translate('change_phone'),
                      Icons.phone_iphone, () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            ChangeNamePassEmailScreen('change_phone')));
                  }),
                  _drawDivider(),
                  _drawListTile(
                      AppLocalization.of(context).translate('change_email'),
                      Icons.email, () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            ChangeNamePassEmailScreen('change_email')));
                  }),
                  _drawDivider(),
                  _drawListTile(
                      AppLocalization.of(context)
                          .translate('change_password_in_account_setting_page'),
                      Icons.lock_open, () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ResetPasswordScreen()));
                  }),
                  _drawDivider(),
                ],
              ),
            ),
    );
  }
}
