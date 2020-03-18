import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topstyle/constants/colors.dart';
import 'package:topstyle/helper/appLocalization.dart';
import 'package:topstyle/providers/user_provider.dart';
import 'package:topstyle/widgets/adaptive_progress_indecator.dart';
import 'package:topstyle/widgets/network_connection.dart';

import 'login_screen.dart';

class ChangePasswordOtpScreen extends StatefulWidget {
  static String routeName = 'change-password-from-otp';

  @override
  _ChangePasswordOtpScreenState createState() =>
      _ChangePasswordOtpScreenState();
}

class _ChangePasswordOtpScreenState extends State<ChangePasswordOtpScreen> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var _formKey = GlobalKey<FormState>();
  String _password, _confirmPass;

  bool _isLoading = false;

  _doChangePassword() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    if (_password != _confirmPass) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          AppLocalization.of(context).translate("mismatch_password_msg"),
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15.0, fontFamily: 'tajawal'),
        ),
      ));
    } else {
      setState(() {
        _isLoading = true;
      });
      Provider.of<UserProvider>(context, listen: false)
          .changeFromOtp(
              data['type'] == 'phone' ? data['phone'] : data['email'],
              data['type'].toString(),
              _password)
          .then((isDone) {
        setState(() {
          _isLoading = false;
        });
        if (isDone) {
          Navigator.pushReplacementNamed(context, LoginScreen.routeName);
        } else {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              AppLocalization.of(context).translate("try_again_later"),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15.0, fontFamily: 'tajawal'),
            ),
          ));
        }
      });
    }
  }

  _checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      _doChangePassword();
    } else {
      ConnectionPopup.showAlert(
          AppLocalization.of(context).translate("show_connection_error"),
          context);
    }
  }

  var data;

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments as Map;
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <
                  Widget>[
            Container(
              child: Image.asset(
                'assets/icons/lock.png',
                width: 45.0,
                height: 60.0,
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                AppLocalization.of(context).translate("new_pass_for_account"),
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 60.0,
            ),
            Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 10.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty || value.length < 6) {
                            return AppLocalization.of(context)
                                .translate("password_validation_msg");
                          }
                          return null;
                        },
                        onSaved: (newPass) {
                          _password = newPass;
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText:
                              AppLocalization.of(context).translate("new_pass"),
                          labelStyle: TextStyle(
                              color: CustomColors.kTabBarIconColor,
                              fontSize: 16.0),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 10.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty || value.length < 6) {
                            return AppLocalization.of(context)
                                .translate("password_validation_msg");
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _confirmPass = value;
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: AppLocalization.of(context)
                                .translate("confirm_pass"),
                            labelStyle: TextStyle(
                                color: CustomColors.kTabBarIconColor,
                                fontSize: 16.0)),
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Container(
                      width: double.infinity,
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
                                _checkInternetConnection();
                              },
                        child: _isLoading
                            ? AdaptiveProgressIndicator()
                            : Text(
                                AppLocalization.of(context)
                                    .translate("save_btn"),
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
                  ],
                )),
          ]),
        ),
      ),
    );
  }
}
