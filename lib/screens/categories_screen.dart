import 'package:flutter/material.dart';
import 'package:topstyle/helper/appLocalization.dart';
import 'package:topstyle/helper/size_config.dart';
import 'package:topstyle/screens/search_screen.dart';
import 'package:topstyle/screens/see_more_screen.dart';

import '../constants/colors.dart';
import '../widgets/category_item.dart';

class CategoriesScreen extends StatefulWidget {
  static const String routeName = 'categories';

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  Map<String, bool> _categories = {
    'isMakeupActive': true,
    'isPerfumeActive': false,
    'isCareActive': false,
    'isNailsActive': false,
    'isLensesActive': false,
    'isDevicesActive': false,
    'face': false,
    'lips': false,
    'eyes': false,
    'eyeBrow': false,
    'cheek': false,
    'highlighter': false,
    'brushes': false,
    'makeupBrushesTools': false,
  };

  _drawSubCategory(String categoryName, String subCategoryName, String title) {
    return ListTile(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SeeMoreScreen(
                categoryName: categoryName, subCategoryName: subCategoryName),
          ),
        );
      },
      title: Text(
        AppLocalization.of(context).translate(title),
        style: TextStyle(
            fontSize: widgetSize.subTitle, fontWeight: FontWeight.bold),
      ),
      trailing: Icon(Icons.arrow_forward_ios,
          size: widgetSize.subTitle, color: CustomColors.kTabBarIconColor),
    );
  }

  _drawSubSubCategory(
      String categoryName, String subCategoryName, String title) {
    return ListTile(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SeeMoreScreen(
                categoryName: categoryName, subCategoryName: subCategoryName),
          ),
        );
      },
      title: Text(
        AppLocalization.of(context).translate(title),
        style: TextStyle(fontSize: widgetSize.subTitle),
      ),
    );
  }

  ScreenConfig screenConfig;
  WidgetSize widgetSize;

  @override
  Widget build(BuildContext context) {
    screenConfig = ScreenConfig(context);
    widgetSize = WidgetSize(screenConfig);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppLocalization.of(context).translate('category_in_nav_bar'),
          style: TextStyle(
              fontSize: widgetSize.mainTitle, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: SearchProduct());
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            // categories listView  Section
            height: 103,
            margin: const EdgeInsets.only(top: 30.0, bottom: 20.0),
            child: ListView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              padding: const EdgeInsets.only(left: 10.0),
              children: <Widget>[
                CategoryItem(
                    color: CustomColors.kCategoryColor1,
                    icon: 'assets/icons/makeup.png',
                    size: _categories['isMakeupActive'] ? 100.0 : 80,
                    categoryName:
                        AppLocalization.of(context).translate('Makeup'),
                    action: () {
                      setState(() {
                        _categories['isMakeupActive'] = true;
                        _categories['isPerfumeActive'] = false;
                        _categories['isCareActive'] = false;
                        _categories['isNailsActive'] = false;
                        _categories['isLensesActive'] = false;
                        _categories['isDevicesActive'] = false;
                      });
                    }),
                CategoryItem(
                    color: CustomColors.kCategoryColor2,
                    icon: 'assets/icons/perfume.png',
                    size: _categories['isPerfumeActive'] ? 100.0 : 80.0,
                    categoryName:
                        AppLocalization.of(context).translate('Perfume'),
                    action: () {
                      setState(() {
                        _categories['isMakeupActive'] = false;
                        _categories['isPerfumeActive'] = true;
                        _categories['isCareActive'] = false;
                        _categories['isNailsActive'] = false;
                        _categories['isLensesActive'] = false;
                        _categories['isDevicesActive'] = false;
                      });
                    }),
                CategoryItem(
                    color: CustomColors.kCategoryColor3,
                    icon: 'assets/icons/care.png',
                    size: _categories['isCareActive'] ? 100.0 : 80.0,
                    categoryName: AppLocalization.of(context).translate('Care'),
                    action: () {
                      setState(() {
                        _categories['isMakeupActive'] = false;
                        _categories['isPerfumeActive'] = false;
                        _categories['isCareActive'] = true;
                        _categories['isNailsActive'] = false;
                        _categories['isLensesActive'] = false;
                        _categories['isDevicesActive'] = false;
                      });
                    }),
                CategoryItem(
                    color: CustomColors.kCategoryColor4,
                    icon: 'assets/icons/nails.png',
                    size: _categories['isNailsActive'] ? 100.0 : 80.0,
                    categoryName:
                        AppLocalization.of(context).translate('Nails'),
                    action: () {
                      setState(() {
                        _categories['isMakeupActive'] = false;
                        _categories['isPerfumeActive'] = false;
                        _categories['isCareActive'] = false;
                        _categories['isNailsActive'] = true;
                        _categories['isLensesActive'] = false;
                        _categories['isDevicesActive'] = false;
                      });
                    }),
                CategoryItem(
                    color: CustomColors.kCategoryColor5,
                    icon: 'assets/icons/device.png',
                    size: _categories['isDevicesActive'] ? 100.0 : 80.0,
                    categoryName:
                        AppLocalization.of(context).translate('Devices'),
                    action: () {
                      setState(() {
                        _categories['isMakeupActive'] = false;
                        _categories['isPerfumeActive'] = false;
                        _categories['isCareActive'] = false;
                        _categories['isNailsActive'] = false;
                        _categories['isLensesActive'] = false;
                        _categories['isDevicesActive'] = true;
                      });
                    }),
                CategoryItem(
                    color: CustomColors.kCategoryColor6,
                    icon: 'assets/icons/lensess.png',
                    size: _categories['isLensesActive'] ? 100.0 : 80.0,
                    categoryName:
                        AppLocalization.of(context).translate('Lenses'),
                    action: () {
                      setState(() {
                        _categories['isMakeupActive'] = false;
                        _categories['isPerfumeActive'] = false;
                        _categories['isCareActive'] = false;
                        _categories['isNailsActive'] = false;
                        _categories['isLensesActive'] = true;
                        _categories['isDevicesActive'] = false;
                      });
                    }),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                _categories['isMakeupActive']
                    ? Container(
                        margin: const EdgeInsets.only(left: 15.0, right: 15.0),
                        child: Column(children: <Widget>[
                          _drawSubCategory('Makeup', '', 'all_products'),
                          Divider(
                            height: 1.0,
                            color: CustomColors.kPCardColor,
                            thickness: 1.0,
                          ),
                          ListTile(
                            onTap: () {
                              setState(() {
                                _categories['face'] = !_categories['face'];
                              });
                            },
                            title: Text(
                              AppLocalization.of(context).translate("face"),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: CustomColors.kTabBarIconColor,
                                  fontSize: widgetSize.subTitle),
                            ),
                            trailing: Icon(
                                _categories['face']
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                size: widgetSize.subTitle + 10,
                                color: CustomColors.kTabBarIconColor),
                            selected: _categories['face'],
                          ),
                          Divider(
                            height: 1.0,
                            color: CustomColors.kPCardColor,
                            thickness: 1.0,
                          ),
                          _categories['face']
                              ? Container(
                                  margin: const EdgeInsets.only(
                                      left: 20.0, right: 20.0),
                                  child: Column(children: <Widget>[
                                    _drawSubSubCategory(
                                        'Makeup', 'Foundation', 'Foundation'),
                                    Divider(
                                      height: 1.0,
                                      color: CustomColors.kPCardColor,
                                      thickness: 1.0,
                                    ),
                                    _drawSubSubCategory(
                                        'Makeup', 'Concealer', 'Concealer'),
                                    Divider(
                                      height: 1.0,
                                      color: CustomColors.kPCardColor,
                                      thickness: 1.0,
                                    ),
                                    _drawSubSubCategory(
                                        'Makeup', 'Highlighter', 'Highlighter'),
                                    Divider(
                                      height: 1.0,
                                      color: CustomColors.kPCardColor,
                                      thickness: 1.0,
                                    ),
                                    _drawSubSubCategory(
                                        'Makeup', 'Powder', 'Powder'),
                                    Divider(
                                      height: 1.0,
                                      color: CustomColors.kPCardColor,
                                      thickness: 1.0,
                                    ),
                                    _drawSubSubCategory(
                                        'Makeup', 'Face Brimer', 'Face Brimer'),
                                    Divider(
                                      height: 1.0,
                                      color: CustomColors.kPCardColor,
                                      thickness: 1.0,
                                    ),
                                    _drawSubSubCategory(
                                        'Makeup',
                                        'Makeup Fixing Spray',
                                        'Makeup Fixing Spray'),
                                    Divider(
                                      height: 1.0,
                                      color: CustomColors.kPCardColor,
                                      thickness: 1.0,
                                    ),
                                    Divider(
                                      height: 1.0,
                                      color: CustomColors.kPCardColor,
                                      thickness: 1.0,
                                    ),
                                    _drawSubSubCategory('Makeup',
                                        'BB And CC Cream', 'BB And CC Cream'),
                                    Divider(
                                      height: 1.0,
                                      color: CustomColors.kPCardColor,
                                      thickness: 1.0,
                                    ),
                                  ]))
                              : Container(),
                          ListTile(
                            onTap: () {
                              setState(() {
                                _categories['eyes'] = !_categories['eyes'];
                              });
                            },
                            title: Text(
                              AppLocalization.of(context).translate("eyes"),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: CustomColors.kTabBarIconColor,
                                  fontSize: widgetSize.subTitle),
                            ),
                            trailing: Icon(
                                _categories['eyes']
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                size: widgetSize.subTitle + 10,
                                color: CustomColors.kTabBarIconColor),
                            selected: _categories['eyes'],
                          ),
                          Divider(
                            height: 1.0,
                            color: CustomColors.kPCardColor,
                            thickness: 1.0,
                          ),
                          _categories['eyes']
                              ? Container(
                                  margin: const EdgeInsets.only(
                                      left: 20.0, right: 20.0),
                                  child: Column(
                                    children: <Widget>[
                                      _drawSubSubCategory(
                                          'Makeup', 'Mascara', 'Mascara'),
                                      Divider(
                                        height: 1.0,
                                        color: CustomColors.kPCardColor,
                                        thickness: 1.0,
                                      ),
                                      _drawSubSubCategory(
                                          'Makeup', 'Eyeshadow', 'Eyeshadow'),
                                      Divider(
                                        height: 1.0,
                                        color: CustomColors.kPCardColor,
                                        thickness: 1.0,
                                      ),
                                      _drawSubSubCategory(
                                          'Makeup', 'Eyeliner', 'Eyeliner'),
                                      Divider(
                                        height: 1.0,
                                        color: CustomColors.kPCardColor,
                                        thickness: 1.0,
                                      ),
                                      _drawSubSubCategory(
                                          'Makeup', 'Brimer', 'Brimer'),
                                      Divider(
                                        height: 1.0,
                                        color: CustomColors.kPCardColor,
                                        thickness: 1.0,
                                      ),
                                      _drawSubSubCategory(
                                          'Makeup', 'Glitter', 'Glitter'),
                                      Divider(
                                        height: 1.0,
                                        color: CustomColors.kPCardColor,
                                        thickness: 1.0,
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
                          ListTile(
                            onTap: () {
                              setState(() {
                                _categories['lips'] = !_categories['lips'];
                              });
                            },
                            title: Text(
                              AppLocalization.of(context).translate("lips"),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: CustomColors.kTabBarIconColor,
                                  fontSize: widgetSize.subTitle),
                            ),
                            trailing: Icon(
                                _categories['lips']
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                size: widgetSize.subTitle + 10,
                                color: CustomColors.kTabBarIconColor),
                            selected: _categories['lips'],
                          ),
                          Divider(
                            height: 1.0,
                            color: CustomColors.kPCardColor,
                            thickness: 1.0,
                          ),
                          _categories['lips']
                              ? Container(
                                  margin: const EdgeInsets.only(
                                      left: 20.0, right: 20.0),
                                  child: Column(
                                    children: <Widget>[
                                      _drawSubSubCategory(
                                          'Makeup', 'Lip Set', 'Lip Set'),
                                      Divider(
                                        height: 1.0,
                                        color: CustomColors.kPCardColor,
                                        thickness: 1.0,
                                      ),
                                      _drawSubSubCategory(
                                          'Makeup', 'Lip Gloss', 'Lip Gloss'),
                                      Divider(
                                        height: 1.0,
                                        color: CustomColors.kPCardColor,
                                        thickness: 1.0,
                                      ),
                                      _drawSubSubCategory(
                                          'Makeup', 'Lip Liner', 'Lip Liner'),
                                      Divider(
                                        height: 1.0,
                                        color: CustomColors.kPCardColor,
                                        thickness: 1.0,
                                      ),
                                      _drawSubSubCategory(
                                          'Makeup', 'Lipstick', 'Lipstick'),
                                      Divider(
                                        height: 1.0,
                                        color: CustomColors.kPCardColor,
                                        thickness: 1.0,
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
                              AppLocalization.of(context).translate("eyebrow"),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: CustomColors.kTabBarIconColor,
                                  fontSize: widgetSize.subTitle),
                            ),
                            trailing: Icon(
                                _categories['eyeBrow']
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                size: widgetSize.subTitle + 10,
                                color: CustomColors.kTabBarIconColor),
                            selected: _categories['eyeBrow'],
                          ),
                          Divider(
                            height: 1.0,
                            color: CustomColors.kPCardColor,
                            thickness: 1.0,
                          ),
                          _categories['eyeBrow']
                              ? Container(
                                  margin: const EdgeInsets.only(
                                      left: 20.0, right: 20.0),
                                  child: Column(
                                    children: <Widget>[
                                      _drawSubSubCategory('Makeup',
                                          'Eyebrow Mascara', 'Eyebrow Mascara'),
                                      Divider(
                                        height: 1.0,
                                        color: CustomColors.kPCardColor,
                                        thickness: 1.0,
                                      ),
                                      _drawSubSubCategory(
                                          'Makeup',
                                          'Eyebrow Gel & Powder',
                                          'Eyebrow Gel & Powder'),
                                      Divider(
                                        height: 1.0,
                                        color: CustomColors.kPCardColor,
                                        thickness: 1.0,
                                      ),
                                      _drawSubSubCategory('Makeup',
                                          'Eyebrow Pencil', 'Eyebrow Pencil'),
                                      Divider(
                                        height: 1.0,
                                        color: CustomColors.kPCardColor,
                                        thickness: 1.0,
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
                          ListTile(
                            onTap: () {
                              setState(() {
                                _categories['cheek'] = !_categories['cheek'];
                              });
                            },
                            title: Text(
                              AppLocalization.of(context).translate("Cheek"),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: CustomColors.kTabBarIconColor,
                                  fontSize: widgetSize.subTitle),
                            ),
                            trailing: Icon(
                                _categories['cheek']
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                size: widgetSize.subTitle + 10,
                                color: CustomColors.kTabBarIconColor),
                            selected: _categories['cheek'],
                          ),
                          Divider(
                            height: 1.0,
                            color: CustomColors.kPCardColor,
                            thickness: 1.0,
                          ),
                          _categories['cheek']
                              ? Container(
                                  margin: const EdgeInsets.only(
                                      left: 20.0, right: 20.0),
                                  child: Column(
                                    children: <Widget>[
                                      _drawSubSubCategory(
                                          'Makeup', 'Contour', 'Contour'),
                                      Divider(
                                        height: 1.0,
                                        color: CustomColors.kPCardColor,
                                        thickness: 1.0,
                                      ),
                                      _drawSubSubCategory('Makeup',
                                          'Cheek Blusher', 'Cheek Blusher'),
                                      Divider(
                                        height: 1.0,
                                        color: CustomColors.kPCardColor,
                                        thickness: 1.0,
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
                          ListTile(
                            onTap: () {
                              setState(() {
                                _categories['makeupBrushesTools'] =
                                    !_categories['makeupBrushesTools'];
                              });
                            },
                            title: Text(
                              AppLocalization.of(context)
                                  .translate("makeup_brushes_tools"),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: CustomColors.kTabBarIconColor,
                                  fontSize: widgetSize.subTitle),
                            ),
                            trailing: Icon(
                                _categories['makeupBrushesTools']
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                size: widgetSize.subTitle + 10,
                                color: CustomColors.kTabBarIconColor),
                            selected: _categories['makeupBrushesTools'],
                          ),
                          Divider(
                            height: 1.0,
                            color: CustomColors.kPCardColor,
                            thickness: 1.0,
                          ),
                          _categories['makeupBrushesTools']
                              ? Container(
                                  margin: const EdgeInsets.only(
                                      left: 20.0, right: 20.0),
                                  child: Column(
                                    children: <Widget>[
                                      _drawSubSubCategory('Makeup',
                                          'Eye Brushes', 'Eye Brushes'),
                                      Divider(
                                        height: 1.0,
                                        color: CustomColors.kPCardColor,
                                        thickness: 1.0,
                                      ),
                                      _drawSubSubCategory('Makeup',
                                          'Face Brushes', 'Face Brushes'),
                                      Divider(
                                        height: 1.0,
                                        color: CustomColors.kPCardColor,
                                        thickness: 1.0,
                                      ),
                                      _drawSubSubCategory('Makeup',
                                          'Eyebrow Brushes', 'Eyebrow Brushes'),
                                      Divider(
                                        height: 1.0,
                                        color: CustomColors.kPCardColor,
                                        thickness: 1.0,
                                      ),
                                      _drawSubSubCategory('Makeup',
                                          'Makeup Remover', 'Makeup Remover'),
                                      Divider(
                                        height: 1.0,
                                        color: CustomColors.kPCardColor,
                                        thickness: 1.0,
                                      ),
                                      _drawSubSubCategory(
                                          'Makeup', 'Sponges', 'Sponges'),
                                      Divider(
                                        height: 1.0,
                                        color: CustomColors.kPCardColor,
                                        thickness: 1.0,
                                      ),
                                      _drawSubSubCategory('Makeup',
                                          'Brusher Sets', 'Brusher Sets'),
                                    ],
                                  ),
                                )
                              : Container(),
                        ]))
                    : _categories['isPerfumeActive']
                        ? Container(
                            margin:
                                const EdgeInsets.only(left: 15.0, right: 15.0),
                            child: Column(children: <Widget>[
                              _drawSubCategory('Perfume', '', 'all_products'),
                              Divider(
                                height: 1.0,
                                color: CustomColors.kPCardColor,
                                thickness: 1.0,
                              ),
                              _drawSubCategory('Perfume', 'Women Perfumes',
                                  'Women Perfumes'),
                              Divider(
                                height: 1.0,
                                color: CustomColors.kPCardColor,
                                thickness: 1.0,
                              ),
                              _drawSubCategory(
                                  'Perfume', 'Men Perfumes', 'Men Perfumes'),
                              Divider(
                                height: 1.0,
                                color: CustomColors.kPCardColor,
                                thickness: 1.0,
                              ),
                              _drawSubCategory('Perfume', 'Unisex Perfumes',
                                  'Unisex Perfumes'),
                              Divider(
                                height: 1.0,
                                color: CustomColors.kPCardColor,
                                thickness: 1.0,
                              ),
                              _drawSubCategory(
                                  'Perfume', 'Hair Mist', 'Hair Mist'),
                              Divider(
                                height: 1.0,
                                color: CustomColors.kPCardColor,
                                thickness: 1.0,
                              ),
                            ]),
                          )
                        : _categories['isCareActive']
                            ? Container(
                                margin: const EdgeInsets.only(
                                    left: 15.0, right: 15.0),
                                child: Column(children: <Widget>[
                                  _drawSubCategory('Care', '', 'all_products'),
                                  Divider(
                                    height: 1.0,
                                    color: CustomColors.kPCardColor,
                                    thickness: 1.0,
                                  ),
                                  _drawSubCategory(
                                      'Care', 'Lips Care', 'Lips Care'),
                                  Divider(
                                    height: 1.0,
                                    color: CustomColors.kPCardColor,
                                    thickness: 1.0,
                                  ),
                                  _drawSubCategory(
                                      'Care', 'Hands Care', 'Hands Care'),
                                  Divider(
                                    height: 1.0,
                                    color: CustomColors.kPCardColor,
                                    thickness: 1.0,
                                  ),
                                  _drawSubCategory(
                                      'Care', 'Face Care', 'Face Care'),
                                  Divider(
                                    height: 1.0,
                                    color: CustomColors.kPCardColor,
                                    thickness: 1.0,
                                  ),
                                  _drawSubCategory('Care', 'Eye And Lash Care',
                                      'Eye And Lash Care'),
                                  Divider(
                                    height: 1.0,
                                    color: CustomColors.kPCardColor,
                                    thickness: 1.0,
                                  ),
                                  _drawSubCategory(
                                      'Care', 'Hair Care', 'Hair Care'),
                                  Divider(
                                    height: 1.0,
                                    color: CustomColors.kPCardColor,
                                    thickness: 1.0,
                                  ),
                                  _drawSubCategory(
                                      'Care', 'Body Care', 'Body Care'),
                                  Divider(
                                    height: 1.0,
                                    color: CustomColors.kPCardColor,
                                    thickness: 1.0,
                                  ),
                                ]),
                              )
                            : _categories['isNailsActive']
                                ? Container(
                                    margin: const EdgeInsets.only(
                                        left: 15.0, right: 15.0),
                                    child: Column(children: <Widget>[
                                      _drawSubCategory(
                                          'Nails', '', 'all_products'),
                                      Divider(
                                        height: 1.0,
                                        color: CustomColors.kPCardColor,
                                        thickness: 1.0,
                                      ),
                                      _drawSubCategory('Nails', 'Nail Polish',
                                          'Nail Polish'),
                                      Divider(
                                        height: 1.0,
                                        color: CustomColors.kPCardColor,
                                        thickness: 1.0,
                                      ),
                                      _drawSubCategory(
                                          'Nails',
                                          'Nail Polish Remover',
                                          'Nail Polish Remover'),
                                      Divider(
                                        height: 1.0,
                                        color: CustomColors.kPCardColor,
                                        thickness: 1.0,
                                      ),
                                      _drawSubCategory(
                                          'Nails', 'Nail Tools', 'Nail Tools'),
                                      Divider(
                                        height: 1.0,
                                        color: CustomColors.kPCardColor,
                                        thickness: 1.0,
                                      ),
                                      _drawSubCategory(
                                          'Nails', 'Nail Care', 'Nail Care'),
                                      Divider(
                                        height: 1.0,
                                        color: CustomColors.kPCardColor,
                                        thickness: 1.0,
                                      ),
                                    ]),
                                  )
                                : _categories['isDevicesActive']
                                    ? Container(
                                        margin: const EdgeInsets.only(
                                            left: 15.0, right: 15.0),
                                        child: Column(children: <Widget>[
                                          _drawSubCategory(
                                              'Devices', '', 'all_products'),
                                          Divider(
                                            height: 1.0,
                                            color: CustomColors.kPCardColor,
                                            thickness: 1.0,
                                          ),
                                          _drawSubCategory('Devices',
                                              'Hair Device', 'Hair Device'),
                                          Divider(
                                            height: 1.0,
                                            color: CustomColors.kPCardColor,
                                            thickness: 1.0,
                                          ),
                                          _drawSubCategory('Devices',
                                              'Body Device', 'Body Device'),
                                          Divider(
                                            height: 1.0,
                                            color: CustomColors.kPCardColor,
                                            thickness: 1.0,
                                          ),
                                          _drawSubCategory('Devices',
                                              'Face Device', 'Face Device'),
                                          Divider(
                                            height: 1.0,
                                            color: CustomColors.kPCardColor,
                                            thickness: 1.0,
                                          ),
                                        ]),
                                      )
                                    : Container(
                                        margin: const EdgeInsets.only(
                                            left: 15.0, right: 15.0),
                                        child: Column(children: <Widget>[
                                          _drawSubCategory(
                                              'Lenses', '', 'all_products'),
                                          Divider(
                                            height: 1.0,
                                            color: CustomColors.kPCardColor,
                                            thickness: 1.0,
                                          ),
                                          _drawSubCategory(
                                              'Lenses', 'Diva', 'Diva'),
                                          Divider(
                                            height: 1.0,
                                            color: CustomColors.kPCardColor,
                                            thickness: 1.0,
                                          ),
                                          _drawSubCategory(
                                              'Lenses', 'Lens me', 'Lens me'),
                                          Divider(
                                            height: 1.0,
                                            color: CustomColors.kPCardColor,
                                            thickness: 1.0,
                                          ),
                                        ]),
                                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
