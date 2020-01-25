import 'package:connectivity/connectivity.dart';

class NetworkConnection {
  static isInternetConnected() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
      print('connected to mobile network');
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      print('connected to wifi network');
    } else {
      print('there are no network connection');
    }
  }
}
