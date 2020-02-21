import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:topstyle/helper/api_util.dart';

class ProductsModel extends ChangeNotifier {
  final int id;
  final String name;
  final String brand;
  final String price;
  final String status;
  final int isAvailable;
  int isFavorite;
  final int discount;
  final int quantity;
  final int itemsCount;
  final String image;
  final List<Option> options;

  ProductsModel(
      {this.id,
      this.name,
      this.brand,
      this.status,
      this.isFavorite = 0,
      this.discount,
      this.image,
      this.price,
      this.quantity,
      this.itemsCount,
      this.isAvailable,
      this.options});

  factory ProductsModel.fromJson(Map<String, dynamic> json) {
    return ProductsModel(
        id: json["id"] as int,
        name: json["name"] as String,
        brand: json["brand"] as String,
        status: json["status"] as String,
        isFavorite: json["isFavorite"] as int,
        discount: json["discount"] as int,
        quantity: json["quantity"] as int,
        itemsCount: json["itemsCount"] as int,
        image: json["image"] as String,
        price: json["price"] as String,
        isAvailable: json["stockStatus"] as int,
        options: parseOptions(json["options"]));
  }

  static List<ProductsModel> parseProducts(List<dynamic> responseBody) {
    return responseBody
        .map<ProductsModel>((product) => ProductsModel.fromJson(product))
        .toList();
  }

  static List<Option> parseOptions(List<dynamic> responseBody) {
    return responseBody
        .map<Option>((option) => Option.fromJson(option))
        .toList();
  }

  Future<void> toggleFavoriteStatus(int productId, String token) async {
    int oldFavorite = isFavorite;
    isFavorite = isFavorite == 0 ? 1 : 0;
    notifyListeners();
    try {
      final response = await http.get(
        '${ApiUtil.BASE_URL}favorite/$productId',
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          "Accept": "application/json",
        },
      );
      if (response.statusCode == 200) {
//        print(jsonDecode(response.body));
//        print('is Favorite Done');
      } else {
        isFavorite = oldFavorite;
        print(response.statusCode);
      }
    } catch (error) {
      print(error.toString());
      isFavorite = oldFavorite;
      throw error;
    }
  }
}

class Option {
  final String optionType;
  final String optionValue;
  Option({this.optionType, this.optionValue});

  factory Option.fromJson(Map<String, dynamic> jsonObject) {
    return Option(
        optionType: jsonObject['type'] as String,
        optionValue: jsonObject['value'] as String);
  }
}
