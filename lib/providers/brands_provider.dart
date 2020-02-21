import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:topstyle/helper/api_util.dart';
import 'package:topstyle/models/brand_model.dart';

class BrandsProvider with ChangeNotifier {
  List<BrandModel> _allBrands = [];

  Future<List<BrandModel>> allBrandsData() async {
    try {
      final response = await http.get('${ApiUtil.BASE_URL}brands', headers: {
        "APPKEY": ApiUtil.APPKEY,
        "Accept": "application/json",
      });
      if (response.statusCode == 200) {
        _allBrands = BrandModel.parsedJson(jsonDecode(response.body)['data']);
      }
    } catch (error) {
      print(error.toString());
      throw error;
    }
    return _allBrands;
  }
}
