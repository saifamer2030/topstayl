import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:topstyle/constants/colors.dart';
import 'package:topstyle/helper/appLocalization.dart';
import 'package:topstyle/helper/common_component.dart';
import 'package:topstyle/helper/size_config.dart';
import 'package:topstyle/providers/user_provider.dart';
import 'package:topstyle/widgets/adaptive_progress_indecator.dart';

class ChangeNamePassEmailScreen extends StatefulWidget {
  final String title;
  ChangeNamePassEmailScreen(this.title);

  @override
  _ChangeNamePassEmailScreenState createState() =>
      _ChangeNamePassEmailScreenState();
}

class _ChangeNamePassEmailScreenState extends State<ChangeNamePassEmailScreen> {
  ScreenConfig screenConfig;
  WidgetSize widgetSize;
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var userData;
  bool _isUserLoggedIn = false, _isLoading = true, _isBtnLoading = false;
  String email = '', name = '', phone = '', countryCode = '+966', image;

  @override
  void initState() {
    checkLoginStatus();
    super.initState();
  }

  checkLoginStatus() async {
    userData = await CommonComponent.checkLoginStatus();
    if (userData == null || userData == {}) {
      // User Not Logged IN
      setState(() {
        _isUserLoggedIn = false;
        _isLoading = false;
      });
    } else {
      // User Is Logged In
      setState(() {
        _isUserLoggedIn = true;
        _isLoading = false;
        countryCode = (userData['phone'] as String).substring(0, 4);
        _setCountyFlag(countryCode);
      });
    }
  }

  _setCountyFlag(String code) {
    switch (code) {
      case '+966':
        image = 'assets/icons/ksa_flag.png';
        break;
      case '+971':
        image = 'assets/icons/uae_flag.png';
        break;
      case '+965':
        image = 'assets/icons/kw_flag.png';
        break;
      default:
        image = 'assets/icons/ksa_flag.png';
        break;
    }
  }

