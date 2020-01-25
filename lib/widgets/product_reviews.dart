import 'package:flutter/material.dart';
import 'package:topstyle/helper/appLocalization.dart';
import 'package:topstyle/models/product_details_model.dart';
import 'package:topstyle/widgets/review_item.dart';

class ProductReviews extends StatelessWidget {
  final List<ProductReview> productReviews;

  ProductReviews(this.productReviews);

  @override
  Widget build(BuildContext context) {
    print(productReviews.length);
    return productReviews.length > 0
        ? Container(
            height: 300.0,
            child: ListView.builder(
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: ReviewItem(
                    userName: productReviews[index].userName,
                    comment: productReviews[index].review,
                    rating: productReviews[index].ratting),
              ),
              itemCount: productReviews.length,
            ),
          )
        : Container(
            margin: const EdgeInsets.only(top: 20.0, bottom: 10.0),
            child: Center(
                child: Text(
              AppLocalization.of(context).translate("be_the_first_to_review"),
              style: TextStyle(fontSize: 16.0),
            )),
          );
  }
}
