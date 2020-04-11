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
}
