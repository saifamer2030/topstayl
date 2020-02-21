import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:topstyle/helper/api_util.dart';

class SearchProvider with ChangeNotifier {
  List<SearchModel> _allProducts = [];
  Future<List<SearchModel>> search(String key, String lang) async {
    try {
      final response = await http
          .get('${ApiUtil.BASE_URL}search?searchKey=$key&lang=$lang', headers: {
        "APPKEY": ApiUtil.APPKEY,
        "Accept": "application/json",
      });
      if (response.statusCode == 200) {
        var _list = jsonDecode(response.body)['data'] as List;
        _allProducts = _list.map((p) => SearchModel.fromJson(p)).toList();
        print(_allProducts.length);
      }
    } catch (error) {
      print(error.toString());
      throw error;
    }
    return _allProducts;
  }

  List<SearchModel> search2(String key, String lang) {
    try {
      http.get('${ApiUtil.BASE_URL}search?searchKey=$key&lang=$lang', headers: {
        "APPKEY": ApiUtil.APPKEY,
        "Accept": "application/json",
      }).then((response) {
        if (response.statusCode == 200) {
          var _list = jsonDecode(response.body)['data'] as List;
          _allProducts = _list.map((p) => SearchModel.fromJson(p)).toList();
          print(_allProducts.length);
        }
      });
    } catch (error) {
      print(error.toString());
      throw error;
    }
    return _allProducts;
  }
}

class SearchModel {
  final String name;
  final int id;
  final String image;

  SearchModel({this.name, this.id, this.image});

  factory SearchModel.fromJson(Map<String, dynamic> json) {
    return SearchModel(
        name: json['name'] as String,
        id: json['id'] as int,
        image: json['image'] as String);
  }
}
