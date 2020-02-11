import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:topstyle/constants/colors.dart';
import 'package:topstyle/helper/appLocalization.dart';
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
  String _selectedCountry;
  String _selectedCity;
  bool _isCitesFetched = false;
  bool _isLoading = false;
  String _gps;
  List<CityModel> cites = [];
  String _countryId;
  var _areaCtr = TextEditingController();
  var _streetCtr = TextEditingController();
  var _nameCtr = TextEditingController();
  var _noteCtr = TextEditingController();
  String _phone, countryCode = '+966';

  var secondCode = FocusNode();
  var thirdCode = FocusNode();
  var fourCode = FocusNode();

  UserProvider _userProvider = UserProvider();

  _getAllCites(int countryId) async {
    var token = await _userProvider.isAuthenticated();
    setState(() {
      _isCitesFetched = false;
    });
    cites = await Provider.of<OrdersProvider>(context)
        .allCites('$countryId', token['Authorization']);
//    print(cites.length);
    setState(() {
      _isCitesFetched = true;
    });
  }

  Widget _buildCitesItem() {
    return ListView.builder(
      itemCount: cites.length,
      itemBuilder: (context, i) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(width: 1.0, color: CustomColors.kPCardColor),
        ),
        child: ListTile(
          onTap: () {
            setState(() {
              _selectedCity = cites[i].cityNameEn;
            });
            _areaCtr.clear();
            _streetCtr.clear();
            Navigator.of(context).pop();
          },
          title: Text('${cites[i].cityNameAr}-${cites[i].cityNameEn}'),
        ),
      ),
      shrinkWrap: true,
    );
  }

  _confirmPhoneNumber() async {
    setState(() {
      _isLoading = true;
    });
    Provider.of<UserProvider>(context).otpByPhone(_phone, '0').then((msg) {
      setState(() {
        _isLoading = false;
      });
      if (msg['msg'] == 2) {
        print(msg['otp']);
        Navigator.of(context).pushNamed(CustomOtpScreen.routeName, arguments: {
          'country': _countryId,
          'city': _selectedCity,
          'name': _nameCtr.text,
          'phone': _phone,
          'area': _areaCtr.text,
          'street': _streetCtr.text,
          'note': _noteCtr.text,
          'gps': _gps,
          'otp': msg['otp']
        });
      } else {
//        print('--------11--${msg['msg']}------------');
        Scaffold.of(context).showSnackBar(SnackBar(
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

  String image;

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
  Widget build(BuildContext context) {
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
                        if (dataFromMap != {} &&
                            dataFromMap['countryId'] != null) {
                          setState(() {
                            _selectedCountry = AppLocalization.of(context)
                                .translate(dataFromMap['countryId'] == '1'
                                    ? "ksa"
                                    : dataFromMap['countryId'] == '2'
                                        ? 'kw'
                                        : dataFromMap['countryId'] == '3'
                                            ? 'uae'
                                            : _selectedCountry = '');
                            _countryId = dataFromMap['countryId'];
                            _getAllCites(int.parse(_countryId));
                            _selectedCity = dataFromMap['city'];
                            _areaCtr.text = dataFromMap['area'];
                            _streetCtr.text = dataFromMap['street'];
                            _gps = dataFromMap['gps'];
                          });
                        }
                      });
                    },
                    leading: Icon(
                      CupertinoIcons.location,
                      size: 30,
                    ),
                    title: Text(AppLocalization.of(context)
                        .translate('choose_location_from_map')),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 18.0,
                    ),
                  ),
                  Divider(
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
                              left: 16.0, right: 16.0, top: 32.0, bottom: 8.0),
                          child: Text(
                            AppLocalization.of(context)
                                .translate('address_details_hint'),
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          height: 50.0,
                          margin: const EdgeInsets.all(
                            16.0,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 1.0, color: CustomColors.kPCardColor),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            child: TextFormField(
                              controller: _nameCtr,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0),
                                  hintText: AppLocalization.of(context)
                                      .translate("userName"),
                                  hintStyle: TextStyle(
                                      color: CustomColors.kTabBarIconColor)),
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
                                        _phone = '$countryCode$value';
                                      });
                                    },
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
                                          left: 10.0, right: 10.0),
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
                            onTap: () async {
                              showModalBottomSheet(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(8.0),
                                          topLeft: Radius.circular(8.0))),
                                  context: context,
                                  builder: (context) => SingleChildScrollView(
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 16.0, vertical: 16.0),
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  border: Border.all(
                                                      width: 1.0,
                                                      color: CustomColors
                                                          .kPCardColor),
                                                ),
                                                child: ListTile(
                                                  onTap: () {
                                                    setState(() {
                                                      _selectedCountry =
                                                          AppLocalization.of(
                                                                  context)
                                                              .translate("ksa");
                                                      _selectedCity = null;
                                                      cites = [];
                                                      _isCitesFetched = false;
                                                      _countryId = '1';
                                                      _areaCtr.clear();
                                                      _streetCtr.clear();
                                                      _noteCtr.clear();
                                                    });
                                                    _getAllCites(1);
                                                    Navigator.of(context).pop();
                                                  },
                                                  title: Text(
                                                      AppLocalization.of(
                                                              context)
                                                          .translate("ksa")),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 16.0,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  border: Border.all(
                                                      width: 1.0,
                                                      color: CustomColors
                                                          .kPCardColor),
                                                ),
                                                child: ListTile(
                                                  onTap: () {
                                                    setState(() {
                                                      _selectedCountry =
                                                          AppLocalization.of(
                                                                  context)
                                                              .translate("kw");
                                                      _selectedCity = null;
                                                      cites = [];
                                                      _isCitesFetched = false;
                                                      _countryId = '2';
                                                      _areaCtr.clear();
                                                      _streetCtr.clear();
                                                      _noteCtr.clear();
                                                    });
                                                    _getAllCites(2);
                                                    Navigator.of(context).pop();
                                                  },
                                                  title: Text(
                                                      AppLocalization.of(
                                                              context)
                                                          .translate("kw")),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 16.0,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  border: Border.all(
                                                      width: 1.0,
                                                      color: CustomColors
                                                          .kPCardColor),
                                                ),
                                                child: ListTile(
                                                  onTap: () {
                                                    setState(() {
                                                      _selectedCountry =
                                                          AppLocalization.of(
                                                                  context)
                                                              .translate("uae");
                                                      _selectedCity = null;
                                                      cites = [];
                                                      _isCitesFetched = false;
                                                      _countryId = '3';
                                                      _areaCtr.clear();
                                                      _streetCtr.clear();
                                                      _noteCtr.clear();
                                                    });
                                                    _getAllCites(3);
                                                    Navigator.of(context).pop();
                                                  },
                                                  title: Text(
                                                      AppLocalization.of(
                                                              context)
                                                          .translate("uae")),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ));
                            },
                            title: Text(_selectedCountry != null
                                ? _selectedCountry
                                : AppLocalization.of(context)
                                    .translate('country_hint')),
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
                                ? () async {
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
                                                        vertical: 8.0),
                                                child:
                                                    Column(children: <Widget>[
                                                  _buildCitesItem(),
                                                ]),
                                              ),
                                            ));
                                  }
                                : null,
                            title: Text(_selectedCity != null
                                ? _selectedCity
                                : AppLocalization.of(context)
                                    .translate('city_hint')),
                            trailing: Icon(Icons.keyboard_arrow_down),
                          ),
                        ),
