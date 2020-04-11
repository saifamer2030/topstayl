import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:topstyle/constants/colors.dart';
import 'package:topstyle/helper/appLocalization.dart';
import 'package:topstyle/helper/size_config.dart';
import 'package:topstyle/models/city.dart';
import 'package:topstyle/providers/network_provider.dart';
import 'package:topstyle/providers/order_provider.dart';
import 'package:topstyle/providers/user_provider.dart';
import 'package:topstyle/screens/address_from_map.dart';
import 'package:topstyle/screens/otp_screen_in_address.dart';
import 'package:topstyle/widgets/adaptive_progress_indecator.dart';
import 'package:topstyle/widgets/connectivity_widget.dart';

class AddressScreen extends StatefulWidget {
  final TabController tabController;

  AddressScreen(this.tabController);

  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  Map<String, String> _stringVar = {
    'selectedCountry': null,
    'selectedCity': null,
    'countryId': null,
    'image': 'assets/icons/ksa_flag.png',
    'gps': '',
    'phone': '',
    'countryCode': '+966',
    'name': '',
    'note': ''
  };
  bool _isCitesFetched = false;
  bool _isLoading = false;
  List<CityModel> cites = [];
  var addressArea = TextEditingController();
  var addressStreet = TextEditingController();
  var secondCode = FocusNode();
  var thirdCode = FocusNode();
  var fourCode = FocusNode();

  UserProvider _userProvider = UserProvider();

  _getAllCites(String countryId) async {
    var token = await _userProvider.isAuthenticated();
    setState(() {
      _isCitesFetched = false;
      _isLoading = true;
    });
    cites = await Provider.of<OrdersProvider>(context, listen: false)
        .allCites(countryId, token['Authorization']);
    setState(() {
      _isCitesFetched = true;
      _isLoading = false;
    });
  }

