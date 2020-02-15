import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:topstyle/constants/colors.dart';
import 'package:topstyle/helper/size_config.dart';
import 'package:topstyle/providers/languages_provider.dart';
import 'package:topstyle/widgets/adaptive_progress_indecator.dart';

import '../helper/appLocalization.dart';
import '../screens/account_setting_screen.dart';

class SettingChoiceScreen extends StatefulWidget {
  @override
  _SettingChoiceScreenState createState() => _SettingChoiceScreenState();
}

class _SettingChoiceScreenState extends State<SettingChoiceScreen> {
  bool _isArabicClicked = false;
  bool _isEnglishClicked = false;

  _getLanguageCode(BuildContext context) {
    return Localizations.localeOf(context).languageCode;
  }

  AppLanguageProvider appLanguage = AppLanguageProvider();

  Future<void> _changeLanguage(String languageCode) async {
    await appLanguage.changeLanguage(Locale(languageCode));
  }

  Widget _buildCountryChoice(
    String country,
    String icon,
    Function action,
    context,
    bool isActive,
  ) {
    return Container(
//      height: widgetSize.textField,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: isActive
              ? Border.all(width: 1.0, color: Theme.of(context).accentColor)
              : null,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                offset: Offset(1, 2),
                blurRadius: 50.0,
                color: Colors.grey.withOpacity(0.2))
          ]),
      child: ListTile(
        onTap: action,
        title: Text(
          country,
          style: TextStyle(fontSize: 16.0),
        ),
        leading: Image.asset(icon),
      ),
    );
  }

  bool _isKSAClicked = false;
  bool _isKuwaitClicked = false;
  bool _isUAEClicked = false;

  bool _isUserLoggedIn = false;
  bool _isLoading = true;
  var userData;

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
  }

  _selectedCountry() async {
    var prefs = await SharedPreferences.getInstance();
    var country = prefs.getString("countryName");
    switch (country) {
      case "KSA":
        setState(() {
          _isKSAClicked = true;
          _isKuwaitClicked = false;
          _isUAEClicked = false;
        });

        break;
      case "UAE":
        setState(() {
          _isKSAClicked = false;
          _isKuwaitClicked = false;
          _isUAEClicked = true;
        });
        break;
      case "KW":
        setState(() {
          _isKSAClicked = false;
          _isKuwaitClicked = true;
          _isUAEClicked = false;
        });
        break;
      default:
        setState(() {
          _isKSAClicked = true;
          _isKuwaitClicked = false;
          _isUAEClicked = false;
        });
    }
  }

  Widget _buildLanguageChoice(
    String language,
    context,
    bool isActive,
    Function action,
  ) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: isActive
              ? Border.all(width: 2.0, color: Theme.of(context).accentColor)
              : null,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                offset: Offset(1, 2),
                blurRadius: 50.0,
                color: CustomColors.kPCardColor)
          ]),
      child: ListTile(
        onTap: action,
        title: Text(
          language,
          style: TextStyle(fontSize: 16.0),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  _showPopupToChangeLanguage(BuildContext context) {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    AppLocalization.of(context).translate("choose_lang"),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: widgetSize.subTitle),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Divider(
                  height: 1.0,
                  color: Colors.grey,
                ),
                SizedBox(
                  height: 30.0,
                ),
                _buildLanguageChoice('عربي', context,
                    _getLanguageCode(context) == 'ar' ? true : false, () {
                  _changeLanguage('ar');
                  Navigator.of(context).pop();
                  setState(() {
                    _isArabicClicked = true;
                    _isEnglishClicked = false;
                  });

//                Navigator.of(context).pop();
                }),
                SizedBox(
                  height: 15.0,
                ),
                _buildLanguageChoice('English', context,
                    _getLanguageCode(context) == 'en' ? true : false, () {
                  _changeLanguage('en');
                  Navigator.of(context).pop();
                  setState(() {
                    _isEnglishClicked = true;
                    _isArabicClicked = false;
                  });

//                Navigator.of(context).pop();
                }),
              ]),
        ),
      ),
    );
  }

  _setCountry(String country) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString("countryName", country);
  }

  _showPopupToChangeCountry(BuildContext context) {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
        ),
      ),
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: Text(
                  AppLocalization.of(context).translate("choose_country"),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Divider(
                height: 1.0,
                color: Colors.grey,
              ),
              SizedBox(
                height: 30.0,
              ),
              _buildCountryChoice(AppLocalization.of(context).translate("ksa"),
                  'assets/icons/ksa_flag.png', () {
                setState(() {
                  _isKSAClicked = true;
                  _isKuwaitClicked = false;
                  _isUAEClicked = false;
                });
                _setCountry("KSA");
                Navigator.of(context).pop();
              }, context, _isKSAClicked),
              SizedBox(
                height: 10.0,
              ),
              _buildCountryChoice(AppLocalization.of(context).translate("uae"),
                  'assets/icons/uae_flag.png', () {
                setState(() {
                  _isKSAClicked = false;
                  _isKuwaitClicked = false;
                  _isUAEClicked = true;
                });
                _setCountry("UAE");
                Navigator.of(context).pop();
              }, context, _isUAEClicked),
              SizedBox(
                height: 10.0,
              ),
              _buildCountryChoice(AppLocalization.of(context).translate("kw"),
                  'assets/icons/kw_flag.png', () {
                setState(() {
                  _isKSAClicked = false;
                  _isKuwaitClicked = true;
                  _isUAEClicked = false;
                });
                _setCountry("KW");
                Navigator.of(context).pop();
              }, context, _isKuwaitClicked),
              SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    checkLoginStatus();
    super.initState();
    this._selectedCountry();
  }

  ScreenConfig screenConfig;
  WidgetSize widgetSize;
  @override
  Widget build(BuildContext context) {
    screenConfig = ScreenConfig(context);
    widgetSize = WidgetSize(screenConfig);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalization.of(context).translate("settings"),
          style: TextStyle(fontSize: widgetSize.mainTitle),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(
              child: AdaptiveProgressIndicator(),
            )
          : Column(
              children: <Widget>[
                _isUserLoggedIn
                    ? Container(
                        margin: const EdgeInsets.only(
                            left: 16.0, right: 16.0, top: 20.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white),
                        child: ListTile(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => AccountSettingScreen()));
                          },
                          title: Text(
                            AppLocalization.of(context)
                                .translate("account_setting_in_settings_page"),
                            style: TextStyle(fontSize: widgetSize.content),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 20.0,
                          ),
                        ),
                      )
                    : Container(),
                Divider(
                  height: 1.0,
                  color: CustomColors.kPCardColor,
                  thickness: 1.5,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white),
                  child: ListTile(
                    onTap: () => _showPopupToChangeCountry(context),
                    title: Text(
                      AppLocalization.of(context)
                          .translate("country_in_settings_page"),
                      style: TextStyle(fontSize: widgetSize.content),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 20.0),
                  ),
                ),
                Divider(
                  height: 1.0,
                  color: CustomColors.kPCardColor,
                  thickness: 1.5,
                ),
                Container(
                  margin: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white),
                  child: ListTile(
                    onTap: () => _showPopupToChangeLanguage(context),
                    title: Text(
                      AppLocalization.of(context)
                          .translate("language_in_settings_page"),
                      style: TextStyle(fontSize: widgetSize.content),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 20.0,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
