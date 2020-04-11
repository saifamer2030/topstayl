import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topstyle/helper/appLocalization.dart';
import 'package:topstyle/helper/size_config.dart';
import 'package:topstyle/providers/network_provider.dart';
import 'package:topstyle/providers/order_provider.dart';
import 'package:topstyle/providers/user_provider.dart';
import 'package:topstyle/screens/checkoutScreen.dart';
import 'package:topstyle/widgets/adaptive_progress_indecator.dart';
import 'package:topstyle/widgets/connectivity_widget.dart';

class CustomOtpScreen extends StatefulWidget {
  static const String routeName = 'CustomOtpInDelivary';
  @override
  _CustomOtpScreenState createState() => _CustomOtpScreenState();
}

class _CustomOtpScreenState extends State<CustomOtpScreen> {
  ScreenConfig screenConfig;
  WidgetSize widgetSize;
  @override
  Widget build(BuildContext context) {
    screenConfig = ScreenConfig(context);
    widgetSize = WidgetSize(screenConfig);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppLocalization.of(context).translate("confirm_phone"),
          style: TextStyle(
            fontSize: widgetSize.mainTitle,
          ),
        ),
      ),
      body: OtpScreen(),
    );
  }
}

class OtpScreen extends StatefulWidget {
  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  List<String> currentPin = ["", "", "", ""];
  Timer _timer;
  int _start = 45;
  Map<String, bool> _flags = {
    'timerFinished': false,
    "isRequestResend": false,
    "isPinCorrect": true,
    "isLoading": false
  };
  final TextEditingController pinOneController = TextEditingController();
  final TextEditingController pinTwoController = TextEditingController();
  final TextEditingController pinThreeController = TextEditingController();
  final TextEditingController pinFourController = TextEditingController();
  final outLineBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide(color: Colors.red),
  );

  int pinIndex = 0;

  void startTimer() {
    const onSec = Duration(seconds: 1);
    _timer = Timer.periodic(onSec, (Timer timer) {
      setState(() {
        if (_start < 1) {
          timer.cancel();
          setState(() {
            _flags['timerFinished'] = true;
          });
        } else {
          _start = _start - 1;
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    pinOneController.dispose();
    pinTwoController.dispose();
    pinThreeController.dispose();
    pinFourController.dispose();
    super.dispose();
  }

  Widget pinNumber(TextEditingController editingController,
      OutlineInputBorder outlineInputBorder, double size, double deviceSize) {
    return Container(
      width: size - 2,
      height: size + 1,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
            color: _flags['isPinCorrect'] ? Colors.transparent : Colors.red),
      ),
      child: TextField(
        enabled: false,
        controller: editingController,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(15.0),
            border: outlineInputBorder,
            filled: true,
            fillColor: Colors.grey.withOpacity(0.1)),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: deviceSize > 736.0 ? 33.0 : 23.0,
        ),
      ),
    );
  }

  _resendConfirmationCode() {
    setState(() {
      _flags['isRequestResend'] = true;
    });
    startTimer();
    setState(() {
      _flags['timerFinished'] = false;
      _start = 45;
    });
    try {
      Provider.of<UserProvider>(context, listen: false)
          .otpByPhone(forgetMethod['phone'], "0")
          .then((forgetData) {
        print('new otp ${forgetData['otp']}');
        forgetMethod['otp'] = forgetData['otp'];
      });
      setState(() {
        _flags['isRequestResend'] = false;
      });
    } catch (error) {
      throw error;
    }
  }

  UserProvider _userProvider = UserProvider();
  _submitForm() async {
    print(forgetMethod['country']);
    print(forgetMethod['city']);
    print(forgetMethod['area']);
    print(forgetMethod['street']);
    print(forgetMethod['note']);
    print(forgetMethod['phone']);
    print(forgetMethod['gps']);
    var token = await _userProvider.isAuthenticated();
    setState(() {
      _flags['isLoading'] = true;
    });
    Provider.of<OrdersProvider>(context, listen: false)
        .saveLocation(
            forgetMethod['country'].toString(),
            forgetMethod['city'].toString(),
            forgetMethod['name'].toString(),
            forgetMethod['area'].toString(),
            forgetMethod['street'].toString(),
            forgetMethod['note'].toString(),
            forgetMethod['phone'].toString(),
            forgetMethod['gps'].toString(),
            token['Authorization'])
        .then((responseNumber) {
      setState(() {
        _flags['isLoading'] = false;
      });
      if (responseNumber == 1) {
        print('status code is  is ok $responseNumber');
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => CheckoutScreen(1)));
      } else {
        Scaffold.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            AppLocalization.of(context).translate("enter_correct_address"),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15.0, fontFamily: 'tajawal'),
          ),
        ));
        Future.delayed(Duration(seconds: 3), () {
          Navigator.of(context).pop();
        });
      }
    });
  }

  var forgetMethod;
  ScreenConfig screenConfig;
  WidgetSize widgetSize;

  @override
  Widget build(BuildContext context) {
    forgetMethod = ModalRoute.of(context).settings.arguments as Map;
//    print(forgetMethod['country']);
//    print(forgetMethod['city']);
//    print(forgetMethod['area']);
//    print(forgetMethod['street']);
    screenConfig = ScreenConfig(context);
    widgetSize = WidgetSize(screenConfig);
    return Provider<NetworkProvider>.value(
      value: NetworkProvider(),
      child: Consumer<NetworkProvider>(
        builder: (context, value, _) => Center(
          child: ConnectivityWidget(
              networkProvider: value,
              child: _flags['isLoading']
                  ? AdaptiveProgressIndicator()
                  : Column(
                      children: <Widget>[
                        Container(
                          height: screenConfig.screenHeight * 0.35,
                          child: LayoutBuilder(builder: (context, constrains) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                screenConfig.screenHeight > 736.0
                                    ? Container(
                                        width: constrains.maxHeight * 0.25,
                                        height: constrains.maxHeight * 0.15,
                                        child: Image.asset(
                                          'assets/images/logo.jpg',
                                          fit: BoxFit.contain,
                                        ),
                                      )
                                    : Container(),
                                SizedBox(height: constrains.maxHeight * 0.05),
                                Container(
                                  alignment: Alignment.bottomCenter,
                                  height: constrains.maxHeight * 0.10,
                                  child: Text(
                                    AppLocalization.of(context)
                                        .translate("enter_verification_code"),
                                    style: TextStyle(
                                      fontSize: screenConfig.screenHeight > 736
                                          ? 16.0
                                          : 13.0,
                                    ),
                                  ),
                                ),
                                SizedBox(height: constrains.maxHeight * 0.07),
                                Container(
                                  height: screenConfig.screenHeight > 736
                                      ? constrains.maxHeight * 0.25
                                      : 60,
                                  child: buildPinRow(),
                                ),
                                SizedBox(
                                  height: constrains.maxHeight * 0.1,
                                ),
                                buildResendNumber(),
                                SizedBox(
                                  height: constrains.maxHeight * 0.10,
                                ),
                              ],
                            );
                          }),
                        ),
                        Container(
                            height: screenConfig.screenHeight * 0.5,
                            child: buildNumberPad()),
                      ],
                    )),
        ),
      ),
    );
  }

  buildPinRow() {
    return Directionality(
        textDirection: TextDirection.ltr,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 40.0),
          child: LayoutBuilder(builder: (context, constraints) {
            return Container(
              height: constraints.maxHeight * 0.8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  pinNumber(
                    pinOneController,
                    outLineBorder,
                    constraints.maxHeight * 0.8,
                    screenConfig.screenHeight,
                  ),
                  pinNumber(
                    pinTwoController,
                    outLineBorder,
                    constraints.maxHeight * 0.8,
                    screenConfig.screenHeight,
                  ),
                  pinNumber(
                    pinThreeController,
                    outLineBorder,
                    constraints.maxHeight * 0.8,
                    screenConfig.screenHeight,
                  ),
                  pinNumber(
                    pinFourController,
                    outLineBorder,
                    constraints.maxHeight * 0.8,
                    screenConfig.screenHeight,
                  ),
                ],
              ),
            );
          }),
        ));
  }

  buildResendNumber() {
    return _flags['timerFinished']
        ? Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  AppLocalization.of(context).translate("dont_receive_code"),
                  style: TextStyle(
                    fontSize: widgetSize.subTitle,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _resendConfirmationCode();
                  },
                  child: Text(
                    AppLocalization.of(context).translate("resend"),
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: widgetSize.subTitle,
                    ),
                  ),
                ),
              ],
            ),
          )
        : Container(
            width: 120.0,
            height: 20.0,
            alignment: Alignment.center,
            child: Text(
              '00:$_start',
              style: TextStyle(
                  fontSize: widgetSize.mainTitle,
                  fontWeight: FontWeight.bold,
                  color: Colors.red),
            ),
          );
  }

  buildRowOfNumbers(num1, String num2, String num3, constraint) {
    return Container(
      height: constraint.maxHeight * 0.2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          KeyBoardNumber(
              n: int.parse(num1),
              onPressed: () {
                pinIndexSetup(num1);
              }),
          KeyBoardNumber(
              n: int.parse(num2),
              onPressed: () {
                pinIndexSetup(num2);
              }),
          KeyBoardNumber(
              n: int.parse(num3),
              onPressed: () {
                pinIndexSetup(num3);
              }),
        ],
      ),
    );
  }

  buildNumberPad() {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: LayoutBuilder(
            builder: (context, constraint) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  buildRowOfNumbers("1", "2", "3", constraint),
                  buildRowOfNumbers("4", "5", "6", constraint),
                  buildRowOfNumbers("7", "8", "9", constraint),
                  Container(
                    height: constraint.maxHeight * 0.2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          width: 70.0,
                          height: 70.0,
                          child: MaterialButton(onPressed: null),
                        ),
                        KeyBoardNumber(
                            n: 0,
                            onPressed: () {
                              pinIndexSetup("0");
                            }),
                        Container(
                          width: 70.0,
                          height: 70.0,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.withOpacity(0.2)),
                          child: MaterialButton(
                            onPressed: () {
                              clearPin();
                            },
                            child: Image.asset(
                              'assets/icons/rm_keyboard.png',
                              width: 25.0,
                              height: 25.0,
                              fit: BoxFit.contain,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(70.0)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void pinIndexSetup(String s) {
    if (pinIndex == 0)
      pinIndex = 1;
    else if (pinIndex < 4) pinIndex++;
    sePin(pinIndex, s);
    currentPin[pinIndex - 1] = s;
    var strPin = "";
    currentPin.forEach((p) {
      strPin += p;
    });
    if (pinIndex == 4) {
      if (strPin == forgetMethod['otp'].toString()) {
        setState(() {
          _flags['isPinCorrect'] = true;
        });
        _submitForm();
      } else {
        setState(() {
          _flags['isPinCorrect'] = false;
        });
      }
    }
  }

  void sePin(int pinIndex, String s) {
    switch (pinIndex) {
      case 1:
        pinOneController.text = s;
        break;
      case 2:
        pinTwoController.text = s;
        break;
      case 3:
        pinThreeController.text = s;
        break;
      case 4:
        pinFourController.text = s;
        break;
    }
  }

  void clearPin() {
    print('pin: $pinIndex');
    if (pinIndex == 0) {
      pinIndex = 0;
      return;
    } else if (pinIndex <= 4) sePin(pinIndex, "");
    currentPin[pinIndex - 1] = "";
    pinIndex--;
    setState(() {
      _flags['isPinCorrect'] = true;
    });
  }
}

class KeyBoardNumber extends StatelessWidget {
  final int n;
  final Function onPressed;
  KeyBoardNumber({this.n, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70.0,
      height: 70.0,
      decoration: BoxDecoration(
          shape: BoxShape.circle, color: Colors.grey.withOpacity(0.2)),
      alignment: Alignment.center,
      child: MaterialButton(
        padding: const EdgeInsets.only(
            left: 8.0, top: 10.0, right: 8.0, bottom: 4.0),
        onPressed: onPressed,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(70.0)),
        height: 70.0,
        child: Text(
          "$n",
          style: TextStyle(
              fontSize: 30 * MediaQuery.of(context).textScaleFactor,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