//                  Container(
//                    height: 50.0,
//                    margin: const EdgeInsets.only(
//                        left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
//                    decoration: BoxDecoration(
//                      border: Border.all(
//                          width: 1.0, color: CustomColors.kPCardColor),
//                      borderRadius: BorderRadius.circular(8.0),
//                    ),
//                    child: Center(
//                      child: TextFormField(
//                        controller: _areaCtr,
//                        onChanged: (val) {
//                          setState(() {
//                            _areaCtr.text = val;
//                          });
//                        },
//                        decoration: InputDecoration(
//                            border: InputBorder.none,
//                            contentPadding:
//                                const EdgeInsets.only(left: 8.0, right: 8.0),
//                            hintText: AppLocalization.of(context)
//                                .translate("neighborhood_hint"),
//                            hintStyle: TextStyle(
//                                color: CustomColors.kTabBarIconColor)),
////
//                      ),
//                    ),
//                  ),
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
                              controller: _areaCtr,
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
                              controller: _streetCtr,
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
                            controller: _noteCtr,
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
                            color: _selectedCountry != null &&
                                    _selectedCity != null &&
                                    _areaCtr.text.length > 1 &&
                                    _phone != null &&
                                    _phone.length > 12
                                ? Theme.of(context).accentColor
                                : Colors.grey,
                          ),
                          child: FlatButton(
                            onPressed: _selectedCountry != null &&
                                    _selectedCity != null &&
                                    _phone != null &&
                                    _phone.length > 12 &&
                                    _areaCtr.text.length > 1
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