  Widget _buildCitesItem() {
    return ListView.builder(
      itemCount: cites.length,
      shrinkWrap: true,
      itemBuilder: (context, i) => Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(width: 1.0, color: CustomColors.kPCardColor),
          ),
          child: ListTile(
            onTap: () {
              setState(() {
                _stringVar['selectedCity'] = cites[i].cityNameEn;
              });
              addressArea.text = '';
              addressStreet.text = '';
              Navigator.of(context).pop();
            },
            title: Text('${cites[i].cityNameAr}-${cites[i].cityNameEn}'),
          ),
        ),
      ),
    );
  }

  _confirmPhoneNumber() async {
    setState(() {
      _isLoading = true;
    });
    Provider.of<UserProvider>(context, listen: false)
        .otpByPhone(_stringVar['phone'], '0')
        .then((msg) {
      setState(() {
        _isLoading = false;
      });
      if (msg['msg'] == 2) {
        print(msg['otp']);
        Navigator.of(context).pushNamed(CustomOtpScreen.routeName, arguments: {
          'country': _stringVar['countryId'],
          'city': _stringVar['selectedCity'],
          'name': _stringVar['name'],
          'phone': _stringVar['phone'],
          'area': addressArea.text,
          'street': addressStreet.text,
          'note': _stringVar['note'],
          'gps': _stringVar['gps'],
          'otp': msg['otp']
        });
      } else {
//        print('--------11--${msg['msg']}------------');
        Scaffold.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            AppLocalization.of(context).translate("try_again_later"),
            textAlign: TextAlign.center,
            style:
                TextStyle(fontSize: widgetSize.content2, fontFamily: 'tajawal'),
          ),
        ));
      }
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
                  color: Colors.transparent,
                  child: Container(
                      color: Colors.transparent,
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
                                  _stringVar['image'] =
                                      'assets/icons/ksa_flag.png';
                                  _stringVar['countryCode'] = '+966';
                                });
                                Navigator.of(context).pop();
                              },
                              title: Text(
                                AppLocalization.of(context).translate("ksa"),
                                style: TextStyle(
                                    fontSize: widgetSize.textFieldError),
                              ),
                              leading: Image.asset(
                                'assets/icons/ksa_flag.png',
                                width: 35.0,
                                height: 25.0,
                                fit: BoxFit.cover,
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
                                  _stringVar['image'] =
                                      'assets/icons/uae_flag.png';
                                  _stringVar['countryCode'] = '+971';
                                });
                                Navigator.of(context).pop();
                              },
                              leading: Image.asset(
                                'assets/icons/uae_flag.png',
                                width: 35.0,
                                height: 25.0,
                                fit: BoxFit.cover,
                              ),
                              title: Text(
                                AppLocalization.of(context).translate("uae"),
                                style: TextStyle(
                                    fontSize: widgetSize.textFieldError),
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
                                  _stringVar['image'] =
                                      'assets/icons/kw_flag.png';
                                  _stringVar['countryCode'] = '+965';
                                });
                                Navigator.of(context).pop();
                              },
                              leading: Image.asset(
                                'assets/icons/kw_flag.png',
                                width: 35.0,
                                height: 25.0,
                                fit: BoxFit.cover,
                              ),
                              title: Text(
                                AppLocalization.of(context).translate("kw"),
                                style: TextStyle(
                                    fontSize: widgetSize.textFieldError),
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
                            _stringVar['image'] = 'assets/icons/ksa_flag.png';
                            _stringVar['countryCode'] = '+966';
                          });
                          Navigator.of(context).pop();
                        },
                        title: Text(
                          AppLocalization.of(context).translate("ksa"),
                          style: TextStyle(fontSize: widgetSize.textFieldError),
                        ),
                        leading: Image.asset(
                          'assets/icons/ksa_flag.png',
                          width: 35.0,
                          height: 25.0,
                          fit: BoxFit.cover,
                        ),
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
                            _stringVar['image'] = 'assets/icons/uae_flag.png';
                            _stringVar['countryCode'] = '+971';
                          });
                          Navigator.of(context).pop();
                        },
                        leading: Image.asset(
                          'assets/icons/uae_flag.png',
                          width: 35.0,
                          height: 25.0,
                          fit: BoxFit.cover,
                        ),
                        title: Text(
                          AppLocalization.of(context).translate("uae"),
                          style: TextStyle(fontSize: widgetSize.textFieldError),
                        ),
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
                            _stringVar['image'] = 'assets/icons/kw_flag.png';
                            _stringVar['countryCode'] = '+965';
                          });
                          Navigator.of(context).pop();
                        },
                        leading: Image.asset(
                          'assets/icons/kw_flag.png',
                          width: 35.0,
                          height: 25.0,
                          fit: BoxFit.cover,
                        ),
                        title: Text(
                          AppLocalization.of(context).translate("kw"),
                          style: TextStyle(fontSize: widgetSize.textFieldError),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  _drawCountryItem(String countryName, String countryId) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(width: 1.0, color: CustomColors.kPCardColor),
      ),
      child: ListTile(
        onTap: () {
          setState(() {
            _stringVar['selectedCountry'] = countryName;
            _stringVar['selectedCity'] = null;
            cites = [];
            _isCitesFetched = false;
            _stringVar['countryId'] = countryId;
            addressArea.text = '';
            addressStreet.text = '';
            _stringVar['note'] = '';
          });
          _getAllCites(countryId);
          Navigator.of(context).pop();
        },
        title: Text(countryName),
      ),
    );
  }

  ScreenConfig screenConfig;
  WidgetSize widgetSize;
  @override
  void dispose() {
    addressArea.dispose();
    addressStreet.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenConfig = ScreenConfig(context);
    widgetSize = WidgetSize(screenConfig);
    return SingleChildScrollView(
      child: Provider<NetworkProvider>.value(
        value: NetworkProvider(),
        child: Consumer<NetworkProvider>(
          builder: (context, value, _) => Center(
              child: ConnectivityWidget(
            networkProvider: value,
            child: Container(
              child: Column(
                children: <Widget>[
                  ListTile(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (context) => AddressFromMap(),
                              fullscreenDialog: true))
                          .then((dataFromMap) {
                        if (dataFromMap != {} && dataFromMap != null) {
                          setState(() {
                            _stringVar['selectedCountry'] =
                                AppLocalization.of(context).translate(
                                    dataFromMap['countryId'] == '1'
                                        ? "ksa"
                                        : dataFromMap['countryId'] == '2'
                                            ? 'kw'
                                            : dataFromMap['countryId'] == '3'
                                                ? 'uae'
                                                : "ksa");
                            _stringVar['countryId'] = dataFromMap['countryId'];
                            _getAllCites(_stringVar['countryId']);
                            _stringVar['selectedCity'] = dataFromMap['city'];
                            addressArea.text = dataFromMap['area'];
                            addressStreet.text = dataFromMap['street'];
                            _stringVar['gps'] = dataFromMap['gps'];
                          });
                        }
                      });
                    },
                    leading: Icon(
                      CupertinoIcons.location_solid,
                      size: widgetSize.favoriteIconSize,
                      color: CustomColors.kTabBarIconColor,
                    ),
                    title: Text(
                      AppLocalization.of(context)
                          .translate('choose_location_from_map'),
                      style: TextStyle(fontSize: widgetSize.content2),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: widgetSize.content,
                    ),
                  ),
                  Divider(
                    thickness: 0.7,
                    height: 2.0,
                    color: CustomColors.kPCardColor,
                  ),
                  Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(
                              left: 16.0, right: 16.0, top: 20.0, bottom: 8.0),
                          child: Text(
                            AppLocalization.of(context)
                                .translate('address_details_hint'),
                            style: TextStyle(
                                fontSize: widgetSize.subTitle,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          height: 50.0,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 5.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 1.0, color: CustomColors.kPCardColor),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            child: TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  _stringVar['name'] = value;
                                });
                              },
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.only(
                                    left: 8.0,
                                    right: 8.0,
                                  ),
                                  hintText: AppLocalization.of(context)
                                      .translate("userName"),
                                  hintStyle: TextStyle(
                                      color: CustomColors.kTabBarIconColor,
                                      fontSize: widgetSize.subTitle)),
                            ),
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
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5.0),
                                        child: Image.asset(
                                          _stringVar['image'] == null
                                              ? 'assets/icons/ksa_flag.png'
                                              : _stringVar['image'],
                                          width: 25.0,
                                          height: 15.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      Text(
                                        _stringVar['countryCode'] == null
                                            ? '+966'
                                            : _stringVar['countryCode'],
                                        style: TextStyle(
                                            fontSize: widgetSize.content),
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
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: TextFormField(
                                      textDirection: TextDirection.ltr,
                                      onChanged: (value) {
                                        setState(() {
                                          _stringVar['phone'] =
                                              '${_stringVar['countryCode']}$value';
                                        });
                                      },
                                      keyboardType: TextInputType.phone,
                                      inputFormatters: <TextInputFormatter>[
                                        WhitelistingTextInputFormatter
                                            .digitsOnly,
                                        LengthLimitingTextInputFormatter(9),
                                      ],
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: AppLocalization.of(context)
                                            .translate('enter_phone'),
                                        hintStyle: TextStyle(
                                          color: CustomColors.kTabBarIconColor,
                                        ),
                                        contentPadding: const EdgeInsets.only(
                                            left: 10.0,
                                            right: 10.0,
                                            bottom: 4.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 50.0,
                          margin: const EdgeInsets.only(
                              left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 1.0, color: CustomColors.kPCardColor),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: ListTile(
                            onTap: _isLoading
                                ? null
                                : () {
                                    showModalBottomSheet(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(8.0),
                                                topLeft: Radius.circular(8.0))),
                                        context: context,
                                        builder: (context) =>
                                            SingleChildScrollView(
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0,
                                                        vertical: 16.0),
                                                child: Column(
                                                  children: <Widget>[
                                                    _drawCountryItem(
                                                        AppLocalization.of(
                                                                context)
                                                            .translate("ksa"),
                                                        '1'),
                                                    SizedBox(
                                                      height: 16.0,
                                                    ),
                                                    _drawCountryItem(
                                                        AppLocalization.of(
                                                                context)
                                                            .translate("kw"),
                                                        '2'),
                                                    SizedBox(
                                                      height: 16.0,
                                                    ),
                                                    _drawCountryItem(
                                                        AppLocalization.of(
                                                                context)
                                                            .translate("uae"),
                                                        '3')
                                                  ],
                                                ),
                                              ),
                                            ));
                                  },
                            title: Text(
                              _stringVar['selectedCountry'] != null
                                  ? _stringVar['selectedCountry']
                                  : AppLocalization.of(context)
                                      .translate('country_hint'),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            trailing: Icon(Icons.keyboard_arrow_down),
                          ),
                        ),
                        Container(
                          height: 50.0,
                          margin: const EdgeInsets.only(
                              left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 1.0, color: CustomColors.kPCardColor),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: ListTile(
                            onTap: _isCitesFetched
                                ? () {
                                    showModalBottomSheet(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(8.0),
                                                topLeft: Radius.circular(8.0))),
                                        context: context,
                                        builder: (context) => Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16.0,
                                                      vertical: 8.0),
                                              child: _buildCitesItem(),
                                            ));
                                  }
                                : null,
                            title: Text(
                              _stringVar['selectedCity'] != null
                                  ? _stringVar['selectedCity']
                                  : AppLocalization.of(context)
                                      .translate('city_hint'),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            trailing: Icon(Icons.keyboard_arrow_down),
                          ),
                        ),
                        Container(
                          height: 50.0,
                          margin: const EdgeInsets.only(
                              left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 1.0, color: CustomColors.kPCardColor),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            child: TextFormField(
                              controller: addressArea,
                              onChanged: (value) {
                                setState(() {
                                  addressArea.text = value;
                                });
                              },
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0),
                                  hintText: AppLocalization.of(context)
                                      .translate("neighborhood_hint"),
                                  hintStyle: TextStyle(
                                      color: CustomColors.kTabBarIconColor)),
