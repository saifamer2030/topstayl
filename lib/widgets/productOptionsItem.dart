import 'package:flutter/material.dart';
import 'package:topstyle/models/product_details_model.dart';

class ProductOptionItem extends StatefulWidget {
  final ProductOption productOption;
  final mainProductAvailability;

  ProductOptionItem(this.productOption, this.mainProductAvailability);

  @override
  _ProductOptionItemState createState() => _ProductOptionItemState();
}

class _ProductOptionItemState extends State<ProductOptionItem> {
  bool _isProductChosen = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isProductChosen = true;
        });
      },
      child: Container(
        width: 25.0,
        height: 25.0,
        decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(25.0),
            border: _isProductChosen
                ? Border.all(width: 2.5, color: Theme.of(context).accentColor)
                : null),
        child: widget.productOption.isAvailable != 0 &&
                widget.mainProductAvailability != 0 &&
                widget.productOption.quantity > 1
            ? Container()
            : Center(
                child: Icon(
                  Icons.clear,
                  size: 17,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
