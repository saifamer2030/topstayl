import 'package:flutter/material.dart';
import 'package:topstyle/helper/appLocalization.dart';

class TagShape extends StatelessWidget {
  final int discount;
  TagShape(this.discount);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
          color: Colors.red,
          shape: BeveledRectangleBorder(
              side: BorderSide(
                color: Colors.red,
              ),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(16.0),
                  topLeft: Radius.circular(1.0),
                  bottomLeft: Radius.circular(1.0),
                  bottomRight: Radius.circular(16.0)))),
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
      child: Text(
        '${AppLocalization.of(context).translate('discount_electronic_payment')} $discount %',
        style: TextStyle(
            color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.bold),
      ),
    );
  }
}
