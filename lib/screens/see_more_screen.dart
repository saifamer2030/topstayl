import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topstyle/constants/colors.dart';
import 'package:topstyle/helper/appLocalization.dart';
import 'package:topstyle/helper/size_config.dart';
import 'package:topstyle/models/products_model.dart';
import 'package:topstyle/providers/cart_provider.dart';
import 'package:topstyle/providers/languages_provider.dart';
import 'package:topstyle/providers/network_provider.dart';
import 'package:topstyle/providers/products_provider.dart';
import 'package:topstyle/providers/user_provider.dart';
import 'package:topstyle/screens/cart_screen.dart';
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
  ScrollController _controller = ScrollController();
  List<String> filterBody = [];
  String _isFrom = '';
  String order = 'asc';
  AppLanguageProvider appLanguage = AppLanguageProvider();
  UserProvider userProvider = UserProvider();
  Map<String, int> _flags = {
    'pageNumber': 1,
    'pageNumberOrdered': 1,
    'lastPage': 0,
    'lastPageFiltered': 0
  };

  Map<String, bool> _categories = {
    'isInti': true,
    'isLoading': false,
    'seeMoreLoading': false,
    'isFilteredData': false,
    'makeup': false,
    'perfume': false,
    'care': false,
    'nails': false,
    'lenses': false,
    'devices': false,
    'face': false,
    'lips': false,
    'eyes': false,
    'eyeBrow': false,
    'cheek': false,
    'highlighter': false,
    'brushes': false,
    'makeupBrushesTools': false,
    'foundation': false,
    'concealer': false,
    'powder': false,
    'faceBrimer': false,
    'makeupFixingSpray': false,
    'bbCcCream': false,
    'eyeMascara': false,
    'eyeShadow': false,
    'eyeLiner': false,
    'eyeBrimer': false,
    'eyeGlitter': false,
    'lipSet': false,
    'lipGloss': false,
    'lipStick': false,
    'lipLiner': false,
    'eyeBrowMascara': false,
    'eyeBrowGel': false,
    'eyeBrowPencil': false,
    'cheekContour': false,
    'cheekBlusher': false,
    'eyeBrushes': false,
    'faceBrushes': false,
    'eyeBrowBrushes': false,
    'brushesCleaners': false,
    'makeupRemover': false,
    'womenPerfume': false,
    'unisexPerfume': false,
    'menPerfume': false,
    'hairMist': false,
    'nichePerfume': false,
    'careTool': false,
    'careLip': false,
    'careHand': false,
    'careFace': false,
    'careHair': false,
    'careBody': false,
    'nailPolish': false,
    'nailPolishRemover': false,
    'nailTool': false,
    'nailCare': false,
    'pureness': false,
    'bella': false,
    'diva': false,
    'beauteous': false,
    'lensme': false,
    'solutionForLenses': false,
    'hairDevice': false,
    'bodyDevice': false,
    'faceDevice': false,
    'loaded': false,
    'sortByLow': false,
    'sortByHigh': false,
    'sortByNew': false,
    'sortByToRated': false
  };

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

  _doFilter(int pageNumber) async {
    final String myLang = appLanguage.appLocal.toString();
    var user = await userProvider.isAuthenticated();
    setState(() {
      _categories['seeMoreLoading'] = true;
    });
    String filterContent = '';
    filterContent =
        filterBody.toString().substring(1, filterBody.toString().length - 1);
    Provider.of<ProductsProvider>(context, listen: false)
        .allDataInSeeMoreWithMultiFilter(
            filterContent, myLang, pageNumber, user['Authorization'])
        .then((data) {
      setState(() {
        if (data['data'] != null) {
          _categories['loaded'] = false;
          _categories['isLoading'] = false;
          _categories['seeMoreLoading'] = false;
          if (_categories['isFilteredData'] &&
              _flags['pageNumberOrdered'] == 1) {
            _products.clear();
          }
          var list = data['data'] as List ?? [];
          _isFrom = 'filter';
          print(list.length);
          _flags['lastPageFiltered'] = data['last_page'] as int;
          _products.addAll(List<ProductsModel>.from(list));
        }
      });
    });
  }

  _doSort(int numberOfPage) async {
    final String lang = appLanguage.appLocal.toString();
    var userData = await userProvider.isAuthenticated();
    print('category name ${widget.categoryName}');
    print('sub category name ${widget.subCategoryName}');
    setState(() {
      _categories['seeMoreLoading'] = true;
    });
    Provider.of<ProductsProvider>(context, listen: false)
        .allDataInSeeMoreWithFilter(
            widget.subCategoryName != ''
                ? widget.subCategoryName
                : widget.categoryName,
            lang,
            numberOfPage,
            order,
            userData['Authorization'])
        .then((products) {
      if (products['data'] != null) {
        setState(() {
          _categories['loaded'] = false;
          _categories['seeMoreLoading'] = false;
          if (_categories['isFilteredData'] &&
              _flags['pageNumberOrdered'] == 1) {
            _products.clear();
          }
          var list = products['data'] as List;
          _isFrom = 'sort';
          _flags['lastPageFiltered'] = products['last_page'];
          _products.addAll(List<ProductsModel>.from(list));
        });
      }
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
                            _categories['sortByLow'] = true;
                            _categories['sortByHigh'] = false;
                            _categories['sortByNew'] = false;
                            _categories['sortByToRated'] = false;
                            _flags['pageNumberOrdered'] = 1;
                            _categories['isFilteredData'] = true;
                            order = 'desc';
                          });

//                          print('is filterd :$_isFilteredData');
                          _doSort(_flags['pageNumberOrdered']);
                          Navigator.of(context).pop();
                        },
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.arrow_downward,
                              size: 30.0,
                              color: _categories['sortByLow']
                                  ? Theme.of(context).accentColor
                                  : CustomColors.kTabBarIconColor,
                            ),
                            Text(
                              AppLocalization.of(context).translate("price"),
                              style: TextStyle(
                                fontSize: 12.0,
                                color: _categories['sortByLow']
                                    ? Theme.of(context).accentColor
                                    : CustomColors.kTabBarIconColor,
                              ),
                            ),
                            Text(
                              "(${AppLocalization.of(context).translate("highest_to_lowest")})",
                              style: TextStyle(
                                fontSize: 10.0,
                                color: _categories['sortByLow']
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
                            _categories['sortByLow'] = false;
                            _categories['sortByHigh'] = true;
                            _categories['sortByNew'] = false;
                            _categories['sortByToRated'] = false;
                            _flags['pageNumberOrdered'] = 1;
                            //_products.clear();
                            _categories['isFilteredData'] = true;
                            order = 'asc';
                          });
