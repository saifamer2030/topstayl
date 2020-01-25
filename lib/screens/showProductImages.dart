import 'package:flutter/material.dart';
import 'package:topstyle/helper/appLocalization.dart';

class ShowProductImage extends StatelessWidget {
  final String images;

  ShowProductImage(this.images);

  @override
  Widget build(BuildContext context) {
    print(images.length);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalization.of(context).translate('app_name')),
      ),
      body: Center(
        child: Container(
          child: Image.network(
            images,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
