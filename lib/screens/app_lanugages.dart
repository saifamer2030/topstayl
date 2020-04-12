import 'package:flutter/material.dart';
import 'package:topstyle/helper/common_component.dart';
import 'package:topstyle/providers/languages_provider.dart';
import 'package:topstyle/screens/tabs_screen.dart';

import '../constants/colors.dart';

class LanguagesScreen extends StatefulWidget {
  static const String routeName = 'app-language';

  @override
  _LanguagesScreenState createState() => _LanguagesScreenState();
}

class _LanguagesScreenState extends State<LanguagesScreen> {
  bool _isKSAClicked = false;
  bool _isUAEClicked = false;
  bool _isKuwaitClicked = false;

  bool _isArabicClicked = false;
  bool _isEnglishClicked = false;
  AppLanguageProvider languageProvider = AppLanguageProvider();

  Widget _buildCountryChoice(
    String country,
    String icon,
    Function action,
    context,
    bool isActive,
  ) {
    return Container(
      height: MediaQuery.of(context).size.width / 8,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: isActive
              ? Border.all(width: 1.0, color: Theme.of(context).accentColor)
              : null,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: Offset(1, 2),
              blurRadius: 50,
            )
          ]),
      child: FlatButton.icon(
        onPressed: action,
        icon: Image.asset(icon),
        label: Text(
          country,
          style: TextStyle(fontSize: 14.0),
        ),
      ),
    );
  }

  Widget _buildLanguageChoice(
    String language,
    context,
    bool isActive,
    Function action,
  ) {
    return Container(
      height: MediaQuery.of(context).size.width / 8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: isActive
            ? Border.all(width: 1.0, color: Theme.of(context).accentColor)
            : null,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            offset: Offset(1, 2),
            blurRadius: 50,
          )
        ],
      ),
      child: ListTile(
        onTap: action,
        title: Text(
          language,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/logo.jpg',
                    width: _deviceSize.size.width / 3 - 40,
                    height: _deviceSize.size.width / 8,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                SizedBox(
                  height: 32.0,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'إختر الدولة',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                _buildCountryChoice(
                    'الممكلة العربية السعودية', 'assets/icons/ksa_flag.png',
                    () {
                  setState(() {
                    _isKSAClicked = true;
                    _isKuwaitClicked = false;
                    _isUAEClicked = false;
                  });
                }, context, _isKSAClicked),
                SizedBox(
                  height: 10.0,
                ),
                _buildCountryChoice(
                    'الامارات العربية المتحدة', 'assets/icons/uae_flag.png',
                    () {
                  setState(() {
                    _isKSAClicked = false;
                    _isKuwaitClicked = false;
                    _isUAEClicked = true;
                  });
                }, context, _isUAEClicked),
                SizedBox(
                  height: 10.0,
                ),
                _buildCountryChoice('الكويت', 'assets/icons/kw_flag.png', () {
                  setState(() {
                    _isKSAClicked = false;
                    _isKuwaitClicked = true;
                    _isUAEClicked = false;
                  });
                }, context, _isKuwaitClicked),
                SizedBox(
                  height: 32.0,
                ),
                Divider(
                  height: 1.0,
                  color: Colors.grey,
                  thickness: 1.0,
                ),
                SizedBox(
                  height: 32.0,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'إختر اللغة',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                _buildLanguageChoice('عربي', context, _isArabicClicked, () {
                  setState(() {
                    _isArabicClicked = true;
                    _isEnglishClicked = false;
                  });
                }),
                SizedBox(
                  height: 10.0,
                ),
                _buildLanguageChoice('English', context, _isEnglishClicked, () {
                  setState(() {
                    _isEnglishClicked = true;
                    _isArabicClicked = false;
                  });
                }),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  height: _deviceSize.size.width / 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: Theme.of(context).accentColor,
                    onPressed: ((_isEnglishClicked || _isArabicClicked) &&
                            (_isKSAClicked ||
                                _isKuwaitClicked ||
                                _isUAEClicked))
                        ? () {
                            if (_isUAEClicked && _isArabicClicked) {
//                              _goToHome('UAE', 'ar', context);
                              languageProvider.changeLanguage(Locale("ar"));
                              CommonComponent.storeCountry('UAE');
                              Navigator.of(context)
                                  .pushReplacementNamed(TabsScreen.routeName);
                            } else if (_isUAEClicked && _isEnglishClicked) {
//                              _goToHome('UAE', 'en', context);
                              languageProvider.changeLanguage(Locale("en"));
                              CommonComponent.storeCountry('UAE');
                              Navigator.of(context)
                                  .pushReplacementNamed(TabsScreen.routeName);
                            } else if (_isKSAClicked && _isArabicClicked) {
//                              _goToHome('KSA', 'ar', context);
                              languageProvider.changeLanguage(Locale("ar"));
                              CommonComponent.storeCountry('KSA');
                              Navigator.of(context)
                                  .pushReplacementNamed(TabsScreen.routeName);
                            } else if (_isKSAClicked && _isEnglishClicked) {
//                              _goToHome('KSA', 'en', context);
                              languageProvider.changeLanguage(Locale("en"));
                              CommonComponent.storeCountry('KSA');
                              Navigator.of(context)
                                  .pushReplacementNamed(TabsScreen.routeName);
                            } else if (_isKuwaitClicked && _isArabicClicked) {
//                              _goToHome('KW', 'ar', context);
                              languageProvider.changeLanguage(Locale("ar"));
                              CommonComponent.storeCountry('KW');
                              Navigator.of(context)
                                  .pushReplacementNamed(TabsScreen.routeName);
                            } else {
//                              _goToHome('KW', 'en', context);
                              languageProvider.changeLanguage(Locale("en"));
                              CommonComponent.storeCountry('KW');
                              Navigator.of(context)
                                  .pushReplacementNamed(TabsScreen.routeName);
                            }
                          }
                        : null,
                    child: Text(
                      'التالي',
                      style: TextStyle(
                          color: ((_isEnglishClicked || _isArabicClicked) &&
                                  (_isKSAClicked ||
                                      _isKuwaitClicked ||
                                      _isUAEClicked))
                              ? Colors.white
                              : CustomColors.kTabBarIconColor,
                          fontSize: 16.0),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    '* يمكن تغير الدولة واللغة من الاعدادات',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 12.0, color: CustomColors.kTabBarIconColor),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