//                          print('is filterd :$_isFilteredData');
                          _doSort(_flags['pageNumberOrdered']);
                          Navigator.of(context).pop();
//                             _checkInternetConnection();
                        },
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.arrow_upward,
                              size: 30.0,
                              color: _categories['sortByHigh']
                                  ? Theme.of(context).accentColor
                                  : CustomColors.kTabBarIconColor,
                            ),
                            Text(
                              AppLocalization.of(context).translate("price"),
                              style: TextStyle(
                                fontSize: 12.0,
                                color: _categories['sortByHigh']
                                    ? Theme.of(context).accentColor
                                    : CustomColors.kTabBarIconColor,
                              ),
                            ),
                            Text(
                              "(${AppLocalization.of(context).translate("lowest_to_highest")})",
                              style: TextStyle(
                                fontSize: 10.0,
                                color: _categories['sortByHigh']
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
                            _categories['sortByLow'] = false;
                            _categories['sortByHigh'] = false;
                            _categories['sortByNew'] = false;
                            _categories['sortByToRated'] = true;
                            order = 'rate';
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
                              color: _categories['sortByToRated']
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
                                color: _categories['sortByToRated']
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
                            _categories['sortByLow'] = false;
                            _categories['sortByHigh'] = false;
                            _categories['sortByNew'] = true;
                            _categories['sortByToRated'] = false;
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
                              color: _categories['sortByNew']
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
                                color: _categories['sortByNew']
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

  _drawSubSubItem(String categoryName) {
    return Row(
      children: <Widget>[
        Checkbox(
          value: _categories[categoryName.toLowerCase()],
          onChanged: (val) {
            setState(() {
              _categories[categoryName.toLowerCase()] = val;
            });
            _populateFilterBody(categoryName, val);
          },
        ),
        Text(
          AppLocalization.of(context).translate("$categoryName"),
        ),
      ],
    );
  }

  _drawSubCategoryItem(String subName) {
    return Container(
        margin: const EdgeInsets.only(left: 15.0, right: 15.0),
        child: ListTile(
          onTap: () {
            setState(() {
              _categories[subName] = !_categories[subName];
            });
          },
          title: Text(
            AppLocalization.of(context).translate(subName),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _categories[subName]
                    ? Theme.of(context).accentColor
                    : CustomColors.kTabBarIconColor),
          ),
          trailing: Icon(
              _categories[subName]
                  ? Icons.arrow_drop_up
                  : Icons.arrow_drop_down,
              size: 30.0,
              color: _categories[subName]
                  ? Theme.of(context).accentColor
                  : CustomColors.kTabBarIconColor),
          selected: _categories[subName],
        ));
  }

  _drawMainCategoryItem(String categoryName) {
    return ListTile(
      selected: _categories[categoryName.toLowerCase()],
      onTap: () {
        setState(() {
          _categories[categoryName.toLowerCase()] =
              !_categories[categoryName.toLowerCase()];
        });
      },
      title: Text(
        AppLocalization.of(context).translate(categoryName),
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: _categories[categoryName.toLowerCase()]
                ? Theme.of(context).accentColor
                : CustomColors.kTabBarIconColor),
      ),
      trailing: Icon(
        _categories[categoryName.toLowerCase()]
            ? Icons.arrow_drop_up
            : Icons.arrow_drop_down,
        color: _categories[categoryName.toLowerCase()]
            ? Theme.of(context).accentColor
            : CustomColors.kTabBarIconColor,
        size: 30.0,
      ),
    );
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
                                    selected: _categories['makeup'],
                                    onTap: () {
                                      setState(() {
                                        _categories['makeup'] =
                                            !_categories['makeup'];
                                      });
                                    },
                                    title: Text(
                                      AppLocalization.of(context)
                                          .translate("Makeup"),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: _categories['makeup']
                                              ? Theme.of(context).accentColor
                                              : CustomColors.kTabBarIconColor),
                                    ),
                                    trailing: Icon(
                                      _categories['makeup']
                                          ? Icons.arrow_drop_up
                                          : Icons.arrow_drop_down,
                                      color: _categories['makeup']
                                          ? Theme.of(context).accentColor
                                          : CustomColors.kTabBarIconColor,
                                      size: 30.0,
                                    ),
                                  )
                                : widget.categoryName == 'Perfume'
                                    ? ListTile(
                                        selected: _categories['perfume'],
                                        onTap: () {
                                          setState(() {
                                            _categories['perfume'] =
                                                !_categories['perfume'];
                                          });
                                        },
                                        title: Text(
                                          AppLocalization.of(context)
                                              .translate("Perfume"),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: _categories['perfume']
                                                  ? Theme.of(context)
                                                      .accentColor
                                                  : CustomColors
                                                      .kTabBarIconColor),
                                        ),
                                        trailing: Icon(
                                          _categories['perfume']
                                              ? Icons.arrow_drop_up
                                              : Icons.arrow_drop_down,
                                          color: _categories['perfume']
                                              ? Theme.of(context).accentColor
                                              : CustomColors.kTabBarIconColor,
                                          size: 30.0,
                                        ),
                                      )
                                    : widget.categoryName == 'Care'
                                        ? ListTile(
                                            selected: _categories['care'],
                                            onTap: () {
                                              setState(() {
                                                _categories['care'] =
                                                    !_categories['care'];
                                              });
                                            },
                                            title: Text(
                                              AppLocalization.of(context)
                                                  .translate("Care"),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: _categories['care']
                                                      ? Theme.of(context)
                                                          .accentColor
                                                      : CustomColors
                                                          .kTabBarIconColor),
                                            ),
                                            trailing: Icon(
                                              _categories['care']
                                                  ? Icons.arrow_drop_up
                                                  : Icons.arrow_drop_down,
                                              color: _categories['care']
                                                  ? Theme.of(context)
                                                      .accentColor
                                                  : CustomColors
                                                      .kTabBarIconColor,
                                              size: 30.0,
                                            ),
                                          )
                                        : widget.categoryName == 'Nails'
                                            ? ListTile(
                                                selected: _categories['nails'],
                                                onTap: () {
                                                  setState(() {
                                                    _categories['nails'] =
                                                        !_categories['nails'];
                                                  });
                                                },
                                                title: Text(
                                                  AppLocalization.of(context)
                                                      .translate("Nails"),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: _categories[
                                                              'nails']
                                                          ? Theme.of(context)
                                                              .accentColor
                                                          : CustomColors
                                                              .kTabBarIconColor),
                                                ),
                                                trailing: Icon(
                                                  _categories['nails']
                                                      ? Icons.arrow_drop_up
                                                      : Icons.arrow_drop_down,
                                                  color: _categories['nails']
                                                      ? Theme.of(context)
                                                          .accentColor
                                                      : CustomColors
                                                          .kTabBarIconColor,
                                                  size: 30.0,
                                                ))
                                            : widget.categoryName == 'Lenses'
                                                ? ListTile(
                                                    selected:
                                                        _categories['lenses'],
                                                    onTap: () {
                                                      setState(() {
                                                        _categories['lenses'] =
                                                            !_categories[
                                                                'lenses'];
                                                      });
                                                    },
                                                    title: Text(
                                                      AppLocalization.of(
                                                              context)
                                                          .translate("Lenses"),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: _categories[
                                                                  'lenses']
                                                              ? Theme.of(
                                                                      context)
                                                                  .accentColor
                                                              : CustomColors
                                                                  .kTabBarIconColor),
                                                    ),
                                                    trailing: Icon(
                                                      _categories['lenses']
                                                          ? Icons.arrow_drop_up
                                                          : Icons
                                                              .arrow_drop_down,
                                                      color: _categories[
                                                              'lenses']
                                                          ? Theme.of(context)
                                                              .accentColor
                                                          : CustomColors
                                                              .kTabBarIconColor,
                                                      size: 30.0,
                                                    ),
                                                  )
                                                : ListTile(
                                                    selected:
                                                        _categories['devices'],
                                                    onTap: () {
                                                      setState(() {
                                                        _categories['devices'] =
                                                            !_categories[
                                                                'devices'];
                                                      });
                                                    },
                                                    title: Text(
                                                      AppLocalization.of(
                                                              context)
                                                          .translate("Devices"),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: _categories[
                                                                  'devices']
                                                              ? Theme.of(
                                                                      context)
                                                                  .accentColor
                                                              : CustomColors
                                                                  .kTabBarIconColor),
                                                    ),
                                                    trailing: Icon(
                                                      _categories['devices']
                                                          ? Icons.arrow_drop_up
                                                          : Icons
                                                              .arrow_drop_down,
                                                      color: _categories[
                                                              'devices']
                                                          ? Theme.of(context)
                                                              .accentColor
                                                          : CustomColors
                                                              .kTabBarIconColor,
                                                      size: 30.0,
                                                    )),
                            _categories['makeup']
                                ? Container(
                                    margin: const EdgeInsets.only(
                                        left: 15.0, right: 15.0),
                                    child: Column(children: <Widget>[
                                      ListTile(
                                        onTap: () {
                                          setState(() {
                                            _categories['face'] =
                                                !_categories['face'];
                                          });
                                        },
                                        title: Text(
                                          AppLocalization.of(context)
                                              .translate("face"),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: _categories['face']
                                                  ? Theme.of(context)
                                                      .accentColor
                                                  : CustomColors
                                                      .kTabBarIconColor),
                                        ),
                                        trailing: Icon(
                                            _categories['face']
                                                ? Icons.arrow_drop_up
                                                : Icons.arrow_drop_down,
                                            size: 30.0,
                                            color: _categories['face']
                                                ? Theme.of(context).accentColor
                                                : CustomColors
                                                    .kTabBarIconColor),
                                        selected: _categories['face'],
                                      ),
                                      _categories['face']
                                          ? Container(
                                              margin: const EdgeInsets.only(
                                                  left: 20.0, right: 20.0),
                                              child: Column(children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    Checkbox(
                                                      value: _categories[
                                                          'foundation'],
                                                      onChanged: (val) {
                                                        setState(() {
                                                          _categories[
                                                                  'foundation'] =
                                                              val;

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
                                                      value: _categories[
                                                          'concealer'],
                                                      onChanged: (val) {
                                                        setState(() {
                                                          _categories[
                                                                  'concealer'] =
                                                              val;
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
                                                      value: _categories[
                                                          'highlighter'],
                                                      onChanged: (val) {
                                                        setState(() {
                                                          _categories[
                                                                  'highlighter'] =
                                                              val;
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
                                                      value:
                                                          _categories['powder'],
                                                      onChanged: (val) {
                                                        setState(() {
                                                          _categories[
                                                              'powder'] = val;
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
                                                      value: _categories[
                                                          'faceBrimer'],
                                                      onChanged: (val) {
                                                        setState(() {
                                                          _categories[
                                                                  'faceBrimer'] =
                                                              val;
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
                                                      value: _categories[
                                                          'makeupFixingSpray'],
                                                      onChanged: (val) {
                                                        setState(() {
                                                          _categories[
                                                                  'makeupFixingSpray'] =
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
                                                      value: _categories[
                                                          'bbCcCream'],
                                                      onChanged: (val) {
                                                        setState(() {
                                                          _categories[
                                                                  'bbCcCream'] =
                                                              val;
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
                                            _categories['eyes'] =
                                                !_categories['eyes'];
                                          });
                                        },
                                        title: Text(
                                          AppLocalization.of(context)
                                              .translate("eyes"),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: _categories['eyes']
                                                  ? Theme.of(context)
                                                      .accentColor
                                                  : CustomColors
                                                      .kTabBarIconColor),
                                        ),
                                        trailing: Icon(
                                            _categories['eyes']
                                                ? Icons.arrow_drop_up
                                                : Icons.arrow_drop_down,
                                            size: 30.0,
                                            color: _categories['eyes']
                                                ? Theme.of(context).accentColor
                                                : CustomColors
                                                    .kTabBarIconColor),
                                        selected: _categories['eyes'],
                                      ),
                                      _categories['eyes']
                                          ? Container(
                                              margin: const EdgeInsets.only(
                                                  left: 20.0, right: 20.0),
                                              child: Column(
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        value: _categories[
                                                            'eyeMascara'],
                                                        onChanged: (val) {
                                                          setState(() {
                                                            _categories[
                                                                    'eyeMascara'] =
                                                                val;
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
                                                        value: _categories[
                                                            'eyeShadow'],
                                                        onChanged: (val) {
                                                          setState(() {
                                                            _categories[
                                                                    'eyeShadow'] =
                                                                val;
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
                                                        value: _categories[
                                                            'eyeLiner'],
                                                        onChanged: (val) {
                                                          setState(() {
                                                            _categories[
                                                                    'eyeLiner'] =
                                                                val;
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
                                                        value: _categories[
                                                            'eyeBrimer'],
                                                        onChanged: (val) {
                                                          setState(() {
                                                            _categories[
                                                                    'eyeBrimer'] =
                                                                val;
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
                                                        value: _categories[
                                                            'eyeGlitter'],
                                                        onChanged: (val) {
                                                          setState(() {
                                                            _categories[
                                                                    'eyeGlitter'] =
                                                                val;
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
                                            _categories['lips'] =
                                                !_categories['lips'];
                                          });
                                        },
                                        title: Text(
                                          AppLocalization.of(context)
                                              .translate("lips"),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: _categories['lips']
                                                  ? Theme.of(context)
                                                      .accentColor
                                                  : CustomColors
                                                      .kTabBarIconColor),
                                        ),
                                        trailing: Icon(
                                            _categories['lips']
                                                ? Icons.arrow_drop_up
                                                : Icons.arrow_drop_down,
                                            size: 30.0,
                                            color: _categories['lips']
                                                ? Theme.of(context).accentColor
                                                : CustomColors
                                                    .kTabBarIconColor),
                                        selected: _categories['lips'],
                                      ),
                                      _categories['lips']
                                          ? Container(
                                              margin: const EdgeInsets.only(
                                                  left: 20.0, right: 20.0),
                                              child: Column(
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        value: _categories[
                                                            'lipSet'],
                                                        onChanged: (val) {
                                                          setState(() {
                                                            _categories[
                                                                'lipSet'] = val;
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
                                                        value: _categories[
                                                            'lipGloss'],
                                                        onChanged: (val) {
                                                          setState(() {
                                                            _categories[
                                                                    'lipGloss'] =
                                                                val;
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
                                                        value: _categories[
                                                            'lipLiner'],
                                                        onChanged: (val) {
                                                          setState(() {
                                                            _categories[
                                                                    'lipLiner'] =
                                                                val;
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
                                                        value: _categories[
                                                            'lipStick'],
                                                        onChanged: (val) {
                                                          setState(() {
                                                            _categories[
                                                                    'lipStick'] =
                                                                val;
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
                                            _categories['eyeBrow'] =
                                                !_categories['eyeBrow'];
                                          });
                                        },
                                        title: Text(
                                          AppLocalization.of(context)
                                              .translate("eyebrow"),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: _categories['eyeBrow']
                                                  ? Theme.of(context)
                                                      .accentColor
                                                  : CustomColors
                                                      .kTabBarIconColor),
                                        ),
                                        trailing: Icon(
                                            _categories['eyeBrow']
                                                ? Icons.arrow_drop_up
                                                : Icons.arrow_drop_down,
                                            size: 30.0,
                                            color: _categories['eyeBrow']
                                                ? Theme.of(context).accentColor
                                                : CustomColors
                                                    .kTabBarIconColor),
                                        selected: _categories['eyeBrow'],
                                      ),
                                      _categories['eyeBrow']
                                          ? Container(
                                              margin: const EdgeInsets.only(
                                                  left: 20.0, right: 20.0),
                                              child: Column(
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        value: _categories[
                                                            'eyeBrowMascara'],
                                                        onChanged: (val) {
                                                          setState(() {
                                                            _categories[
                                                                    'eyeBrowMascara'] =
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
                                                        value: _categories[
                                                            'eyeBrowGel'],
                                                        onChanged: (val) {
                                                          setState(() {
                                                            _categories[
                                                                    'eyeBrowGel'] =
                                                                val;
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
                                                        value: _categories[
                                                            'eyeBrowPencil'],
                                                        onChanged: (val) {
                                                          setState(() {
                                                            _categories[
                                                                    'eyeBrowPencil'] =
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
                                            _categories['cheek'] =
                                                !_categories['cheek'];
                                          });
                                        },
                                        title: Text(
                                          AppLocalization.of(context)
                                              .translate("Cheek"),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: _categories['cheek']
                                                  ? Theme.of(context)
                                                      .accentColor
                                                  : CustomColors
                                                      .kTabBarIconColor),
                                        ),
                                        trailing: Icon(
                                            _categories['cheek']
                                                ? Icons.arrow_drop_up
                                                : Icons.arrow_drop_down,
                                            size: 30.0,
                                            color: _categories['cheek']
                                                ? Theme.of(context).accentColor
                                                : CustomColors
                                                    .kTabBarIconColor),
                                        selected: _categories['cheek'],
                                      ),
                                      _categories['cheek']
                                          ? Container(
                                              margin: const EdgeInsets.only(
                                                  left: 20.0, right: 20.0),
                                              child: Column(
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        value: _categories[
                                                            'cheekContour'],
                                                        onChanged: (val) {
                                                          setState(() {
                                                            _categories[
                                                                    'cheekContour'] =
                                                                val;
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
                                                        value: _categories[
                                                            'cheekBlusher'],
                                                        onChanged: (val) {
                                                          setState(() {
                                                            _categories[
                                                                    'cheekBlusher'] =
                                                                val;
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
                                            _categories['makeupBrushesTools'] =
                                                !_categories[
                                                    'makeupBrushesTools'];
                                          });
                                        },
                                        title: Text(
                                          AppLocalization.of(context).translate(
                                              "makeup_brushes_tools"),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: _categories[
                                                      'makeupBrushesTools']
                                                  ? Theme.of(context)
                                                      .accentColor
                                                  : CustomColors
                                                      .kTabBarIconColor),
                                        ),
                                        trailing: Icon(
                                            _categories['makeupBrushesTools']
                                                ? Icons.arrow_drop_up
                                                : Icons.arrow_drop_down,
                                            size: 30.0,
                                            color: _categories[
                                                    'makeupBrushesTools']
                                                ? Theme.of(context).accentColor
                                                : CustomColors
                                                    .kTabBarIconColor),
                                        selected:
                                            _categories['makeupBrushesTools'],
                                      ),
                                      _categories['makeupBrushesTools']
                                          ? Container(
                                              margin: const EdgeInsets.only(
                                                  left: 20.0, right: 20.0),
                                              child: Column(
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        value: _categories[
                                                            'eyeBrushes'],
                                                        onChanged: (val) {
                                                          setState(() {
                                                            _categories[
                                                                    'eyeBrushes'] =
                                                                val;
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
                                                        value: _categories[
                                                            'faceBrushes'],
                                                        onChanged: (val) {
                                                          setState(() {
                                                            _categories[
                                                                    'faceBrushes'] =
                                                                val;
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
                                                        value: _categories[
                                                            'eyeBrowBrushes'],
                                                        onChanged: (val) {
                                                          setState(() {
                                                            _categories[
                                                                    'eyeBrowBrushes'] =
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
                                                        value: _categories[
                                                            'makeupRemover'],
                                                        onChanged: (val) {
                                                          setState(() {
                                                            _categories[
                                                                    'makeupRemover'] =
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
                            _categories['perfume']
                                ? Container(
                                    margin: const EdgeInsets.only(
                                        left: 15.0, right: 15.0),
                                    child: Column(children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Checkbox(
                                            value: _categories['womenPerfume'],
                                            onChanged: (val) {
                                              setState(() {
                                                _categories['womenPerfume'] =
                                                    val;
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
                                            value: _categories['menPerfume'],
                                            onChanged: (val) {
                                              setState(() {
                                                _categories['menPerfume'] = val;
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
                                            value: _categories['unisexPerfume'],
                                            onChanged: (val) {
                                              setState(() {
                                                _categories['unisexPerfume'] =
                                                    val;
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
//                                      Row(
//                                        children: <Widget>[
//                                          Checkbox(
//                                            value: _nichePerfume,
//                                            onChanged: (val) {
//                                              setState(() {
//                                                _nichePerfume = val;
//                                              });
//                                              _populateFilterBody(
//                                                  'Niche Perfumes', val);
//                                            },
//                                          ),
//                                          Text(
//                                            AppLocalization.of(context)
//                                                .translate("Niche Perfumes"),
//                                          ),
//                                        ],
//                                      ),
                                      Row(
                                        children: <Widget>[
                                          Checkbox(
                                            value: _categories['hairMist'],
                                            onChanged: (val) {
                                              setState(() {
                                                _categories['hairMist'] = val;
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
                            _categories['care']
                                ? Container(
                                    margin: const EdgeInsets.only(
                                        left: 15.0, right: 15.0),
                                    child: Column(children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Checkbox(
                                            value: _categories['careTool'],
                                            onChanged: (val) {
                                              setState(() {
                                                _categories['careTool'] = val;
                                              });
                                              _populateFilterBody(
                                                  'Lips Care', val);
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
                                            value: _categories['careLip'],
                                            onChanged: (val) {
                                              setState(() {
                                                _categories['careLip'] = val;
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
                                            value: _categories['careHand'],
                                            onChanged: (val) {
                                              setState(() {
                                                _categories['careHand'] = val;
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
                                            value: _categories['careFace'],
                                            onChanged: (val) {
                                              setState(() {
                                                _categories['careFace'] = val;
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
                                            value: _categories['careHair'],
                                            onChanged: (val) {
                                              setState(() {
                                                _categories['careHair'] = val;
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
                                            value: _categories['careBody'],
                                            onChanged: (val) {
                                              setState(() {
                                                _categories['careBody'] = val;
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
                            _categories['nails']
                                ? Container(
                                    margin: const EdgeInsets.only(
                                        left: 15.0, right: 15.0),
                                    child: Column(children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Checkbox(
                                            value: _categories['nailPolish'],
                                            onChanged: (val) {
                                              setState(() {
                                                _categories['nailPolish'] = val;
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
                                            value: _categories[
                                                'nailPolishRemover'],
                                            onChanged: (val) {
                                              setState(() {
                                                _categories[
                                                    'nailPolishRemover'] = val;
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
                                            value: _categories['nailTool'],
                                            onChanged: (val) {
                                              setState(() {
                                                _categories['nailTool'] = val;
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
                                            value: _categories['nailCare'],
                                            onChanged: (val) {
                                              setState(() {
                                                _categories['nailCare'] = val;
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
                            _categories['lenses']
                                ? Container(
                                    margin: const EdgeInsets.only(
                                        left: 15.0, right: 15.0),
                                    child: Column(children: <Widget>[
//                                      Row(
//                                        children: <Widget>[
//                                          Checkbox(
//                                            value: _pureness,
//                                            onChanged: (val) {
//                                              setState(() {
//                                                _pureness = val;
//                                              });
//                                              _populateFilterBody(
//                                                  'Pureness', val);
//                                            },
//                                          ),
//                                          Text(
//                                            AppLocalization.of(context)
//                                                .translate("Pureness"),
//                                          ),
//                                        ],
//                                      ),
//                                      Row(
//                                        children: <Widget>[
//                                          Checkbox(
//                                            value: _bella,
//                                            onChanged: (val) {
//                                              setState(() {
//                                                _bella = val;
//                                              });
//                                              _populateFilterBody('Bella', val);
//                                            },
//                                          ),
//                                          Text(
//                                            AppLocalization.of(context)
//                                                .translate("Bella"),
//                                          ),
//                                        ],
//                                      ),
                                      Row(
                                        children: <Widget>[
                                          Checkbox(
                                            value: _categories['diva'],
                                            onChanged: (val) {
                                              setState(() {
                                                _categories['diva'] = val;
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
//                                      Row(
//                                        children: <Widget>[
//                                          Checkbox(
//                                            value: _beauteous,
//                                            onChanged: (val) {
//                                              setState(() {
//                                                _beauteous = val;
//                                              });
//                                              _populateFilterBody(
//                                                  'Beauteous', val);
//                                            },
//                                          ),
//                                          Text(
//                                            AppLocalization.of(context)
//                                                .translate("Beauteous"),
//                                          ),
//                                        ],
//                                      ),
                                      Row(
                                        children: <Widget>[
                                          Checkbox(
                                            value: _categories['lensme'],
                                            onChanged: (val) {
                                              setState(() {
                                                _categories['lensme'] = val;
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
//                                      Row(
//                                        children: <Widget>[
//                                          Checkbox(
//                                            value: _solutionForLenses,
//                                            onChanged: (val) {
//                                              setState(() {
//                                                _solutionForLenses = val;
//                                              });
//                                              _populateFilterBody(
//                                                  'Solution For Lenses', val);
//                                            },
//                                          ),
//                                          Text(
//                                            AppLocalization.of(context)
//                                                .translate(
//                                                    "Solution For Lenses"),
//                                          ),
//                                        ],
//                                      ),
                                    ]),
                                  )
                                : Container(),
                            _categories['devices']
                                ? Container(
                                    margin: const EdgeInsets.only(
                                        left: 15.0, right: 15.0),
                                    child: Column(children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Checkbox(
                                            value: _categories['hairDevice'],
                                            onChanged: (val) {
                                              setState(() {
                                                _categories['hairDevice'] = val;
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
                                            value: _categories['bodyDevice'],
                                            onChanged: (val) {
                                              setState(() {
                                                _categories['bodyDevice'] = val;
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
                                            value: _categories['faceDevice'],
                                            onChanged: (val) {
                                              setState(() {
                                                _categories['faceDevice'] = val;
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
                            onTap: _categories['isLoading']
                                ? null
                                : () {
                                    setState(() {
                                      _categories['isLoading'] = true;
                                      _flags['pageNumberOrdered'] = 1;
                                      _products.clear();
                                      _categories['isFilteredData'] = true;
                                    });

//                                    print('index :$pageNumberOrdered');
//                                    print('is filterd :$_isFilteredData');
                                    _doFilter(_flags['pageNumberOrdered']);
                                    Navigator.of(context).pop();
//                             _checkInternetConnection();
                                  },
                            child: _categories['isLoading']
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
                                _categories['foundation'] = false;
                                _categories['concealer'] = false;
                                _categories['powder'] = false;
                                _categories['faceBrimer'] = false;
                                _categories['makeupFixingSpray'] = false;
                                _categories['bbCcCream'] = false;
                                _categories['eyeMascara'] = false;
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

  _showEmptyCartPopup(BuildContext context) async {
    return showModalBottomSheet(
        context: context,
        backgroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0))),
        builder: (context) {
          return Container(
            height: 90.0,
            child: Center(
              child: Text(AppLocalization.of(context).translate("empty_cart")),
            ),
          );
        });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_categories['isInti']) {
      getProductsData(_flags['pageNumber']);
    }
    _categories['isInti'] = false;
  }

  getProductsData(int pageNumber) async {
    final String lang = appLanguage.appLocal.toString();
    setState(() {
      pageNumber > 1
          ? _categories['seeMoreLoading'] = true
          : _categories['isLoading'] = true;
    });
    var userData = await userProvider.isAuthenticated();
    Provider.of<ProductsProvider>(context, listen: false)
        .allDataInSpecificCategory(
            widget.subCategoryName == ''
                ? widget.categoryName
                : widget.subCategoryName,
            lang,
            pageNumber,
            userData['Authorization'])
        .then((products) {
      if (products != null) {
        var list = products['data'] as List;
        _products.addAll(List<ProductsModel>.from(list));
        _flags['lastPage'] = products['last_page'];
      }
      print('call product num $pageNumber and lenght is ${_products.length}');
      setState(() {
        _categories['loaded'] = false;
        _categories['isLoading'] = false;
        _categories['seeMoreLoading'] = false;
        _categories['isFilteredData'] = false;
      });
    });
  }

  loadMore() async {
    if (_categories['isFilteredData']) {
//      print('order page num is $pageNumberOrdered and last page is $lastPage');
      _flags['pageNumberOrdered']++;
      if (_isFrom == 'filter') {
        print(_isFrom);
        if (_flags['pageNumberOrdered'] <= _flags['lastPageFiltered']) {
          _doFilter(_flags['pageNumberOrdered']);
        }
      } else if (_isFrom == 'sort') {
        print(_isFrom);
        if (_flags['pageNumberOrdered'] <= _flags['lastPageFiltered']) {
          _doSort(_flags['pageNumberOrdered']);
        }
      }
    } else {
//      print('else execute  , last page : $lastPage');
      _flags['pageNumber']++;
      if (_flags['pageNumber'] <= _flags['lastPage'])
        getProductsData(_flags['pageNumber']);
    }
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      double _maxScroll = _controller.position.maxScrollExtent;
      double _currentScroll = _controller.position.pixels;
      double _delta = _maxScroll * 0.20 / _flags['pageNumberOrdered'];
      if (_maxScroll - _currentScroll <= _delta) {
        if (_categories['loaded'] == false) {
          _categories['loaded'] = true;
          loadMore();
//          print('max is ; $_maxScroll and current is : $_currentScroll');
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  ScreenConfig screenConfig;
  WidgetSize widgetSize;
  @override
  Widget build(BuildContext context) {
    screenConfig = ScreenConfig(context);
    widgetSize = WidgetSize(screenConfig);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalization.of(context).translate(widget.subCategoryName != ''
              ? "${widget.subCategoryName}"
              : '${widget.categoryName}'),
          style: TextStyle(fontSize: widgetSize.mainTitle),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: SearchProduct());
            },
          ),
          Consumer<CartItemProvider>(
              builder: (ctx, cart, _) => IconButton(
                    onPressed: () {
                      cart.cartItems.length > 0
                          ? showModalBottomSheet(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(16.0),
                                      topRight: Radius.circular(16.0))),
                              context: context,
                              backgroundColor: Theme.of(context).primaryColor,
                              builder: (context) => CartScreen())
                          : _showEmptyCartPopup(context);
                    },
                    icon: Stack(
                      children: <Widget>[
                        Image.asset(
                          'assets/icons/cart.png',
                          width: 20.0,
                          height: 25.0,
                          fit: BoxFit.fill,
                        ),
                        Positioned(
                          top: 11.0,
                          bottom: 4.0,
                          child: Container(
                            margin: cart.allItemQuantity > 9
                                ? const EdgeInsets.symmetric(
                                    horizontal: 4.0,
                                  )
                                : const EdgeInsets.symmetric(horizontal: 6.0),
                            child: Text(
                              '${cart.allItemQuantity > 9 ? '9+' : cart.allItemQuantity == 0 ? '' : cart.allItemQuantity}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 11.0,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
        ],
      ),
      body: _categories['isLoading']
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
                          _categories['seeMoreLoading']
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

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}
