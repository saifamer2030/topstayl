import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:topstyle/helper/appLocalization.dart';
import 'package:topstyle/providers/order_provider.dart';
import 'package:topstyle/providers/user_provider.dart';
import 'package:topstyle/widgets/adaptive_progress_indecator.dart';
import 'package:topstyle/widgets/network_connection.dart';

import 'checkoutScreen.dart';

class PhoneOtpInDelivery extends StatefulWidget {
  static String routeName = 'phoneOtpInDelivery';

  @override
  _PhoneOtpInDeliveryState createState() => _PhoneOtpInDeliveryState();
}

class _PhoneOtpInDeliveryState extends State<PhoneOtpInDelivery> {
  Timer _timer;
  int _start = 35;
  bool _timerFinished = false;
  bool _isLoading = false;
  bool _isRequestResend = false;
  String _verificationCode, _num1, _num2, _num3, _num4;
  UserProvider _userProvider = UserProvider();

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    const onSec = Duration(seconds: 1);
    _timer = Timer.periodic(onSec, (Timer timer) {
      setState(() {
        if (_start < 1) {
          timer.cancel();
          setState(() {
            _timerFinished = true;
          });
        } else {
          _start = _start - 1;
        }
      });
    });
  }

  var _vCodeKey = GlobalKey<FormState>();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var secondCode = FocusNode();
  var thirdCode = FocusNode();
  var fourCode = FocusNode();

  _checkInternetConnection(int direction) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      if (direction == 1)
        _submitForm();
      else
        _resendConfirmationCode();
    } else {
      ConnectionPopup.showAlert(
          AppLocalization.of(context).translate("show_connection_error"),
          context);
    }
  }

  _resendConfirmationCode() {
    setState(() {
      _isRequestResend = true;
    });
    startTimer();
    setState(() {
      _timerFinished = false;
      _start = 35;
    });
    try {
      Provider.of<UserProvider>(context)
          .otpByPhone(forgetMethod['phone'], "0")
          .then((forgetData) {
        print('new otp ${forgetData['otp']}');
        forgetMethod['otp'] = forgetData['otp'];
      });
      setState(() {
        _isRequestResend = false;
      });
    } catch (error) {
      throw error;
    }
  }

  _submitForm() async {
    var token = await _userProvider.isAuthenticated();
    setState(() {
      _isLoading = true;
    });
    _verificationCode = '$_num1$_num2$_num3$_num4';
    if (_verificationCode == forgetMethod['otp'].toString()) {
      Provider.of<OrdersProvider>(context)
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
        if (responseNumber == 1) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => CheckoutScreen(1)));
        } else {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                AppLocalization.of(context).translate("try_again_later"),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15.0, fontFamily: 'tajawal'),
              )));
        }
        setState(() {
          _isLoading = false;
        });
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            AppLocalization.of(context).translate("mismatch"),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15.0, fontFamily: 'tajawal'),
          )));
    }
  }

  var forgetMethod;

  @override
  Widget build(BuildContext context) {
    forgetMethod = ModalRoute.of(context).settings.arguments as Map;
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            AppLocalization.of(context).translate("confirm_phone"),
            style: TextStyle(
              fontSize: 19.0,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      AppLocalization.of(context)
                          .translate("enter_verification_code"),
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      AppLocalization.of(context).translate("enter_code_msg"),
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  Form(
                    key: _vCodeKey,
                    child: Row(
                      textDirection: TextDirection.ltr,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            width: 30,
                            child: Center(
                              child: TextFormField(
                                onChanged: (val) {
                                  _num1 = val;
//                                print(_verificationCode);
                                  FocusScope.of(context)
                                      .requestFocus(secondCode);
                                },
                                style: TextStyle(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.bold),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
                                  //WhitelistingTextInputFormatter.digitsOnly
                                ],
                                textInputAction: TextInputAction.next,
                              ),
                            )),
                        SizedBox(
                          width: 10.0,
                        ),
                        Container(
                            width: 30,
                            child: TextFormField(
                              onChanged: (val) {
                                _num2 = val;
//                                print(_verificationCode);
                                FocusScope.of(context).requestFocus(thirdCode);
                              },
                              style: TextStyle(
                                  fontSize: 25.0, fontWeight: FontWeight.bold),
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(1),
                                // WhitelistingTextInputFormatter.digitsOnly
                              ],
                              focusNode: secondCode,
                            )),
                        SizedBox(
                          width: 10.0,
                        ),
                        Container(
                            width: 30,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(1),
                                // WhitelistingTextInputFormatter.digitsOnly
                              ],
                              style: TextStyle(
                                  fontSize: 25.0, fontWeight: FontWeight.bold),
                              textInputAction: TextInputAction.next,
                              focusNode: thirdCode,
                              onChanged: (val) {
                                _num3 = val;
//                                print(_verificationCode);
                                FocusScope.of(context).requestFocus(fourCode);
                              },
                            )),
                        SizedBox(
                          width: 7.0,
                        ),
                        Container(
                            width: 30,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                  fontSize: 25.0, fontWeight: FontWeight.bold),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(1),
                                //WhitelistingTextInputFormatter.digitsOnly
                              ],
                              textInputAction: TextInputAction.send,
                              focusNode: fourCode,
                              onChanged: (val) {
                                _num4 = val;
//                                print(_verificationCode);
                              },
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 60.0,
                  ),
                  _timerFinished
                      ? Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                AppLocalization.of(context)
                                    .translate("dont_receive_code"),
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _checkInternetConnection(0);
                                },
                                child: Text(
                                  AppLocalization.of(context)
                                      .translate("resend"),
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(
                          width: 30.0,
                          height: 30.0,
                          alignment: Alignment.center,
                          child: Text(
                            '$_start',
                            style: TextStyle(
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                          ),
                        ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    height: 44.0,
                    margin: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: RaisedButton(
                      color: Theme.of(context).accentColor,
                      onPressed: _isLoading
                          ? null
                          : () {
                              _checkInternetConnection(1);
                            },
                      child: _isLoading
                          ? AdaptiveProgressIndicator()
                          : Text(
                              AppLocalization.of(context).translate("verify"),
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ]),
          ),
        ));
  }
}
