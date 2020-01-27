import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:topstyle/constants/colors.dart';
import 'package:topstyle/helper/appLocalization.dart';
import 'package:topstyle/models/products_model.dart';
import 'package:topstyle/screens/login_screen.dart';

import '../screens/product_details.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductsModel>(context, listen: false);
    return LayoutBuilder(
      builder: (context, constraints) => GestureDetector(
        onTap: () {
          print(constraints.maxHeight * 0.5);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProductDetails(product.id)));
          print(product.id);
        },
        child: Container(
          height: constraints.maxHeight,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
              border: Border.all(width: 1.0, color: Color(0xFFeaeaea))),
          padding: const EdgeInsets.only(
              left: 8.0, right: 8.0, top: 8.0, bottom: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                      height: constraints.maxHeight * 0.6,
                      width: constraints.maxHeight * 0.5,
                      padding: EdgeInsets.all(12.0),
                      child: FadeInImage.assetNetwork(
                        image: product.image,
                        height: constraints.maxHeight * 0.6 - 16.0,
                        width: constraints.maxHeight * 0.5 - 10.0,
                        fit: BoxFit.contain,
                        fadeInDuration: const Duration(milliseconds: 200),
                        fadeInCurve: Curves.bounceIn,
                        placeholder: product.image,
                      )
//                    child: Image.network(
//                      product.image,
//                      height: constraints.maxHeight * 0.6 - 16.0,
//                      width: constraints.maxHeight * 0.5 - 10.0,
//                      fit: BoxFit.contain,
//                    ),
                      ),
                  Positioned(
                    top: 1.0,
                    right: 1.0,
                    child: Consumer<ProductsModel>(
                      builder: (context, prod, child) => GestureDetector(
                          onTap: () async {
                            final prefs = await SharedPreferences.getInstance();
                            if (prefs.getString('userData') != null) {
                              final data =
                                  jsonDecode(prefs.getString('userData'))
                                      as Map;
                              prod.toggleFavoriteStatus(
                                  product.id, data['userToken']);
                            } else {
                              Navigator.of(context)
                                  .pushNamed(LoginScreen.routeName);
                              SharedPreferences.getInstance().then((prefs) {
                                prefs.setString("redirection", 'toHome');
                              });
                            }
                          },
                          child: product.isFavorite == 1
                              ? Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                )
                              : Icon(Icons.favorite_border)),
                    ),
                  ),
                  Positioned(
                    top: 1.0,
                    left: 1.0,
                    child: product.status == ""
                        ? Container()
                        : Container(
                            width: 50.0,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 4.0),
                            decoration: BoxDecoration(
                                color: CustomColors.kTabBarIconColor,
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Center(
                              child: Text(
                                product.status == 'new'
                                    ? AppLocalization.of(context)
                                        .translate("new_tag")
                                    : AppLocalization.of(context)
                                        .translate("exclusive_tag"),
                                style: TextStyle(
                                    fontSize: 10.0, color: Colors.white),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
              SizedBox(
                height: constraints.maxHeight * 0.03,
              ),
              Container(
                height: constraints.maxHeight * 0.05,
//                color: Colors.red,
                child: Text(
                  product.brand.length > 22
                      ? '${product.brand.substring(0, 21)}...'
                      : product.brand,
                  style: TextStyle(color: Color(0xFF5a5a5a), fontSize: 12.0),
                ),
              ),
              SizedBox(height: constraints.maxHeight * 0.02),
              Container(
                height: constraints.maxHeight * 0.13,
//                color: Colors.amber,
                child: Text(
                  product.name.length > 45
                      ? '${product.name.substring(0, 45)}...'
                      : product.name,
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              ),
              Container(
                height: constraints.maxHeight * 0.10,
//                color: Colors.green,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
//
                  children: <Widget>[
                    product.discount == 0
                        ? Container()
                        : Text(
                            '${(double.parse(product.price) - (double.parse(product.price) * product.discount / 100)).toStringAsFixed(2)} ${AppLocalization.of(context).translate("sar")}',
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              color: CustomColors.kPriceColor,
                            ),
                          ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      '${double.parse(product.price).toStringAsFixed(2)} ${AppLocalization.of(context).translate("sar")}',
                      style: TextStyle(
                        decoration: product.discount != 0
                            ? TextDecoration.lineThrough
                            : null,
                        color: CustomColors.kTabBarIconColor,
                        fontSize: product.discount != 0 ? 12.0 : 14.0,
                        fontWeight: product.discount == 0
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
