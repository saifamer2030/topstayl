import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class PaymentProvider with ChangeNotifier {
  final String _baseUrl = 'https://topstylesa.com/api/';

  //final String _topStyleUrl = 'https://api.topstyle-sa.com';

  Future<double> changePaymentMethod(int paymentId, String token) async {
    double _discount = 0.0;
    try {
      final response = await http.get(
        '${_baseUrl}payDiscount?payId=$paymentId',
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
