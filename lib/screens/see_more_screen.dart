import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topstyle/constants/colors.dart';
import 'package:topstyle/helper/appLocalization.dart';
import 'package:topstyle/models/products_model.dart';
import 'package:topstyle/providers/languages_provider.dart';
import 'package:topstyle/providers/network_provider.dart';
import 'package:topstyle/providers/products_provider.dart';
import 'package:topstyle/providers/user_provider.dart';
import 'package:topstyle/screens/search_screen.dart';
import 'package:topstyle/widgets/adaptive_progress_indecator.dart';
import 'package:topstyle/widgets/connectivity_widget.dart';
import 'package:topstyle/widgets/product_item.dart';

class SeeMoreScreen extends StatefulWidget {
  final String categoryName;
  final String subCategoryName;

  SeeMoreScreen({this.categoryName, this.subCategoryName});

  @override
  _SeeMoreScreenState createState() => _SeeMoreScreenState();
}

class _SeeMoreScreenState extends State<SeeMoreScreen> {
  List<ProductsModel> _products = [];
  bool _isInti = true;
  bool _isLoading = false;
  bool _seeMoreLoading = false;
  bool _isFilteredData = false,
      _makeup = false,
      _perfume = false,
      _care = false,
      _nails = false,
      _lenses = false,
      _devices = false;

  bool _face = false,
      _lips = false,
      _eyes = false,
      _eyeBrow = false,
      _cheek = false,
      _highlighter = false,
      _brushes = false,
      _makeupBrushesTools = false;
  bool _foundation = false,
      _concealer = false,
      _powder = false,
      _faceBrimer = false,
      _makeupFixingSpray = false,
      _bbCcCream = false;
  bool _eyeMascara = false,
      _eyeShadow = false,
      _eyeLiner = false,
      _eyeBrimer = false,
      _eyeGlitter = false;
  bool _lipSet = false, _lipGloss = false, _lipStick = false, _lipLiner = false;
  bool _eyeBrowMascara = false, _eyeBrowGel = false, _eyeBrowPencil = false;
  bool _cheekContour = false, _cheekBlusher = false;
  bool _eyeBrushes = false,
      _faceBrushes = false,
      _eyeBrowBrushes = false,
      _brushesCleaners = false,
      _makeupRemover = false;
  bool _womenPerfume = false,
      _unisexPerfume = false,
      _menPerfume = false,
      _hairMist = false,
      _nichePerfume = false;
  bool _careTool = false,
      _careLip = false,
      _careHand = false,
      _careFace = false,
      _careHair = false,
      _careBody = false;
  bool _nailPolish = false,
      _nailPolishRemover = false,
      _nailTool = false,
      _nailCare = false;
  bool _pureness = false,
      _bella = false,
      _diva = false,
      _beauteous = false,
      _lensme = false,
      _solutionForLenses = false;
  bool _hairDevice = false, _bodyDevice = false, _faceDevice = false;

  AppLanguageProvider appLanguage = AppLanguageProvider();
  UserProvider userProvider = UserProvider();
  int pageNumber = 1;
  int pageNumberOrdered = 1;
  int lastPage = 0;
  int lastPageFiltered = 0;
  bool loaded = false;
  bool _sortByLow = false,
      _sortByHigh = false,
      _sortByNew = false,
      _sortByToRated = false;
  ScrollController _controller = ScrollController();

  List<String> filterBody = [];
  String _isFrom = '';
  String order = 'asc';

  void _populateFilterBody(String s, bool val) {
    if (val) {
      filterBody.add(s);
      print('length : ${filterBody.length}');
    } else {
      int index = filterBody.indexOf(s);
      filterBody.removeAt(index);
      print('length after remove${filterBody.length}');
    }
  }

  _doFilterWithMultiCategory(int pageNumber) async {
    final String myLang = appLanguage.appLocal.toString();
    var user = await userProvider.isAuthenticated();
    setState(() {
      _seeMoreLoading = true;
    });
    String filterContent = '';
    filterBody.forEach((f) => filterContent = '$filterContent,$f');
    print(filterBody.toString().substring(1, filterBody.toString().length - 1));
    print(filterContent);
    Provider.of<ProductsProvider>(context)
        .allDataInSeeMoreWithMultiFilter(filterContent, myLang, pageNumber,
            user['Authorization'] == 'none' ? 'none' : user['Authorization'])
        .then((data) {
      setState(() {
        loaded = false;
        _seeMoreLoading = false;
        _isLoading = false;
        if (_isFilteredData && pageNumberOrdered == 1) {
          _products.clear();
        }
        var list = data['data'] as List;
        _isFrom = 'filter';
        lastPageFiltered = data['last_page'];
        _products.addAll(List<ProductsModel>.from(list));
//        print('dataaaaa length : ${_products.length}');
      });
    });
  }

  _doFilter(int numberOfPage) async {
//    print(
//        'page number is $numberOfPage and last index is $lastPageFiltered and product length is ${_products.length}');
    final String lang = appLanguage.appLocal.toString();
    var userData = await userProvider.isAuthenticated();
    setState(() {
      _seeMoreLoading = true;
    });
    Provider.of<ProductsProvider>(context)
        .allDataInSeeMoreWithFilter(
            widget.categoryName,
            lang,
            numberOfPage,
            order,
            userData['Authorization'] == 'none'
                ? 'none'
                : userData['Authorization'])
        .then((products) {
      setState(() {
        loaded = false;
        _seeMoreLoading = false;
        if (_isFilteredData && pageNumberOrdered == 1) {
          _products.clear();
        }
        var list = products['data'] as List;
        _isFrom = 'sort';
        if (list.length > 0) {
          lastPageFiltered = products['last_page'];
          _products.addAll(List<ProductsModel>.from(list));
        }
      });
    });
  }

