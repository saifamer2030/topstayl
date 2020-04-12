import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:topstyle/constants/colors.dart';
import 'package:topstyle/helper/appLocalization.dart';
import 'package:topstyle/helper/size_config.dart';
import 'package:topstyle/providers/network_provider.dart';
import 'package:topstyle/providers/user_provider.dart';
import 'package:topstyle/screens/checkoutScreen.dart';
import 'package:topstyle/screens/forget_password.dart';
import 'package:topstyle/screens/product_details.dart';
import 'package:topstyle/screens/register_screen.dart';
import 'package:topstyle/screens/tabs_screen.dart';
import 'package:topstyle/widgets/adaptive_progress_indecator.dart';
import 'package:topstyle/widgets/connectivity_widget.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = 'login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var _loginKey = GlobalKey<FormState>();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  final focusPassword = FocusNode();
  Map<String, String> _loginMap = {'email': '', 'password': ''};
  bool _isLoading = false;
  bool _isNotVisible = true;
  bool _autoValidation = false;

  _setPassVisible() {
    setState(() {
      _isNotVisible = !_isNotVisible;
    });
  }

  _doLogin(var from) async {
    if (!_loginKey.currentState.validate()) {
      setState(() {
        _autoValidation = true;
      });
    } else {
      _loginKey.currentState.save();
      setState(() {
        _isLoading = true;
      });
      Provider.of<UserProvider>(context, listen: false)
          .login(_loginMap['email'], _loginMap['password'])
          .then((isAuthenticated) {
        setState(() {
          _isLoading = false;
        });

        if (isAuthenticated) {
          SharedPreferences.getInstance().then((p) {
            if (p != null) {
              String redirection = p.getString('redirection');
              if (redirection == 'toPayment') {
                Navigator.of(context).push(
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
        } else {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              AppLocalization.of(context)
                  .translate("user_or_pass_incorrect_msg"),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15.0, fontFamily: 'tajawal'),
            ),
          ));
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
    String fromScreen = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            AppLocalization.of(context).translate('login_btn'),
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
                    key: _loginKey,
                    autovalidate: _autoValidation,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 10.0),
                      height: screenConfig.screenHeight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width / 3 - 15,
                            height: MediaQuery.of(context).size.width / 6 - 15,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 50.0),
                            child: Image.asset(
                              'assets/images/logo.jpg',
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                          ButtonBar(
                            alignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 1.0,
                                        color: Theme.of(context).accentColor),
                                  ),
                                ),
                                child: FlatButton(
                                  splashColor: Colors.white,
                                  onPressed: () {},
                                  child: Text(
                                    AppLocalization.of(context)
                                        .translate("login_btn"),
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontSize: widgetSize.subTitle),
                                  ),
                                ),
                              ),
                              FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pushReplacementNamed(
                                      RegisterScreen.routeName,
                                      arguments: fromScreen);
                                },
                                child: Text(
                                  AppLocalization.of(context)
                                      .translate("registration_from_title"),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: widgetSize.subTitle),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          Container(
                            height: widgetSize.textField,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1.0, color: CustomColors.kPCardColor),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Center(
                              child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (v) {
                                  FocusScope.of(context)
                                      .requestFocus(focusPassword);
                                },
                                style: TextStyle(fontSize: widgetSize.subTitle),
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
                                  _loginMap['email'] = value;
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  errorStyle: TextStyle(
                                      fontSize: widgetSize.textFieldError),
                                  hintText: AppLocalization.of(context)
                                      .translate("userEmail"),
                                  hintStyle: TextStyle(
                                    fontSize: widgetSize.subTitle,
                                    color: Colors.grey,
                                  ),
                                  contentPadding: const EdgeInsets.only(
                                      left: 10.0, right: 10.0, bottom: 5.0),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Container(
                            height: widgetSize.textField,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1.0, color: CustomColors.kPCardColor),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: TextFormField(
                              obscureText: _isNotVisible,
                              focusNode: this.focusPassword,
                              textInputAction: TextInputAction.done,
                              onSaved: (value) {
                                _loginMap['password'] = value;
                              },
                              style: TextStyle(
                                fontSize: widgetSize.subTitle,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: AppLocalization.of(context)
                                    .translate('password_hint'),
                                hintStyle: TextStyle(
                                  fontSize: widgetSize.subTitle,
                                  color: Colors.grey,
                                ),
                                suffixIcon: IconButton(
                                  color: Colors.grey,
                                  onPressed: () => _setPassVisible(),
                                  icon: Icon(_isNotVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                ),
                                contentPadding: const EdgeInsets.only(
                                    left: 10.0, right: 10.0, top: 10.0),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          Container(
                            height: widgetSize.textField,
                            margin:
                                const EdgeInsets.only(top: 20.0, bottom: 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Theme.of(context).accentColor,
                            ),
                            child: RaisedButton(
                              color: Theme.of(context).accentColor,
                              onPressed: _isLoading
                                  ? null
                                  : () {
                                      _doLogin(fromScreen);
//
                                    },
                              child: _isLoading
                                  ? AdaptiveProgressIndicator()
                                  : Text(
                                      AppLocalization.of(context)
                                          .translate("login_form_title"),
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
                          Container(
                            alignment: Alignment.center,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(ForgetPasswordScreen.routeName);
                              },
                              child: Text(
                                AppLocalization.of(context)
                                    .translate("forget_password"),
                                style: TextStyle(
                                  fontSize: widgetSize.subTitle,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
