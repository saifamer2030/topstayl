import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:topstyle/providers/user_provider.dart';
import 'package:topstyle/widgets/adaptive_progress_indecator.dart';

import '../constants/colors.dart';
import '../helper/appLocalization.dart';
import '../screens/reset_password_screen.dart';

class AccountSettingScreen extends StatefulWidget {
  @override
  _AccountSettingScreenState createState() => _AccountSettingScreenState();
}

class _AccountSettingScreenState extends State<AccountSettingScreen> {
  var _accountFormKey = GlobalKey<FormState>();
  String name = '';
  String newName = '';
  String phone = '';
  String newPhone = '';
  String email = '';
  String newEmail = '';
  String image;
  String countryCode = '+966';
  bool _isInit = true;
  bool _isLoading = true;
  bool _isBtnLoading = false;

  getData() async {
    setState(() {
      _isLoading = true;
    });
    var prefs = await SharedPreferences.getInstance();
    name = jsonDecode(prefs.getString('userData'))['name'].toString();
    email = jsonDecode(prefs.getString('userData'))['email'].toString();
    setState(() {
      _isLoading = false;
    });
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
                  child: Container(
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
                                style: TextStyle(fontSize: 12.0),
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
                                });
                                Navigator.of(context).pop();
                              },
                              leading: Image.asset('assets/icons/uae_flag.png'),
                              title: Text(
                                AppLocalization.of(context).translate("uae"),
                                style: TextStyle(fontSize: 12.0),
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
                              leading: Image.asset('assets/icons/kw_flag.png'),
                              title: Text(
                                AppLocalization.of(context).translate("kw"),
                                style: TextStyle(fontSize: 12.0),
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
                        title:
                            Text(AppLocalization.of(context).translate("ksa")),
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
                        title:
                            Text(AppLocalization.of(context).translate("uae")),
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
    );
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      getData();
    }
    setState(() {
      _isInit = false;
    });
    super.didChangeDependencies();
  }

  var _scaffoldKey = GlobalKey<ScaffoldState>();
  UserProvider user = UserProvider();

  void _doUpdateProfile() async {
    print(newName);
    print(newEmail);
    print(newPhone);
    setState(() {
      _isBtnLoading = true;
    });
    var token = await user.isAuthenticated();
    final response = await Provider.of<UserProvider>(context)
        .updateUserData(token['Authorization'], newName, newPhone, newEmail);
    setState(() {
      _isBtnLoading = false;
    });
    if (response != null && response > 0) {
//      print(response);

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
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Scaffold(
            body: Center(
              child: AdaptiveProgressIndicator(),
            ),
          )
        : Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: Text(
                AppLocalization.of(context)
                    .translate("account_setting_in_settings_page"),
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Form(
                  key: _accountFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 16.0),
                          child: Text(
                            AppLocalization.of(context).translate(
                                "profile_info_in_account_setting_page"),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 10.0),
                        child: TextFormField(
                          initialValue: name,
                          onChanged: (val) {
                            newName = val;
                          },
                          decoration: InputDecoration(
                              labelText: AppLocalization.of(context)
                                  .translate("userName")),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 10.0),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          initialValue: email,
                          onChanged: (val) {
                            newEmail = val;
                          },
                          decoration: InputDecoration(
                              labelText: AppLocalization.of(context)
                                  .translate("userEmail")),
                        ),
                      ),
                      Container(
                        height: 50.0,
                        margin: const EdgeInsets.only(
                            left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
                        child: Row(
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
                                height: 44.0,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1.0,
                                      color: CustomColors.kPCardColor),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: TextFormField(
                                  textDirection: TextDirection.ltr,
                                  onChanged: (value) {
                                    setState(() {
                                      phone = '$countryCode$value';
                                    });
                                  },
                                  maxLengthEnforced: true,
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: <TextInputFormatter>[
                                    WhitelistingTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(9),
                                  ],
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: AppLocalization.of(context)
                                        .translate("phone_in_login"),
                                    hintStyle: TextStyle(
                                      fontSize: 14.0,
                                      color: CustomColors.kTabBarIconColor,
                                    ),
                                    contentPadding: const EdgeInsets.only(
                                        top: 15.0, left: 10.0, right: 10.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 10.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(1, 2),
                                    blurRadius: 50.0,
                                    color: Colors.grey.withOpacity(0.3))
                              ]),
                          child: ListTile(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (ctx) => ResetPasswordScreen()));
                            },
                            title: Text(
                              AppLocalization.of(context).translate(
                                  "change_password_in_account_setting_page"),
                            ),
                            trailing: Icon(Icons.arrow_forward),
                          )),
                    ],
                  )),
            ),
            bottomNavigationBar: Container(
              margin:
                  const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: CustomColors.kTabBarIconColor,
              ),
              child: FlatButton(
                onPressed: _isBtnLoading ||
                        (newEmail == '' && newName == '' && phone == '')
                    ? null
                    : () {
                        _doUpdateProfile();
                      },
                child: _isBtnLoading
                    ? AdaptiveProgressIndicator()
                    : Text(
                        AppLocalization.of(context).translate("save_btn"),
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          );
  }
}