  _showSortDialog() async {
    return showModalBottomSheet(
//        isScrollControlled: false,
        backgroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10.0),
                topLeft: Radius.circular(10.0))),
        context: context,
        builder: (context) => StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 30.0,
                        height: 3.5,
                        margin: const EdgeInsets.only(top: 7.0),
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(3.0)),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, bottom: 10.0, top: 10.0),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, bottom: 7.0, top: 10.0),
                    child: Text(
                      AppLocalization.of(context).translate("sort"),
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _sortByLow = true;
                            _sortByHigh = false;
                            _sortByNew = false;
                            _sortByToRated = false;
                            pageNumberOrdered = 1;
                            //_products.clear();
                            _isFilteredData = true;
                            order = 'desc';
                          });

                          print('index :$pageNumberOrdered');
                          print('is filterd :$_isFilteredData');
                          _doFilter(pageNumberOrdered);
                          Navigator.of(context).pop();
                        },
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.arrow_downward,
                              size: 30.0,
                              color: _sortByLow
                                  ? Theme.of(context).accentColor
                                  : CustomColors.kTabBarIconColor,
                            ),
                            Text(
                              AppLocalization.of(context).translate("price"),
                              style: TextStyle(
                                fontSize: 12.0,
                                color: _sortByLow
                                    ? Theme.of(context).accentColor
                                    : CustomColors.kTabBarIconColor,
                              ),
                            ),
                            Text(
                              "(${AppLocalization.of(context).translate("highest_to_lowest")})",
                              style: TextStyle(
                                fontSize: 10.0,
                                color: _sortByLow
                                    ? Theme.of(context).accentColor
                                    : CustomColors.kTabBarIconColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _sortByLow = false;
                            _sortByHigh = true;
                            _sortByNew = false;
                            _sortByToRated = false;
                            pageNumberOrdered = 1;
                            //_products.clear();
                            _isFilteredData = true;
                            order = 'asc';
                          });

                          print('index :$pageNumberOrdered');
                          print('is filterd :$_isFilteredData');
                          _doFilter(pageNumberOrdered);
                          Navigator.of(context).pop();
