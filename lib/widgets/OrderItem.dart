import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:topstyle/helper/appLocalization.dart';

import '../constants/colors.dart';
import '../screens/order_details.dart';

class OrderItem extends StatelessWidget {
  final int orderId;
  final String orderDate;
  final int orderStatus;
  final int itemCount;

  OrderItem(this.orderId, this.orderDate, this.orderStatus, this.itemCount);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 7.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
          border: Border.all(width: 1.0, color: CustomColors.kPCardColor)),
      child: Column(
        children: <Widget>[
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '$itemCount ${AppLocalization.of(context).translate("order_items")}',
                  style: TextStyle(fontSize: 14.0),
                ),
                Text(
                  '${AppLocalization.of(context).translate('order_date')}: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(orderDate))}',
                  style: TextStyle(fontSize: 12.0),
                  textAlign: TextAlign.end,
                ),
              ],
            ),
          ),
          Divider(
            height: 1.0,
            color: CustomColors.kPCardColor,
            thickness: 1.0,
          ),
          Container(
            margin: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
              top: 16.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      AppLocalization.of(context).translate('order_status'),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    orderStatus == 2
                        ? Image.asset(
                            'assets/icons/on_the_way.png',
                            width: 25.0,
                            height: 18.0,
                            fit: BoxFit.fitWidth,
                          )
                        : orderStatus == 3
                            ? Container(
                                padding: const EdgeInsets.all(7.0),
                                child: Image.asset(
                                  'assets/icons/product_recived.png',
                                  width: 18.0,
                                  height: 18.0,
                                  fit: BoxFit.fitHeight,
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.0),
                                    color: orderStatus == 1
                                        ? CustomColors.kPAddedToCartIconColor
                                        : orderStatus == 4 || orderStatus == 5
                                            ? Colors.red
                                            : null),
                                child: Icon(
                                  orderStatus == 1
                                      ? Icons.check
                                      : orderStatus == 4 || orderStatus == 5
                                          ? Icons.close
                                          : null,
                                  color: Colors.white,
                                  size: 18.0,
                                ),
                              ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      orderStatus == 1
                          ? AppLocalization.of(context)
                              .translate("order_placed")
                          : orderStatus == 2
                              ? AppLocalization.of(context)
                                  .translate("order_shipped")
                              : orderStatus == 3
                                  ? AppLocalization.of(context)
                                      .translate("order_delivered")
                                  : AppLocalization.of(context)
                                      .translate("order_canceled"),
                      style: TextStyle(fontSize: 12.0),
                    ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => OrderDetails(orderId)));
            },
            child: Container(
              height: 40.0,
              margin:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  border: Border.all(
                    width: 2.0,
                    color: Theme.of(context).accentColor,
                  )),
              child: Center(
                child: Text(
                  AppLocalization.of(context).translate("order_details"),
                  style: TextStyle(
                      fontSize: 16, color: Theme.of(context).accentColor),

                  // trailing: Icon(Icons.arrow_forward, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
