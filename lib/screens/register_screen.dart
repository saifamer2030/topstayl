import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:topstyle/constants/colors.dart';
import 'package:topstyle/helper/appLocalization.dart';
import 'package:topstyle/helper/size_config.dart';
import 'package:topstyle/providers/network_provider.dart';
import 'package:topstyle/providers/user_provider.dart';
import 'package:topstyle/screens/checkoutScreen.dart';
import 'package:topstyle/screens/login_screen.dart';
import 'package:topstyle/screens/product_details.dart';
import 'package:topstyle/screens/tabs_screen.dart';
import 'package:topstyle/widgets/adaptive_progress_indecator.dart';
import 'package:topstyle/widgets/connectivity_widget.dart';

class RegisterScreen extends StatefulWidget {
  static String routeName = 'register';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var _createAccountKey = GlobalKey<FormState>();
  Map<String, String> _registerMap = {
    'email': '',
    'password': '',
    'name': '',
    'phone': '',
    'country': "1",
    'langugae': 'ar',
    'guestId': 'new'
  };
  bool _isLoading = false;
  bool _autoValidation = false;
  var phone;
  String countryCode = '+966', image;

  _doRegistration(var from) {
    if (!_createAccountKey.currentState.validate()) {
      setState(() {
        _autoValidation = true;
      });
    } else {
      _createAccountKey.currentState.save();
//      print(_registerMap['phone']);
//      print(_registerMap['password']);
//      print(_registerMap['name']);
//      print(_registerMap['email']);
//      print(_registerMap['phone']);
      setState(() {
        _isLoading = true;
      });
      Provider.of<UserProvider>(context, listen: false)
          .register(
              _registerMap['name'],
              _registerMap['email'],
              _registerMap['password'],
              _registerMap['phone'],
              _registerMap['langugae'],
              _registerMap['country'])
          .then((responseMap) {
        setState(() {
          _isLoading = false;
        });

        if (responseMap['isRegisterd']) {
          Navigator.of(context).pop();
          SharedPreferences.getInstance().then((p) {
            if (p != null) {
              String redirection = p.getString('redirection');
              if (redirection == 'toPayment') {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => CheckoutScreen(0)));
              } else if (redirection == 'toHome') {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    TabsScreen.routeName, (Route<dynamic> route) => false);
              } else if (redirection == 'toDetails') {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => ProductDetails(int.parse(from))));
              }
            } else {
              // if redirection null go home and remove all pages stack
              Navigator.of(context).pushNamedAndRemoveUntil(
                  TabsScreen.routeName, (Route<dynamic> route) => false);
            }
          });
          from == 1
              ? Navigator.of(context).pushNamedAndRemoveUntil(
                  TabsScreen.routeName, (Route<dynamic> route) => false)
              : Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => CheckoutScreen(0)));
        } else {
          //print('some error occured');
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              responseMap['msg'] == 1
                  ? AppLocalization.of(context).translate("phone_taken_msg")
                  : responseMap['msg'] == 2
                      ? AppLocalization.of(context).translate("email_taken_msg")
                      : AppLocalization.of(context)
                          .translate("try_again_later"),
//            AppLocalization.of(context).translate("user_or_pass_incorrect_msg"),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15.0, fontFamily: 'tajawal'),
            ),
          ));
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserCountryAndLanguage();
  }

