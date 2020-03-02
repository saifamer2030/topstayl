import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:topstyle/constants/colors.dart';
import 'package:topstyle/helper/appLocalization.dart';
import 'package:topstyle/helper/size_config.dart';
import 'package:topstyle/models/products_model.dart';
import 'package:topstyle/screens/login_screen.dart';

import '../screens/product_details.dart';

class ProductItem extends StatelessWidget {
  _buildOptions(List<Option> options, BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: options.length > 4 ? 4 : options.length,
      itemBuilder: (context, i) => Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          width: widgetSize.subTitle,
          height: widgetSize.subTitle,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(int.parse('0xFF${options[i].optionValue}'))),
        ),
      ),
    );
  }

  ScreenConfig screenConfig;
  WidgetSize widgetSize;
  @override
  Widget build(BuildContext context) {
    screenConfig = ScreenConfig(context);
    widgetSize = WidgetSize(screenConfig);
    final product = Provider.of<ProductsModel>(context, listen: false);
    return LayoutBuilder(
      builder: (context, constraints) => GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProductDetails(product.id)));
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
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                      height: constraints.maxHeight * 0.53,
                      width: constraints.maxHeight * 0.45,
//                      padding: EdgeInsets.all(12.0),
                      child: Image.network(
                        product.image,
                        height: constraints.maxHeight * 0.53 - 5.0,
                        width: constraints.maxHeight * 0.45 - 10.0,
                        fit: BoxFit.contain,
//                          placeholder: (context, url) =>
//                              Image.asset('assets/images/logo.jpg'),
//                          color: Colors.grey.withOpacity(0.3),
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
                    child:
                        product.status == "new" || product.status == "exclusive"
                            ? Container(
                                width: 60.0,
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
                                        fontSize: widgetSize.iconText - 1,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              )
                            : Container(),
                  ),
                  product.itemsCount == 1 && product.quantity < 1
                      ? Positioned(
                          bottom: 1.0,
                          child: Container(
                            width: constraints.maxWidth / 2,
//                            margin:
//                                EdgeInsets.only(left: constraints.maxWidth / 4),
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                            ),
                            child: Text(
                              AppLocalization.of(context)
                                  .translate('product not available'),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: widgetSize.textFieldError,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      : Container(),
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
                  style: TextStyle(
                      color: Color(0xFF5a5a5a), fontSize: widgetSize.iconText),
                ),
              ),
              SizedBox(height: constraints.maxHeight * 0.02),
              Container(
                height: constraints.maxHeight * 0.11,
                child: Text(
                  product.name.length > 45
                      ? '${product.name.substring(0, 45)}...'
                      : product.name,
                  style: TextStyle(
                    fontSize: widgetSize.subTitle - 1,
                  ),
                ),
              ),
              Container(
                height: constraints.maxHeight * 0.06,
                child: product.options.length > 1
                    ? product.options[0].optionType == 'size'
                        ? Container()
                        : _buildOptions(product.options, context)
                    : Container(),
              ),
              Container(
                height: constraints.maxHeight * 0.07,
//                color: Colors.green,
                child: Row(
                  children: <Widget>[
                    Text(
                      '${double.parse(product.price).toStringAsFixed(2)} ${AppLocalization.of(context).translate("sar")}',
                      style: TextStyle(
                        decoration: product.discount != 0
                            ? TextDecoration.lineThrough
                            : null,
                        color: CustomColors.kTabBarIconColor,
                        fontSize: product.discount != 0
                            ? widgetSize.textFieldError
                            : widgetSize.subTitle,
                        fontWeight: product.discount == 0
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    product.discount == 0
                        ? Container()
                        : Text(
                            '${(double.parse(product.price) - (double.parse(product.price) * product.discount / 100)).toStringAsFixed(2)} ${AppLocalization.of(context).translate("sar")}',
                            style: TextStyle(
                              fontSize: widgetSize.subTitle,
                              fontWeight: FontWeight.bold,
                              color: CustomColors.kPriceColor,
                            ),
                          ),
                  ],
                ),
              ),
              product.discount == 0
                  ? Container()
                  : Container(
                      height: constraints.maxHeight * 0.07,
                      width: constraints.maxWidth,
                      margin: const EdgeInsets.symmetric(horizontal: 10.0),
                      padding: const EdgeInsets.all(3.0),
                      color: Color(0xffdb6772),
                      child: Center(
                        child: Text(
                          '${AppLocalization.of(context).translate('offer')} ${(double.parse(product.price) - (double.parse(product.price) - (double.parse(product.price) * product.discount / 100))).toStringAsFixed(2)} ',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
