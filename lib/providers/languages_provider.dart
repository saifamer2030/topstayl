import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLanguageProvider extends ChangeNotifier {
  static final AppLanguageProvider _instance = AppLanguageProvider._internal();

  AppLanguageProvider._internal();

  factory AppLanguageProvider() {
    return _instance;
  }

  Locale _appLocale;

  Locale get appLocal => _appLocale;

  Locale fetchLocale() {
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.getString('language_code') != null) {
        _appLocale = Locale(prefs.getString('language_code'));
      }
    });
    return _appLocale ?? Locale('ar');
  }

  Future<void> changeLanguage(Locale type) async {
    var prefs = await SharedPreferences.getInstance();
    print('before change ${prefs.getString('language_code')}');
    if (type == Locale("ar")) {
      _appLocale = Locale("ar");
      prefs.setString('language_code', 'ar');
      prefs.setString('countryCode', '');
    } else {
      _appLocale = Locale("en");
      prefs.setString('language_code', 'en');
      prefs.setString('countryCode', 'US');
    }
    notifyListeners();
    print('after change ${prefs.getString('language_code')}');
  }
}
