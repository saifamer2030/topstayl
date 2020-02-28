import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:topstyle/constants/colors.dart';
import 'package:topstyle/helper/size_config.dart';
import 'package:topstyle/providers/network_provider.dart';
import 'package:topstyle/widgets/adaptive_progress_indecator.dart';
import 'package:topstyle/widgets/connectivity_widget.dart';

import '../helper/appLocalization.dart';
import '../helper/location_helper.dart';
import '../models/place.dart';

class AddressFromMap extends StatefulWidget {
  @override
  _AddressFromMapState createState() => _AddressFromMapState();
}

class _AddressFromMapState extends State<AddressFromMap> {
  String address;
  GoogleMapController _controller;
  bool _isLoading = true;

  LocationData currentLocation;
  Location location = Location();
  double lat;
  double long;
  @override
  void initState() {
    initLocation();
    super.initState();
  }

  initLocation() async {
    try {
      currentLocation = await location.getLocation();
      setState(() {
        lat = currentLocation.latitude;
        long = currentLocation.longitude;
        _isLoading = false;
      });
      readableAddress = await LocationHelper.getPlaceLocation(
          currentLocation.latitude, currentLocation.longitude);
    } catch (error) {
      print(error.toString());
    }
  }

  String countryId;
  Map<String, String> realAddress = {};
  List<String> _supported = ['SA', 'KW', 'AE'];

  List<AddressFromGoogleMap> readableAddress = [];

  getAddressDataWhenChange(double lt, double lng) async {
    await LocationHelper.getPlaceLocation(lt, lng).then((newAddress) {
      if (newAddress.length > 0) {
        realAddress.clear();
        readableAddress.clear();
        readableAddress = newAddress;
      }
    });
  }

  String _currentAddress;

  _getAddressFromLatLng(double lt, double lg) async {
    try {
      List<Placemark> p = await Geolocator().placemarkFromCoordinates(lt, lg);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  ScreenConfig screenConfig;
  WidgetSize widgetSize;

  @override
  Widget build(BuildContext context) {
    screenConfig = ScreenConfig(context);
    widgetSize = WidgetSize(screenConfig);
    return _isLoading
        ? Provider<NetworkProvider>.value(
            value: NetworkProvider(),
            child: Consumer<NetworkProvider>(
              builder: (context, value, _) => Center(
                  child: ConnectivityWidget(
                networkProvider: value,
                child: Scaffold(
                    appBar: AppBar(
                      centerTitle: true,
                      title: Text(
                        AppLocalization.of(context)
                            .translate('delivery_location'),
                        style: TextStyle(fontSize: widgetSize.mainTitle),
                      ),
                    ),
                    body: Center(
                      child: AdaptiveProgressIndicator(),
                    )),
              )),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                AppLocalization.of(context).translate('delivery_location'),
                style: TextStyle(fontSize: widgetSize.mainTitle),
              ),
            ),
            body: Stack(
              children: <Widget>[
                GoogleMap(
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  mapType: MapType.normal,
                  onMapCreated: (GoogleMapController controller) {
                    _controller = controller;
                  },
                  initialCameraPosition:
                      CameraPosition(target: LatLng(lat, long), zoom: 16),
                  markers: {
                    Marker(
                      draggable: true,
                      markerId: MarkerId('loc1'),
                      position: LatLng(lat, long),
                      infoWindow: InfoWindow(
                          title: 'موقعك الحالي',
                          snippet:
                              '${_currentAddress == null ? '' : _currentAddress}'),
                      icon: BitmapDescriptor.defaultMarker,
                    ),
                  },
                  onTap: (LatLng myNewLocation) {
                    setState(() {
                      lat = myNewLocation.latitude;
                      long = myNewLocation.longitude;
                      getAddressDataWhenChange(lat, long);
                    });
                  },
                ),
                Positioned(
                  bottom: 20.0,
                  child: FloatingActionButton(
                    child: Icon(
                      Icons.my_location,
                      size: 30.0,
                    ),
                    onPressed: () async {
                      getAddressDataWhenChange(
                          currentLocation.latitude, currentLocation.longitude);
                      _controller.moveCamera(CameraUpdate.newCameraPosition(
                          CameraPosition(
                              target: LatLng(currentLocation.latitude,
                                  currentLocation.longitude),
                              zoom: 16)));
                      setState(() {
                        lat = currentLocation.latitude;
                        long = currentLocation.longitude;
                      });
                    },
                  ),
                ),
                Positioned(
                  left: 8.0,
                  right: Platform.isIOS ? 8.0 : 15.0,
                  top: 12.0,
                  child: Container(
                    height: 50.0,
                    margin: Platform.isIOS
                        ? const EdgeInsets.all(5.0)
                        : const EdgeInsets.only(right: 39.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            width: 1.0, color: CustomColors.kPCardColor),
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Center(
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: AppLocalization.of(context)
                              .translate('address_search_hint'),
                          hintStyle: TextStyle(
                            fontSize: widgetSize.content,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              right: 15.0, left: 15.0, top: 15.0),
                          suffixIcon: IconButton(
                              icon: Icon(
                                Icons.search,
                                color: Theme.of(context).accentColor,
                              ),
                              onPressed: doSearch),
                        ),
                        onChanged: (val) {
                          setState(() {
                            address = val;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            bottomNavigationBar: Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 16.0),
              height: MediaQuery.of(context).size.height / 16,
              child: RaisedButton(
                  padding: const EdgeInsets.all(8.0),
                  onPressed: readableAddress.length > 0
                      ? () {
                          for (int i = 0; i < readableAddress.length; i++) {
                            realAddress.putIfAbsent(readableAddress[i].type[0],
                                () => readableAddress[i].shortName);
                          }
                          countryId =
                              '${_supported.indexOf(realAddress['country']) + 1}';
//                          print(realAddress['administrative_area_level_1']);
                          if (_supported.contains(realAddress['country'])) {
                            // GO BACK TO FROM ADDRESS SCREEN
                            Map<String, String> locationData = {};
                            locationData['countryId'] = countryId;
                            locationData['country'] = realAddress['country'];
                            locationData['city'] = realAddress[
                                        'administrative_area_level_2'] !=
                                    null
                                ? realAddress['administrative_area_level_2']
                                : realAddress['administrative_area_level_1'];
                            locationData['area'] = realAddress['political'];
                            locationData['street'] = realAddress['route'];
                            locationData['gps'] = '$lat,$long';
                            Navigator.of(context).pop(locationData);
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Center(
                                          child: Text(
                                              AppLocalization.of(context)
                                                  .translate('attention'))),
                                      content: Text(AppLocalization.of(context)
                                          .translate(
                                              'your_country_not_supported')),
                                      actions: <Widget>[
                                        Center(
                                          child: FlatButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Ok'),
                                          ),
                                        )
                                      ],
                                    ));
                          }
                        }
                      : null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  ),
                  color: Theme.of(context).accentColor,
                  child: Text(
                    AppLocalization.of(context).translate('confirm_location'),
                    style: TextStyle(
                        color: Colors.white, fontSize: widgetSize.content),
                  )),
            ));
  }

  doSearch() {
    Geolocator().placemarkFromAddress(address).then((result) {
      setState(() {
        readableAddress.clear();
        realAddress.clear();
      });
      _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target:
              LatLng(result[0].position.latitude, result[0].position.longitude),
          zoom: 16.0)));
      _getAddressFromLatLng(
          result[0].position.latitude, result[0].position.longitude);
    });
  }
}
