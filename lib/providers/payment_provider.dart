import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:topstyle/helper/api_util.dart';

class PaymentProvider with ChangeNotifier {
  Future<double> changePaymentMethod(int paymentId, String token) async {
    double _discount = 0.0;
    try {
      final response = await http.get(
        '${ApiUtil.BASE_URL}payDiscount?payId=$paymentId',
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          "Accept": "application/json",
        },
      );
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['exist'] == 1) {
          _discount = double.parse(jsonDecode(response.body)['amount']);
        }
      } else {
        print(response.statusCode);
      }
    } catch (error) {
      print(error.toString());
      throw error;
    }
    return _discount;
  }
}
