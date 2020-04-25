import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:topstyle/helper/api_util.dart';

import '../models/place.dart';

class LocationHelper {
  static String generateLocationPerViewImage(
      {double latitude, double longitude}) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$latitude,$longitude&key=${ApiUtil.GOOGLE_API_KEY}';
  }

  static Map<String, String> realAddress = {};

//  static List<String> addressDetails;
  static Future<List<AddressFromGoogleMap>> getPlaceLocation(
      double lat, double lng) async {
    AddressComponents addressData;
    try {
      String url =
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng'
          '&key=${ApiUtil.GOOGLE_API_KEY}';
      final response = await http.get(url);
      switch (json.decode(response.body)['status']) {
        case "OK":
          addressData = AddressComponents(
              addressComponent: AddressComponents.listAddressComponent(json
                  .decode(response.body)['results'][0]['address_components']));
//          for (int i = 0; i < allAddressComponent.length; i++) {
//            realAddress.(allAddressComponent[i]['types'][0],
//                (v) => allAddressComponent[i]['long_name']);
//            realAddress.putIfAbsent(allAddressComponent[i]['types'][0],
//                () => allAddressComponent[i]['long_name']);
//          }

          break;
        case "ZERO_RESULTS":
          realAddress = {"errorMessage": "Sorry your place not found in map"};
          print(json.decode(response.body)['status']);
          break;
        case "INVALID_REQUEST":
          realAddress = {"errorMessage": "Please Try again"};
          print(json.decode(response.body)['status']);
          break;
        case "REQUEST_DENIED":
        case "INVALID_REQUEST":
        case "UNKNOWN_ERROR":
          realAddress = {
            "errorMessage":
                "Google Map Services not Avilable Please Use manual form "
          };
          print(json.decode(response.body)['status']);
          break;
        case "OVER_DAILY_LIMIT":
        case "OVER_QUERY_LIMIT":
          realAddress = {
            "errorMessage":
                "Google Map Services not Avilable Please Use manual form "
          };
//        print(json.decode(response.body)['status']);
          // Send request to server to tell Team to check our google account
          break;
      }
    } catch (error) {
      print(error.toString());
      throw error;
    }

//    print(addressData.addressComponent.length);
    return addressData.addressComponent;
    /*
    INVALID_REQUEST problem in parameter lat lng
    REQUEST_DENIED problem in google api key
    OK success with data
    ZERO_RESULTS success but without data
    OVER_DAILY_LIMIT billing problem
    OVER_QUERY_LIMIT quota is finished
    INVALID_REQUEST => problem in request address lng lat missing
    UNKNOWN_ERROR => Some error occured during prosses the req  request may successd when try agin

     */
  }
}
