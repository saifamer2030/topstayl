import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:topstyle/helper/api_util.dart';

class UserProvider with ChangeNotifier {
  static final UserProvider _instance = UserProvider._internal();

  UserProvider._internal();

  factory UserProvider() {
    return _instance;
  }

  bool _isAuth = false;

  Future<int> updateUserData(
      String token, String name, String phone, String email) async {
    int responseContent = 0;
    try {
      final response =
          await http.post('${ApiUtil.BASE_URL}updateUser', headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        "Accept": "application/json",
      }, body: {
        'name': name,
        'phone': phone,
        'email': email,
      });
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['errors'] != null) {
          // error
          if (jsonDecode(response.body)['errors']
              .toString()
              .contains('The email has already been taken')) {
            // email already taken
            responseContent = 2;
            print(jsonDecode(response.body));
          } else if (jsonDecode(response.body)['errors']
              .toString()
              .contains('The phone has already been taken.')) {
            // phone already taken
            responseContent = 3;
            print(jsonDecode(response.body));
          }

          print(jsonDecode(response.body));
        } else {
          // do update
          responseContent = 1;
          print(jsonDecode(response.body));
          var prefs = await SharedPreferences.getInstance();
          final userData = json.encode({
            'id': json.decode(response.body)['data']['id'],
            'name': json.decode(response.body)['data']['name'],
            'email': json.decode(response.body)['data']['email'],
            'phone': json.decode(response.body)['data']['phone'],
            'langugae': json.decode(response.body)['data']['language'],
            'group': json.decode(response.body)['data']['group'],
            'country': json.decode(response.body)['data']['country'],
            'city': json.decode(response.body)['data']['city'],
            'address': json.decode(response.body)['data']['address'],
            'currency': json.decode(response.body)['data']['currency'],
            'email_verified': json.decode(response.body)['data']
                ['email_verified'],
            'phone_verified': json.decode(response.body)['data']
                ['phone_verified'],
            'registered_at': json.decode(response.body)['data']
                ['registered_at'],
            'userToken': token
          });
          prefs.setString('userData', userData);
        }
      }
    } catch (error) {
      print(error.toString());
      throw error;
    }
    return responseContent;
  }

  Future<bool> changeFromOtp(
      String method, String type, String password) async {
    bool isDone = false;
//    var requestBody = jsonEncode(type == 'email'
//        ? {'password': password, 'email': method}
//        : {'password': password, 'phone': method});
    final response = await http.post('${ApiUtil.BASE_URL}setPassword',
        body: type == 'email'
            ? {'password': password, 'email': method}
            : {'password': password, 'phone': method});

    if (response.statusCode == 200) {
      if (jsonDecode(response.body).toString().contains('message')) {
        isDone = true;
      } else {
        isDone = false;
        print(jsonDecode(response.body));
      }
    } else {
      isDone = false;
      print(response.statusCode);
    }
    return isDone;
  }

  Future<bool> changeEmailOtp(String email, String password) async {
    bool isDone = false;
    final response = await http.post('${ApiUtil.BASE_URL}setPassword',
        body: {'password': password, 'email': email});
    if (response.statusCode == 200) {
      if (jsonDecode(response.body).toString().contains('message')) {
        isDone = true;
      } else {
        isDone = false;
      }
    } else {
      isDone = false;
    }
    return isDone;
  }

  Future<Map<String, dynamic>> otpByEmail(String email) async {
    var msg = {'msg': 0, 'otp': ''};
    try {
      final response = await http
          .post('${ApiUtil.BASE_URL}otpEmail', body: {'email': email});
      if (response.statusCode == 200) {
        if (jsonDecode(response.body).toString().contains('errors')) {
          // not sent and phone not found
          msg['msg'] = 1;
        } else if (jsonDecode(response.body).toString().contains('user') ||
            jsonDecode(response.body).toString().contains('otp')) {
          // message sent successfully
          msg['msg'] = 2;
          msg['otp'] = jsonDecode(response.body)['otp'];
//          print(jsonDecode(response.body)['otp']);
        } else {
          print('Email number is requird');
        }
      } else {
        print(response.statusCode);
      }
    } catch (error) {
      print(error);
      throw error;
    }
    return msg;
  }

  Future<Map<String, dynamic>> otpByPhone(String phone, String check) async {
    var msg = {'msg': 0, 'otp': ''};
    try {
      final response = await http.post('${ApiUtil.BASE_URL}otp',
          body: {'phone': phone, 'check': check});
      if (response.statusCode == 200) {
        if (jsonDecode(response.body).toString().contains('error')) {
          // not sent and phone not found
          msg['msg'] = 1;
        } else if (jsonDecode(response.body).toString().contains('user') ||
            jsonDecode(response.body).toString().contains('otp')) {
          // message sent successfully
          msg['msg'] = 2;
          msg['otp'] = jsonDecode(response.body)['otp'];
          print(jsonDecode(response.body));
        } else {
          print('Phone number is requird');
        }
      } else {
        print(response.statusCode);
        print('here');
      }
    } catch (error) {
      print(error);
      throw error;
    }
    return msg;
  }

  Future<int> resetPassword(
      String token, String oldPassword, String newPassword) async {
    var _resetMsg = 0;
    try {
      final response =
          await http.post('${ApiUtil.BASE_URL}resetPassword', headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        "Accept": "application/json",
      }, body: {
        'oldPassword': oldPassword,
        'password': newPassword
      });
      if (response.statusCode == 200) {
        if (jsonDecode(response.body).toString().contains('message')) {
          // password change successfully
          _resetMsg = 1;
        } else {
          // Wrong old password
          _resetMsg = 2;
        }
      } else if (response.statusCode == 401) {
        _resetMsg = 3;
      } else {
        _resetMsg = 4;
      }
    } catch (error) {
      print(error);
      throw error;
    }
    return _resetMsg;
  }

  Map<String, dynamic> _map = {'isRegisterd': false, 'msg': 0};

  Future<Map<String, dynamic>> register(String name, String email,
      String password, String phone, String language, String country) async {
    try {
      var prefs = await SharedPreferences.getInstance();
      String guestId = prefs.getString('guestId') == null
          ? 'new'
          : prefs.getString('guestId');
      final response = await http.post('${ApiUtil.BASE_URL}register', body: {
        'email': email,
        'name': name,
        'password': password,
        'phone': phone,
        'language': language,
        'country': country,
        'guestId': guestId,
      });
      if (response.statusCode == 200) {
        // response success
        if (jsonDecode(response.body).toString().contains('token')) {
          var prefs = await SharedPreferences.getInstance();
          prefs.remove('guestId');
          final userData = json.encode({
            'id': json.decode(response.body)['user']['id'],
            'name': json.decode(response.body)['user']['name'],
            'email': json.decode(response.body)['user']['email'],
            'phone': json.decode(response.body)['user']['phone'],
            'langugae': json.decode(response.body)['user']['language'],
            'group': json.decode(response.body)['user']['group'],
            'country': json.decode(response.body)['user']['country'],
            'city': json.decode(response.body)['user']['city'],
            'address': json.decode(response.body)['user']['address'],
            'currency': json.decode(response.body)['user']['currency'],
            'email_verified': json.decode(response.body)['user']
                ['email_verified'],
            'phone_verified': json.decode(response.body)['user']
                ['phone_verified'],
            'registered_at': json.decode(response.body)['user']
                ['registered_at'],
            'userToken': json.decode(response.body)['token']
          });
          prefs.setString('userData', userData);
          _map['isRegisterd'] = true;
//          print(jsonDecode(response.body)['user']);

//          print(jsonDecode(response.body)['user']);
        } else if (jsonDecode(response.body).toString().contains('error')) {
          // user not added there are 5 err {error:{ phone, name , password , email , language , country} }
          _map['isRegisterd'] = false;
//          switch(jsonDecode(response.body)['errors'])
          if (jsonDecode(response.body)['errors']
              .toString()
              .contains('password')) {
//            _map['msg'] = jsonDecode(response.body)['errors']['password'];
            print(jsonDecode(response.body)['errors']['password']);
          } else if (jsonDecode(response.body)['errors']
              .toString()
              .contains('name')) {
            print(jsonDecode(response.body)['errors']['name']);
          } else if (jsonDecode(response.body)['errors']
              .toString()
              .contains('email')) {
            _map['msg'] = 2;
//            print(jsonDecode(response.body)['errors']['email']);
          } else if (jsonDecode(response.body)['errors']
              .toString()
              .contains('phone')) {
            _map['msg'] = 1;
            print(jsonDecode(response.body)['errors']['phone']);
          } else if (jsonDecode(response.body)['errors']
              .toString()
              .contains('language')) {
            print(jsonDecode(response.body)['errors']['language']);
          } else {
            print(jsonDecode(response.body)['errors']['country']);
          }
        }
      } else {
        _map['isRegisterd'] = false;
        _map['msg'] = 3;
      }
    } catch (error) {
      print(error);
      throw error;
    }
    return _map;
  }

  Future<bool> login(String email, String password) async {
    try {
      var prefs = await SharedPreferences.getInstance();
      String guestId = prefs.getString('guestId') == null
          ? 'new'
          : prefs.getString('guestId');
      final response = await http.post('${ApiUtil.BASE_URL}login',
          body: {'email': email, 'password': password, 'guestId': guestId});
      if (response.statusCode == 200) {
        if (json.decode(response.body).toString().contains('token')) {
          //          print(json.decode(response.body)['user']['name']);
          var prefs = await SharedPreferences.getInstance();
          prefs.remove('guestId');
          final userData = json.encode({
//            'user': UserModel.fromJson(json.decode(response.body)['user']),
            'id': json.decode(response.body)['user']['id'],
            'name': json.decode(response.body)['user']['name'],
            'email': json.decode(response.body)['user']['email'],
            'phone': json.decode(response.body)['user']['phone'],
            'langugae': json.decode(response.body)['user']['language'],
            'group': json.decode(response.body)['user']['group'],
            'country': json.decode(response.body)['user']['country'],
            'city': json.decode(response.body)['user']['city'],
            'address': json.decode(response.body)['user']['address'],
            'currency': json.decode(response.body)['user']['currency'],
            'email_verified': json.decode(response.body)['user']
                ['email_verified'],
            'phone_verified': json.decode(response.body)['user']
                ['phone_verified'],
            'registered_at': json.decode(response.body)['user']
                ['registered_at'],
            'userToken': json.decode(response.body)['token']
          });
//          print(jsonDecode(userData)['user'].name);
          prefs.setString('userData', userData);
          _isAuth = true;
        } else {
          _isAuth = false;
        }
      } else {}
    } catch (error) {
      print(error.toString());
    }
    return _isAuth;
  }

  Future<void> logout() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
    notifyListeners();
  }

//  Map<String, String> _isAuthUserData = {};

  Future<Map<String, String>> isAuthenticated() async {
    var prefs = await SharedPreferences.getInstance();
//      print(prefs.getString('userData'));
    Map<String, String> _isAuthUserData = {};
    if (prefs.getString('userData') != null) {
      final data = jsonDecode(prefs.getString('userData')) as Map;
      _isAuthUserData = {'Authorization': data['userToken']};
    } else {
//        print(prefs.getString('userData'));
      _isAuthUserData = {'Authorization': 'none'};
    }

    return _isAuthUserData;
  }
}