//
                            ),
                          ),
                        ),
                        Container(
                          height: 50.0,
                          margin: const EdgeInsets.only(
                              left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 1.0, color: CustomColors.kPCardColor),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            child: TextFormField(
                              controller: addressStreet,
                              onChanged: (value) {
                                setState(() {
                                  addressStreet.text = value;
                                });
                              },
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0),
                                  hintText: AppLocalization.of(context)
                                      .translate("street_hint"),
                                  hintStyle: TextStyle(
                                      color: CustomColors.kTabBarIconColor)),
//
                            ),
                          ),
                        ),
                        Container(
                          height: 100.0,
                          margin: const EdgeInsets.only(
                              left: 16.0, right: 16.0, top: 8.0, bottom: 32.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              width: 1.0,
                              color: CustomColors.kPCardColor,
                            ),
                          ),
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {
                                _stringVar['note'] = value;
                              });
                            },
                            keyboardType: TextInputType.multiline,
                            maxLines: 3,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0, top: 8.0),
                                hintText: AppLocalization.of(context)
                                    .translate('note_hint'),
                                hintStyle: TextStyle(
                                    color: CustomColors.kTabBarIconColor)),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 16.0, right: 16.0, bottom: 20.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: _stringVar['selectedCountry'] != null &&
                                    _stringVar['selectedCity'] != null &&
                                    addressArea != null &&
                                    addressArea.text != '' &&
                                    _stringVar['phone'] != null &&
                                    _stringVar['phone'].length > 11
                                ? Theme.of(context).accentColor
                                : Colors.grey,
                          ),
                          child: FlatButton(
                            onPressed: _stringVar['selectedCountry'] != null &&
                                    _stringVar['selectedCity'] != null &&
                                    _stringVar['phone'] != null &&
                                    _stringVar['phone'].length > 11 &&
                                    addressArea != null &&
                                    addressArea.text != ''
                                ? () {
                                    _confirmPhoneNumber();
                                  }
                                : null,
                            child: _isLoading
                                ? AdaptiveProgressIndicator()
                                : Text(
                                    AppLocalization.of(context)
                                        .translate("save_location"),
                                    style: TextStyle(
                                        fontSize: widgetSize.mainTitle,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
        ),
      ),
    );
  }
}
