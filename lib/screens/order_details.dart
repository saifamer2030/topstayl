import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:topstyle/constants/colors.dart';
import 'package:topstyle/models/orders_model.dart';
import 'package:topstyle/providers/user_provider.dart';
import 'package:topstyle/widgets/adaptive_progress_indecator.dart';

import '../helper/appLocalization.dart';
import '../providers/order_provider.dart';
import '../widgets/oder_item_in_order_details.dart';

class OrderDetails extends StatefulWidget {
  final int productId;
  OrderDetails(this.productId);

  static const String routeName = 'order-details';

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  final UserProvider userProvider = UserProvider();
  OrderDetailsModel orderDetailsModel;
  bool _isInit = true;
  bool _isLoading = true;
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  getOrderDetailData() async {
    setState(() {
      _isLoading = true;
    });
    var token = await userProvider.isAuthenticated();
    orderDetailsModel = await Provider.of<OrdersProvider>(context)
        .getOrderDetails(widget.productId.toString(), token['Authorization']);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      getOrderDetailData();
    }
    setState(() {
      _isInit = false;
    });
    super.didChangeDependencies();
  }

  _doCancelOrder() async {
    setState(() {
      _isLoading = true;
    });
    var token = await userProvider.isAuthenticated();
    var result = await Provider.of<OrdersProvider>(context).cancelOrder(
        token['Authorization'],
        orderDetailsModel.orderModel.orderId.toString());
    setState(() {
      _isLoading = false;
    });
    if (result == 0) {
      Navigator.of(context).pop();
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          AppLocalization.of(context).translate('try_again_later'),
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15.0, fontFamily: 'tajawal'),
        ),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Scaffold(
            body: Center(
              child: AdaptiveProgressIndicator(),
            ),
          )
        : Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              centerTitle: true,
              title:
                  Text(AppLocalization.of(context).translate("order_details")),
            ),
            body: orderDetailsModel.orderModel == null
                ? Center(
                    child: Text('No Details'),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
//                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Container(
                            margin:
                                const EdgeInsets.only(top: 20.0, bottom: 20.0),
                            alignment: Alignment.center,
                            width: 50.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.0),
                                color:
                                    orderDetailsModel.orderModel.orderStatus ==
                                            1
                                        ? CustomColors.kPAddedToCartIconColor
                                        : orderDetailsModel.orderModel
                                                        .orderStatus ==
                                                    4 ||
                                                orderDetailsModel.orderModel
                                                        .orderStatus ==
                                                    5
                                            ? Colors.red
                                            : null),
                            child: orderDetailsModel.orderModel.orderStatus == 1
                                ? Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 40.0,
                                  )
                                : orderDetailsModel.orderModel.orderStatus == 2
                                    ? Image.asset(
                                        'assets/icons/on_the_way.png',
                                      )
                                    : orderDetailsModel
                                                .orderModel.orderStatus ==
                                            3
                                        ? Container(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Image.asset(
                                                'assets/icons/product_recived.png'))
                                        : Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 40.0,
                                          ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              orderDetailsModel.orderModel.orderStatus == 1
                                  ? AppLocalization.of(context)
                                      .translate("order_placed")
                                  : orderDetailsModel.orderModel.orderStatus ==
                                          2
                                      ? AppLocalization.of(context)
                                          .translate("order_shipped")
                                      : orderDetailsModel
                                                  .orderModel.orderStatus ==
                                              3
                                          ? AppLocalization.of(context)
                                              .translate("order_delivered")
                                          : AppLocalization.of(context)
                                              .translate("order_canceled"),
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                '${AppLocalization.of(context).translate("order_id")} : ${orderDetailsModel.orderModel.orderId}',
                                style: TextStyle(fontSize: 14.0),
                              ),
                              Text(
                                '${AppLocalization.of(context).translate('order_date')}: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(orderDetailsModel.orderModel.orderDate))}',
                                style: TextStyle(fontSize: 12.0),
                                textAlign: TextAlign.end,
                              ),
                            ],
                          ),
                          Divider(
                            height: 1.0,
                            color: CustomColors.kPCardColor,
                            thickness: 1.0,
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                AppLocalization.of(context)
                                    .translate('delivery_location'),
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          ListTile(
                            contentPadding: const EdgeInsets.all(0.0),
                            title: Text(
                              orderDetailsModel.addressModel.name,
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            subtitle: Text(
                              '${orderDetailsModel.addressModel.phone}\n ${orderDetailsModel.addressModel.country}،${orderDetailsModel.addressModel.city}،${orderDetailsModel.addressModel.area}',
                              style: TextStyle(
                                  fontSize: 14.0, color: Colors.black),
                            ),
                            isThreeLine: true,
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          Divider(
                            color: CustomColors.kPCardColor,
                            height: 1.0,
                            thickness: 1.0,
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                AppLocalization.of(context)
                                    .translate("payment_method"),
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          orderDetailsModel.orderModel.paymentId == 1
                              ? ListTile(
                                  contentPadding: const EdgeInsets.all(0.0),
                                  title: Text(
                                    AppLocalization.of(context)
                                        .translate("payment_when_receiving"),
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                  trailing:
                                      SvgPicture.asset('assets/icons/cash.svg'),
                                )
                              : orderDetailsModel.orderModel.paymentId == 2 &&
                                      Platform.isIOS
                                  ? ListTile(
                                      title: Text(
                                        AppLocalization.of(context)
                                            .translate("apple_pay"),
                                        style: TextStyle(fontSize: 16.0),
                                      ),
                                      trailing: Image.asset(
                                        'assets/icons/apple_pay.png',
                                        width: 38.8,
                                        height: 16.0,
                                        fit: BoxFit.fitHeight,
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          AppLocalization.of(context)
                                              .translate("credit_card"),
                                          style: TextStyle(fontSize: 16.0),
                                        ),
                                        Image.asset(
                                          'assets/icons/visa.png',
                                          width: 38.8,
                                          height: 16.0,
                                          fit: BoxFit.fitWidth,
                                        ),
                                        Image.asset(
                                          'assets/icons/master.png',
                                          width: 19.8,
                                          height: 12.0,
                                          fit: BoxFit.fitWidth,
                                        ),
                                        Image.asset(
                                          'assets/icons/amex.png',
                                          width: 17.8,
                                          height: 12.0,
                                          fit: BoxFit.fitWidth,
                                        ),
                                        Image.asset(
                                          'assets/icons/mada.png',
                                          width: 35.0,
                                          height: 12.0,
                                          fit: BoxFit.fitWidth,
                                        ),
                                      ],
                                    ),
                          SizedBox(
                            height: 16.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                AppLocalization.of(context)
                                    .translate("order_summary_title"),
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                AppLocalization.of(context)
                                    .translate("purchase_price"),
                                style: TextStyle(fontSize: 14.0),
                              ),
                              Text(
                                '${orderDetailsModel.orderModel.totalPrice.toStringAsFixed(2)} ${AppLocalization.of(context).translate("sar")}',
                                style: TextStyle(fontSize: 14.0),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  '${orderDetailsModel.orderModel.itemsCount} ${AppLocalization.of(context).translate("order_items")}',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ]),
                          SizedBox(
                            height: 20.0,
                          ),
                          Container(
                            height: 300,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: orderDetailsModel.listOfDetails.length,
                              itemBuilder: (ctx, index) => Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: OrderItemInOrderDetails(
                                  orderId: orderDetailsModel
                                      .listOfDetails[index].optionId,
                                  brandName: orderDetailsModel
                                      .listOfDetails[index].brand,
                                  productName: orderDetailsModel
                                      .listOfDetails[index].productName,
                                  quantity: orderDetailsModel
                                      .listOfDetails[index].quantity,
                                  productPrice: orderDetailsModel
                                      .listOfDetails[index].productPrice,
                                  productImage: orderDetailsModel
                                      .listOfDetails[index].image,
                                  optionType: orderDetailsModel
                                      .listOfDetails[index].type,
                                  optionValue: orderDetailsModel
                                      .listOfDetails[index].value,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            bottomNavigationBar:
                orderDetailsModel.orderModel.orderStatus == 1 ||
                        orderDetailsModel.orderModel.orderStatus == 2 &&
                            orderDetailsModel != null
                    ? Container(
                        margin: const EdgeInsets.only(
                            left: 16.0, right: 16.0, bottom: 20.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.red,
                        ),
                        child: FlatButton(
                          onPressed: () {
                            _doCancelOrder();
                          },
                          child: _isLoading
                              ? AdaptiveProgressIndicator()
                              : Text(
                                  AppLocalization.of(context)
                                      .translate("cancel_order"),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                        ),
                      )
                    : null,
          );
  }
}
