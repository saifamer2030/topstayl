import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:topstyle/constants/colors.dart';
import 'package:topstyle/helper/appLocalization.dart';
import 'package:topstyle/providers/user_provider.dart';
import 'package:topstyle/widgets/adaptive_progress_indecator.dart';
import 'package:topstyle/widgets/network_connection.dart';

import 'confirm_otp.dart';

class ForgetPasswordScreen extends StatefulWidget {
  static String routeName = 'forget-passowrd';

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  bool _isEmailMethodClicked = false;
  bool _isPhoneMethodClicked = false;
  bool _isLoading = false;
  var _emailFormKey = GlobalKey<FormState>();
  var _phoneFormKey = GlobalKey<FormState>();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  String email, phone;
  String countryCode = '+966', image;

  _showPopupCountry() async {
    return Theme.of(context).platform == TargetPlatform.iOS
        ? showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: Text('choose Country'),
              content: Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width,
                child: Scaffold(
                  body: Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Theme.of(context).primaryColor),
                        child: ListTile(
                          onTap: () {
                            setState(() {
                              image = 'assets/icons/ksa_flag.png';
                              countryCode = '+966';
                            });
                            Navigator.of(context).pop();
                          },
                          title: Text(
                              AppLocalization.of(context).translate("ksa")),
                          leading: Image.asset('assets/icons/ksa_flag.png'),
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Theme.of(context).primaryColor),
                        child: ListTile(
                          onTap: () {
                            setState(() {
                              image = 'assets/icons/uae_flag.png';
                              countryCode = '+971';
                            });
                            Navigator.of(context).pop();
                          },
                          leading: Image.asset('assets/icons/uae_flag.png'),
                          title: Text(
                              AppLocalization.of(context).translate("uae")),
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Theme.of(context).primaryColor),
                        child: ListTile(
                          onTap: () {
                            setState(() {
                              image = 'assets/icons/kw_flag.png';
                              countryCode = '+965';
                            });
                            Navigator.of(context).pop();
                          },
                          leading: Image.asset('assets/icons/kw_flag.png'),
                          title:
                              Text(AppLocalization.of(context).translate("kw")),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        : showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
                  content: Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Theme.of(context).primaryColor),
                          child: ListTile(
                            onTap: () {
                              setState(() {
                                image = 'assets/icons/ksa_flag.png';
                                countryCode = '+966';
                              });
                              Navigator.of(context).pop();
                            },
                            title: Text(
                                AppLocalization.of(context).translate("ksa")),
                            leading: Image.asset('assets/icons/ksa_flag.png'),
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Theme.of(context).primaryColor),
                          child: ListTile(
                            onTap: () {
                              setState(() {
                                image = 'assets/icons/uae_flag.png';
                                countryCode = '+971';
                              });
                              Navigator.of(context).pop();
                            },
                            leading: Image.asset('assets/icons/uae_flag.png'),
                            title: Text(
                                AppLocalization.of(context).translate("uae")),
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Theme.of(context).primaryColor),
                          child: ListTile(
                            onTap: () {
                              setState(() {
                                image = 'assets/icons/kw_flag.png';
                                countryCode = '+965';
                              });
                              Navigator.of(context).pop();
                            },
                            leading: Image.asset('assets/icons/kw_flag.png'),
                            title: Text(
                                AppLocalization.of(context).translate("kw")),
                          ),
                        )
                      ],
                    ),
                  ),
                  title: Center(
                    child: Text(
                      AppLocalization.of(context).translate("choose_country"),
                    ),
                  ),
                ));
  }

  _doForget() {
    if (_isEmailMethodClicked) {
      if (!_emailFormKey.currentState.validate()) {
        return;
      }
      _emailFormKey.currentState.save();
      setState(() {
        _isLoading = true;
      });
      Provider.of<UserProvider>(context).otpByEmail(email).then((msg) {
        setState(() {
          _isLoading = false;
        });
        if (msg['msg'] == 2) {
//          print(msg['otp']);
          Navigator.pushReplacementNamed(context, ConfirmOtpScreen.routeName,
              arguments: {'email': email, 'type': 'email', 'otp': msg['otp']});
        } else {
//          print(msg);
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              msg['msg'] == 1
                  ? AppLocalization.of(context).translate("user_not_found")
                  : AppLocalization.of(context).translate("try_again_later"),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15.0, fontFamily: 'tajawal'),
            ),
          ));
        }
      });
    } else if (_isPhoneMethodClicked) {
      if (!_phoneFormKey.currentState.validate()) {
        return;
      }
      _phoneFormKey.currentState.save();
      setState(() {
        _isLoading = true;
      });
      Provider.of<UserProvider>(context).otpByPhone(phone, "1").then((msg) {
        setState(() {
          _isLoading = false;
        });
        if (msg['msg'] == 2) {
//          print(msg['otp']);
          Navigator.pushReplacementNamed(context, ConfirmOtpScreen.routeName,
              arguments: {'phone': phone, 'type': 'phone', 'otp': msg['otp']});
        } else {
//          print(msg);
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              msg['msg'] == 1
                  ? AppLocalization.of(context).translate("user_not_found")
                  : AppLocalization.of(context).translate("try_again_later"),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15.0, fontFamily: 'tajawal'),
            ),
          ));
        }
      });
