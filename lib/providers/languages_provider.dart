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
    return _appLocale;
  }

  Future<void> changeLanguage(Locale type) async {
    var prefs = await SharedPreferences.getInstance();
    if (_appLocale != type) {
//      print(prefs.getString('language_code'));
      if (type == Locale("ar")) {
        _appLocale = Locale("ar");
        await prefs.setString('language_code', 'ar');
//      await prefs.setString('countryCode', '');
        notifyListeners();
      } else {
        _appLocale = Locale("en");
        await prefs.setString('language_code', 'en');
//      await prefs.setString('countryCode', 'US');
        notifyListeners();
      }
//      print(prefs.getString('language_code'));
    }
  }
}
