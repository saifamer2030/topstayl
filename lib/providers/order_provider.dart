import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:topstyle/helper/api_util.dart';
import 'package:topstyle/models/checkout_summery_model.dart';
import 'package:topstyle/models/city.dart';
import 'package:topstyle/models/set_order.dart';

import '../models/orders_model.dart' as odModel;

class OrdersProvider with ChangeNotifier {
  final String _checkoutUrl = 'https://test.oppwa.com/v1/checkouts';
  final String _entityId = '8ac7a4c76e91bcde016e9dcfb4b908cf';
  final String _paymentToken =
      "Bearer OGFjN2E0Yzc2ZTkxYmNkZTAxNmU5ZGNmNmYyOTA4Y2J8Q3M2SlpHOWEzWg==";
  List<odModel.OrderModel> _orders = [];

  Future<int> cancelOrder(String token, String orderId) async {
    int result = -1;
    try {
      final response =
          await http.get('${ApiUtil.BASE_URL}order/$orderId/cancel', headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        "Accept": "application/json",
      });
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['message'] != null) {
          print(jsonDecode(response.body)['message']);
          result = 0;
        } else {
          result = 1;
        }
      }
    } catch (error) {
      print(error.toString());
      throw error;
    }
    return result;
  }

  Future<void> getUserOrderDetails(String token) async {
    odModel.OrderDetailsModel _orderDetailsModel;
    print(token);
    try {
      final response = await http.get('${ApiUtil.BASE_URL}userOrder', headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        "Accept": "application/json",
      });
      if (response.statusCode == 200) {
        if (jsonDecode(response.body) != null) {
          print(jsonDecode(response.body));
        }
      }
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  Future<List<odModel.OrderModel>> getUserOrder(String token) async {
    try {
      final response = await http.get('${ApiUtil.BASE_URL}userOrder', headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        "Accept": "application/json",
      });
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['data'] != null) {
          var _list = jsonDecode(response.body)['data'] as List;
          _orders =
              _list.map((order) => odModel.OrderModel.fromJson(order)).toList();
        }
      }
    } catch (error) {
      print(error.toString());
      throw error;
    }
    return _orders;
  }

  Future<String> requestCheckoutId(String amount) async {
    String checkoutId = '';
    try {
      final response = await http.post(_checkoutUrl, headers: {
        "Authorization": _paymentToken
      }, body: {
        "entityId": _entityId,
        "amount": amount,
        "currency": "SAR",
        "paymentType": "DB"
      });
      if (response.statusCode == 200) {
        checkoutId = jsonDecode(response.body)['id'];
      } else {
        print('not success ${response.statusCode}');
      }
    } catch (error) {
      print(error.toString());
    }
    return checkoutId;
  }

  Future<String> checkPaymentStatus(String checkoutId) async {
    String _paymentStatus = '';
    try {
      final response = await http.get(
        'https://test.oppwa.com/v1/checkouts/$checkoutId/payment?entityId=$_entityId',
        headers: {"Authorization": _paymentToken},
      );
      if (response.statusCode == 200) {
        _paymentStatus = jsonDecode(response.body)['result']['code'];
        print(jsonDecode(response.body));
      } else {
        print('not success ${response.statusCode}');
      }
    } catch (error) {
      print(error.toString());
    }
    return _paymentStatus;
  }

  Future<SetOrder> addOrder(String token, String paymentId, String coupon,
      String checkoutId, int userCheckoutId) async {
    SetOrder orderData;
    print(
        '------------------------------$checkoutId---------------------------------');
    print(
        '------------------------------$paymentId---------------------------------');
    try {
      final response = await http.post('${ApiUtil.BASE_URL}setOrder', headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        "Accept": "application/json",
      }, body: {
        'payment_id': paymentId,
        'coupon': coupon,
        'checkoutId': checkoutId,
        'userCheckoutId': userCheckoutId.toString()
      });
      if (response.statusCode == 200) {
        if (jsonDecode(response.body) != null) {
          orderData = SetOrder.fromJson(
              jsonDecode(response.body)['payment_url'],
              jsonDecode(response.body)['payment_checkout_id'],
              jsonDecode(response.body)['order']['id']);
          print(
              '--------------------- ${jsonDecode(response.body)} ---------------------------------');
//          print(jsonDecode(response.body)['payment_checkout_id']);
        } else {
          print('response is null');
        }
      } else {
        print('error code is ${response.statusCode}');
      }
    } catch (error) {
      print(error.toString());
      throw error.toString();
    }
    return orderData;
  }

  Future<List<CityModel>> allCites(String countryId, String token) async {
    List<CityModel> _cites = [];
    try {
      final response =
          await http.get('${ApiUtil.BASE_URL}getCities/$countryId', headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'] as List;
        _cites = data.map((city) => CityModel.fromJson(city)).toList();
//        print(jsonDecode(response.body)['data']);
      }
    } catch (error) {
      print(error.toString());
      throw error;
    }
    return _cites;
  }

  Future<int> saveLocation(
      String country,
      String city,
      String fullName,
      String area,
      String street,
      String address,
      String phone,
      String gps,
      String token) async {
    int responseNumber = 0;
    try {
      final response = await http.post('${ApiUtil.BASE_URL}address', headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        "Accept": "application/json",
      }, body: {
        'country': country,
        'city': city,
        'full_name': fullName,
        'area': area,
        'street': street,
        'address': address,
        'phone': phone,
        'gps': gps,
        'is_default': '1'
      });
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['message'] != null) {
          responseNumber = 1;
//          print(jsonDecode(response.body)['message']);
        } else {
          responseNumber = 0;
        }
      } else {
        print('Error Number ${response.statusCode}');
      }
    } catch (error) {
      print(error.toString());
      throw error;
    }
    return responseNumber;
  }

  Future<AddressModel> getUserAddresses(String token) async {
    AddressModel addressModel;
    try {
      final response = await http.get('${ApiUtil.BASE_URL}address', headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        "Accept": "application/json",
      });
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['data'] != null) {
          addressModel =
              AddressModel.fromJson(jsonDecode(response.body)['data']);
          print(jsonDecode(response.body));
        }
      } else {
        print('Reponse status code number : ${response.statusCode}');
      }
    } catch (error) {
      print(error.toString());
      throw error;
    }
    return addressModel;
  }

  Future<CheckoutSummeryModel> getCheckoutData(String token) async {
    CheckoutSummeryModel checkoutSummeryModel;
    try {
      final response = await http.get('${ApiUtil.BASE_URL}checkout', headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        "Accept": "application/json",
      });
      if (response.statusCode == 200) {
        var prefs = await SharedPreferences.getInstance();
        prefs.setInt(
            "userCheckoutId",
            CheckoutSummery.fromJson(jsonDecode(response.body)['summary'])
                .userCheckoutId);
        checkoutSummeryModel = CheckoutSummeryModel.fromJson(
            jsonDecode(response.body)['address'],
            jsonDecode(response.body)['payments'],
            jsonDecode(response.body)['summary']);
      } else {
        print('Reponse status code number : ${response.statusCode}');
      }
    } catch (error) {
      print(error.toString());
      throw error;
    }
    return checkoutSummeryModel;
  }

  Future<odModel.OrderDetailsModel> getOrderDetails(
      String productId, String token) async {
    odModel.OrderDetailsModel orderDetailsModel;
    try {
      final response = await http
          .get('${ApiUtil.BASE_URL}orderDetails/$productId', headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        "Accept": "application/json",
      });
      if (response.statusCode == 200) {
//        print(jsonDecode(response.body));
        orderDetailsModel =
            odModel.OrderDetailsModel.fromJson(jsonDecode(response.body));
      }
    } catch (error) {
      print(error.toString());
      throw error;
    }
    return orderDetailsModel;
  }

  List<odModel.OrderModel> get orders {
    return List.of(_orders);
  }
}
