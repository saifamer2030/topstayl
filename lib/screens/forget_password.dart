import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:topstyle/constants/colors.dart';
import 'package:topstyle/helper/appLocalization.dart';
import 'package:topstyle/helper/size_config.dart';
import 'package:topstyle/providers/user_provider.dart';
import 'package:topstyle/screens/otp_screen_in_forget_pass.dart';
import 'package:topstyle/widgets/adaptive_progress_indecator.dart';
import 'package:topstyle/widgets/network_connection.dart';

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
    return showDialog(
      context: context,
      builder: (context) => Theme.of(context).platform == TargetPlatform.iOS
          ? CupertinoAlertDialog(
              title: Text(
                AppLocalization.of(context).translate("choose_country"),
              ),
              content: Material(
                  color: Colors.transparent,
                  child: Container(
                      color: Colors.transparent,
                      height: 240.0,
                      margin: const EdgeInsets.only(top: 20.0),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 50.0,
                                    offset: Offset(1, 2),
                                    color: Colors.grey.withOpacity(0.3),
                                  )
                                ]),
                            child: ListTile(
                              onTap: () {
                                setState(() {
                                  image = 'assets/icons/ksa_flag.png';
                                  countryCode = '+966';
                                  phone = '$countryCode$phone';
                                });
                                Navigator.of(context).pop();
                              },
                              title: Text(
                                AppLocalization.of(context).translate("ksa"),
                                style: TextStyle(
                                    fontSize: widgetSize.textFieldError),
                              ),
                              leading: Image.asset('assets/icons/ksa_flag.png'),
                            ),
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 50.0,
                                    offset: Offset(1, 2),
                                    color: Colors.grey.withOpacity(0.3),
                                  )
                                ]),
                            child: ListTile(
                              onTap: () {
                                setState(() {
                                  image = 'assets/icons/uae_flag.png';
                                  countryCode = '+971';
                                  phone = '$countryCode$phone';
                                });
                                Navigator.of(context).pop();
                              },
                              leading: Image.asset('assets/icons/uae_flag.png'),
                              title: Text(
                                AppLocalization.of(context).translate("uae"),
                                style: TextStyle(
                                    fontSize: widgetSize.textFieldError),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 50.0,
                                    offset: Offset(1, 2),
                                    color: Colors.grey.withOpacity(0.3),
                                  )
                                ]),
                            child: ListTile(
                              onTap: () {
                                setState(() {
                                  image = 'assets/icons/kw_flag.png';
                                  countryCode = '+965';
                                  phone = '$countryCode$phone';
                                });
                                Navigator.of(context).pop();
                              },
                              leading: Image.asset('assets/icons/kw_flag.png'),
                              title: Text(
                                AppLocalization.of(context).translate("kw"),
                                style: TextStyle(
                                    fontSize: widgetSize.textFieldError),
                              ),
                            ),
                          )
                        ],
                      ))),
            )
          : AlertDialog(
              title: Center(
                child: Text(
                  AppLocalization.of(context).translate('choose_country'),
                ),
              ),
              content: Container(
                height: 240.0,
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
                          AppLocalization.of(context).translate("ksa"),
                          style: TextStyle(fontSize: widgetSize.textFieldError),
                        ),
                        leading: Image.asset('assets/icons/ksa_flag.png'),
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
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
                          AppLocalization.of(context).translate("uae"),
                          style: TextStyle(fontSize: widgetSize.textFieldError),
                        ),
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
                          AppLocalization.of(context).translate("kw"),
                          style: TextStyle(fontSize: widgetSize.textFieldError),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
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
      Provider.of<UserProvider>(context, listen: false)
          .otpByEmail(email)
          .then((msg) {
        setState(() {
          _isLoading = false;
        });
        if (msg['msg'] == 2) {
//          print(msg['otp']);
          Navigator.pushReplacementNamed(
              context, CustomOtpScreenInForgetPass.routeName,
              arguments: {'email': email, 'type': 'email', 'otp': msg['otp']});
        } else {
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
      Provider.of<UserProvider>(context, listen: false)
          .otpByPhone(phone, "1")
          .then((msg) {
        setState(() {
          _isLoading = false;
        });
        if (msg['msg'] == 2) {
//          print(msg['otp']);
          Navigator.pushReplacementNamed(
              context, CustomOtpScreenInForgetPass.routeName,
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

  ScreenConfig screenConfig;
  WidgetSize widgetSize;
  @override
  Widget build(BuildContext context) {
    screenConfig = ScreenConfig(context);
    widgetSize = WidgetSize(screenConfig);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppLocalization.of(context).translate("forget_pass_title"),
          style: TextStyle(fontSize: widgetSize.mainTitle),
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
                  style: TextStyle(
                      fontSize: widgetSize.subTitle,
                      fontWeight: FontWeight.bold),
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
                        height: widgetSize.textField,
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  offset: Offset(1, 2),
                                  blurRadius: 55.0)
                            ]),
                        child: Text(
                          AppLocalization.of(context).translate("userEmail"),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                offset: Offset(1, 2),
                                blurRadius: 55.0)
                          ],
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
                                    fontSize: widgetSize.subTitle),
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Container(
                              height: widgetSize.textField,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1.0,
                                    color: CustomColors.kPCardColor),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
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
                                    border: InputBorder.none,
                                    errorStyle: TextStyle(
                                        fontSize: widgetSize.textFieldError),
                                    hintText: AppLocalization.of(context)
                                        .translate("email_hint"),
                                    hintStyle: TextStyle(
                                      fontSize: widgetSize.subTitle,
                                      color: Colors.grey,
                                    ),
                                    contentPadding: const EdgeInsets.only(
                                        left: 10.0, right: 10.0, bottom: 5.0),
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
                        height: widgetSize.textField,
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  offset: Offset(1, 2),
                                  blurRadius: 55.0)
                            ]),
                        child: Text(
                          AppLocalization.of(context)
                              .translate("phone_in_login"),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                offset: Offset(1, 2),
                                blurRadius: 55.0)
                          ],
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
                                    fontSize: widgetSize.subTitle),
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
                                                  value.length < 8)
                                              ? AppLocalization.of(context)
                                                  .translate(
                                                      "phone_validation_length_msg")
                                              : null;
                                        },
                                        onSaved: (value) {
                                          phone = '$countryCode$value';
                                        },
                                        style: TextStyle(
                                            fontSize: widgetSize.content),
                                        keyboardType: TextInputType.phone,
                                        maxLength: 9,
                                        inputFormatters: <TextInputFormatter>[
                                          WhitelistingTextInputFormatter
                                              .digitsOnly,
                                        ],
                                        decoration: InputDecoration(
                                          labelText: AppLocalization.of(context)
                                              .translate("enter_phone"),
                                          labelStyle: TextStyle(
                                              color: CustomColors
                                                  .kTabBarIconColor),
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
                              fontSize: widgetSize.mainTitle,
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
