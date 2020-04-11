import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topstyle/constants/colors.dart';
import 'package:topstyle/helper/appLocalization.dart';
import 'package:topstyle/models/cart_item_model.dart';
import 'package:topstyle/providers/languages_provider.dart';
import 'package:topstyle/providers/user_provider.dart';
import 'package:topstyle/widgets/adaptive_progress_indecator.dart';

import '../providers/cart_provider.dart';

class CartItemListView extends StatefulWidget {
  final CartItemModel product;
  CartItemListView(this.product);

  @override
  _CartItemListViewState createState() => _CartItemListViewState();
}

class _CartItemListViewState extends State<CartItemListView> {
  final AppLanguageProvider appLanguage = AppLanguageProvider();
  final UserProvider userProvider = UserProvider();

  bool _isAddPressed = false;
  bool _isMinPressed = false;
  bool _isDeletePressed = false;

  addQty(BuildContext context, int lastQty) async {
    setState(() {
      _isAddPressed = true;
    });
    final String lang = appLanguage.appLocal.toString();
    var userData = await userProvider.isAuthenticated();
    await Provider.of<CartItemProvider>(context, listen: false)
        .increaseDecreaseProductQty(
            widget.product.id, lang, lastQty, userData['Authorization']);
    setState(() {
      _isAddPressed = false;
    });
  }

  minQty(BuildContext context, int lastQty) async {
    setState(() {
      _isMinPressed = true;
    });
    final String lang = appLanguage.appLocal.toString();
    var userData = await userProvider.isAuthenticated();
    await Provider.of<CartItemProvider>(context, listen: false)
        .increaseDecreaseProductQty(
            widget.product.id, lang, lastQty, userData['Authorization']);
    setState(() {
      _isMinPressed = false;
    });
  }

  _deleteProduct(BuildContext context) async {
    setState(() {
      _isDeletePressed = true;
    });
    final String lang = appLanguage.appLocal.toString();
    var userData = await userProvider.isAuthenticated();
    await Provider.of<CartItemProvider>(context, listen: false)
        .removeProductById(widget.product.id, lang, userData['Authorization']);
    setState(() {
      _isDeletePressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
//    final shoppingCartItem = Provider.of<CartItemProvider>(context);
    return Container(
      margin: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 15.0,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(width: 1.0, color: CustomColors.kPCardColor),
          color: Colors.white),
      height: 140,
      child: Row(children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(color: Colors.white),
                  child: Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: Opacity(
                      opacity: widget.product.isAvailable == 1 &&
                              widget.product.availableQuantity > 0 &&
                              widget.product.quantity <=
                                  widget.product.availableQuantity
                          ? 1.0
                          : 0.3,
                      child: Image(
                        image: NetworkImage(widget.product.productImageUrl),
                        width: 90.0,
                        height: 90.0,
                        fit: BoxFit.fill,
                      ),
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
                        widget.product.brandName.length > 20
                            ? '${widget.product.brandName.substring(0, 19)}...'
                            : widget.product.brandName,
                        style: TextStyle(fontSize: 12.0),
                      ),
                      Text(
                        '${widget.product.discount == 0 ? widget.product.productPrice.toStringAsFixed(2) : ((widget.product.productPrice) - (widget.product.productPrice * widget.product.discount) / 100).toStringAsFixed(2)} ${AppLocalization.of(context).translate("sar")}',
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
                            widget.product.productName.length > 50
                                ? '${widget.product.productName.substring(0, 49)}...'
                                : widget.product.productName,
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
                              onTap: widget.product.isAvailable == 1 &&
                                      widget.product.quantity > 1 &&
                                      !_isMinPressed
                                  ? () {
                                      setState(() {
                                        widget.product.quantity--;
                                      });
                                      minQty(context, widget.product.quantity);
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
                                child: _isMinPressed
                                    ? AdaptiveProgressIndicator()
                                    : Icon(
                                        Icons.remove,
                                        color: widget.product.quantity > 1
                                            ? Colors.black
                                            : Colors.grey.withOpacity(0.3),
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
                                '${widget.product.quantity}',
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            GestureDetector(
                              onTap: widget.product.isAvailable == 1 &&
                                      widget.product.availableQuantity > 1 &&
                                      widget.product.quantity <
                                          widget.product.availableQuantity &&
                                      widget.product.quantity < 12 &&
                                      !_isAddPressed
                                  ? () {
                                      setState(() {
                                        widget.product.quantity++;
                                      });
                                      addQty(context, widget.product.quantity);
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
                                child: _isAddPressed
                                    ? AdaptiveProgressIndicator()
                                    : Icon(
                                        Icons.add,
                                        color: widget.product.quantity < 12 &&
                                                widget.product
                                                        .availableQuantity >
                                                    1 &&
                                                widget.product.quantity <
                                                    widget.product
                                                        .availableQuantity
                                            ? Colors.black
                                            : Colors.grey.withOpacity(0.3),
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
                      widget.product.type == 'color'
                          ? Container(
                              width: 20.0,
                              height: 20.0,
                              decoration: BoxDecoration(
                                color: widget.product.value != null &&
                                        widget.product.value.length >= 3
                                    ? Color(int.parse(
                                        '0xFF${widget.product.value}'))
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: widget.product.isAvailable == 1 &&
                                      widget.product.availableQuantity > 0 &&
                                      widget.product.quantity <=
                                          widget.product.availableQuantity
                                  ? Container()
                                  : Center(
                                      child: Icon(
                                        Icons.clear,
                                        size: 17,
                                        color: Colors.white,
                                      ),
                                    ),
                            )
                          : widget.product.type == 'size'
                              ? Container(
                                  width: 75.0,
                                  height: 30.0,
                                  padding: const EdgeInsets.all(3.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6.0),
                                    color: Color(0xFFe8e8e8),
                                  ),
                                  child: widget.product.value != null
                                      ? Center(
                                          child: widget.product.isAvailable ==
                                                      1 &&
                                                  widget.product
                                                          .availableQuantity >
                                                      0 &&
                                                  widget.product.quantity <=
                                                      widget.product
                                                          .availableQuantity
                                              ? Text(
                                                  '${widget.product.value} ${AppLocalization.of(context).translate("ml")}',
                                                  style:
                                                      TextStyle(fontSize: 12.0),
                                                )
                                              : Row(
                                                  children: <Widget>[
                                                    Text(
                                                      '${widget.product.value} ${AppLocalization.of(context).translate("ml")}',
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
                      widget.product.isAvailable == 1 &&
                              widget.product.availableQuantity > 0 &&
                              widget.product.quantity <=
                                  widget.product.availableQuantity
                          ? Container()
                          : Text(
                              AppLocalization.of(context)
                                  .translate('product not available'),
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                      Container(
                        child: GestureDetector(
                          onTap: _isDeletePressed
                              ? null
                              : () {
                                  _deleteProduct(context);
                                },
                          child: _isDeletePressed
                              ? AdaptiveProgressIndicator()
                              : Icon(
                                  CupertinoIcons.delete,
                                  color: Colors.black,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
