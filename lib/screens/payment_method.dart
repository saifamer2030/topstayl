import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:topstyle/helper/size_config.dart';
import 'package:topstyle/models/checkout_summery_model.dart';
import 'package:topstyle/models/set_order.dart';
import 'package:topstyle/providers/cart_provider.dart';
import 'package:topstyle/providers/order_provider.dart';
import 'package:topstyle/providers/user_provider.dart';
import 'package:topstyle/screens/checkout_done.dart';
import 'package:topstyle/screens/payment_webview.dart';
import 'package:topstyle/widgets/adaptive_progress_indecator.dart';

import '../constants/colors.dart';
import '../helper/appLocalization.dart';

class PaymentMethod extends StatefulWidget {
  final TabController tabController;

  PaymentMethod(this.tabController);

  static const String routeName = "payment-method";

  @override
  _PaymentMethodState createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  bool _isInit = true;
  bool _isLoading = false;
  bool _isBtnLoading = false;
  String coupon;
  int couponPercentage = 0;
  double couponValue = 0.0;
  double _paymentDiscount = 0.0;
  double _cashOnDeliveryValueFees = 0.0;
  int _paymentRadioGroup = 0;

  UserProvider userData = UserProvider();
  CheckoutSummeryModel checkoutData;

  getCheckoutData() async {
    var token = await userData.isAuthenticated();
    setState(() {
      _isLoading = true;
    });
    checkoutData = await Provider.of<OrdersProvider>(context)
        .getCheckoutData(token['Authorization']);
    setState(() {
      if (checkoutData.payments[0].available == 1) {
        _paymentRadioGroup = 1;
      } else if (checkoutData.payments[1].available == 1) {
        _paymentRadioGroup = 2;
      } else {
        _paymentRadioGroup = 3;
      }
      calculatePaymentDiscount(_paymentRadioGroup);
      if (checkoutData != null) {
        _isLoading = false;
      }
    });
  }

