import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:topstyle/constants/colors.dart';
import 'package:topstyle/helper/appLocalization.dart';
import 'package:topstyle/models/cart_item_model.dart';
import 'package:topstyle/providers/cart_provider.dart';
import 'package:topstyle/providers/languages_provider.dart';
import 'package:topstyle/providers/order_provider.dart';
import 'package:topstyle/providers/user_provider.dart';
import 'package:topstyle/screens/checkoutScreen.dart';
import 'package:topstyle/screens/login_screen.dart';
import 'package:topstyle/widgets/adaptive_progress_indecator.dart';
import 'package:topstyle/widgets/cart_item_in_listview.dart';

class CartScreen extends StatefulWidget {
  static const String routeName = 'cart';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen>
    with AutomaticKeepAliveClientMixin<CartScreen> {
  @override
  bool get wantKeepAlive => true;

  bool _isProductOutOfStock = false;
  bool _isLoading = false;
  bool _isBtnLoading = false;
  double totalPrice = 0.0;

  List<CartItemModel> cartItems = [];
  UserProvider userProvider = UserProvider();
  AppLanguageProvider appLanguage = AppLanguageProvider();

  getCartData() async {
    setState(() {
      _isLoading = true;
    });
    var token = await userProvider.isAuthenticated();
    final String lang = appLanguage.appLocal.toString();
    cartItems = await Provider.of<CartItemProvider>(context)
        .fetchAllCartItem(lang, token['Authorization']);
    cartItems.forEach((cart) {
      if (cart.isAvailable == 0 || cart.quantity > cart.availableQuantity) {
        setState(() {
          _isProductOutOfStock = true;
        });
      }
    });
    setState(() {
      _isLoading = false;
    });
//    print(_allCartItems.length);
  }

  @override
  void initState() {
    getCartData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final unavailableList = cartItems
        .where((e) => e.isAvailable == 0 || e.quantity > e.availableQuantity)
        .toList();

    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      child: _isLoading
          ? Center(
              child: AdaptiveProgressIndicator(),
            )
          : cartItems.length > 0
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Consumer<CartItemProvider>(
                        builder: (context, cart, _) => Container(
                              padding: const EdgeInsets.all(5.0),
                              margin: const EdgeInsets.only(
                                  left: 16.0, right: 16.0, top: 10.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: cart.totalPrice >= 199.0
                                    ? Color(0xff009688)
                                    : Colors.black,
                              ),
                              child: Text(
                                '${cart.totalPrice >= 199.0 ? AppLocalization.of(context).translate('free_shipping_hint') : '${AppLocalization.of(context).translate('get_free_shipping_hint_1')}${(cart.totalPrice - 199.0).abs()} ${AppLocalization.of(context).translate("sar")}${AppLocalization.of(context).translate('get_free_shipping_hint_2')}'}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.0,
                                    color: Colors.white),
                              ),
                            )),
                    Expanded(
                      child: ListView.builder(
                          itemCount: cartItems.length,
                          itemBuilder: (ctx, index) => CartItemListView(
                                productId: cartItems[index].id,
                                productName: cartItems[index].productName,
                                brandName: cartItems[index].brandName,
                                productImageUrl:
                                    cartItems[index].productImageUrl,
                                productPrice: cartItems[index].productPrice,
                                isAvailable: cartItems[index].isAvailable,
                                availableQuantity:
                                    cartItems[index].availableQuantity,
                                category: cartItems[index].category,
                                quantity: cartItems[index].quantity > 0
                                    ? cartItems[index].quantity
                                    : 0,
                                type: cartItems[index].type,
                                value: cartItems[index].value,
                              )),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16.0),
                              topRight: Radius.circular(16.0)),
                          color: Theme.of(context).primaryColor,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                offset: Offset(0, -2),
                                blurRadius: 3)
                          ]),
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 2.0),
                            child: Container(
                              margin:
                                  const EdgeInsets.only(top: 10.0, bottom: 5.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    AppLocalization.of(context)
                                        .translate("total"),
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Consumer<CartItemProvider>(
                                    builder: (context, cart, _) => Text(
                                      '${cart.totalPrice.toStringAsFixed(2)} ${AppLocalization.of(context).translate("sar")}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: 40.0,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 5.0),
                            decoration: BoxDecoration(boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  offset: Offset(0, -2),
                                  blurRadius: 8)
                            ]),
                            child: RaisedButton(
                              color: unavailableList.length > 0
                                  ? Colors.grey
                                  : CustomColors.kTabBarIconColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              onPressed: _isBtnLoading ||
                                      unavailableList.length > 0
                                  ? null
                                  : () async {
                                      var token =
                                          await userProvider.isAuthenticated();
                                      if (token['Authorization'] == 'none') {
                                        Navigator.of(context)
                                            .pushNamed(LoginScreen.routeName);
                                        SharedPreferences.getInstance()
                                            .then((prefs) {
                                          prefs.setString(
                                              "redirection", 'toPayment');
                                        });
                                      } else {
                                        setState(() {
                                          _isBtnLoading = true;
                                        });
                                        var token = await userProvider
                                            .isAuthenticated();
                                        Provider.of<OrdersProvider>(context)
                                            .getUserAddresses(
                                                token['Authorization'])
                                            .then((address) {
                                          setState(() {
                                            _isBtnLoading = false;
                                          });
                                          if (address == null) {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        CheckoutScreen(0)));
                                          } else {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        CheckoutScreen(
                                                            0, address)
//                                                  PreviousAddress(address),
                                                    ));
                                          }
                                        });
                                      }
                                    },
                              child: _isBtnLoading
                                  ? AdaptiveProgressIndicator()
                                  : Text(
                                      AppLocalization.of(context)
                                          .translate("checkout"),
                                      style: TextStyle(color: Colors.white),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              : Center(
                  child: Text(
                      AppLocalization.of(context).translate("bag_is_empty")),
                ),
    );
//
  }
}
