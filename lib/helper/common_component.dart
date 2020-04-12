import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class CommonComponent {
  static Future<Map<String, dynamic>> checkLoginStatus() async {
    var userData = {};
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    userData = jsonDecode(sharedPreferences.getString('userData')) as Map;
    return userData;
  }

  static storeCountry(String country) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('userCountryName', country);
  }

  static Future<String> checkCountry() async {
    String country;
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getString('userCountryName') != null) {
      country = prefs.getString('userCountryName');
    } else {
      country = 'KSA';
    }
    return country;
  }
}
