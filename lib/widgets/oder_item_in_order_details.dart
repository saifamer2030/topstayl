import 'package:flutter/material.dart';
import 'package:topstyle/constants/colors.dart';
import 'package:topstyle/helper/appLocalization.dart';
import 'package:topstyle/models/orders_model.dart';

class OrderItemInOrderDetails extends StatelessWidget {
  final DetailsModel orderModel;

  OrderItemInOrderDetails(this.orderModel);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 15.0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(width: 1.0, color: CustomColors.kPCardColor),
          color: Colors.white,
        ),
//      color: Colors.green,
        height: 140,
        child: Row(children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              height: 130,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(color: Colors.white),
                    child: Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      child: Image(
                        image: NetworkImage(orderModel.image),
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
              height: 150,
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
                          orderModel.brand.length > 20
                              ? '${orderModel.brand.substring(0, 19)}...'
                              : orderModel.brand,
                          style: TextStyle(fontSize: 12.0),
                        ),
                        Text(
                          '${orderModel.price.toStringAsFixed(2)} ${AppLocalization.of(context).translate("sar")}',
                          style: TextStyle(
                              fontSize: 12.0, fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
//                  color: Colors.blue,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Wrap(children: [
                            Text(
                              orderModel.productName.length > 50
                                  ? '${orderModel.productName.substring(0, 49)}...'
                                  : orderModel.productName,
                              //40
                              style: TextStyle(
                                  fontSize: 12.0, fontWeight: FontWeight.bold),
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      orderModel.type == 'color'
                          ? Container(
                              width: 20.0,
                              height: 20.0,
                              decoration: BoxDecoration(
                                color:
                                    Color(int.parse('0xFF${orderModel.value}')),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            )
                          : orderModel.type == 'size'
                              ? Container(
                                  width: 75.0,
                                  height: 30.0,
                                  padding: const EdgeInsets.all(3.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6.0),
                                    color: Color(0xFFe8e8e8),
                                  ),
                                  child: Center(
                                      child: Text(
                                    '${orderModel.value} ${AppLocalization.of(context).translate("ml")}',
                                    style: TextStyle(fontSize: 12.0),
                                  )),
                                )
                              : Container(),
                      Text(
                          '${orderModel.quantity} ${AppLocalization.of(context).translate('order_items')}')
                    ],
                  ),
                ],
              ),
            ),
          ),
        ]));
  }
}
