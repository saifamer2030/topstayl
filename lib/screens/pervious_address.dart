import 'package:flutter/material.dart';
import 'package:topstyle/constants/colors.dart';
import 'package:topstyle/helper/appLocalization.dart';
import 'package:topstyle/helper/size_config.dart';
import 'package:topstyle/models/checkout_summery_model.dart';
import 'package:topstyle/screens/checkoutScreen.dart';

class PreviousAddress extends StatefulWidget {
  final AddressModel addressModel;
  PreviousAddress(this.addressModel);

  @override
  _PreviousAddressState createState() => _PreviousAddressState();
}

class _PreviousAddressState extends State<PreviousAddress> {
  ScreenConfig screenConfig;

  WidgetSize widgetSize;

  @override
  Widget build(BuildContext context) {
    screenConfig = ScreenConfig(context);
    widgetSize = WidgetSize(screenConfig);
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  Text(
                    AppLocalization.of(context).translate('previous_location'),
                    style: TextStyle(fontSize: widgetSize.subTitle),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  RadioListTile(
                    value: 1,
                    groupValue: 1,
                    selected: true,
                    onChanged: (val) {},
                    activeColor: Theme.of(context).accentColor,
                    title: Text(
                      widget.addressModel.userName,
                      style: TextStyle(
                          fontSize: widgetSize.subTitle,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    subtitle: Text(
                      '${widget.addressModel.phone}\n ${widget.addressModel.country}،${widget.addressModel.city}،${widget.addressModel.area}',
                      style: TextStyle(
                          fontSize: widgetSize.subTitle, color: Colors.black),
                    ),
                    isThreeLine: true,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Divider(
                    color: CustomColors.kPCardColor,
                    height: 1.0,
                    thickness: 1.0,
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => CheckoutScreen(0)));
                    },
                    title: Text(AppLocalization.of(context)
                        .translate('add_new_address')),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: widgetSize.content,
                    ),
                  ),
                  Divider(
                    color: CustomColors.kPCardColor,
                    height: 1.0,
                    thickness: 1.0,
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
                color: Theme.of(context).accentColor,
              ),
              child: FlatButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => CheckoutScreen(1)));
                },
                child: Text(
                  AppLocalization.of(context).translate("continue_to_payment"),
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: widgetSize.content),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
