import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:topstyle/helper/appLocalization.dart';
import 'package:topstyle/helper/size_config.dart';
import 'package:topstyle/models/set_order.dart';
import 'package:topstyle/providers/network_provider.dart';
import 'package:topstyle/providers/order_provider.dart';
import 'package:topstyle/providers/user_provider.dart';
import 'package:topstyle/screens/checkout_done.dart';
import 'package:topstyle/widgets/connectivity_widget.dart';

class PaymentWebView extends StatefulWidget {
  final String token, checkoutId, paymentType, coupon;

  PaymentWebView(this.token, this.checkoutId, this.paymentType, this.coupon);

  @override
  _PaymentWebViewState createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  final flutterWebViewPlugin = new FlutterWebviewPlugin();
  StreamSubscription<String> _onUrlChanged;
  bool _isOrderSent = true;
  UserProvider userData = UserProvider();

  _doSendOrder() async {
    SetOrder orderData;
    var token = await userData.isAuthenticated();
    var prefs = await SharedPreferences.getInstance();
    int userCheckoutId = await prefs.getInt('userCheckoutId');
    orderData = await Provider.of<OrdersProvider>(context).addOrder(
        token['Authorization'],
        widget.paymentType,
        widget.coupon,
        widget.checkoutId,
        userCheckoutId);
    if (orderData != null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => CheckoutDoneScreen(orderData.orderId)),
          (Route<dynamic> roue) => false);
//      print(orderData.checkoutId);
    } else {
      flutterWebViewPlugin.hide();
      showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text('حدث خطأ'),
          content: Text(
            'إختر طريقه دفع اخري او اعد المحاولة لاحقاً',
            style: TextStyle(fontSize: 14.0),
          ),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text('حسناً'))
          ],
        ),
      );
    }
  }

  String _status;

  _checkPaymentStatus() async {
    _status = await Provider.of<OrdersProvider>(context).checkPaymentStatus(
      widget.checkoutId,
    );
//    _status = '000.200.000';
    List<String> stringList = _status.split('.');
    List<int> responseList = stringList.map((e) => int.parse(e)).toList();
    // Done Transactions go to order page
    if ((responseList[0] == 0) &&
        (responseList[1] == 0 ||
            responseList[1] == 100 ||
            responseList[1] == 300 ||
            responseList[1] == 310 ||
            responseList[1] == 600) &&
        (responseList[2] == 0 ||
            responseList[2] == 100 ||
            responseList[2] == 101 ||
            responseList[2] == 102 ||
            responseList[2] == 110 ||
            responseList[2] == 111 ||
            responseList[2] == 112)) {
      print('Successful');
      _doSendOrder();
      print(responseList[2]);
    } else if ((responseList[0] == 0) &&
        (responseList[1] == 200) &&
        (responseList[2] == 0 ||
            responseList[2] == 001 ||
            responseList[2] >= 100 && responseList[2] <= 103 ||
            responseList[2] == 200)) {
      // pending Transactions go to payment again with same checkout id
      print('Pending');
      flutterWebViewPlugin.hide();
      flutterWebViewPlugin.stopLoading();
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => CupertinoAlertDialog(
          content: Text(AppLocalization.of(context)
              .translate('something_went_wrong_in_payment')),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  flutterWebViewPlugin.show();
                  flutterWebViewPlugin.launch(
                      'http://192.168.100.29/api/payment?checkoutId=${widget.checkoutId}');
                },
                child: Text(AppLocalization.of(context).translate('ok')))
          ],
        ),
      );
    } else {
      // otherwise display dialog
      print('Otherwise hapnes');
      flutterWebViewPlugin.hide();
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => CupertinoAlertDialog(
          content: Text(AppLocalization.of(context)
              .translate('something_went_wrong_in_payment')),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text(AppLocalization.of(context).translate('ok')))
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    flutterWebViewPlugin.close();
    _onUrlChanged = flutterWebViewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        if (url.contains('resourcePath')) {
          if (_isOrderSent) {
            _checkPaymentStatus();
            setState(() {
              _isOrderSent = false;
            });
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _onUrlChanged.cancel();
    super.dispose();
  }

  ScreenConfig screenConfig;
  WidgetSize widgetSize;
  @override
  Widget build(BuildContext context) {
    screenConfig = ScreenConfig(context);
    widgetSize = WidgetSize(screenConfig);
    return Provider<NetworkProvider>.value(
      value: NetworkProvider(),
      child: Consumer<NetworkProvider>(
        builder: (context, value, _) => Center(
            child: Scaffold(
          body: ConnectivityWidget(
            networkProvider: value,
            child: WebviewScaffold(
              url:
                  'https://topstylesa.com/api/payment?checkoutId=${widget.checkoutId}',
              withZoom: true,
              appBar: AppBar(
                title: Text(
                  AppLocalization.of(context).translate('payment_title'),
                  style: TextStyle(fontSize: widgetSize.mainTitle),
                ),
                centerTitle: true,
              ),
            ),
          ),
        )),
      ),
    );
  }
}
