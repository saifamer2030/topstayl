import 'package:flutter/material.dart';
import 'package:topstyle/constants/colors.dart';
import 'package:topstyle/helper/appLocalization.dart';
import 'package:topstyle/screens/tabs_screen.dart';

class CheckoutDoneScreen extends StatelessWidget {
  final int orderId;

  CheckoutDoneScreen(this.orderId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.check_circle,
                    color: CustomColors.kPAddedToCartIconColor,
                    size: 50,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    AppLocalization.of(context).translate('order_placed'),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    AppLocalization.of(context)
                        .translate('successful_purchase'),
                    style: TextStyle(
                        fontSize: 14.0, color: CustomColors.kPSomeTextColor),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        AppLocalization.of(context).translate('order_id'),
                        style: TextStyle(
                            fontSize: 14.0,
                            color: CustomColors.kPSomeTextColor),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        '$orderId',
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: CustomColors.kPSomeTextColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Theme.of(context).accentColor),
              child: FlatButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      TabsScreen.routeName, (Route<dynamic> route) => false);
                },
                child: Text(
                  AppLocalization.of(context).translate("return_to_home"),
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
