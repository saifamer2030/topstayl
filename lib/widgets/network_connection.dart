import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:topstyle/constants/colors.dart';
import 'package:topstyle/helper/appLocalization.dart';

class ConnectionScreen extends StatelessWidget {
  final Function action;

  ConnectionScreen(this.action);

  _checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      () => action;
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              width: 90.0,
              height: 100.0,
              child: Image.asset('assets/images/antenna.png'),
            ),
            SizedBox(
              height: 50.0,
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                AppLocalization.of(context).translate("no_internet_connection"),
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                  AppLocalization.of(context)
                      .translate("show_connection_error"),
                  style: TextStyle(fontSize: 16.0)),
            ),
            SizedBox(
              height: 50.0,
            ),
            Container(
              height: 44.0,
              margin: const EdgeInsets.only(top: 20.0, bottom: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: CustomColors.kTabBarIconColor,
              ),
              child: RaisedButton(
                color: CustomColors.kTabBarIconColor,
                onPressed: () {
                  _checkInternetConnection();
                },
                child: Text(
                  AppLocalization.of(context).translate("retry"),
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
        ),
      ),
    );
  }
}

class ConnectionPopup {
  final String msg;

  ConnectionPopup(this.msg);

  static showAlert(String msg, BuildContext context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) =>
            Theme.of(context).platform == TargetPlatform.android
                ? AlertDialog(
                    content: Container(
                      height: 250.0,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 20.0),
                      child: Column(
                        children: <Widget>[
                          Expanded(
                              child: Text(
                            msg,
                            style: TextStyle(fontSize: 16.0),
                          )),
                          Container(
                            width: 88.0,
                            height: 100.0,
                            child: Image.asset('assets/images/antenna.png'),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 12.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7.0),
                                  border: Border.all(
                                      width: 2.0,
                                      color: Theme.of(context).accentColor)),
                              child: Center(
                                child: Text(
                                  'Ok',
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : CupertinoAlertDialog(
                    content: Text(msg),
                    actions: <Widget>[
                      FlatButton(
                        child: Text(
                          'Ok',
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  ));
  }
}
