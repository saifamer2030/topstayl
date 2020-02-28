import 'package:flutter/material.dart';
import 'package:topstyle/constants/colors.dart';
import 'package:topstyle/helper/appLocalization.dart';

class OrderItemInOrderDetails extends StatelessWidget {
  final int orderId;
  final String brandName;
  final String productName;
  final int quantity;
  final double productPrice;
  final String productImage;
  final String optionType;
  final String optionValue;

  OrderItemInOrderDetails(
      {this.orderId,
      this.productName,
      this.brandName,
      this.quantity,
      this.productPrice,
      this.productImage,
      this.optionType,
      this.optionValue});

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
                      child: Image.network(
                        productImage,
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
                          brandName.length > 20
                              ? '${brandName.substring(0, 19)}...'
                              : brandName,
                          style: TextStyle(fontSize: 12.0),
                        ),
                        Text(
                          '${productPrice.toStringAsFixed(2)} ${AppLocalization.of(context).translate("sar")}',
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
                              productName.length > 50
                                  ? '${productName.substring(0, 49)}...'
                                  : productName,
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
                      optionType == 'color'
                          ? Container(
                              width: 20.0,
                              height: 20.0,
                              decoration: BoxDecoration(
                                color: Color(int.parse('0xFF$optionValue')),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            )
                          : optionType == 'size'
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
                                    '$optionValue ${AppLocalization.of(context).translate("ml")}',
                                    style: TextStyle(fontSize: 12.0),
                                  )),
                                )
                              : Container(),
                      Text(
                          '$quantity ${AppLocalization.of(context).translate('order_items')}')
                    ],
                  ),
                ],
              ),
            ),
          ),
        ]));
  }
}
