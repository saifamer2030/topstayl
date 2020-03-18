import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topstyle/helper/appLocalization.dart';
import 'package:topstyle/providers/network_provider.dart';

class ConnectivityWidget extends StatefulWidget {
  final NetworkProvider networkProvider;
  final Widget child;

  ConnectivityWidget({this.networkProvider, this.child});

  @override
  _ConnectivityWidgetState createState() => _ConnectivityWidgetState();
}

class _ConnectivityWidgetState extends State<ConnectivityWidget> {
  @override
  void dispose() {
    widget.networkProvider.disposeStreams();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<ConnectivityResult>.value(
      value: widget.networkProvider.networkConnectionStatus.stream,
      child: Consumer<ConnectivityResult>(
        builder: (context, value, _) {
          if (value == null) {
            return Container();
          }
          return value != ConnectivityResult.none
              ? widget.child
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                      Container(
                        width: 50.0,
                        height: 70.0,
                        child: Image.asset(
                          'assets/images/antenna.png',
                          fit: BoxFit.contain,
                          width: 88.0,
                          height: 100.0,
                        ),
                      ),
                      SizedBox(
                        height: 50.0,
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          AppLocalization.of(context)
                              .translate("no_internet_connection"),
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
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
                    ]);
        },
      ),
    );
  }
}