//      print(phone);
    }
  }

  _checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      _doForget();
    } else {
      ConnectionPopup.showAlert(
          AppLocalization.of(context).translate("show_connection_error"),
          context);
    }
  }

  @override
  void initState() {
    super.initState();
    _checkInternetConnection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppLocalization.of(context).translate("forget_pass_title"),
          style: TextStyle(
            fontSize: 19.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                child: Image.asset(
                  'assets/icons/lock.png',
                  width: 45.0,
                  height: 60.0,
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  AppLocalization.of(context)
                      .translate("method_receive_verification"),
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isEmailMethodClicked = true;
                    _isPhoneMethodClicked = false;
                  });
                },
                child: !_isEmailMethodClicked
                    ? Container(
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          color: CustomColors.kSecondaryColor,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Text(
                          AppLocalization.of(context).translate("userEmail"),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: CustomColors.kSecondaryColor,
                          borderRadius: BorderRadius.circular(10.0),
                          border: _isEmailMethodClicked
                              ? Border.all(
                                  width: 1.0,
                                  color: Theme.of(context).accentColor)
                              : Border.all(
                                  width: 0.0,
                                  color: Theme.of(context).primaryColor,
                                ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Container(
                              child: Text(
                                AppLocalization.of(context)
                                    .translate("userEmail"),
                                style: TextStyle(
                                    color: CustomColors.kTabBarIconColor,
                                    fontSize: 16.0),
                              ),
                            ),
                            Container(
                              child: Form(
                                key: _emailFormKey,
                                child: TextFormField(
                                  validator: (value) {
                                    Pattern pattern =
                                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                    RegExp regex = new RegExp(pattern);
                                    if (!regex.hasMatch(value))
                                      return AppLocalization.of(context)
                                          .translate("email_validation_msg");
                                    else
                                      return null;
                                  },
                                  onSaved: (value) {
                                    email = value;
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    hintText: AppLocalization.of(context)
                                        .translate("email_hint"),
                                    hintStyle: TextStyle(
                                        color: CustomColors.kTabBarIconColor,
                                        fontSize: 16.0),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
              ),
              SizedBox(
                height: 20.0,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isEmailMethodClicked = false;
                    _isPhoneMethodClicked = true;
                  });
                },
                child: !_isPhoneMethodClicked
                    ? Container(
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          color: CustomColors.kSecondaryColor,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Text(
                          AppLocalization.of(context)
                              .translate("phone_in_login"),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: CustomColors.kSecondaryColor,
                          borderRadius: BorderRadius.circular(10.0),
                          border: _isPhoneMethodClicked
                              ? Border.all(
                                  width: 1.0,
                                  color: Theme.of(context).accentColor)
                              : Border.all(
                                  width: 0.0,
                                  color: Theme.of(context).primaryColor,
                                ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Container(
                              child: Text(
                                AppLocalization.of(context)
                                    .translate("phone_in_login"),
                                style: TextStyle(
                                    color: CustomColors.kTabBarIconColor,
                                    fontSize: 16.0),
                              ),
                            ),
                            Row(
                              textDirection: TextDirection.ltr,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    _showPopupCountry();
                                  },
                                  child: Container(
                                    width: 100.0,
                                    margin: const EdgeInsets.only(bottom: 10.0),
                                    child: Row(
                                      textDirection: TextDirection.ltr,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Image.asset(
                                          image == null
                                              ? 'assets/icons/ksa_flag.png'
                                              : image,
                                          width: 25.0,
                                          height: 15.0,
                                          fit: BoxFit.cover,
                                        ),
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                        Text(
                                          countryCode == null
                                              ? '+966'
                                              : countryCode,
                                          style: TextStyle(fontSize: 16.0),
                                          textDirection: TextDirection.ltr,
                                        ),
                                        Icon(Icons.arrow_drop_down),
                                      ],
                                    ),
//                  ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Form(
                                      key: _phoneFormKey,
                                      child: TextFormField(
                                        textDirection: TextDirection.ltr,
                                        validator: (value) {
                                          return (value.isEmpty ||
                                                  value.length < 9 ||
                                                  value.length > 15)
                                              ? AppLocalization.of(context)
                                                  .translate(
                                                      "phone_validation_length_msg")
                                              : null;
                                        },
                                        onSaved: (value) {
                                          phone = '$countryCode$value';
                                        },
                                        keyboardType: TextInputType.phone,
                                        maxLength: 15,
                                        inputFormatters: <TextInputFormatter>[
                                          WhitelistingTextInputFormatter
                                              .digitsOnly,
                                        ],
                                        decoration: InputDecoration(
                                          labelText: AppLocalization.of(context)
                                              .translate("phone_in_login"),
                                          labelStyle: TextStyle(
                                              color: CustomColors
                                                  .kTabBarIconColor),
                                          hintText: AppLocalization.of(context)
                                              .translate("phone_hint"),
                                          hintStyle: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
//
                          ],
                        ),
                      ),
              ),
              SizedBox(height: 30.0),
              Container(
                width: double.infinity,
                height: 44.0,
                margin:
                    const EdgeInsets.only(left: 16.0, right: 16.0, top: 30.0),
                decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.circular(10.0)),
                child: FlatButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          _checkInternetConnection();
                        },
                  child: _isLoading
                      ? AdaptiveProgressIndicator()
                      : Text(
                          AppLocalization.of(context).translate("send_btn"),
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
