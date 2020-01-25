import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:topstyle/models/products_model.dart';

class ProductDetailsModelWithList {
  final ProductDetailsModel productDetailsModel;
  final List<ProductsModel> mayAlsoLike;

  ProductDetailsModelWithList({this.productDetailsModel, this.mayAlsoLike});

  factory ProductDetailsModelWithList.fromJson(Map<String, dynamic> json) {
    return ProductDetailsModelWithList(
        productDetailsModel: ProductDetailsModel.fromJson(json['data']),
        mayAlsoLike: ProductsModel.parseProducts(json['mayLike']));
  }
}

class ProductDetailsModel extends ChangeNotifier {
  final int id;
  final String name;
  final String description;
  final String category;
  final String brand;
  final int discount;
  final double ratting;
  int isFavorite;
  final int reviewers;
  final List<ProductOption> options;
  final List<ProductReview> reviews;

  ProductDetailsModel(
      {this.id,
      this.name,
      this.description,
      this.category,
      this.brand,
      this.discount,
      this.ratting,
      this.isFavorite = 0,
      this.reviewers,
      this.options,
      this.reviews});

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailsModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      brand: json['brand'] as String,
      discount: json['discount'] as int,
      ratting: double.parse(json['ratting']),
      isFavorite: json['isFavorite'] as int,
      reviewers: json['reviewers'] as int,
      options: parsedProductOption(json['options']),
      reviews: parsedProductReview(json['reviews']),
    );
  }

  static List<ProductOption> parsedProductOption(parsedJson) {
    var _list = parsedJson as List;
    List<ProductOption> _productOptions =
        _list.map((prodOption) => ProductOption.fromJson(prodOption)).toList();
    return _productOptions;
  }

  static List<ProductReview> parsedProductReview(parsedJson) {
    var _reviewsList = parsedJson as List;
    List<ProductReview> _productReviews = _reviewsList
        .map((prodReview) => ProductReview.fromJson(prodReview))
        .toList();
    return _productReviews;
  }

  Future<void> toggleFavoriteStatus(int productId, String token) async {
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
        print('is Favorite clicked');
      } else {
//        print(response.statusCode);
      }
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }
}

class ProductOption {
  final int id;
  final String optionName;
  final int quantity;
  final double price;
  final String status;
  final String type;
  final String value;
  final String specification;
  final int isAvailable;
  final List<String> media;

  ProductOption(
      {this.id,
      this.optionName,
      this.quantity,
      this.price,
      this.status,
      this.type,
      this.value,
      this.specification,
      this.isAvailable,
      this.media});

  factory ProductOption.fromJson(Map<String, dynamic> json) {
    return ProductOption(
        id: json['id'] as int,
        optionName: json['name'] as String,
        quantity: json['quantity'] as int,
        price: double.parse(json['price'] as String),
        status: json['status'] as String,
        type: json['type'] as String,
        value: json['value'] as String,
        specification: json['specification'] as String,
        isAvailable: json['isAvailable'] as int,
        media: parsedStringList(json['media']));
  }

  static List<String> parsedStringList(parsedJson) {
    List<String> parsedList = List<String>.from(parsedJson);
    return parsedList;
  }
}

class ProductReview {
  final String userName;
  final String review;
  final int ratting;

  ProductReview({this.userName, this.review, this.ratting});

  factory ProductReview.fromJson(Map<String, dynamic> json) {
    return ProductReview(
        userName: json['name'] as String,
        review: json['review'] as String,
        ratting: json["ratting"] as int);
  }
}
