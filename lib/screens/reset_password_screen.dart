import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:topstyle/constants/colors.dart';
import 'package:topstyle/helper/size_config.dart';
import 'package:topstyle/providers/network_provider.dart';
import 'package:topstyle/providers/user_provider.dart';
import 'package:topstyle/widgets/adaptive_progress_indecator.dart';
import 'package:topstyle/widgets/connectivity_widget.dart';

import '../helper/appLocalization.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  getUserToken() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getString('userData') != null) {
      var userData = jsonDecode(prefs.getString('userData'));
      _resetMap['token'] = userData['userToken'];
//      print(_resetMap['token']);
    }
  }

  @override
  void initState() {
    getUserToken();
    super.initState();
  }

  bool _oldIsNotVisible = true, _newIsNotVisible = true;

  _setPassVisible(String type) {
    if (type == 'old') {
      setState(() {
        _oldIsNotVisible = !_oldIsNotVisible;
      });
    } else {
      setState(() {
        _newIsNotVisible = !_newIsNotVisible;
      });
    }
  }

  _showSnackBar(int type, String msg) {
    return _scaffoldKey.currentState.showSnackBar(SnackBar(
      backgroundColor: type == 1 ? Colors.green : Colors.red,
      content: Text(
        msg,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15.0, fontFamily: 'tajawal'),
      ),
    ));
  }

  var _resetPassFormKey = GlobalKey<FormState>();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var _resetMap = {'old': '', 'new': '', 'confirm': '', 'token': ''};

  bool _isLoading = false;

  _doReset() async {
    if (!_resetPassFormKey.currentState.validate()) {
      return;
    }
    _resetPassFormKey.currentState.save();
    if (_resetMap['new'] != _resetMap['confirm']) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          AppLocalization.of(context).translate("mismatch_password_msg"),
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15.0, fontFamily: 'tajawal'),
        ),
      ));
    } else if (_resetMap['old'] == _resetMap['new']) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          AppLocalization.of(context).translate("old_new_pass_same"),
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15.0, fontFamily: 'tajawal'),
        ),
      ));
    } else {
      setState(() {
        _isLoading = true;
      });
      Provider.of<UserProvider>(context, listen: false)
          .resetPassword(_resetMap['token'], _resetMap['old'], _resetMap['new'])
          .then((resetMsg) {
        setState(() {
          _isLoading = false;
        });

        switch (resetMsg) {
          case 1:
            _resetPassFormKey.currentState.reset();
            _showSnackBar(
              1,
              AppLocalization.of(context)
                  .translate("password_change_successfully"),
            );
            break;
          case 2:
            _showSnackBar(
              2,
              AppLocalization.of(context).translate("wrong_password"),
            );
            break;
          case 3:
            _showSnackBar(
              3,
              AppLocalization.of(context).translate("un_authenticated"),
            );
            break;
          case 4:
            _showSnackBar(
              4,
              AppLocalization.of(context).translate("try_again_later"),
            );
            break;
        }
      });
    }
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
          title: Text(
            AppLocalization.of(context)
                .translate("change_password_in_account_setting_page"),
            style: TextStyle(fontSize: widgetSize.mainTitle),
          ),
          centerTitle: true,
        ),
        body: Provider<NetworkProvider>.value(
          value: NetworkProvider(),
          child: Consumer<NetworkProvider>(
            builder: (context, value, _) => Center(
              child: ConnectivityWidget(
                networkProvider: value,
                child: Container(
                  height: screenConfig.screenHeight,
                  child: SingleChildScrollView(
                    child: Form(
                        key: _resetPassFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Container(
                              height: 50.0,
                              margin: const EdgeInsets.only(
                                  left: 16.0,
                                  right: 16.0,
                                  top: 16.0,
                                  bottom: 8.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1.0,
                                    color: CustomColors.kPCardColor),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Center(
                                child: TextFormField(
                                  validator: (value) {
                                    if (value.isEmpty || value.length < 6) {
                                      return AppLocalization.of(context)
                                          .translate("password_validation_msg");
                                    }
                                    return null;
                                  },
                                  onSaved: (oldPass) {
                                    _resetMap['old'] = oldPass;
                                  },
                                  obscureText: _oldIsNotVisible,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.only(
                                        left: 8.0, right: 8.0, top: 16.0),
                                    hintText: AppLocalization.of(context)
                                        .translate("old_pass"),
                                    hintStyle: TextStyle(
                                        color: CustomColors.kTabBarIconColor),
                                    suffixIcon: IconButton(
                                      color: Colors.grey,
                                      onPressed: () => _setPassVisible('old'),
                                      icon: Icon(_oldIsNotVisible
                                          ? Icons.visibility_off
                                          : Icons.visibility),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 50.0,
                              margin: const EdgeInsets.only(
                                  left: 16.0,
                                  right: 16.0,
                                  top: 8.0,
                                  bottom: 8.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1.0,
                                    color: CustomColors.kPCardColor),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Center(
                                child: TextFormField(
                                  validator: (value) {
                                    if (value.isEmpty || value.length < 6) {
                                      return AppLocalization.of(context)
                                          .translate("password_validation_msg");
                                    }
                                    return null;
                                  },
                                  onSaved: (newPass) {
                                    _resetMap['new'] = newPass;
                                  },
                                  obscureText: _newIsNotVisible,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.only(
                                        left: 8.0, right: 8.0, top: 16.0),
                                    hintText: AppLocalization.of(context)
                                        .translate("new_pass"),
                                    hintStyle: TextStyle(
                                        color: CustomColors.kTabBarIconColor),
                                    suffixIcon: IconButton(
                                      color: Colors.grey,
                                      onPressed: () => _setPassVisible('new'),
                                      icon: Icon(_newIsNotVisible
                                          ? Icons.visibility_off
                                          : Icons.visibility),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 50.0,
                              margin: const EdgeInsets.only(
                                  left: 16.0,
                                  right: 16.0,
                                  top: 8.0,
                                  bottom: 8.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1.0,
                                    color: CustomColors.kPCardColor),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Center(
                                child: TextFormField(
                                  validator: (value) {
                                    if (value.isEmpty || value.length < 6) {
                                      return AppLocalization.of(context)
                                          .translate("password_validation_msg");
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _resetMap['confirm'] = value;
                                  },
                                  obscureText: _newIsNotVisible,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.only(
                                        left: 8.0, right: 8.0, top: 16.0),
                                    hintText: AppLocalization.of(context)
                                        .translate("confirm_pass"),
                                    hintStyle: TextStyle(
                                        color: CustomColors.kTabBarIconColor),
                                    suffixIcon: IconButton(
                                      color: Colors.grey,
                                      onPressed: () => _setPassVisible('new'),
                                      icon: Icon(_newIsNotVisible
                                          ? Icons.visibility_off
                                          : Icons.visibility),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 16.0, right: 16.0, top: 30.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: CustomColors.kAccentColor,
                              ),
                              child: FlatButton(
                                onPressed: _isLoading
                                    ? null
                                    : () {
                                        _doReset();
                                      },
                                child: _isLoading
                                    ? AdaptiveProgressIndicator()
                                    : Text(
                                        AppLocalization.of(context)
                                            .translate("change_btn"),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                              ),
                            ),
                          ],
                        )),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
