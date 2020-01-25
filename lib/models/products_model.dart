import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ProductsModel extends ChangeNotifier {
  final int id;
  final String name;
  final String brand;
  final String price;
  final String status;
  final int isAvailable;
  int isFavorite;
  final int discount;
  final String image;

  ProductsModel(
      {this.id,
      this.name,
      this.brand,
      this.status,
      this.isFavorite = 0,
      this.discount,
      this.image,
      this.price,
      this.isAvailable});

  factory ProductsModel.fromJson(Map<String, dynamic> json) {
    return ProductsModel(
        id: json["id"] as int,
        name: json["name"] as String,
        brand: json["brand"] as String,
        status: json["status"] as String,
        isFavorite: json["isFavorite"] as int,
        discount: json["discount"] as int,
        image: json["image"] as String,
        price: json["price"] as String,
        isAvailable: json["stockStatus"] as int);
  }

  static List<ProductsModel> parseProducts(List<dynamic> responseBody) {
    return responseBody
        .map<ProductsModel>((json) => ProductsModel.fromJson(json))
        .toList();
  }

  Future<void> toggleFavoriteStatus(int productId, String token) async {
    int oldFavorite = isFavorite;
    isFavorite = isFavorite == 0 ? 1 : 0;
    notifyListeners();
    try {
      final String baseUrl = 'http://192.168.100.29/api/';
      final response = await http.get(
        '${baseUrl}favorite/$productId',
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
