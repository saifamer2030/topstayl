import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:topstyle/helper/api_util.dart';
import 'package:topstyle/models/ads_model.dart';
import 'package:topstyle/models/home_page_model.dart';
import 'package:topstyle/models/product_details_model.dart';

import '../models/products_model.dart';

class ProductsProvider with ChangeNotifier {
  List<ProductsModel> _bestSeller = [];
  List<ProductsModel> _makeup = [];
  List<ProductsModel> _perfume = [];
  List<ProductsModel> _care = [];
  List<ProductsModel> _lenses = [];
  List<ProductsModel> _nails = [];
  List<ProductsModel> _devices = [];
  List<ProductsModel> _favorite = [];
  List<Ads> _ads = [];

  List<ProductsModel> get devices => _devices;

  List<ProductsModel> get nails => _nails;

  List<ProductsModel> get lenses => _lenses;

  List<ProductsModel> get care => _care;

  List<ProductsModel> get perfume => _perfume;

  List<ProductsModel> get makeup => _makeup;

  List<ProductsModel> get bestSeller => _bestSeller;

  List<ProductsModel> get favorite => _favorite;

  List<Ads> get ads {
    return List.from(_ads);
  }

  Future<int> sendEmailReminder(String email, String poid) async {
    int result = 0;
    try {
      final response = await http.post('${ApiUtil.BASE_URL}remember',
          body: {'email': email, 'product_option_id': poid});
      if (response.statusCode == 201) {
        print(jsonDecode(response.body));
        if (!response.body.contains('errors')) {
          result = 1;
          print(jsonDecode(response.body));
        }
      } else {
        print(response.statusCode);
      }
    } catch (error) {
      print(error.toString());
      throw error;
    }
    return result;
  }

