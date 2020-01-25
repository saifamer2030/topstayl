import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:topstyle/models/brand_model.dart';

class BrandsProvider with ChangeNotifier {
  List<BrandModel> _allBrands = [];

  Future<List<BrandModel>> allBrandsData() async {
    try {
      final response = await http.get('https://topstylesa.com/api/brands');
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
