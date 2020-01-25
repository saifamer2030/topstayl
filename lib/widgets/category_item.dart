import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final Color color;
  final String icon;
  final Function action;
  final double size;
  final String categoryName;

  CategoryItem(
      {@required this.color,
      @required this.icon,
      @required this.size,
      @required this.action,
      this.categoryName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInCirc,
        margin: size == 80
            ? const EdgeInsets.all(
                10.0,
              )
            : const EdgeInsets.all(
                0.0,
              ),
        width: size,
        height: size,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0), color: color),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              icon,
              height: size == 80 ? 40.0 : 50.0,
              fit: BoxFit.fitHeight,
            ),
            SizedBox(
              height: 8.0,
            ),
            categoryName == ''
                ? Container()
                : Text(
                    categoryName,
                    style: TextStyle(fontSize: 12.0),
                  )
          ],
        ),
      ),
    );
  }
}
