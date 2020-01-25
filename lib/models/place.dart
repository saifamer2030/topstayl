import 'package:flutter/foundation.dart';

class PlaceLocation {
  // delete it bcus associate with map_screen
  final double latitude;
  final double longitude;
  final String address;

  const PlaceLocation(
      {@required this.latitude,
      @required this.longitude,
      @required this.address});
}

class AddressFromGoogleMap {
  // model from google map response in map screen
  String longName;
  String shortName;
  List<String> type;

  AddressFromGoogleMap({this.longName, this.shortName, this.type});

  factory AddressFromGoogleMap.fromJson(parsedAddress) {
    return AddressFromGoogleMap(
        longName: parsedAddress['long_name'],
        shortName: parsedAddress['short_name'],
        type: AddressFromGoogleMap.parsedTypes(parsedAddress['types']));
  }

  static List<String> parsedTypes(parsedType) {
    var _listOfType = parsedType as List;
    return List<String>.from(_listOfType);
  }
}

class AddressComponents {
  List<AddressFromGoogleMap> addressComponent;

  AddressComponents({this.addressComponent});

  factory AddressComponents.fromJson(parsedAddressComponent) {
    return AddressComponents(
        addressComponent: AddressComponents.listAddressComponent(
            parsedAddressComponent['address_components']));
  }

  static List<AddressFromGoogleMap> listAddressComponent(listOfAddress) {
    var _listOfAddressComponent = listOfAddress as List;
    List<AddressFromGoogleMap> _allAddress = _listOfAddressComponent
        .map((address) => AddressFromGoogleMap.fromJson(address))
        .toList();
    return _allAddress;
  }
}