  calculatePaymentDiscount(int paymentId) {
    setState(() {
      _paymentRadioGroup = paymentId;
    });
    if (paymentId > 1) {
      setState(() {
        couponValue = 0.0;
        _cashOnDeliveryValueFees = 0.0;
      });
      if (checkoutData.payments[paymentId - 1].isPercentage) {
        _paymentDiscount = checkoutData.summery.availableCostForCoupon *
            checkoutData.payments[paymentId - 1].cost /
            100;
      } else {
        _paymentDiscount = checkoutData.payments[paymentId - 1].cost;
      }
      if (checkoutData.payments[paymentId - 1].isDiscount) {
        _paymentDiscount *= -1;
      }
      print(_paymentDiscount);
      print(_cashOnDeliveryValueFees);
      print(couponValue);
    } else {
      _paymentDiscount = 0.0;
      if (checkoutData.payments[paymentId - 1].isPercentage) {
        _cashOnDeliveryValueFees = checkoutData.summery.availableCostForCoupon *
            checkoutData.payments[paymentId - 1].cost /
            100;
      } else {
        _cashOnDeliveryValueFees = checkoutData.payments[paymentId - 1].cost;
      }
      if (checkoutData.payments[paymentId - 1].isDiscount) {
        _cashOnDeliveryValueFees *= -1;
      }
      print(_cashOnDeliveryValueFees);
      print(_paymentDiscount);
      print(couponValue);
    }
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      getCheckoutData();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  _doCreditCardPayment(String total) async {
    setState(() {
      _isBtnLoading = true;
    });
    var token = await userData.isAuthenticated();
    var prefs = await SharedPreferences.getInstance();
    var data = jsonDecode(prefs.getString('userData')) as Map;
    String checkoutId = await Provider.of<OrdersProvider>(context)
        .requestCheckoutId(
            total, prefs.getInt('userCheckoutId'), data['email']);
    if (checkoutId != '') {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PaymentWebView(
          token['Authorization'],
          checkoutId,
          _paymentRadioGroup.toString(),
          coupon == null ? '' : coupon,
        ),
      ));
    } else {
      print('error in checkout id');
    }
    setState(() {
      _isBtnLoading = false;
    });
  }

  _doCashOnDeliveryPayment() async {
    setState(() {
      _isBtnLoading = true;
    });

    SetOrder orderData;
    var token = await userData.isAuthenticated();
    var prefs = await SharedPreferences.getInstance();
    int userCheckoutId = prefs.getInt('userCheckoutId');
    orderData = await Provider.of<OrdersProvider>(context).addOrder(
        token['Authorization'],
        _paymentRadioGroup.toString(),
        coupon == null ? '' : coupon,
        '',
        userCheckoutId);
    setState(() {
      _isBtnLoading = false;
    });

    if (orderData.orderId != null) {
      if (orderData.paymentUrl == "" ||
          orderData.paymentUrl == null && orderData.checkoutId == "" ||
          orderData.checkoutId == null) {
        print('is cash payment');
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => CheckoutDoneScreen(orderData.orderId)),
            (Route<dynamic> roue) => false);
      } else {
        print(orderData.paymentUrl);
        print('is credit payment');
//        Navigator.of(context).push(
//            MaterialPageRoute(builder: (context) => PaymentWebView(orderData)));
      }
    } else {
      print('order data is null');
    }
  }

  static const channel = const MethodChannel('com.topstylesa/applePay');

  Future<void> _doApplePay() async {
    try {
      final response = await channel.invokeMethod("applePay", ["Caming Soon"]);
      print('The Result From Swift : $response');
    } catch (e) {
      print(e.toString());
    }
    //print('hello apple pay');
  }

  ScreenConfig screenConfig;
  WidgetSize widgetSize;
  @override
  Widget build(BuildContext context) {
    screenConfig = ScreenConfig(context);
    widgetSize = WidgetSize(screenConfig);
    return _isLoading
        ? Center(child: AdaptiveProgressIndicator())
        : SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 32.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    AppLocalization.of(context).translate("delivery_location"),
                    style: TextStyle(
                        fontSize: widgetSize.subTitle,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.tabController.animateTo(0);
                    },
                    child: checkoutData != null && checkoutData.address != null
                        ? Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  checkoutData.address.userName,
                                  style: TextStyle(
                                      fontSize: widgetSize.subTitle,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  checkoutData.address.phone,
                                  style: TextStyle(
                                      fontSize: widgetSize.textFieldError),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      '${checkoutData.address.country ?? ''}،${checkoutData.address.city ?? ''}،${checkoutData.address.area ?? ''}،${checkoutData.address.street ?? ''}'
                                                  .length >
                                              50
                                          ? '${checkoutData.address.country ?? ''}،${checkoutData.address.city ?? ''}،${checkoutData.address.area ?? ''}،${checkoutData.address.street ?? ''}'
                                              .substring(0, 49)
                                          : '${checkoutData.address.country ?? ''}،${checkoutData.address.city ?? ''}،${checkoutData.address.area ?? ''}،${checkoutData.address.street ?? ''}',
                                      style: TextStyle(
                                          fontSize: widgetSize.content),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: widgetSize.subTitle,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        : Container(),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Divider(
                    height: 1.0,
                    color: CustomColors.kPCardColor,
                    thickness: 1.0,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    AppLocalization.of(context)
                        .translate("choose_payment_method"),
                    style: TextStyle(
                        fontSize: widgetSize.subTitle,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  checkoutData != null &&
                          checkoutData.payments[0].available == 1
                      ? Row(
                          children: <Widget>[
                            Radio(
                                value: 1,
                                groupValue: _paymentRadioGroup,
                                onChanged: (val) {
                                  calculatePaymentDiscount(val);
                                }),
                            Expanded(
                              child: Container(
                                child: ListTile(
                                  title: Text(
                                    AppLocalization.of(context)
                                        .translate("payment_when_receiving"),
                                    style: TextStyle(
                                        fontSize: widgetSize.subTitle),
                                  ),
                                  subtitle: Text(
                                    '${AppLocalization.of(context).translate('fee_in_cash_on_delivery')} ${checkoutData.payments[0].cost} ${AppLocalization.of(context).translate('sar')} ',
                                    style: TextStyle(
                                        fontSize: widgetSize.textFieldError),
                                  ),
                                  trailing: SvgPicture.asset(
                                    'assets/icons/cash.svg',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      : Container(),
                  SizedBox(
                    height: 8.0,
                  ),
                  Divider(
                    height: 1.0,
                    color: CustomColors.kPCardColor,
                    thickness: 1.0,
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  checkoutData != null &&
                          checkoutData.payments[1].available == 1 &&
                          Platform.isIOS
                      ? Row(
                          children: <Widget>[
                            Radio(
                                value: 2,
                                groupValue: _paymentRadioGroup,
                                onChanged: (val) {
                                  calculatePaymentDiscount(val);
                                }),
                            Expanded(
                              child: Container(
                                child: ListTile(
                                  title: Text(
                                    AppLocalization.of(context)
                                        .translate("apple_pay"),
                                    style: TextStyle(
                                        fontSize: widgetSize.subTitle),
                                  ),
                                  subtitle: Container(
                                      child: Text(
                                    '${AppLocalization.of(context).translate('discount_electronic_payment')} ${checkoutData.payments[2].cost} ${checkoutData.payments[2].isPercentage ? '%' : AppLocalization.of(context).translate('sar')}',
                                    style: TextStyle(
                                        fontSize: widgetSize.textFieldError),
                                  )),
                                  trailing: Image.asset(
                                    'assets/icons/apple_pay.png',
                                    width: 38.8,
                                    height: 16.0,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      : Container(),
                  SizedBox(
                    height: 8.0,
                  ),
                  Divider(
                    height: 1.0,
                    color: CustomColors.kPCardColor,
                    thickness: 1.0,
                  ),
                  checkoutData != null &&
                          checkoutData.payments[2].available == 1
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Radio(
                                    value: 3,
                                    groupValue: _paymentRadioGroup,
                                    onChanged: (val) {
                                      calculatePaymentDiscount(val);
                                    }),
                                Text(
                                  AppLocalization.of(context)
                                      .translate("credit_card"),
                                  style:
                                      TextStyle(fontSize: widgetSize.subTitle),
                                ),
                                Image.asset(
                                  'assets/icons/visa.png',
                                  width: 38.8,
                                  height: 16.0,
                                  fit: BoxFit.contain,
                                ),
                                Image.asset(
                                  'assets/icons/master.png',
                                  width: 19.8,
                                  height: 12.0,
                                  fit: BoxFit.contain,
                                ),
                                Image.asset(
                                  'assets/icons/amex.png',
                                  width: 17.8,
                                  height: 12.0,
                                  fit: BoxFit.contain,
                                ),
                                Image.asset(
                                  'assets/icons/mada.png',
                                  width: 35.0,
                                  height: 12.0,
                                  fit: BoxFit.contain,
                                ),
                              ],
                            ),
                            Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 67.0, vertical: 0.0),
                                child: Text(
                                  '${AppLocalization.of(context).translate('discount_electronic_payment')} ${checkoutData.payments[2].cost} ${checkoutData.payments[2].isPercentage ? '%' : AppLocalization.of(context).translate('sar')}',
                                  style: TextStyle(
                                      fontSize: widgetSize.textFieldError,
                                      color: Colors.grey),
                                ))
                          ],
                        )
                      : Container(),
                  SizedBox(
                    height: 8.0,
                  ),
                  Divider(
                    height: 1.0,
                    color: CustomColors.kPCardColor,
                    thickness: 1.0,
                  ),
                  SizedBox(
                    height: 32.0,
                  ),
                  Container(
                    height: 50.0,
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8.0, top: 5.0, bottom: 5.0),
                    decoration: BoxDecoration(
//                      errorText: 'Your Coupon May expired or Invalid',
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                            width: 1, color: CustomColors.kPCardColor)),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 5,
                          child: TextFormField(
                            onChanged: (val) {
                              setState(() {
                                coupon = val;
                              });
                            },
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: AppLocalization.of(context)
                                    .translate("coupon"),
                                hintStyle: TextStyle(
                                    color: CustomColors.kTabBarIconColor,
                                    fontSize: widgetSize.subTitle + 1)),
//
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: () async {
                              var token = await userData.isAuthenticated();
                              Provider.of<CartItemProvider>(context)
                                  .applyCoupon(token['Authorization'], coupon)
                                  .then((coupon) {
                                if (coupon['couponValue'] > 0.0) {
                                  setState(() {
                                    couponValue = coupon['couponValue'];
                                    _paymentDiscount = 0.0;
                                  });
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) => CupertinoAlertDialog(
                                      title: Text(
                                        AppLocalization.of(context)
                                            .translate('attention'),
                                      ),
                                      content: Text(AppLocalization.of(context)
                                          .translate('coupon_not_valid')),
                                      actions: <Widget>[
                                        FlatButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            AppLocalization.of(context)
                                                .translate('ok'),
                                            style: TextStyle(
                                                fontSize:
                                                    widgetSize.subTitle + 1),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                  setState(() {
                                    couponValue = 0.0;
                                  });
                                }
                              });
                            },
                            child: couponValue == 0.0
                                ? Text(
                                    AppLocalization.of(context)
                                        .translate("check"),
                                    textAlign: TextAlign.end,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                : Icon(
                                    Icons.check_circle,
                                    color: CustomColors.kPAddedToCartIconColor,
                                    size: widgetSize.favoriteIconSize,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    AppLocalization.of(context)
                        .translate("order_summary_title"),
                    style: TextStyle(
                        fontSize: widgetSize.content,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        AppLocalization.of(context).translate("purchase_price"),
                        style: TextStyle(fontSize: widgetSize.subTitle),
                      ),
                      Text(
                        checkoutData != null
                            ? '${checkoutData.summery.total - checkoutData.summery.discount} ${AppLocalization.of(context).translate("sar")}'
                            : '',
                        style: TextStyle(fontSize: widgetSize.subTitle),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        AppLocalization.of(context).translate("shipping_cost"),
                        style: TextStyle(fontSize: widgetSize.subTitle),
                      ),
                      checkoutData != null
                          ? Text(
                              (checkoutData.summery.total -
                                          checkoutData.summery.discount -
                                          couponValue -
                                          _paymentDiscount) >=
                                      checkoutData.address.freeShipping
                                  ? AppLocalization.of(context)
                                      .translate('free_shipping')
                                  : '${checkoutData.address.cost} ${AppLocalization.of(context).translate("sar")}',
                              style: TextStyle(
                                  fontSize: widgetSize.subTitle,
                                  color: Theme.of(context).accentColor,
                                  fontWeight: FontWeight.bold),
                            )
                          : Container(),
                    ],
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  checkoutData != null && _paymentRadioGroup == 1
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              AppLocalization.of(context)
                                  .translate("cash_on_delivery_fee_hint"),
                              style: TextStyle(fontSize: widgetSize.subTitle),
                            ),
                            Text(
                              '$_cashOnDeliveryValueFees ${AppLocalization.of(context).translate("sar")}',
                              style: TextStyle(fontSize: widgetSize.subTitle),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              AppLocalization.of(context).translate("discount"),
                              style: TextStyle(fontSize: widgetSize.subTitle),
                            ),
                            Text(
                              '$_paymentDiscount ${AppLocalization.of(context).translate("sar")}',
                              style: TextStyle(fontSize: widgetSize.subTitle),
                            ),
                          ],
                        ),
                  SizedBox(
                    height: 5.0,
                  ),
                  checkoutData != null && _paymentDiscount < 0.0
                      ? Text(
                          '(${AppLocalization.of(context).translate("coupon_hint")})',
                          style: TextStyle(
                              fontSize: widgetSize.textFieldError - 1,
                              color: Colors.red,
                              fontWeight: FontWeight.bold),
                        )
                      : Container(),
                  SizedBox(
                    height: 8.0,
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  checkoutData != null && couponValue > 0.0
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              '${AppLocalization.of(context).translate("coupon_value")}($coupon)',
                              style: TextStyle(fontSize: widgetSize.subTitle),
                            ),
                            Text(
                              '$couponValue ${AppLocalization.of(context).translate("sar")}',
                              style: TextStyle(fontSize: widgetSize.subTitle),
                            ),
                          ],
                        )
                      : Container(),
                  checkoutData != null && couponValue > 0.0
                      ? Text(
                          '(${AppLocalization.of(context).translate('coupon_hint')})',
                          style: TextStyle(
                              fontSize: widgetSize.textFieldError - 1,
                              color: Colors.red,
                              fontWeight: FontWeight.bold),
                        )
                      : Container(),
                  SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        AppLocalization.of(context).translate("total"),
                        style: TextStyle(fontSize: widgetSize.subTitle),
                      ),
                      Text(
                        checkoutData != null
                            ? '${(checkoutData.summery.total - couponValue - checkoutData.summery.discount + _paymentDiscount + ((checkoutData.summery.total - checkoutData.summery.discount - couponValue - _paymentDiscount) >= checkoutData.address.freeShipping ? 0 : checkoutData.address.cost) + _cashOnDeliveryValueFees).toStringAsFixed(2)} ${AppLocalization.of(context).translate("sar")}'
                            : '',
                        style: TextStyle(fontSize: widgetSize.subTitle),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Divider(
                    height: 1.0,
                    color: CustomColors.kPCardColor,
                    thickness: 1.0,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: checkoutData != null &&
                              checkoutData.address.country != null
                          ? Theme.of(context).accentColor
                          : Colors.grey,
                    ),
                    child: FlatButton(
                      onPressed: checkoutData != null &&
                              checkoutData.address.country != null
                          ? () {
                              if (_paymentRadioGroup == 1) {
                                _doCashOnDeliveryPayment();
                              } else if (_paymentRadioGroup == 2) {
                                _doApplePay();
                              } else {
                                String total = (checkoutData.summery.total -
                                        couponValue -
                                        checkoutData.summery.discount +
                                        _paymentDiscount +
                                        ((checkoutData.summery.total -
                                                    checkoutData
                                                        .summery.discount -
                                                    couponValue -
                                                    _paymentDiscount) >=
                                                checkoutData
                                                    .address.freeShipping
                                            ? 0
                                            : checkoutData.address.cost) +
                                        _cashOnDeliveryValueFees)
                                    .toStringAsFixed(2);
                                _doCreditCardPayment(total);
                              }
                            }
                          : null,
                      child: _isBtnLoading
                          ? AdaptiveProgressIndicator()
                          : Text(
                              AppLocalization.of(context)
                                  .translate("confirm_order"),
                              style: TextStyle(
                                  fontSize: widgetSize.content,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                ],
              ),
            ),
          );
  }
}