// Initialize country and lang if null the default arabic
  getUserCountryAndLanguage() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getString('language_code') != null) {
//      print(prefs.getString('language_code'));
      switch (prefs.getString('language_code')) {
        case 'ar':
          _registerMap['langugae'] = "ar";
          break;
        case 'en':
          _registerMap['langugae'] = "en";
          break;
      }
    }
    if (prefs.getString('countryName') != null) {
      switch (prefs.getString('countryName')) {
        case 'KSA':
          setState(() {
            countryCode = '+966';
            _registerMap['country'] = "1";
            image = 'assets/icons/ksa_flag.png';
          });
          break;
        case 'UAE':
          setState(() {
            countryCode = '+971';
            _registerMap['country'] = "3";
            image = 'assets/icons/uae_flag.png';
          });
          break;
        case 'KW':
          setState(() {
            countryCode = '+965';
            _registerMap['country'] = "2";
            image = 'assets/icons/kw_flag.png';
          });
          break;
      }
    }
  }

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

  ScreenConfig screenConfig;
  WidgetSize widgetSize;
  @override
  Widget build(BuildContext context) {
    screenConfig = ScreenConfig(context);
    widgetSize = WidgetSize(screenConfig);
    String fromScreen = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            AppLocalization.of(context).translate('registration_from_title'),
            style: TextStyle(
                fontSize: widgetSize.mainTitle, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Provider<NetworkProvider>.value(
            value: NetworkProvider(),
            child: Consumer<NetworkProvider>(
              builder: (context, value, _) => Center(
                child: ConnectivityWidget(
                  networkProvider: value,
                  child: SingleChildScrollView(
                    child: Form(
                      key: _createAccountKey,
                      autovalidate: _autoValidation,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 10.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Container(
                                width:
                                    MediaQuery.of(context).size.width / 3 - 15,
                                height:
                                    MediaQuery.of(context).size.width / 6 - 15,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 50.0),
                                child: Image.asset(
                                  'assets/images/logo.jpg',
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                              ButtonBar(
                                alignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                            width: 2.0,
                                            color:
                                                Theme.of(context).accentColor),
                                      ),
                                    ),
                                    child: FlatButton(
                                      splashColor: Colors.white,
                                      onPressed: () {},
                                      child: Text(
                                        AppLocalization.of(context).translate(
                                            "registration_from_title"),
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor,
                                            fontSize: widgetSize.subTitle),
                                      ),
                                    ),
                                  ),
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                              LoginScreen.routeName);
                                    },
                                    child: Text(
                                      AppLocalization.of(context)
                                          .translate("login_btn"),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: widgetSize.subTitle),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Container(
                                height: widgetSize.textField,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1.0,
                                      color: CustomColors.kPCardColor),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value.isEmpty ||
                                        value.length < 5 ||
                                        value.length > 30) {
                                      return AppLocalization.of(context)
                                          .translate(
                                              "user_name_validation_length_msg");
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _registerMap['name'] = value;
                                  },
                                  style:
                                      TextStyle(fontSize: widgetSize.subTitle),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    errorStyle: TextStyle(
                                        fontSize: widgetSize.textFieldError),
                                    hintText: AppLocalization.of(context)
                                        .translate("userName"),
                                    hintStyle: TextStyle(
                                      fontSize: widgetSize.subTitle,
                                      color: Colors.grey,
                                    ),
                                    contentPadding: const EdgeInsets.only(
                                        left: 10.0, right: 10.0, bottom: 6.0),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
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
                                            style: TextStyle(fontSize: 14.0),
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
                                      height: widgetSize.textField,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1.0,
                                            color: CustomColors.kPCardColor),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: Directionality(
                                        textDirection: TextDirection.ltr,
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
                                          style: TextStyle(
                                              fontSize: widgetSize.subTitle),
                                          onSaved: (value) {
                                            _registerMap['phone'] =
                                                '$countryCode$value';
                                          },
                                          keyboardType: TextInputType.phone,
                                          inputFormatters: <TextInputFormatter>[
                                            WhitelistingTextInputFormatter
                                                .digitsOnly,
                                            LengthLimitingTextInputFormatter(9),
                                          ],
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            errorStyle: TextStyle(
                                                fontSize:
                                                    widgetSize.textFieldError),
                                            hintText: '5xxxxxxxx',
                                            hintStyle: TextStyle(
                                                fontSize: widgetSize.subTitle,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold),
                                            contentPadding:
                                                const EdgeInsets.only(
                                              left: 10.0,
                                              right: 10.0,
                                              bottom: 6.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Container(
                                height: widgetSize.textField,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1.0,
                                      color: CustomColors.kPCardColor),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
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
                                  style:
                                      TextStyle(fontSize: widgetSize.subTitle),
                                  onSaved: (value) {
                                    _registerMap['email'] = value;
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                      errorStyle: TextStyle(
                                          fontSize: widgetSize.textFieldError),
                                      border: InputBorder.none,
                                      hintText: AppLocalization.of(context)
                                          .translate("userEmail"),
                                      hintStyle: TextStyle(
                                        fontSize: widgetSize.subTitle,
                                        color: Colors.grey,
                                      ),
                                      contentPadding: const EdgeInsets.only(
                                          left: 10.0,
                                          right: 10.0,
                                          bottom: 6.0)),
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Container(
                                height: widgetSize.textField,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1.0,
                                      color: CustomColors.kPCardColor),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value.isEmpty || value.length < 6) {
                                      return AppLocalization.of(context)
                                          .translate("password_validation_msg");
                                    }
                                    return null;
                                  },
                                  style:
                                      TextStyle(fontSize: widgetSize.subTitle),
                                  onSaved: (value) {
                                    _registerMap['password'] = value;
                                  },
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    errorStyle: TextStyle(
                                        fontSize: widgetSize.textFieldError),
                                    hintText: AppLocalization.of(context)
                                        .translate("password"),
                                    hintStyle: TextStyle(
                                      fontSize: widgetSize.subTitle,
                                      color: Colors.grey,
                                    ),
                                    contentPadding: const EdgeInsets.only(
                                        left: 10.0, right: 10.0, bottom: 6.0),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              Container(
                                height: widgetSize.textField,
                                margin: const EdgeInsets.only(
                                    top: 20.0, bottom: 10.0),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).accentColor,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: RaisedButton(
                                  color: Theme.of(context).accentColor,
                                  onPressed: _isLoading
                                      ? null
                                      : () {
                                          _doRegistration(fromScreen);
                                        },
                                  child: _isLoading
                                      ? AdaptiveProgressIndicator()
                                      : Text(
                                          AppLocalization.of(context).translate(
                                              "registration_from_title"),
                                          style: TextStyle(
                                              fontSize: widgetSize.mainTitle,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                            ]),
                      ),
                    ),
                  ),
                ),
              ),
            )));
  }
}
