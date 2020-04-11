import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:topstyle/constants/colors.dart';
import 'package:topstyle/helper/appLocalization.dart';
import 'package:topstyle/helper/size_config.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class CustomerSupport extends StatefulWidget {
  static const String routeName = 'customer-support';

  @override
  _CustomerSupportState createState() => _CustomerSupportState();
}

class _CustomerSupportState extends State<CustomerSupport> {
  final String phone = 'tel:+966920005869';

  final String email = 'support@topstylesa.com';

  final String whatsApp = 'https://api.whatsapp.com/send?phone=+966506221099';

  _callPhone() async {
    if (await UrlLauncher.canLaunch(phone)) {
      await UrlLauncher.launch(phone);
    } else {
      throw 'Could not Call Phone';
    }
  }

  _msgOnWhatsApp() async {
    if (await UrlLauncher.canLaunch(whatsApp)) {
      await UrlLauncher.launch(whatsApp);
    } else {
      throw 'Could not Open Whatsapp Phone';
    }
  }

  _launchEmail() async {
    if (await UrlLauncher.canLaunch("mailto:$email")) {
      await UrlLauncher.launch("mailto:$email");
    } else {
      throw 'Could not launch';
    }
  }

  ScreenConfig screenConfig;

  WidgetSize widgetSize;

  @override
  Widget build(BuildContext context) {
    screenConfig = ScreenConfig(context);
    widgetSize = WidgetSize(screenConfig);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalization.of(context).translate('customer_support'),
          style: TextStyle(fontSize: widgetSize.mainTitle),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  Image.asset(
                    'assets/icons/headphone.png',
                    width: 80.0,
                    height: 90.0,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    AppLocalization.of(context)
                        .translate('customer_support_msg'),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: widgetSize.subTitle),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    GestureDetector(
                      onTap: _callPhone,
                      child: Container(
                        height: widgetSize.textField,
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1.0, color: CustomColors.kPCardColor),
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          textBaseline: TextBaseline.alphabetic,
                          children: <Widget>[
//                                - assets/icons/whats.png
//                                - assets/icons/email.png
                            Container(
                              margin: const EdgeInsets.only(bottom: 7.0),
                              child: Image.asset(
                                'assets/icons/call.png',
                                width: 18.0,
                                height: 18.0,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            Text(
                              AppLocalization.of(context)
                                  .translate('contact_us'),
                              style: TextStyle(fontSize: widgetSize.subTitle),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    GestureDetector(
                      onTap: _msgOnWhatsApp,
                      child: Container(
                        height: 40.0,
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1.0, color: CustomColors.kPCardColor),
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          textBaseline: TextBaseline.alphabetic,
                          children: <Widget>[
//                                - assets/icons/whats.png
//                                - assets/icons/email.png
                            Container(
                              margin: const EdgeInsets.only(bottom: 7.0),
                              child: Image.asset(
                                'assets/icons/whats.png',
                                width: 18.0,
                                height: 18.0,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            Text(
                              AppLocalization.of(context).translate('whats'),
                              style: TextStyle(fontSize: widgetSize.subTitle),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    GestureDetector(
                      onTap: _launchEmail,
                      child: Container(
                        height: 40.0,
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1.0, color: CustomColors.kPCardColor),
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          textBaseline: TextBaseline.alphabetic,
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(bottom: 7.0),
                              child: Image.asset(
                                'assets/icons/email.png',
                                width: 18.0,
                                height: 18.0,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            Text(
                              AppLocalization.of(context).translate('email'),
                              style: TextStyle(fontSize: widgetSize.subTitle),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              flex: 2,
            ),
          ],
        ),
      ),
    );
  }
}
