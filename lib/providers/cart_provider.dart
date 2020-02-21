import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:topstyle/helper/api_util.dart';

import '../models/cart_item_model.dart';

class CartItemProvider with ChangeNotifier {
  Future<Map<String, double>> applyCoupon(String token, String coupon) async {
    Map<String, double> couponValue = {
      'couponValue': 0.0,
      'couponPercentage': 0.0
    };
    print('sfdvdfvfd');
    try {
      final response = await http
          .get('${ApiUtil.BASE_URL}useCoupon?coupon=$coupon', headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        "Accept": "application/json",
        "APPKEY": ApiUtil.APPKEY,
      });
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['exist'] == 1) {
          print(jsonDecode(response.body));
          couponValue = {
            'couponValue':
                double.parse(jsonDecode(response.body)['coupon_amount']),
            'couponPercentage':
                double.parse(jsonDecode(response.body)['coupon'])
          };
        } else {
          print('is not valid');
        }
      }
    } catch (error) {
      print(error.toString());
      throw error;
    }
    return couponValue;
  }

  Future<int> addCartItem(
      int productId, String lang, int qty, String token) async {
    int msg = -1;

    try {
      /* added 0 ,
         updated 1 ,
         deleted 2 ,
         product not available 3 ,
         qty must be greater than Zero 4 ,
         qty not available 5
          */
      if (token == 'none') {
        var prefs = await SharedPreferences.getInstance();
        String guestId = prefs.getString('guestId') == null
            ? 'new'
            : prefs.getString('guestId');
        final response = await http
            .post('${ApiUtil.BASE_URL}cart/add/guest/$guestId', headers: {
          "Accept": "application/json",
          "APPKEY": ApiUtil.APPKEY,
        }, body: {
          'lang': lang,
          'poid': productId.toString(),
          'qty': qty.toString()
        });
        if (response.statusCode == 200) {
          msg = json.decode(response.body)['error'];
          _cartItems.add(CartItemModel(
            id: productId,
            productName: '',
            productPrice: 0.0,
            quantity: 1,
            productImageUrl: '',
            brandName: '',
          ));
          notifyListeners();
          if (prefs.getString('guestId') == null) {
            prefs.setString('guestId', jsonDecode(response.body)['user_id']);
//            prefs.setInt("allItemQty", qty);
          }
          print(jsonDecode(response.body));
        } else {
//          msg = 6;
          print(response.statusCode);
        }
      } else {
        final response =
            await http.post('${ApiUtil.BASE_URL}cart/add', headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          "Accept": "application/json",
          "APPKEY": ApiUtil.APPKEY,
        }, body: {
          'lang': lang,
          'poid': productId.toString(),
          'qty': qty.toString()
        });
        if (response.statusCode == 200) {
          msg = json.decode(response.body)['error'];
          _cartItems.add(CartItemModel(
            id: productId,
            productName: '',
            productPrice: 0.0,
            quantity: 1,
            productImageUrl: '',
            brandName: '',
          ));
          notifyListeners();
          print(jsonDecode(response.body));
        } else {
          msg = 6;
          print(response.statusCode);
        }
      }
    } catch (error) {
      print(error.toString());
      throw error.toString();
    }
    return msg;
  }

  List<CartItemModel> _cartItems = [];

  List<CartItemModel> get cartItems {
    return List.from(_cartItems);
  }

  Future<List<CartItemModel>> fetchAllCartItem(
      String lang, String token) async {
    List<CartItemModel> _lists = [];
    try {
      if (token == 'none') {
        var prefs = await SharedPreferences.getInstance();
        String guestId = prefs.getString('guestId') == null
            ? 'g0'
            : prefs.getString('guestId');
        final response = await http
            .get('${ApiUtil.BASE_URL}cart/guest/$guestId?lang=$lang', headers: {
          "APPKEY": ApiUtil.APPKEY,
          "Accept": "application/json",
        });
        if (response.statusCode == 200) {
          if (json.decode(response.body)['data'] != null) {
            _cartItems =
                CartItemModel.parsedJson(json.decode(response.body)['data']);
//            print(json.decode(response.body)['data']);
          }
        }
      } else {
        final response = await http.get(
          '${ApiUtil.BASE_URL}cart?lang=$lang',
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            "Accept": "application/json",
            "APPKEY": ApiUtil.APPKEY,
          },
        );
        if (response.statusCode == 200) {
//          print(json.decode(response.body)['data']);
          if (json.decode(response.body)['data'] != null) {
            _cartItems =
                CartItemModel.parsedJson(json.decode(response.body)['data']);
          }
        } else {
//          print(json.decode(response.body));
        }
      }
    } catch (error) {
      print(error.toString());
      throw error;
    }
    return _cartItems;
  }

  Future<int> removeProductById(
      int productId, String lang, int qty, String token) async {
    int msg;
    _cartItems.removeWhere((prod) => prod.id == productId);
    notifyListeners();
    try {
      if (token == 'none') {
        var prefs = await SharedPreferences.getInstance();
        String guestId = prefs.getString('guestId');
        final response = await http
            .post('${ApiUtil.BASE_URL}cart/add/guest/$guestId', headers: {
          "Accept": "application/json",
          "APPKEY": ApiUtil.APPKEY,
        }, body: {
          'lang': lang,
          'poid': productId.toString(),
          'qty': '0'
        });
        if (response.statusCode == 200) {
          msg = json.decode(response.body)['error'];
//          print(jsonDecode(response.body));
        } else {
          msg = 6;
        }
      } else {
        final response =
            await http.post('${ApiUtil.BASE_URL}cart/add', headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          "Accept": "application/json",
          "APPKEY": ApiUtil.APPKEY,
        }, body: {
          'lang': lang,
          'poid': productId.toString(),
          'qty': '0'
        });
        if (response.statusCode == 200) {
          msg = json.decode(response.body)['error'];
        } else {
          msg = 6;
        }
      } // User Unregistered

    } catch (error) {
      print(error.toString());
      throw error;
    }

    return msg;
  }

  Future<int> increaseDecreaseProductQty(
      int productId, String lang, int qty, String token) async {
    print(qty);
    int msg;
    _cartItems.forEach((product) {
      if (product.id == productId) {
        product.quantity = qty;
      }
    });
    notifyListeners();
    try {
      if (token == 'none') {
        var prefs = await SharedPreferences.getInstance();
        String guestId = prefs.getString('guestId');
        final response = await http
            .post('${ApiUtil.BASE_URL}cart/add/guest/$guestId', headers: {
          "Accept": "application/json",
          "APPKEY": ApiUtil.APPKEY,
        }, body: {
          'lang': lang,
          'poid': productId.toString(),
          'qty': qty.toString()
        });
        if (response.statusCode == 200) {
          msg = json.decode(response.body)['error'];
          print(jsonDecode(response.body));
        } else {
          msg = 6;
        }
      } else {
        final response =
            await http.post('${ApiUtil.BASE_URL}cart/add', headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          "Accept": "application/json",
          "APPKEY": ApiUtil.APPKEY,
        }, body: {
          'lang': lang,
          'poid': productId.toString(),
          'qty': qty.toString()
        });
        if (response.statusCode == 200) {
          msg = json.decode(response.body)['error'];
        } else {
          msg = 6;
        }
      }
    } catch (error) {
      print(error.toString());
      throw error;
    }

    return msg;
  }

  int productQty(int productId) {
    int qty = 0;
    _cartItems.forEach((p) {
      if (p.id == productId) {
        qty = p.quantity;
      }
    });

    return qty;
  }

//  int get allItemQuantity {
//    int totalQty = 0;
////    SharedPreferences.getInstance().then((prefs) {
////      if (prefs.getString('allItemQty') != null) {
////        totalQty = int.parse(prefs.getString('allItemQty'));
////      }
////    });
//    return totalQty;
//  }
  int get allItemQuantity {
    int totalQty = 0;
    _cartItems.forEach((allQty) {
      totalQty += allQty.quantity;
    });
    return totalQty;
  }

  double get totalPrice {
    double totalPrice = 0.0;
    _cartItems.forEach((data) {
      totalPrice +=
          (data.productPrice - (data.productPrice * data.discount / 100)) *
              data.quantity;
    });
    return totalPrice;
  }
}