  _showCountryPopup() async {
    return showDialog(
      context: context,
      builder: (context) => Platform.isIOS
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
                                });
                                Navigator.of(context).pop();
                              },
                              title: Text(
                                AppLocalization.of(context).translate("ksa"),
                                style: TextStyle(
                                    fontSize: widgetSize.textFieldError),
                              ),
                              leading: Image.asset(
                                'assets/icons/ksa_flag.png',
                                width: 35.0,
                                height: 25.0,
                                fit: BoxFit.cover,
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
                                  image = 'assets/icons/uae_flag.png';
                                  countryCode = '+971';
                                });
                                Navigator.of(context).pop();
                              },
                              leading: Image.asset(
                                'assets/icons/uae_flag.png',
                                width: 35.0,
                                height: 25.0,
                                fit: BoxFit.cover,
                              ),
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
                                });
                                Navigator.of(context).pop();
                              },
                              leading: Image.asset(
                                'assets/icons/kw_flag.png',
                                width: 35.0,
                                height: 25.0,
                                fit: BoxFit.cover,
                              ),
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
                        leading: Image.asset(
                          'assets/icons/ksa_flag.png',
                          width: 35.0,
                          height: 25.0,
                          fit: BoxFit.cover,
                        ),
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
                        leading: Image.asset(
                          'assets/icons/uae_flag.png',
                          width: 35.0,
                          height: 25.0,
                          fit: BoxFit.cover,
                        ),
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
                        leading: Image.asset(
                          'assets/icons/kw_flag.png',
                          width: 35.0,
                          height: 25.0,
                          fit: BoxFit.cover,
                        ),
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

  Widget _buildPhone(BuildContext context) {
    return Container(
      height: widgetSize.textField,
      margin: const EdgeInsets.only(top: 15.0),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Stack(
          children: <Widget>[
            Container(
              height: widgetSize.textField,
              child: GestureDetector(
                onTap: () {
                  _showCountryPopup();
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  textDirection: TextDirection.ltr,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Image.asset(
                      image,
                      width: 35.0,
                      height: 25.0,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      countryCode,
                      style: TextStyle(fontSize: widgetSize.content),
                      textDirection: TextDirection.ltr,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Icon(Icons.keyboard_arrow_down),
                  ],
                ),
              ),
            ),
            Positioned(
                top: 0,
                left: 125,
                child: Container(
                  width: screenConfig.screenWidth,
                  child: TextFormField(
                    textDirection: TextDirection.ltr,
                    style: TextStyle(fontSize: widgetSize.content),
                    initialValue: (userData['phone'] as String).substring(4),
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                    onChanged: (phoneValue) {
                      setState(() {
                        phone = '$countryCode$phoneValue';
                      });
                    },
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _drawTextField(BuildContext context) {
    Widget myWidget;
    switch (widget.title) {
      case 'change_name':
        myWidget = Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: TextFormField(
            initialValue: userData['name'],
            textInputAction: TextInputAction.done,
            onChanged: (val) {
              name = val;
            },
          ),
        );
        break;
      case 'change_email':
        myWidget = Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            initialValue: userData['email'],
            onChanged: (val) {
              email = val;
            },
          ),
        );
        break;
      case 'change_phone':
        myWidget = _buildPhone(context);
        break;
      default:
        myWidget = Container();
        break;
    }
    return myWidget;
  }

  final UserProvider user = UserProvider();
  void _doUpdateProfile(String name, String email, String phone) async {
    setState(() {
      _isBtnLoading = true;
    });
    var token = await user.isAuthenticated();
    final response = await Provider.of<UserProvider>(context, listen: false)
        .updateUserData(token['Authorization'], name, phone, email);
    setState(() {
      _isBtnLoading = false;
    });
    if (response != null && response > 0) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: response == 1 ? Colors.green : Colors.red,
        content: Text(
          AppLocalization.of(context).translate(response == 1
              ? "user_data_is_changed"
              : response == 2
                  ? "email_taken_msg"
                  : response == 3 ? "phone_taken_msg" : "try_again_later"),
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15.0, fontFamily: 'tajawal'),
        ),
      ));
      if (response == 1) {
        Future.delayed(Duration(seconds: 3), () {
          Navigator.of(context).pop();
        });
      }
    }
  }

  _updateName() {
    if (name.isNotEmpty && name != userData['name']) {
      _doUpdateProfile(name, '', '');
    }
  }

  _updateEmail() {
    if (email.isNotEmpty && email != userData['email']) {
      _doUpdateProfile('', email, '');
    }
  }

  _updatePhone() {
    if (phone.isNotEmpty && phone != userData['phone']) {
      _doUpdateProfile('', '', phone);
    }
  }

  @override
  Widget build(BuildContext context) {
    screenConfig = ScreenConfig(context);
    widgetSize = WidgetSize(screenConfig);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          AppLocalization.of(context).translate(widget.title),
          style: TextStyle(fontSize: widgetSize.mainTitle),
        ),
      ),
      body: _isLoading
          ? Center(
              child: AdaptiveProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _drawTextField(context),
                  SizedBox(
                    height: 16.0,
                  ),
                  Container(
                    height: widgetSize.textField,
                    child: RaisedButton(
                      color: CustomColors.kAccentColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      onPressed: _isBtnLoading
                          ? null
                          : () {
                              switch (widget.title) {
                                case 'change_name':
                                  _updateName();
                                  break;
                                case 'change_email':
                                  _updateEmail();
                                  break;
                                case 'change_phone':
                                  _updatePhone();
                                  break;
                                default:
                                  print('out of oprions');
                                  break;
                              }
                            },
                      child: _isBtnLoading
                          ? AdaptiveProgressIndicator()
                          : Text(
                              AppLocalization.of(context).translate('save_btn'),
                              style: TextStyle(
                                  fontSize: widgetSize.content,
                                  color: Colors.white),
                            ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
