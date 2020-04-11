import 'package:flutter/material.dart';
import 'package:topstyle/screens/brand_products_screen.dart';

class BrandItem extends StatelessWidget {
  final String brandName;
  final String brandImage;
  final int brandId;
  final double fontSize;

  BrandItem(this.brandId, this.brandName, this.brandImage, this.fontSize);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 55.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(1, 2),
                  blurRadius: 55.0)
            ]),
        child: ListTile(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    BrandProductsScreen(brandName, brandId.toString())));
          },
          leading: Text(
            brandName,
            style: TextStyle(
              fontSize: fontSize,
            ),
          ),
          trailing: Container(
            child: Image(
              image: NetworkImage(brandImage),
              width: 75.0,
              height: 50.0,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
