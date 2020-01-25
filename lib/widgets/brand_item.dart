import 'package:flutter/material.dart';
import 'package:topstyle/screens/brand_products_screen.dart';

class BrandItem extends StatelessWidget {
  final String brandName;
  final String brandImage;
  final int brandId;

  BrandItem(this.brandId, this.brandName, this.brandImage);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                offset: Offset(1, 2),
                blurRadius: 50.0)
          ]),
      child: ListTile(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  BrandProductsScreen(brandName, brandId.toString())));
        },
        leading: Text(
          brandName,
          style: TextStyle(fontSize: 14.0),
        ),
        trailing: Container(
          margin: const EdgeInsets.only(bottom: 8.0),
          child: Image.network(
            brandImage,
            width: 75.0,
            height: 40.0,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
