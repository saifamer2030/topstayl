import 'package:flutter/material.dart';

import '../constants/colors.dart';

class ReviewItem extends StatelessWidget {
  final String userName, comment;
  final int rating;

  ReviewItem({@required this.userName, this.comment, @required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            width: 40.0,
            height: 40.0,
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
            child: Image.asset(
              'assets/images/profile.png',
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      userName,
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          rating >= 1 ? Icons.star : Icons.star_border,
                          color: Color(0xfffdcc0d),
                          size: 18.0,
                        ),
                        Icon(
                          rating >= 2 ? Icons.star : Icons.star_border,
                          color: Color(0xfffdcc0d),
                          size: 18.0,
                        ),
                        Icon(
                          rating >= 3 ? Icons.star : Icons.star_border,
                          color: Color(0xfffdcc0d),
                          size: 18.0,
                        ),
                        Icon(
                          rating >= 4 ? Icons.star : Icons.star_border,
                          color: Color(0xfffdcc0d),
                          size: 18.0,
                        ),
                        Icon(
                          rating >= 5 ? Icons.star : Icons.star_border,
                          color: Color(0xfffdcc0d),
                          size: 18.0,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.0,
                ),
                Wrap(
                  children: [
                    Text(
                      comment,
                      style: TextStyle(
                          fontSize: 16.0, color: CustomColors.kBrandsNameColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
