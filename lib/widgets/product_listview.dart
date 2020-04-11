import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topstyle/widgets/product_item.dart';

import '../models/products_model.dart';

class ProductListView extends StatelessWidget {
  final List<ProductsModel> _products;
  ProductListView(this._products);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemExtent: 190.0,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: _products.length,
        itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
          value: _products[index],
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: ProductItem(),
          ),
        ),
      ),
    );
  }
}