  Future<int> submitComment(
      String review, int productId, double rate, String token) async {
    int msg = 0;
//    print(review);
    try {
      final response = await http.post('${ApiUtil.BASE_URL}review', headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        "Accept": "application/json",
        "APPKEY": ApiUtil.APPKEY,
      }, body: {
        'rate': rate.round().toString(),
        'review': review,
        'product_id': productId.toString()
      });
      if (response.statusCode == 200) {
        msg = 1;
        print(response.body);
      } else {
        msg = 2;
        print(response.body);
      }
    } catch (error) {
      print(msg);
      print(error.toString());
//      throw error;
    }
    return msg;
  }

  Future<ProductDetailsModelWithList> productDetailsData(
      int productId, String lang, String token) async {
    ProductDetailsModelWithList productDetailsModelWithList;
    try {
      final response = token == 'none'
          ? await http.get(
              '${ApiUtil.BASE_URL}product/details/guest/$productId?lang=$lang',
              headers: {
                  "Accept": "application/json",
                  "APPKEY": ApiUtil.APPKEY,
                })
          : await http.get(
              '${ApiUtil.BASE_URL}product/details/$productId?lang=$lang',
              headers: {
                  HttpHeaders.authorizationHeader: 'Bearer $token',
                  "Accept": "application/json",
                  "APPKEY": ApiUtil.APPKEY,
                });
      if (response.statusCode == 200) {
        if (jsonDecode(response.body) != null) {
//          print(jsonDecode(response.body));
          productDetailsModelWithList =
              ProductDetailsModelWithList.fromJson(jsonDecode(response.body));
//          print(productDetailsModelWithList.productDetailsModel.name);
        }
      } else {
        print('request is faild in product provider'
            ' productDetailsData'
            ' code ${response.statusCode}');
      }
    } catch (error) {
      print(error.toString());
      throw error.toString();
    }
    return productDetailsModelWithList;
  }

  Future<bool> toggleProductFavorite(int productId, String token) async {
    bool isDone = false;
    try {
      final response = await http.get(
        '${ApiUtil.BASE_URL}favorite/$productId',
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          "Accept": "application/json",
          "APPKEY": ApiUtil.APPKEY,
        },
      );
      if (response.statusCode == 200) {
        notifyListeners();
        isDone = true;
//        print(jsonDecode(response.body));
      } else {
        isDone = false;
        print(response.statusCode);
      }
    } catch (error) {
      print(error.toString());
      throw error;
    }
    notifyListeners();
    return isDone;
  }

  Future<List<ProductsModel>> allFavoriteProducts(
      String lang, String token) async {
    try {
      final response = await http.get(
        '${ApiUtil.BASE_URL}favorite?lang=$lang',
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          "Accept": "application/json",
          "APPKEY": ApiUtil.APPKEY,
        },
      );
      if (response.statusCode == 200) {
        _favorite = ProductsModel.parseProducts(
            jsonDecode(response.body)['data'] as List);
      } else {}
    } catch (error) {
      print(error.toString());
      throw error.toString();
    }
    return List.from(_favorite);
  }

  // Data is See More With Filter
  Future<Map<String, dynamic>> allDataInSeeMoreWithMultiFilter(
      String category, String lang, int pageNumber, String token) async {
    List<ProductsModel> _allProductsFilter = [];
    Map<String, dynamic> responseMap;
    try {
      final response = token == 'none'
          ? await http.get(
              '${ApiUtil.BASE_URL}filtter/guest?category=$category&lang=$lang&page=$pageNumber',
              headers: {
                  "Accept": "application/json",
                  "APPKEY": ApiUtil.APPKEY,
                })
          : await http.get(
              '${ApiUtil.BASE_URL}filtter/?category=$category&lang=$lang&page=$pageNumber',
              headers: {
                  HttpHeaders.authorizationHeader: 'Bearer $token',
                  "Accept": "application/json",
                  "APPKEY": ApiUtil.APPKEY,
                });
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['data'] != null) {
          print(jsonDecode(response.body)['data']);
          _allProductsFilter = ProductsModel.parseProducts(
              jsonDecode(response.body)['data'] as List);
          responseMap = {
            'data': _allProductsFilter,
            'last_page': jsonDecode(response.body)['meta']['last_page'],
          };
        }
      } else {
        print('request is faild in product provider'
            ' allDataInSpecificCategoryWith Multi Filter status'
            ' code ${response.statusCode}');
      }
    } catch (error) {
      print(error.toString());
      throw error.toString();
    }
    return responseMap;
  }

  Future<Map<String, dynamic>> allDataInSeeMoreWithFilter(String category,
      String lang, int pageNumber, String order, String token) async {
    List<ProductsModel> _allProductsFilter = [];
    Map<String, dynamic> responseMap;
    print(order);
    print(pageNumber);
    try {
      final response = token == 'none'
          ? await http.get(
              '${ApiUtil.BASE_URL}filtter/guest?category=$category&lang=$lang&order=$order&page=$pageNumber',
              headers: {
                  "Accept": "application/json",
                  "APPKEY": ApiUtil.APPKEY,
                })
          : await http.get(
              '${ApiUtil.BASE_URL}filtter/?category=$category&lang=$lang&order=$order&page=$pageNumber',
              headers: {
                  HttpHeaders.authorizationHeader: 'Bearer $token',
                  "Accept": "application/json",
                  "APPKEY": ApiUtil.APPKEY,
                });
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['data'] != null) {
          print(jsonDecode(response.body));
          _allProductsFilter = ProductsModel.parseProducts(
              jsonDecode(response.body)['data'] as List);
          responseMap = {
            'data': _allProductsFilter,
            'last_page': jsonDecode(response.body)['meta']['last_page'],
          };
        }
      } else {
        print('request is faild in product provider'
            ' allDataInSpecificCategoryAndFilter status'
            ' code ${response.statusCode}');
      }
    } catch (error) {
      print(error.toString());
      throw error.toString();
    }
    return responseMap;
  }

  // Data in See More Page
  Future<Map<String, dynamic>> allDataInSpecificCategory(
      String category, String lang, int pageNumber, String token) async {
//    print(token);
    List<ProductsModel> _allProducts = [];
    Map<String, dynamic> responseMap;
    try {
      final response = token == 'none'
          ? await http.get(
              '${ApiUtil.BASE_URL}products/guest/$category?lang=$lang&page=$pageNumber',
              headers: {
                  "Accept": "application/json",
                  "APPKEY": ApiUtil.APPKEY,
                })
          : await http.get(
              '${ApiUtil.BASE_URL}products/$category?lang=$lang&page=$pageNumber',
              headers: {
                HttpHeaders.authorizationHeader: 'Bearer $token',
                "Accept": "application/json",
                "APPKEY": ApiUtil.APPKEY,
              },
            );
      if (response.statusCode == 200) {
        _allProducts = ProductsModel.parseProducts(
            jsonDecode(response.body)['data'] as List);
//        print(jsonDecode(response.body)['meta']);
        responseMap = {
          'data': _allProducts,
          'last_page': jsonDecode(response.body)['meta']['last_page'],
        };
      }
    } catch (error) {
      print(error.toString());
      throw error.toString();
    }
    return responseMap;
  }

  Future<Map<String, dynamic>> allDataWithSpecificBrand(
      String brandId, int pageNumber, String lang) async {
    print('barand is :$brandId');
    List<ProductsModel> _allProducts = [];
    Map<String, dynamic> responseMap;
    try {
      final response = await http.get(
          '${ApiUtil.BASE_URL}brandProducts/$brandId?page=$pageNumber&lang=$lang',
          headers: {
            "Accept": "application/json",
            "APPKEY": ApiUtil.APPKEY,
          });
      if (response.statusCode == 200) {
        _allProducts = ProductsModel.parseProducts(
            jsonDecode(response.body)['data'] as List);
        responseMap = {
          'data': _allProducts,
          'last_page': jsonDecode(response.body)['meta']['last_page'],
        };
      }
    } catch (error) {
      print(error.toString());
      throw error;
    }
    return responseMap;
  }

  Future<HomePageModel> fetchAllProducts(String lang, String token) async {
    HomePageModel home;
    try {
      final response = token == 'none'
          ? await http.get('${ApiUtil.BASE_URL}homePageGuest?lang=$lang')
          : await http.get(
              '${ApiUtil.BASE_URL}homePage?lang=$lang',
              headers: {
                HttpHeaders.authorizationHeader: 'Bearer $token',
                "Accept": "application/json",
                "APPKEY": ApiUtil.APPKEY,
              },
            );

      if (response.statusCode == 200) {
        if (jsonDecode(response.body) != null) {
          home = HomePageModel.fromJson(jsonDecode(response.body));
        }
      } else {
        print('response status code is ${response.statusCode}');
      }
    } catch (e) {
      print(e.toString());
    }
    return home;
  }

//  ProductDetailsModelWithList get productDetails {
//    return productDetailsModelWithList;
//  }
}
