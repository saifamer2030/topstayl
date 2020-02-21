import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topstyle/constants/colors.dart';
import 'package:topstyle/helper/appLocalization.dart';
import 'package:topstyle/providers/languages_provider.dart';
import 'package:topstyle/providers/user_provider.dart';

import '../providers/cart_provider.dart';

class CartItemListView extends StatefulWidget {
  final String productName;
  final int productId;
  final String brandName;
  final double productPrice;
  final int discountPrice;
  final int quantity;
  final int availableQuantity;
  final String productImageUrl;
  final int isAvailable;
  final String category;
  final String type;
  final String value;

  CartItemListView(
      {@required this.productId,
      @required this.quantity,
      @required this.availableQuantity,
      @required this.productPrice,
      @required this.discountPrice,
      @required this.productName,
      @required this.brandName,
      @required this.productImageUrl,
      @required this.isAvailable,
      this.category,
      this.value,
      this.type});

  @override
  _CartItemListViewState createState() => _CartItemListViewState();
}

class _CartItemListViewState extends State<CartItemListView> {
  final AppLanguageProvider appLanguage = AppLanguageProvider();

  final UserProvider userProvider = UserProvider();

  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final shoppingCartItem = Provider.of<CartItemProvider>(context);
    return Opacity(
      opacity: widget.isAvailable == 1 &&
              widget.availableQuantity > 0 &&
              widget.quantity <= widget.availableQuantity
          ? 1.0
          : 0.3,
      child: Container(
        margin: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 15.0,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(width: 1.0, color: CustomColors.kPCardColor),
            color: Colors.white),
//      color: Colors.green,
        height: 130,
        child: Row(children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              height: 130,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(color: Colors.white),
                    child: Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      child: CachedNetworkImage(
                        imageUrl: widget.productImageUrl,
                        width: 90.0,
                        height: 90.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              height: 130,
//            color: Colors.pink,
              margin: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(
                      top: 15.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          widget.brandName.length > 20
                              ? '${widget.brandName.substring(0, 19)}...'
                              : widget.brandName,
                          style: TextStyle(fontSize: 12.0),
                        ),
                        Text(
                          '${widget.discountPrice == 0 ? widget.productPrice.toStringAsFixed(2) : ((widget.productPrice) - (widget.discountPrice * widget.productPrice) / 100).toStringAsFixed(2)} ${AppLocalization.of(context).translate("sar")}',
                          style: TextStyle(
                              fontSize: 12.0, fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Wrap(children: [
                            Text(
                              widget.productName.length > 50
                                  ? '${widget.productName.substring(0, 49)}...'
                                  : widget.productName,
                              //40
                              style: TextStyle(
                                  fontSize: 12.0, fontWeight: FontWeight.bold),
                            ),
                          ]),
                        ),
                        SizedBox(
                          width: 3.0,
                        ),
                        Container(
                          child: Row(
                            children: <Widget>[
                              GestureDetector(
                                onTap: widget.isAvailable == 1
                                    ? () async {
                                        if (widget.quantity > 1) {
                                          final String lang =
                                              appLanguage.appLocal.toString();
                                          var userData = await userProvider
                                              .isAuthenticated();
                                          await shoppingCartItem
                                              .increaseDecreaseProductQty(
                                                  widget.productId,
                                                  lang,
                                                  widget.quantity - 1,
                                                  userData['Authorization']);
                                        }
                                      }
                                    : null,
                                child: Container(
                                  width: 30.0,
                                  height: 30.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                    border: Border.all(
                                        width: 1.0,
                                        color: CustomColors.kPCardColor),
                                  ),
                                  child: Icon(
                                    Icons.remove,
                                    color: Colors.black,
                                    size: 16.0,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10.0),
                                child: Text(
                                  shoppingCartItem
                                      .productQty(widget.productId)
                                      .toString(),
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              GestureDetector(
                                onTap: widget.isAvailable == 1 &&
                                        widget.availableQuantity > 0 &&
                                        widget.quantity <
                                            widget.availableQuantity
                                    ? () async {
                                        if (widget.quantity < 12) {
                                          final String lang =
                                              appLanguage.appLocal.toString();
                                          var userData = await userProvider
                                              .isAuthenticated();
                                          await shoppingCartItem
                                              .increaseDecreaseProductQty(
                                                  widget.productId,
                                                  lang,
                                                  widget.quantity + 1,
                                                  userData['Authorization']);
                                        }
                                      }
                                    : null,
                                child: Container(
                                  width: 30.0,
                                  height: 30.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                      border: Border.all(
                                          width: 1.0,
                                          color: CustomColors.kPCardColor)),
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.black,
                                    size: 16.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
//                  color: Colors.black45,
                    margin: const EdgeInsets.only(top: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        widget.type == 'color'
                            ? Container(
                                width: 20.0,
                                height: 20.0,
                                decoration: BoxDecoration(
                                  color: widget.value != null &&
                                          widget.value.length >= 3
                                      ? Color(int.parse('0xFF${widget.value}'))
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: widget.isAvailable == 1 &&
                                        widget.availableQuantity > 0 &&
                                        widget.quantity <=
                                            widget.availableQuantity
                                    ? Container()
                                    : Center(
                                        child: Icon(
                                          Icons.clear,
                                          size: 17,
                                          color: Colors.white,
                                        ),
                                      ),
                              )
                            : widget.type == 'size'
                                ? Container(
                                    width: 75.0,
                                    height: 30.0,
                                    padding: const EdgeInsets.all(3.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6.0),
                                      color: Color(0xFFe8e8e8),
                                    ),
                                    child: widget.value != null
                                        ? Center(
                                            child: widget.isAvailable == 1 &&
                                                    widget.availableQuantity >
                                                        0 &&
                                                    widget.quantity <=
                                                        widget.availableQuantity
                                                ? Text(
                                                    '${widget.value} ${AppLocalization.of(context).translate("ml")}',
                                                    style: TextStyle(
                                                        fontSize: 12.0),
                                                  )
                                                : Row(
                                                    children: <Widget>[
                                                      Text(
                                                        '${widget.value} ${AppLocalization.of(context).translate("ml")}',
                                                        style: TextStyle(
                                                            fontSize: 12.0),
                                                      ),
                                                      Icon(
                                                        Icons.clear,
                                                        size: 17,
                                                        color: CustomColors
                                                            .kTabBarIconColor,
                                                      ),
                                                    ],
                                                  ))
                                        : Container(),
                                  )
                                : Container(),
                        widget.isAvailable == 1 &&
                                widget.availableQuantity > 0 &&
                                widget.quantity <= widget.availableQuantity
                            ? Container()
                            : Text(
                                AppLocalization.of(context)
                                    .translate('product_out'),
                                style: TextStyle(
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              ),
                        Container(
                          child: GestureDetector(
                            onTap: () async {
                              final String lang =
                                  appLanguage.appLocal.toString();
                              var userData =
                                  await userProvider.isAuthenticated();
                              shoppingCartItem
                                  .removeProductById(widget.productId, lang, 0,
                                      userData['Authorization'])
                                  .then((response) {
                                // should be 2
                              });
//                            print(userData['Authorization']);
                            },
                            child: Icon(
                              CupertinoIcons.delete,
                              color: Colors.black,
                            ),
                          ),
//
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