//                             _checkInternetConnection();
                        },
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.arrow_upward,
                              size: 30.0,
                              color: _sortByHigh
                                  ? Theme.of(context).accentColor
                                  : CustomColors.kTabBarIconColor,
                            ),
                            Text(
                              AppLocalization.of(context).translate("price"),
                              style: TextStyle(
                                fontSize: 12.0,
                                color: _sortByHigh
                                    ? Theme.of(context).accentColor
                                    : CustomColors.kTabBarIconColor,
                              ),
                            ),
                            Text(
                              "(${AppLocalization.of(context).translate("lowest_to_highest")})",
                              style: TextStyle(
                                fontSize: 10.0,
                                color: _sortByHigh
                                    ? Theme.of(context).accentColor
                                    : CustomColors.kTabBarIconColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _sortByLow = false;
                            _sortByHigh = false;
                            _sortByNew = false;
                            _sortByToRated = true;
                            order = 'top';
                            Navigator.of(context).pop();
                          });
                        },
                        child: Column(
                          children: <Widget>[
                            Image.asset(
                              'assets/icons/top_rated.png',
                              width: 30.0,
                              height: 30.0,
                              fit: BoxFit.cover,
                              color: _sortByToRated
                                  ? Theme.of(context).accentColor
                                  : CustomColors.kTabBarIconColor,
                            ),
                            SizedBox(
                              height: 14.0,
                            ),
                            Text(
                              AppLocalization.of(context)
                                  .translate("popularity"),
                              style: TextStyle(
                                fontSize: 12.0,
                                color: _sortByToRated
                                    ? Theme.of(context).accentColor
                                    : CustomColors.kTabBarIconColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _sortByLow = false;
                            _sortByHigh = false;
                            _sortByNew = true;
                            _sortByToRated = false;
                            order = 'new';
                            Navigator.of(context).pop();
                          });
                        },
                        child: Column(
                          children: <Widget>[
                            Image.asset(
                              'assets/icons/most_recent.png',
                              width: 35.0,
                              height: 35.0,
                              fit: BoxFit.cover,
                              color: _sortByNew
                                  ? Theme.of(context).accentColor
                                  : CustomColors.kTabBarIconColor,
                            ),
                            SizedBox(
                              height: 14.0,
                            ),
                            Text(
                              AppLocalization.of(context)
                                  .translate("most_recent"),
                              style: TextStyle(
                                fontSize: 12.0,
                                color: _sortByNew
                                    ? Theme.of(context).accentColor
                                    : CustomColors.kTabBarIconColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  )
                ],
              );
            }));
  }

  _showFilterDialog() async {
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Theme.of(context).accentColor, width: 1.0),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0))),
        context: context,
        builder: (context) => StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.filter_list),
                                SizedBox(
                                  width: 7.0,
                                ),
                                Text(
                                  AppLocalization.of(context)
                                      .translate("filter"),
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            widget.categoryName == 'Makeup'
                                ? ListTile(
                                    selected: _makeup,
                                    onTap: () {
                                      setState(() {
                                        _makeup = !_makeup;
                                      });
                                    },
                                    title: Text(
                                      AppLocalization.of(context)
                                          .translate("Makeup"),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: _makeup
                                              ? Theme.of(context).accentColor
                                              : CustomColors.kTabBarIconColor),
                                    ),
                                    trailing: Icon(
                                      _makeup
                                          ? Icons.arrow_drop_up
                                          : Icons.arrow_drop_down,
                                      color: _makeup
                                          ? Theme.of(context).accentColor
                                          : CustomColors.kTabBarIconColor,
                                      size: 30.0,
                                    ),
                                  )
                                : widget.categoryName == 'Perfume'
                                    ? ListTile(
                                        selected: _perfume,
                                        onTap: () {
                                          setState(() {
                                            _perfume = !_perfume;
                                          });
                                        },
                                        title: Text(
                                          AppLocalization.of(context)
                                              .translate("Perfume"),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: _perfume
                                                  ? Theme.of(context)
                                                      .accentColor
                                                  : CustomColors
                                                      .kTabBarIconColor),
                                        ),
                                        trailing: Icon(
                                          _perfume
                                              ? Icons.arrow_drop_up
                                              : Icons.arrow_drop_down,
                                          color: _perfume
                                              ? Theme.of(context).accentColor
                                              : CustomColors.kTabBarIconColor,
                                          size: 30.0,
                                        ),
                                      )
                                    : widget.categoryName == 'Care'
                                        ? ListTile(
                                            selected: _care,
                                            onTap: () {
                                              setState(() {
                                                _care = !_care;
                                              });
                                            },
                                            title: Text(
                                              AppLocalization.of(context)
                                                  .translate("Care"),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: _care
                                                      ? Theme.of(context)
                                                          .accentColor
                                                      : CustomColors
                                                          .kTabBarIconColor),
                                            ),
                                            trailing: Icon(
                                              _care
                                                  ? Icons.arrow_drop_up
                                                  : Icons.arrow_drop_down,
                                              color: _care
                                                  ? Theme.of(context)
                                                      .accentColor
                                                  : CustomColors
                                                      .kTabBarIconColor,
                                              size: 30.0,
                                            ),
                                          )
                                        : widget.categoryName == 'Nails'
                                            ? ListTile(
                                                selected: _nails,
                                                onTap: () {
                                                  setState(() {
                                                    _nails = !_nails;
                                                  });
                                                },
                                                title: Text(
                                                  AppLocalization.of(context)
                                                      .translate("Nails"),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: _nails
                                                          ? Theme.of(context)
                                                              .accentColor
                                                          : CustomColors
                                                              .kTabBarIconColor),
                                                ),
                                                trailing: Icon(
                                                  _nails
                                                      ? Icons.arrow_drop_up
                                                      : Icons.arrow_drop_down,
                                                  color: _nails
                                                      ? Theme.of(context)
                                                          .accentColor
                                                      : CustomColors
                                                          .kTabBarIconColor,
                                                  size: 30.0,
                                                ))
                                            : widget.categoryName == 'Lenses'
                                                ? ListTile(
                                                    selected: _lenses,
                                                    onTap: () {
                                                      setState(() {
                                                        _lenses = !_lenses;
                                                      });
                                                    },
                                                    title: Text(
                                                      AppLocalization.of(
                                                              context)
                                                          .translate("Lenses"),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: _lenses
                                                              ? Theme.of(
                                                                      context)
                                                                  .accentColor
                                                              : CustomColors
                                                                  .kTabBarIconColor),
                                                    ),
                                                    trailing: Icon(
                                                      _lenses
                                                          ? Icons.arrow_drop_up
                                                          : Icons
                                                              .arrow_drop_down,
                                                      color: _lenses
                                                          ? Theme.of(context)
                                                              .accentColor
                                                          : CustomColors
                                                              .kTabBarIconColor,
                                                      size: 30.0,
                                                    ),
                                                  )
                                                : ListTile(
                                                    selected: _devices,
                                                    onTap: () {
                                                      setState(() {
                                                        _devices = !_devices;
                                                      });
                                                    },
                                                    title: Text(
                                                      AppLocalization.of(
                                                              context)
                                                          .translate("Devices"),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: _devices
                                                              ? Theme.of(
                                                                      context)
                                                                  .accentColor
                                                              : CustomColors
                                                                  .kTabBarIconColor),
                                                    ),
                                                    trailing: Icon(
                                                      _devices
                                                          ? Icons.arrow_drop_up
                                                          : Icons
                                                              .arrow_drop_down,
                                                      color: _lenses
                                                          ? Theme.of(context)
                                                              .accentColor
                                                          : CustomColors
                                                              .kTabBarIconColor,
                                                      size: 30.0,
                                                    )),
                            _makeup
                                ? Container(
                                    margin: const EdgeInsets.only(
                                        left: 15.0, right: 15.0),
                                    child: Column(children: <Widget>[
                                      ListTile(
                                        onTap: () {
                                          setState(() {
                                            _face = !_face;
                                          });
                                        },
                                        title: Text(
                                          AppLocalization.of(context)
                                              .translate("face"),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: _face
                                                  ? Theme.of(context)
                                                      .accentColor
                                                  : CustomColors
                                                      .kTabBarIconColor),
                                        ),
                                        trailing: Icon(
                                            _face
                                                ? Icons.arrow_drop_up
                                                : Icons.arrow_drop_down,
                                            size: 30.0,
                                            color: _face
                                                ? Theme.of(context).accentColor
                                                : CustomColors
                                                    .kTabBarIconColor),
                                        selected: _face,
                                      ),
                                      _face
                                          ? Container(
                                              margin: const EdgeInsets.only(
                                                  left: 20.0, right: 20.0),
                                              child: Column(children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    Checkbox(
                                                      value: _foundation,
                                                      onChanged: (val) {
                                                        setState(() {
                                                          _foundation = val;

//                                                          print(val);
                                                        });
                                                        _populateFilterBody(
                                                            'Foundation', val);
                                                      },
                                                    ),
                                                    Text(
                                                      AppLocalization.of(
                                                              context)
                                                          .translate(
                                                              "Foundation"),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Checkbox(
                                                      value: _concealer,
                                                      onChanged: (val) {
                                                        setState(() {
                                                          _concealer = val;
                                                        });
                                                        _populateFilterBody(
                                                            'Concealer', val);
                                                      },
                                                    ),
                                                    Text(
                                                      AppLocalization.of(
                                                              context)
                                                          .translate(
                                                              "Concealer"),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Checkbox(
                                                      value: _highlighter,
                                                      onChanged: (val) {
                                                        setState(() {
                                                          _highlighter = val;
                                                        });
                                                        _populateFilterBody(
                                                            'Highlighter', val);
                                                      },
                                                    ),
                                                    Text(
                                                      AppLocalization.of(
                                                              context)
                                                          .translate(
                                                              "Highlighter"),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Checkbox(
                                                      value: _powder,
                                                      onChanged: (val) {
                                                        setState(() {
                                                          _powder = val;
                                                        });
                                                        _populateFilterBody(
                                                            'Powder', val);
                                                      },
                                                    ),
                                                    Text(
                                                      AppLocalization.of(
                                                              context)
                                                          .translate("Powder"),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Checkbox(
                                                      value: _faceBrimer,
                                                      onChanged: (val) {
                                                        setState(() {
                                                          _faceBrimer = val;
                                                        });
                                                        _populateFilterBody(
                                                            'Face Brimer', val);
                                                      },
                                                    ),
                                                    Text(
                                                      AppLocalization.of(
                                                              context)
                                                          .translate(
                                                              "Face Brimer"),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Checkbox(
                                                      value: _makeupFixingSpray,
                                                      onChanged: (val) {
                                                        setState(() {
                                                          _makeupFixingSpray =
                                                              val;
                                                        });
                                                        _populateFilterBody(
                                                            'Makeup Fixing Spray',
                                                            val);
                                                      },
                                                    ),
                                                    Text(
                                                      AppLocalization.of(
                                                              context)
                                                          .translate(
                                                              "Makeup Fixing Spray"),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Checkbox(
                                                      value: _bbCcCream,
                                                      onChanged: (val) {
                                                        setState(() {
                                                          _bbCcCream = val;
                                                        });
                                                        _populateFilterBody(
                                                            'BB And CC Cream',
                                                            val);
                                                      },
                                                    ),
                                                    Text(
                                                      AppLocalization.of(
                                                              context)
                                                          .translate(
                                                              "BB And CC Cream"),
                                                    ),
                                                  ],
                                                ),
                                              ]))
                                          : Container(),
                                      ListTile(
                                        onTap: () {
                                          setState(() {
                                            _eyes = !_eyes;
                                          });
                                        },
                                        title: Text(
                                          AppLocalization.of(context)
                                              .translate("eyes"),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: _eyes
                                                  ? Theme.of(context)
                                                      .accentColor
                                                  : CustomColors
                                                      .kTabBarIconColor),
                                        ),
                                        trailing: Icon(
                                            _eyes
                                                ? Icons.arrow_drop_up
                                                : Icons.arrow_drop_down,
                                            size: 30.0,
                                            color: _eyes
                                                ? Theme.of(context).accentColor
                                                : CustomColors
                                                    .kTabBarIconColor),
                                        selected: _eyes,
                                      ),
                                      _eyes
                                          ? Container(
                                              margin: const EdgeInsets.only(
                                                  left: 20.0, right: 20.0),
                                              child: Column(
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        value: _eyeMascara,
                                                        onChanged: (val) {
                                                          setState(() {
                                                            _eyeMascara = val;
                                                          });
                                                          _populateFilterBody(
                                                              'Mascara', val);
                                                        },
                                                      ),
                                                      Text(
                                                        AppLocalization.of(
                                                                context)
                                                            .translate(
                                                                "Mascara"),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        value: _eyeShadow,
                                                        onChanged: (val) {
                                                          setState(() {
                                                            _eyeShadow = val;
                                                          });
                                                          _populateFilterBody(
                                                              'Eyeshadow', val);
                                                        },
                                                      ),
                                                      Text(
                                                        AppLocalization.of(
                                                                context)
                                                            .translate(
                                                                "Eyeshadow"),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        value: _eyeLiner,
                                                        onChanged: (val) {
                                                          setState(() {
                                                            _eyeLiner = val;
                                                          });
                                                          _populateFilterBody(
                                                              'Eyeliner', val);
                                                        },
                                                      ),
                                                      Text(
                                                        AppLocalization.of(
                                                                context)
                                                            .translate(
                                                                "Eyeliner"),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        value: _eyeBrimer,
                                                        onChanged: (val) {
                                                          setState(() {
                                                            _eyeBrimer = val;
                                                            print(val);
                                                          });
                                                          _populateFilterBody(
                                                              'Brimer', val);
                                                        },
                                                      ),
                                                      Text(
                                                        AppLocalization.of(
                                                                context)
                                                            .translate(
                                                                "Brimer"),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        value: _eyeGlitter,
                                                        onChanged: (val) {
                                                          setState(() {
                                                            _eyeGlitter = val;
                                                            print(val);
                                                          });
                                                          _populateFilterBody(
                                                              'Glitter', val);
                                                        },
                                                      ),
                                                      Text(
                                                        AppLocalization.of(
                                                                context)
                                                            .translate(
                                                                "Glitter"),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Container(),
                                      ListTile(
                                        onTap: () {
                                          setState(() {
                                            _lips = !_lips;
                                          });
                                        },
                                        title: Text(
                                          AppLocalization.of(context)
                                              .translate("lips"),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: _lips
                                                  ? Theme.of(context)
                                                      .accentColor
                                                  : CustomColors
                                                      .kTabBarIconColor),
                                        ),
                                        trailing: Icon(
                                            _lips
                                                ? Icons.arrow_drop_up
                                                : Icons.arrow_drop_down,
                                            size: 30.0,
                                            color: _lips
                                                ? Theme.of(context).accentColor
                                                : CustomColors
                                                    .kTabBarIconColor),
                                        selected: _lips,
                                      ),
                                      _lips
                                          ? Container(
                                              margin: const EdgeInsets.only(
                                                  left: 20.0, right: 20.0),
                                              child: Column(
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        value: _lipSet,
                                                        onChanged: (val) {
                                                          setState(() {
                                                            _lipSet = val;
                                                          });
                                                          _populateFilterBody(
                                                              'Lip Set', val);
                                                        },
                                                      ),
                                                      Text(
                                                        AppLocalization.of(
                                                                context)
                                                            .translate(
                                                                "Lip Set"),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        value: _lipGloss,
                                                        onChanged: (val) {
                                                          setState(() {
                                                            _lipGloss = val;
                                                          });
                                                          _populateFilterBody(
                                                              'Lip Gloss', val);
                                                        },
                                                      ),
                                                      Text(
                                                        AppLocalization.of(
                                                                context)
                                                            .translate(
                                                                "Lip Gloss"),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        value: _lipLiner,
                                                        onChanged: (val) {
                                                          setState(() {
                                                            _lipLiner = val;
                                                          });
                                                          _populateFilterBody(
                                                              'Lip Liner', val);
                                                        },
                                                      ),
                                                      Text(
                                                        AppLocalization.of(
                                                                context)
                                                            .translate(
                                                                "Lip Liner"),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        value: _lipStick,
                                                        onChanged: (val) {
                                                          setState(() {
                                                            _lipStick = val;
                                                            print(val);
                                                          });
                                                          _populateFilterBody(
                                                              'Lipstick', val);
                                                        },
                                                      ),
                                                      Text(
                                                        AppLocalization.of(
                                                                context)
                                                            .translate(
                                                                "Lipstick"),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Container(),
                                      ListTile(
                                        onTap: () {
                                          setState(() {
                                            _eyeBrow = !_eyeBrow;
                                          });
                                        },
                                        title: Text(
                                          AppLocalization.of(context)
                                              .translate("eyebrow"),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: _eyeBrow
                                                  ? Theme.of(context)
                                                      .accentColor
                                                  : CustomColors
                                                      .kTabBarIconColor),
                                        ),
                                        trailing: Icon(
                                            _eyeBrow
                                                ? Icons.arrow_drop_up
                                                : Icons.arrow_drop_down,
                                            size: 30.0,
                                            color: _eyeBrow
                                                ? Theme.of(context).accentColor
                                                : CustomColors
                                                    .kTabBarIconColor),
                                        selected: _eyeBrow,
                                      ),
                                      _eyeBrow
                                          ? Container(
                                              margin: const EdgeInsets.only(
                                                  left: 20.0, right: 20.0),
                                              child: Column(
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        value: _eyeBrowMascara,
                                                        onChanged: (val) {
                                                          setState(() {
                                                            _eyeBrowMascara =
                                                                val;
                                                          });
                                                          _populateFilterBody(
                                                              'Eyebrow Mascara',
                                                              val);
                                                        },
                                                      ),
                                                      Text(
                                                        AppLocalization.of(
                                                                context)
                                                            .translate(
                                                                "Eyebrow Mascara"),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        value: _eyeBrowGel,
                                                        onChanged: (val) {
                                                          setState(() {
                                                            _eyeBrowGel = val;
                                                          });
                                                          _populateFilterBody(
                                                              'Eyebrow Gel & Powder',
                                                              val);
                                                        },
                                                      ),
                                                      Text(
                                                        AppLocalization.of(
                                                                context)
                                                            .translate(
                                                                "Eyebrow Gel & Powder"),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        value: _eyeBrowPencil,
                                                        onChanged: (val) {
                                                          setState(() {
                                                            _eyeBrowPencil =
                                                                val;
                                                          });
                                                          _populateFilterBody(
                                                              'Eyebrow Pencil',
                                                              val);
                                                        },
                                                      ),
                                                      Text(
                                                        AppLocalization.of(
                                                                context)
                                                            .translate(
                                                                "Eyebrow Pencil"),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Container(),
                                      ListTile(
                                        onTap: () {
                                          setState(() {
                                            _cheek = !_cheek;
                                          });
                                        },
                                        title: Text(
                                          AppLocalization.of(context)
                                              .translate("Cheek"),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: _cheek
                                                  ? Theme.of(context)
                                                      .accentColor
                                                  : CustomColors
                                                      .kTabBarIconColor),
                                        ),
                                        trailing: Icon(
                                            _cheek
                                                ? Icons.arrow_drop_up
                                                : Icons.arrow_drop_down,
                                            size: 30.0,
                                            color: _cheek
                                                ? Theme.of(context).accentColor
                                                : CustomColors
                                                    .kTabBarIconColor),
                                        selected: _cheek,
                                      ),
                                      _cheek
                                          ? Container(
                                              margin: const EdgeInsets.only(
                                                  left: 20.0, right: 20.0),
                                              child: Column(
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        value: _cheekContour,
                                                        onChanged: (val) {
                                                          setState(() {
                                                            _cheekContour = val;
                                                          });
                                                          _populateFilterBody(
                                                              'Contour', val);
                                                        },
                                                      ),
                                                      Text(
                                                        AppLocalization.of(
                                                                context)
                                                            .translate(
                                                                "Contour"),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        value: _cheekBlusher,
                                                        onChanged: (val) {
                                                          setState(() {
                                                            _cheekBlusher = val;
                                                          });
                                                          _populateFilterBody(
                                                              'Cheek Blusher',
                                                              val);
                                                        },
                                                      ),
                                                      Text(
                                                        AppLocalization.of(
                                                                context)
                                                            .translate(
                                                                "Cheek Blusher"),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Container(),
                                      ListTile(
                                        onTap: () {
                                          setState(() {
                                            _makeupBrushesTools =
                                                !_makeupBrushesTools;
                                          });
                                        },
                                        title: Text(
                                          AppLocalization.of(context).translate(
                                              "makeup_brushes_tools"),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: _makeupBrushesTools
                                                  ? Theme.of(context)
                                                      .accentColor
                                                  : CustomColors
                                                      .kTabBarIconColor),
                                        ),
                                        trailing: Icon(
                                            _makeupBrushesTools
                                                ? Icons.arrow_drop_up
                                                : Icons.arrow_drop_down,
                                            size: 30.0,
                                            color: _makeupBrushesTools
                                                ? Theme.of(context).accentColor
                                                : CustomColors
                                                    .kTabBarIconColor),
                                        selected: _makeupBrushesTools,
                                      ),
                                      _makeupBrushesTools
                                          ? Container(
                                              margin: const EdgeInsets.only(
                                                  left: 20.0, right: 20.0),
                                              child: Column(
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        value: _eyeBrushes,
                                                        onChanged: (val) {
                                                          setState(() {
                                                            _eyeBrushes = val;
                                                          });
                                                          _populateFilterBody(
                                                              'Eye Brushes',
                                                              val);
                                                        },
                                                      ),
                                                      Text(
                                                        AppLocalization.of(
                                                                context)
                                                            .translate(
                                                                "Eye Brushes"),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        value: _faceBrushes,
                                                        onChanged: (val) {
                                                          setState(() {
                                                            _faceBrushes = val;
                                                          });
                                                          _populateFilterBody(
                                                              'Face Brushes',
                                                              val);
                                                        },
                                                      ),
                                                      Text(
                                                        AppLocalization.of(
                                                                context)
                                                            .translate(
                                                                "Face Brushes"),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        value: _eyeBrowBrushes,
                                                        onChanged: (val) {
                                                          setState(() {
                                                            _eyeBrowBrushes =
                                                                val;
                                                          });
                                                          _populateFilterBody(
                                                              'Eyebrow Brushes',
                                                              val);
                                                        },
                                                      ),
                                                      Text(
                                                        AppLocalization.of(
                                                                context)
                                                            .translate(
                                                                "Eyebrow Brushes"),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        value: _makeupRemover,
                                                        onChanged: (val) {
                                                          setState(() {
                                                            _makeupRemover =
                                                                val;
                                                          });
                                                          _populateFilterBody(
                                                              'Makeup Remover',
                                                              val);
                                                        },
                                                      ),
                                                      Text(
                                                        AppLocalization.of(
                                                                context)
                                                            .translate(
                                                                "Makeup Remover"),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Container(),
                                    ]))
                                : Container(),
                            _perfume
                                ? Container(
                                    margin: const EdgeInsets.only(
                                        left: 15.0, right: 15.0),
                                    child: Column(children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Checkbox(
                                            value: _womenPerfume,
                                            onChanged: (val) {
                                              setState(() {
                                                _womenPerfume = val;
                                              });
                                              _populateFilterBody(
                                                  'Women Perfumes', val);
                                            },
                                          ),
                                          Text(
                                            AppLocalization.of(context)
                                                .translate("Women Perfumes"),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Checkbox(
                                            value: _menPerfume,
                                            onChanged: (val) {
                                              setState(() {
                                                _menPerfume = val;
                                              });
                                              _populateFilterBody(
                                                  'Men Perfumes', val);
                                            },
                                          ),
                                          Text(
                                            AppLocalization.of(context)
                                                .translate("Men Perfumes"),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Checkbox(
                                            value: _unisexPerfume,
                                            onChanged: (val) {
                                              setState(() {
                                                _unisexPerfume = val;
                                              });
                                              _populateFilterBody(
                                                  'Unisex Perfumes', val);
                                            },
                                          ),
                                          Text(
                                            AppLocalization.of(context)
                                                .translate("Unisex Perfumes"),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Checkbox(
                                            value: _nichePerfume,
                                            onChanged: (val) {
                                              setState(() {
                                                _nichePerfume = val;
                                              });
                                              _populateFilterBody(
                                                  'Niche Perfumes', val);
                                            },
                                          ),
                                          Text(
                                            AppLocalization.of(context)
                                                .translate("Niche Perfumes"),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Checkbox(
                                            value: _hairMist,
                                            onChanged: (val) {
                                              setState(() {
                                                _hairMist = val;
                                              });
                                              _populateFilterBody(
                                                  'Hair Mist', val);
                                            },
                                          ),
                                          Text(
                                            AppLocalization.of(context)
                                                .translate("Hair Mist"),
                                          ),
                                        ],
                                      ),
                                    ]),
                                  )
                                : Container(),
                            _care
                                ? Container(
                                    margin: const EdgeInsets.only(
                                        left: 15.0, right: 15.0),
                                    child: Column(children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Checkbox(
                                            value: _careTool,
                                            onChanged: (val) {
                                              setState(() {
                                                _careTool = val;
                                              });
                                              _populateFilterBody(
                                                  'Lip Care', val);
                                            },
                                          ),
                                          Text(
                                            AppLocalization.of(context)
                                                .translate("Lip Care"),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Checkbox(
                                            value: _careLip,
                                            onChanged: (val) {
                                              setState(() {
                                                _careLip = val;
                                              });
                                              _populateFilterBody(
                                                  'Hands Care', val);
                                            },
                                          ),
                                          Text(
                                            AppLocalization.of(context)
                                                .translate("Hands Care"),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Checkbox(
                                            value: _careHand,
                                            onChanged: (val) {
                                              setState(() {
                                                _careHand = val;
                                              });
                                              _populateFilterBody(
                                                  'Face Care', val);
                                            },
                                          ),
                                          Text(
                                            AppLocalization.of(context)
                                                .translate("Face Care"),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Checkbox(
                                            value: _careFace,
                                            onChanged: (val) {
                                              setState(() {
                                                _careFace = val;
                                              });
                                              _populateFilterBody(
                                                  'Eye And Lash Care', val);
                                            },
                                          ),
                                          Text(
                                            AppLocalization.of(context)
                                                .translate("Eye And Lash Care"),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Checkbox(
                                            value: _careHair,
                                            onChanged: (val) {
                                              setState(() {
                                                _careHair = val;
                                              });
                                              _populateFilterBody(
                                                  'Hair Care', val);
                                            },
                                          ),
                                          Text(
                                            AppLocalization.of(context)
                                                .translate("Hair Care"),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Checkbox(
                                            value: _careBody,
                                            onChanged: (val) {
                                              setState(() {
                                                _careBody = val;
                                              });
                                              _populateFilterBody(
                                                  'Body Care', val);
                                            },
                                          ),
                                          Text(
                                            AppLocalization.of(context)
                                                .translate("Body Care"),
                                          ),
                                        ],
                                      ),
                                    ]),
                                  )
                                : Container(),
                            _nails
                                ? Container(
                                    margin: const EdgeInsets.only(
                                        left: 15.0, right: 15.0),
                                    child: Column(children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Checkbox(
                                            value: _nailPolish,
                                            onChanged: (val) {
                                              setState(() {
                                                _nailPolish = val;
                                              });
                                              _populateFilterBody(
                                                  'Nail Polish', val);
                                            },
                                          ),
                                          Text(
                                            AppLocalization.of(context)
                                                .translate("Nail Polish"),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Checkbox(
                                            value: _nailPolishRemover,
                                            onChanged: (val) {
                                              setState(() {
                                                _nailPolishRemover = val;
                                              });
                                              _populateFilterBody(
                                                  'Nail Polish Remover', val);
                                            },
                                          ),
                                          Text(
                                            AppLocalization.of(context)
                                                .translate(
                                                    "Nail Polish Remover"),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Checkbox(
                                            value: _nailTool,
                                            onChanged: (val) {
                                              setState(() {
                                                _nailTool = val;
                                              });
                                              _populateFilterBody(
                                                  'Nail Tools', val);
                                            },
                                          ),
                                          Text(
                                            AppLocalization.of(context)
                                                .translate("Nail Tools"),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Checkbox(
                                            value: _nailCare,
                                            onChanged: (val) {
                                              setState(() {
                                                _nailCare = val;
                                              });
                                              _populateFilterBody(
                                                  'Nail Care', val);
                                            },
                                          ),
                                          Text(
                                            AppLocalization.of(context)
                                                .translate("Nail Care"),
                                          ),
                                        ],
                                      ),
                                    ]),
                                  )
                                : Container(),
                            _lenses
                                ? Container(
                                    margin: const EdgeInsets.only(
                                        left: 15.0, right: 15.0),
                                    child: Column(children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Checkbox(
                                            value: _pureness,
                                            onChanged: (val) {
                                              setState(() {
                                                _pureness = val;
                                              });
                                              _populateFilterBody(
                                                  'Pureness', val);
                                            },
                                          ),
                                          Text(
                                            AppLocalization.of(context)
                                                .translate("Pureness"),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Checkbox(
                                            value: _bella,
                                            onChanged: (val) {
                                              setState(() {
                                                _bella = val;
                                              });
                                              _populateFilterBody('Bella', val);
                                            },
                                          ),
                                          Text(
                                            AppLocalization.of(context)
                                                .translate("Bella"),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Checkbox(
                                            value: _diva,
                                            onChanged: (val) {
                                              setState(() {
                                                _diva = val;
                                              });
                                              _populateFilterBody('Diva', val);
                                            },
                                          ),
                                          Text(
                                            AppLocalization.of(context)
                                                .translate("Diva"),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Checkbox(
                                            value: _beauteous,
                                            onChanged: (val) {
                                              setState(() {
                                                _beauteous = val;
                                              });
                                              _populateFilterBody(
                                                  'Beauteous', val);
                                            },
                                          ),
                                          Text(
                                            AppLocalization.of(context)
                                                .translate("Beauteous"),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Checkbox(
                                            value: _lensme,
                                            onChanged: (val) {
                                              setState(() {
                                                _lensme = val;
                                              });
                                              _populateFilterBody(
                                                  'Lens me', val);
                                            },
                                          ),
                                          Text(
                                            AppLocalization.of(context)
                                                .translate("Lens me"),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Checkbox(
                                            value: _solutionForLenses,
                                            onChanged: (val) {
                                              setState(() {
                                                _solutionForLenses = val;
                                              });
                                              _populateFilterBody(
                                                  'Solution For Lenses', val);
                                            },
                                          ),
                                          Text(
                                            AppLocalization.of(context)
                                                .translate(
                                                    "Solution For Lenses"),
                                          ),
                                        ],
                                      ),
                                    ]),
                                  )
                                : Container(),
                            _devices
                                ? Container(
                                    margin: const EdgeInsets.only(
                                        left: 15.0, right: 15.0),
                                    child: Column(children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Checkbox(
                                            value: _hairDevice,
                                            onChanged: (val) {
                                              setState(() {
                                                _hairDevice = val;
                                              });
                                              _populateFilterBody(
                                                  'Hair Device', val);
                                            },
                                          ),
                                          Text(
                                            AppLocalization.of(context)
                                                .translate("Hair Device"),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Checkbox(
                                            value: _bodyDevice,
                                            onChanged: (val) {
                                              setState(() {
                                                _bodyDevice = val;
                                              });
                                              _populateFilterBody(
                                                  'Body Device', val);
                                            },
                                          ),
                                          Text(
                                            AppLocalization.of(context)
                                                .translate("Body Device"),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Checkbox(
                                            value: _faceDevice,
                                            onChanged: (val) {
                                              setState(() {
                                                _faceDevice = val;
                                              });
                                              _populateFilterBody(
                                                  'Face Device', val);
                                            },
                                          ),
                                          Text(
                                            AppLocalization.of(context)
                                                .translate("Face Device"),
                                          ),
                                        ],
                                      ),
                                    ]),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          GestureDetector(
                            onTap: _isLoading
                                ? null
                                : () {
                                    setState(() {
                                      _isLoading = true;
                                      pageNumberOrdered = 1;
                                      _products.clear();
                                      _isFilteredData = true;
                                    });

                                    print('index :$pageNumberOrdered');
                                    print('is filterd :$_isFilteredData');
                                    _doFilterWithMultiCategory(
                                        pageNumberOrdered);
                                    Navigator.of(context).pop();
//                             _checkInternetConnection();
                                  },
                            child: _isLoading
                                ? AdaptiveProgressIndicator()
                                : Container(
                                    height: 40,
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0, vertical: 10),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: Theme.of(context).accentColor),
                                    child: Center(
                                      child: Text(
                                        AppLocalization.of(context)
                                            .translate("apply_filter"),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _foundation = false;
                                _concealer = false;
                                _powder = false;
                                _faceBrimer = false;
                                _makeupFixingSpray = false;
                                _bbCcCream = false;
                                _eyeMascara = false;
                              });
                            },
                            child: Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width * 0.4,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(
                                      width: 1,
                                      color: Theme.of(context).accentColor)),
                              child: Center(
                                child: Text(
                                  AppLocalization.of(context)
                                      .translate('clear'),
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInti) {
      getProductsData(pageNumber);
    }
    _isInti = false;
  }

  getProductsData(int pageNumber) async {
    final String lang = appLanguage.appLocal.toString();
    setState(() {
      pageNumber > 1 ? _seeMoreLoading = true : _isLoading = true;
    });
    var userData = await userProvider.isAuthenticated();
//    print(userData['Authorization']);

    Provider.of<ProductsProvider>(context)
        .allDataInSpecificCategory(
            widget.subCategoryName == ''
                ? widget.categoryName
                : widget.subCategoryName,
            lang,
            pageNumber,
            userData['Authorization'] == 'none'
                ? 'none'
                : userData['Authorization'])
        .then((products) {
      var list = products['data'] as List;
      _products.addAll(List<ProductsModel>.from(list));
      lastPage = products['last_page'];
      print('call product num $pageNumber and lenght is ${_products.length}');
      setState(() {
        _isLoading = false;
        _seeMoreLoading = false;
        _isFilteredData = false;
      });
    });
  }

  loadMore() async {
    if (_isFilteredData) {
//      print('order page num is $pageNumberOrdered and last page is $lastPage');
      pageNumberOrdered++;
      if (_isFrom == 'filter') {
        print(_isFrom);
        if (pageNumberOrdered <= lastPageFiltered) {
          _doFilterWithMultiCategory(pageNumberOrdered);
        }
      } else if (_isFrom == 'sort') {
        print(_isFrom);
        if (pageNumberOrdered <= lastPageFiltered) {
          _doFilter(pageNumberOrdered);
        }
      }
      print(pageNumberOrdered);
    } else {
      pageNumber++;
      if (pageNumber <= lastPage) getProductsData(pageNumber);
    }
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      double _maxScroll = _controller.position.maxScrollExtent;
      double _currentScroll = _controller.position.pixels;
      double _delta = _maxScroll * 0.20 / pageNumberOrdered;
      if (_maxScroll - _currentScroll <= _delta) {
        if (loaded == false) {
          loaded = true;
          loadMore();
//          print('max is ; $_maxScroll and current is : $_currentScroll');
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalization.of(context).translate(widget.subCategoryName != ''
              ? "${widget.subCategoryName}"
              : '${widget.categoryName}'),
          style: TextStyle(fontSize: 18.0),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: SearchProduct());
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: AdaptiveProgressIndicator(),
            )
          : _products.length == 0
              ? Container(
                  child: Center(
                    child: Text(AppLocalization.of(context)
                        .translate('no_products_in_category')),
                  ),
                )
              : Provider<NetworkProvider>.value(
                  value: NetworkProvider(),
                  child: Consumer<NetworkProvider>(
                    builder: (context, value, _) => Center(
                        child: ConnectivityWidget(
                      networkProvider: value,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(1, 3),
                                      blurRadius: 10.0,
                                      color: Colors.grey.withOpacity(0.3))
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Expanded(
                                    child: FlatButton.icon(
                                      onPressed: () {
                                        _showSortDialog();
                                      },
                                      icon: Icon(
                                        Icons.import_export,
                                      ),
                                      label: Text(AppLocalization.of(context)
                                          .translate('sort_hint')),
                                    ),
                                  ),
                                  Container(
                                    child: Text('|'),
                                  ),
                                  Expanded(
                                    child: FlatButton.icon(
                                      onPressed: () {
                                        _showFilterDialog();
                                      },
                                      icon: Icon(Icons.filter_list),
                                      label: Text(AppLocalization.of(context)
                                          .translate('filter_hint')),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Expanded(
                            flex: 9,
                            child: Container(
                              child: GridView.builder(
                                controller: _controller,
                                itemCount: _products.length,
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 10.0,
                                        crossAxisSpacing: 10.0,
                                        childAspectRatio: 2 / 3.4),
                                itemBuilder: (ctx, i) =>
                                    ChangeNotifierProvider.value(
                                  value: _products[i],
                                  child: ProductItem(),
                                ),
                              ),
                            ),
                          ),
                          _seeMoreLoading
                              ? Expanded(
                                  flex: 1,
                                  child: Container(
                                    child: Center(
                                      child: Container(
                                        width: 25.0,
                                        height: 25.0,
                                        child: CircularProgressIndicator(
                                          backgroundColor:
                                              CustomColors.kTabBarIconColor,
                                          strokeWidth: 1.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Container()
                        ],
                      ),
                    )),
                  ),
                ),
    );
  }
}
