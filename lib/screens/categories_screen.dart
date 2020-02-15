import 'package:flutter/material.dart';
import 'package:topstyle/helper/appLocalization.dart';
import 'package:topstyle/helper/size_config.dart';
import 'package:topstyle/screens/see_more_screen.dart';

import '../constants/colors.dart';
import '../widgets/category_item.dart';

class CategoriesScreen extends StatefulWidget {
  static const String routeName = 'categories';

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  bool _isMakeupActive = true;
  bool _isPerfumeActive = false;
  bool _isCareActive = false;
  bool _isNailsActive = false;
  bool _isLensesActive = false;
  bool _isDevicesActive = false;

  bool _face = false,
      _lips = false,
      _eyes = false,
      _eyeBrow = false,
      _cheek = false,
      _highlighter = false,
      _brushes = false,
      _makeupBrushesTools = false;

  ScreenConfig screenConfig;
  WidgetSize widgetSize;

  @override
  Widget build(BuildContext context) {
    screenConfig = ScreenConfig(context);
    widgetSize = WidgetSize(screenConfig);
    return Column(
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
                  size: _isMakeupActive ? 100.0 : 80,
                  categoryName: AppLocalization.of(context).translate('Makeup'),
                  action: () {
                    setState(() {
                      _isMakeupActive = true;
                      _isPerfumeActive = false;
                      _isCareActive = false;
                      _isNailsActive = false;
                      _isLensesActive = false;
                      _isDevicesActive = false;
                    });
                  }),
              CategoryItem(
                  color: CustomColors.kCategoryColor2,
                  icon: 'assets/icons/perfume.png',
                  size: _isPerfumeActive ? 100.0 : 80.0,
                  categoryName:
                      AppLocalization.of(context).translate('Perfume'),
                  action: () {
                    setState(() {
                      _isMakeupActive = false;
                      _isPerfumeActive = true;
                      _isCareActive = false;
                      _isNailsActive = false;
                      _isLensesActive = false;
                      _isDevicesActive = false;
                    });
                  }),
              CategoryItem(
                  color: CustomColors.kCategoryColor3,
                  icon: 'assets/icons/care.png',
                  size: _isCareActive ? 100.0 : 80.0,
                  categoryName: AppLocalization.of(context).translate('Care'),
                  action: () {
                    setState(() {
                      _isMakeupActive = false;
                      _isPerfumeActive = false;
                      _isCareActive = true;
                      _isNailsActive = false;
                      _isLensesActive = false;
                      _isDevicesActive = false;
                    });
                  }),
              CategoryItem(
                  color: CustomColors.kCategoryColor4,
                  icon: 'assets/icons/nails.png',
                  size: _isNailsActive ? 100.0 : 80.0,
                  categoryName: AppLocalization.of(context).translate('Nails'),
                  action: () {
                    setState(() {
                      _isMakeupActive = false;
                      _isPerfumeActive = false;
                      _isCareActive = false;
                      _isNailsActive = true;
                      _isLensesActive = false;
                      _isDevicesActive = false;
                    });
                  }),
              CategoryItem(
                  color: CustomColors.kCategoryColor5,
                  icon: 'assets/icons/device.png',
                  size: _isDevicesActive ? 100.0 : 80.0,
                  categoryName:
                      AppLocalization.of(context).translate('Devices'),
                  action: () {
                    setState(() {
                      _isMakeupActive = false;
                      _isPerfumeActive = false;
                      _isCareActive = false;
                      _isNailsActive = false;
                      _isLensesActive = false;
                      _isDevicesActive = true;
                    });
                  }),
              CategoryItem(
                  color: CustomColors.kCategoryColor6,
                  icon: 'assets/icons/lensess.png',
                  size: _isLensesActive ? 100.0 : 80.0,
                  categoryName: AppLocalization.of(context).translate('Lenses'),
                  action: () {
                    setState(() {
                      _isMakeupActive = false;
                      _isPerfumeActive = false;
                      _isCareActive = false;
                      _isNailsActive = false;
                      _isLensesActive = true;
                      _isDevicesActive = false;
                    });
                  }),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            children: <Widget>[
              _isMakeupActive
                  ? Container(
                      margin: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Column(children: <Widget>[
                        ListTile(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => SeeMoreScreen(
                                    categoryName: 'Makeup',
                                    subCategoryName: ''),
                              ),
                            );
                          },
                          title: Text(
                            AppLocalization.of(context)
                                .translate("all_products"),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: CustomColors.kTabBarIconColor,
                                fontSize: widgetSize.subTitle),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios,
                              size: widgetSize.subTitle,
                              color: CustomColors.kTabBarIconColor),
                        ),
                        Divider(
                          height: 1.0,
                          color: CustomColors.kPCardColor,
                          thickness: 1.0,
                        ),
                        ListTile(
                          onTap: () {
                            setState(() {
                              _face = !_face;
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
                              _face
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              size: widgetSize.subTitle + 10,
                              color: CustomColors.kTabBarIconColor),
                          selected: _face,
                        ),
                        Divider(
                          height: 1.0,
                          color: CustomColors.kPCardColor,
                          thickness: 1.0,
                        ),
                        _face
                            ? Container(
                                margin: const EdgeInsets.only(
                                    left: 20.0, right: 20.0),
                                child: Column(children: <Widget>[
                                  ListTile(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => SeeMoreScreen(
                                              categoryName: 'Makeup',
                                              subCategoryName: 'Foundation'),
                                        ),
                                      );
                                    },
                                    title: Text(
                                      AppLocalization.of(context)
                                          .translate("Foundation"),
                                      style: TextStyle(
                                          fontSize: widgetSize.subTitle),
                                    ),
                                  ),
                                  Divider(
                                    height: 1.0,
                                    color: CustomColors.kPCardColor,
                                    thickness: 1.0,
                                  ),
                                  ListTile(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => SeeMoreScreen(
                                              categoryName: 'Makeup',
                                              subCategoryName: 'Concealer'),
                                        ),
                                      );
                                    },
                                    title: Text(
                                      AppLocalization.of(context)
                                          .translate("Concealer"),
                                      style: TextStyle(
                                          fontSize: widgetSize.subTitle),
                                    ),
                                  ),
                                  Divider(
                                    height: 1.0,
                                    color: CustomColors.kPCardColor,
                                    thickness: 1.0,
                                  ),
                                  ListTile(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => SeeMoreScreen(
                                              categoryName: 'Makeup',
                                              subCategoryName: 'Highlighter'),
                                        ),
                                      );
                                    },
                                    title: Text(
                                      AppLocalization.of(context)
                                          .translate("Highlighter"),
                                      style: TextStyle(
                                          fontSize: widgetSize.subTitle),
                                    ),
                                  ),
                                  Divider(
                                    height: 1.0,
                                    color: CustomColors.kPCardColor,
                                    thickness: 1.0,
                                  ),
                                  ListTile(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => SeeMoreScreen(
                                              categoryName: 'Makeup',
                                              subCategoryName: 'Powder'),
                                        ),
                                      );
                                    },
                                    title: Text(
                                      AppLocalization.of(context)
                                          .translate("Powder"),
                                      style: TextStyle(
                                          fontSize: widgetSize.subTitle),
                                    ),
                                  ),
                                  Divider(
                                    height: 1.0,
                                    color: CustomColors.kPCardColor,
                                    thickness: 1.0,
                                  ),
                                  ListTile(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => SeeMoreScreen(
                                              categoryName: 'Makeup',
                                              subCategoryName: 'Face Brimer'),
                                        ),
                                      );
                                    },
                                    title: Text(
                                      AppLocalization.of(context)
                                          .translate("Face Brimer"),
                                      style: TextStyle(
                                          fontSize: widgetSize.subTitle),
                                    ),
                                  ),
                                  Divider(
                                    height: 1.0,
                                    color: CustomColors.kPCardColor,
                                    thickness: 1.0,
                                  ),
                                  ListTile(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => SeeMoreScreen(
                                              categoryName: 'Makeup',
                                              subCategoryName:
                                                  'Makeup Fixing Spray'),
                                        ),
                                      );
                                    },
                                    title: Text(
                                      AppLocalization.of(context)
                                          .translate("Makeup Fixing Spray"),
                                      style: TextStyle(
                                          fontSize: widgetSize.subTitle),
                                    ),
                                  ),
                                  Divider(
                                    height: 1.0,
                                    color: CustomColors.kPCardColor,
                                    thickness: 1.0,
                                  ),
                                  ListTile(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => SeeMoreScreen(
                                              categoryName: 'Makeup',
                                              subCategoryName:
                                                  'BB And CC Cream'),
                                        ),
                                      );
                                    },
                                    title: Text(
                                      AppLocalization.of(context)
                                          .translate("BB And CC Cream"),
                                      style: TextStyle(
                                          fontSize: widgetSize.subTitle),
                                    ),
                                  ),
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
                              _eyes = !_eyes;
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
                              _eyes
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              size: widgetSize.subTitle + 10,
                              color: CustomColors.kTabBarIconColor),
                          selected: _eyes,
                        ),
                        Divider(
                          height: 1.0,
                          color: CustomColors.kPCardColor,
                          thickness: 1.0,
                        ),
                        _eyes
                            ? Container(
                                margin: const EdgeInsets.only(
                                    left: 20.0, right: 20.0),
                                child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => SeeMoreScreen(
                                                categoryName: 'Makeup',
                                                subCategoryName:
                                                    'BB And CC Cream'),
                                          ),
                                        );
                                      },
                                      title: Text(
                                        AppLocalization.of(context)
                                            .translate("Mascara"),
                                        style: TextStyle(
                                            fontSize: widgetSize.subTitle),
                                      ),
                                    ),
                                    Divider(
                                      height: 1.0,
                                      color: CustomColors.kPCardColor,
                                      thickness: 1.0,
                                    ),
                                    ListTile(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => SeeMoreScreen(
                                                categoryName: 'Makeup',
                                                subCategoryName: 'Eyeshadow'),
                                          ),
                                        );
                                      },
                                      title: Text(
                                        AppLocalization.of(context)
                                            .translate("Eyeshadow"),
                                        style: TextStyle(
                                            fontSize: widgetSize.subTitle),
                                      ),
                                    ),
                                    Divider(
                                      height: 1.0,
                                      color: CustomColors.kPCardColor,
                                      thickness: 1.0,
                                    ),
                                    ListTile(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => SeeMoreScreen(
                                                categoryName: 'Makeup',
                                                subCategoryName: 'Eyeliner'),
                                          ),
                                        );
                                      },
                                      title: Text(
                                        AppLocalization.of(context)
                                            .translate("Eyeliner"),
                                        style: TextStyle(
                                            fontSize: widgetSize.subTitle),
                                      ),
                                    ),
                                    Divider(
                                      height: 1.0,
                                      color: CustomColors.kPCardColor,
                                      thickness: 1.0,
                                    ),
                                    ListTile(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => SeeMoreScreen(
                                                categoryName: 'Makeup',
                                                subCategoryName: 'Brimer'),
                                          ),
                                        );
                                      },
                                      title: Text(
                                        AppLocalization.of(context)
                                            .translate("Brimer"),
                                        style: TextStyle(
                                            fontSize: widgetSize.subTitle),
                                      ),
                                    ),
                                    Divider(
                                      height: 1.0,
                                      color: CustomColors.kPCardColor,
                                      thickness: 1.0,
                                    ),
                                    ListTile(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => SeeMoreScreen(
                                                categoryName: 'Makeup',
                                                subCategoryName: 'Glitter'),
                                          ),
                                        );
                                      },
                                      title: Text(
                                        AppLocalization.of(context)
                                            .translate("Glitter"),
                                        style: TextStyle(
                                            fontSize: widgetSize.subTitle),
                                      ),
                                    ),
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
                              _lips = !_lips;
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
                              _lips
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              size: widgetSize.subTitle + 10,
                              color: CustomColors.kTabBarIconColor),
                          selected: _lips,
                        ),
                        Divider(
                          height: 1.0,
                          color: CustomColors.kPCardColor,
                          thickness: 1.0,
                        ),
                        _lips
                            ? Container(
                                margin: const EdgeInsets.only(
                                    left: 20.0, right: 20.0),
                                child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => SeeMoreScreen(
                                                categoryName: 'Makeup',
                                                subCategoryName: 'Lip Set'),
                                          ),
                                        );
                                      },
                                      title: Text(
                                        AppLocalization.of(context)
                                            .translate("Lip Set"),
                                        style: TextStyle(
                                            fontSize: widgetSize.subTitle),
                                      ),
                                    ),
                                    Divider(
                                      height: 1.0,
                                      color: CustomColors.kPCardColor,
                                      thickness: 1.0,
                                    ),
                                    ListTile(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => SeeMoreScreen(
                                                categoryName: 'Makeup',
                                                subCategoryName: 'Lip Gloss'),
                                          ),
                                        );
                                      },
                                      title: Text(
                                        AppLocalization.of(context)
                                            .translate("Lip Gloss"),
                                        style: TextStyle(
                                            fontSize: widgetSize.subTitle),
                                      ),
                                    ),
                                    Divider(
                                      height: 1.0,
                                      color: CustomColors.kPCardColor,
                                      thickness: 1.0,
                                    ),
                                    ListTile(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => SeeMoreScreen(
                                                categoryName: 'Makeup',
                                                subCategoryName: 'Lip Liner'),
                                          ),
                                        );
                                      },
                                      title: Text(
                                        AppLocalization.of(context)
                                            .translate("Lip Liner"),
                                        style: TextStyle(
                                            fontSize: widgetSize.subTitle),
                                      ),
                                    ),
                                    Divider(
                                      height: 1.0,
                                      color: CustomColors.kPCardColor,
                                      thickness: 1.0,
                                    ),
                                    ListTile(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => SeeMoreScreen(
                                                categoryName: 'Makeup',
                                                subCategoryName: 'Lipstick'),
                                          ),
                                        );
                                      },
                                      title: Text(
                                        AppLocalization.of(context)
                                            .translate("Lipstick"),
                                        style: TextStyle(
                                            fontSize: widgetSize.subTitle),
                                      ),
                                    ),
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
                              _eyeBrow = !_eyeBrow;
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
                              _eyeBrow
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              size: widgetSize.subTitle + 10,
                              color: CustomColors.kTabBarIconColor),
                          selected: _eyeBrow,
                        ),
                        Divider(
                          height: 1.0,
                          color: CustomColors.kPCardColor,
                          thickness: 1.0,
                        ),
                        _eyeBrow
                            ? Container(
                                margin: const EdgeInsets.only(
                                    left: 20.0, right: 20.0),
                                child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => SeeMoreScreen(
                                                categoryName: 'Makeup',
                                                subCategoryName:
                                                    'Eyebrow Mascara'),
                                          ),
                                        );
                                      },
                                      title: Text(
                                        AppLocalization.of(context)
                                            .translate("Eyebrow Mascara"),
                                        style: TextStyle(
                                            fontSize: widgetSize.subTitle),
                                      ),
                                    ),
                                    Divider(
                                      height: 1.0,
                                      color: CustomColors.kPCardColor,
                                      thickness: 1.0,
                                    ),
                                    ListTile(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => SeeMoreScreen(
                                                categoryName: 'Makeup',
                                                subCategoryName:
                                                    'Eyebrow Gel & Powder'),
                                          ),
                                        );
                                      },
                                      title: Text(
                                        AppLocalization.of(context)
                                            .translate("Eyebrow Gel & Powder"),
                                        style: TextStyle(
                                            fontSize: widgetSize.subTitle),
                                      ),
                                    ),
                                    Divider(
                                      height: 1.0,
                                      color: CustomColors.kPCardColor,
                                      thickness: 1.0,
                                    ),
                                    ListTile(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => SeeMoreScreen(
                                                categoryName: 'Makeup',
                                                subCategoryName:
                                                    'Eyebrow Pencil'),
                                          ),
                                        );
                                      },
                                      title: Text(
                                        AppLocalization.of(context)
                                            .translate("Eyebrow Pencil"),
                                        style: TextStyle(
                                            fontSize: widgetSize.subTitle),
                                      ),
                                    ),
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
                              _cheek = !_cheek;
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
                              _cheek
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              size: widgetSize.subTitle + 10,
                              color: CustomColors.kTabBarIconColor),
                          selected: _cheek,
                        ),
                        Divider(
                          height: 1.0,
                          color: CustomColors.kPCardColor,
                          thickness: 1.0,
                        ),
                        _cheek
                            ? Container(
                                margin: const EdgeInsets.only(
                                    left: 20.0, right: 20.0),
                                child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => SeeMoreScreen(
                                                categoryName: 'Makeup',
                                                subCategoryName: 'Contour'),
                                          ),
                                        );
                                      },
                                      title: Text(
                                        AppLocalization.of(context)
                                            .translate("Contour"),
                                        style: TextStyle(
                                            fontSize: widgetSize.subTitle),
                                      ),
                                    ),
                                    Divider(
                                      height: 1.0,
                                      color: CustomColors.kPCardColor,
                                      thickness: 1.0,
                                    ),
                                    ListTile(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => SeeMoreScreen(
                                                categoryName: 'Makeup',
                                                subCategoryName:
                                                    'Cheek Blusher'),
                                          ),
                                        );
                                      },
                                      title: Text(
                                        AppLocalization.of(context)
                                            .translate("Cheek Blusher"),
                                        style: TextStyle(
                                            fontSize: widgetSize.subTitle),
                                      ),
                                    ),
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
                              _makeupBrushesTools = !_makeupBrushesTools;
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
                              _makeupBrushesTools
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              size: widgetSize.subTitle + 10,
                              color: CustomColors.kTabBarIconColor),
                          selected: _makeupBrushesTools,
                        ),
                        Divider(
                          height: 1.0,
                          color: CustomColors.kPCardColor,
                          thickness: 1.0,
                        ),
                        _makeupBrushesTools
                            ? Container(
                                margin: const EdgeInsets.only(
                                    left: 20.0, right: 20.0),
                                child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => SeeMoreScreen(
                                                categoryName: 'Makeup',
                                                subCategoryName: 'Eye Brushes'),
                                          ),
                                        );
                                      },
                                      title: Text(
                                        AppLocalization.of(context)
                                            .translate("Eye Brushes"),
                                        style: TextStyle(
                                            fontSize: widgetSize.subTitle),
                                      ),
                                    ),
                                    Divider(
                                      height: 1.0,
                                      color: CustomColors.kPCardColor,
                                      thickness: 1.0,
                                    ),
                                    ListTile(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => SeeMoreScreen(
                                                categoryName: 'Makeup',
                                                subCategoryName:
                                                    'Face Brushes'),
                                          ),
                                        );
                                      },
                                      title: Text(
                                        AppLocalization.of(context)
                                            .translate("Face Brushes"),
                                        style: TextStyle(
                                            fontSize: widgetSize.subTitle),
                                      ),
                                    ),
                                    Divider(
                                      height: 1.0,
                                      color: CustomColors.kPCardColor,
                                      thickness: 1.0,
                                    ),
                                    ListTile(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => SeeMoreScreen(
                                                categoryName: 'Makeup',
                                                subCategoryName:
                                                    'Eyebrow Brushes'),
                                          ),
                                        );
                                      },
                                      title: Text(
                                        AppLocalization.of(context)
                                            .translate("Eyebrow Brushes"),
                                        style: TextStyle(
                                            fontSize: widgetSize.subTitle),
                                      ),
                                    ),
                                    Divider(
                                      height: 1.0,
                                      color: CustomColors.kPCardColor,
                                      thickness: 1.0,
                                    ),
                                    ListTile(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => SeeMoreScreen(
                                                categoryName: 'Makeup',
                                                subCategoryName:
                                                    'Makeup Remover'),
                                          ),
                                        );
                                      },
                                      title: Text(
                                        AppLocalization.of(context)
                                            .translate("Makeup Remover"),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                      ]))
                  : _isPerfumeActive
                      ? Container(
                          margin:
                              const EdgeInsets.only(left: 15.0, right: 15.0),
                          child: Column(children: <Widget>[
                            ListTile(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => SeeMoreScreen(
                                        categoryName: 'Perfume',
                                        subCategoryName: ''),
                                  ),
                                );
                              },
                              title: Text(
                                AppLocalization.of(context)
                                    .translate("all_products"),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: CustomColors.kTabBarIconColor,
                                    fontSize: widgetSize.subTitle),
                              ),
                              trailing: Icon(Icons.arrow_forward_ios,
                                  size: widgetSize.subTitle,
                                  color: CustomColors.kTabBarIconColor),
                            ),
                            Divider(
                              height: 1.0,
                              color: CustomColors.kPCardColor,
                              thickness: 1.0,
                            ),
                            ListTile(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => SeeMoreScreen(
                                        categoryName: 'Perfume',
                                        subCategoryName: 'Women Perfumes'),
                                  ),
                                );
                              },
                              title: Text(
                                AppLocalization.of(context)
                                    .translate("Women Perfumes"),
                                style: TextStyle(
                                    fontSize: widgetSize.subTitle,
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: Icon(Icons.arrow_forward_ios,
                                  size: widgetSize.subTitle,
                                  color: CustomColors.kTabBarIconColor),
                            ),
                            Divider(
                              height: 1.0,
                              color: CustomColors.kPCardColor,
                              thickness: 1.0,
                            ),
                            ListTile(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => SeeMoreScreen(
                                        categoryName: 'Perfume',
                                        subCategoryName: 'Men Perfumes'),
                                  ),
                                );
                              },
                              title: Text(
                                AppLocalization.of(context)
                                    .translate("Men Perfumes"),
                                style: TextStyle(
                                    fontSize: widgetSize.subTitle,
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: Icon(Icons.arrow_forward_ios,
                                  size: widgetSize.subTitle,
                                  color: CustomColors.kTabBarIconColor),
                            ),
                            Divider(
                              height: 1.0,
                              color: CustomColors.kPCardColor,
                              thickness: 1.0,
                            ),
                            ListTile(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => SeeMoreScreen(
                                        categoryName: 'Perfume',
                                        subCategoryName: 'Unisex Perfumes'),
                                  ),
                                );
                              },
                              title: Text(
                                AppLocalization.of(context)
                                    .translate("Unisex Perfumes"),
                                style: TextStyle(
                                    fontSize: widgetSize.subTitle,
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: Icon(Icons.arrow_forward_ios,
                                  size: widgetSize.subTitle,
                                  color: CustomColors.kTabBarIconColor),
                            ),
                            Divider(
                              height: 1.0,
                              color: CustomColors.kPCardColor,
                              thickness: 1.0,
                            ),
                            ListTile(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => SeeMoreScreen(
                                        categoryName: 'Perfume',
                                        subCategoryName: 'Niche Perfumes'),
                                  ),
                                );
                              },
                              title: Text(
                                AppLocalization.of(context)
                                    .translate("Niche Perfumes"),
                                style: TextStyle(
                                    fontSize: widgetSize.subTitle,
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: Icon(Icons.arrow_forward_ios,
                                  size: widgetSize.subTitle,
                                  color: CustomColors.kTabBarIconColor),
                            ),
                            Divider(
                              height: 1.0,
                              color: CustomColors.kPCardColor,
                              thickness: 1.0,
                            ),
                            ListTile(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => SeeMoreScreen(
                                        categoryName: 'Perfume',
                                        subCategoryName: 'Hair Mist'),
                                  ),
                                );
                              },
                              title: Text(
                                AppLocalization.of(context)
                                    .translate("Hair Mist"),
                                style: TextStyle(
                                    fontSize: widgetSize.subTitle,
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: Icon(Icons.arrow_forward_ios,
                                  size: widgetSize.subTitle,
                                  color: CustomColors.kTabBarIconColor),
                            ),
                            Divider(
                              height: 1.0,
                              color: CustomColors.kPCardColor,
                              thickness: 1.0,
                            ),
                          ]),
                        )
                      : _isCareActive
                          ? Container(
                              margin: const EdgeInsets.only(
                                  left: 15.0, right: 15.0),
                              child: Column(children: <Widget>[
                                ListTile(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => SeeMoreScreen(
                                            categoryName: 'Care',
                                            subCategoryName: ''),
                                      ),
                                    );
                                  },
                                  title: Text(
                                    AppLocalization.of(context)
                                        .translate("all_products"),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: CustomColors.kTabBarIconColor,
                                        fontSize: widgetSize.subTitle),
                                  ),
                                  trailing: Icon(Icons.arrow_forward_ios,
                                      size: widgetSize.subTitle,
                                      color: CustomColors.kTabBarIconColor),
                                ),
                                Divider(
                                  height: 1.0,
                                  color: CustomColors.kPCardColor,
                                  thickness: 1.0,
                                ),
                                ListTile(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => SeeMoreScreen(
                                            categoryName: 'Care',
                                            subCategoryName: 'Lip Care'),
                                      ),
                                    );
                                  },
                                  title: Text(
                                    AppLocalization.of(context)
                                        .translate("Lip Care"),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: widgetSize.subTitle),
                                  ),
                                  trailing: Icon(Icons.arrow_forward_ios,
                                      size: widgetSize.subTitle,
                                      color: CustomColors.kTabBarIconColor),
                                ),
                                Divider(
                                  height: 1.0,
                                  color: CustomColors.kPCardColor,
                                  thickness: 1.0,
                                ),
                                ListTile(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => SeeMoreScreen(
                                            categoryName: 'Care',
                                            subCategoryName: 'Hands Care'),
                                      ),
                                    );
                                  },
                                  title: Text(
                                    AppLocalization.of(context)
                                        .translate("Hands Care"),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: widgetSize.subTitle),
                                  ),
                                  trailing: Icon(Icons.arrow_forward_ios,
                                      size: widgetSize.subTitle,
                                      color: CustomColors.kTabBarIconColor),
                                ),
                                Divider(
                                  height: 1.0,
                                  color: CustomColors.kPCardColor,
                                  thickness: 1.0,
                                ),
                                ListTile(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => SeeMoreScreen(
                                            categoryName: 'Care',
                                            subCategoryName: 'Face Care'),
                                      ),
                                    );
                                  },
                                  title: Text(
                                    AppLocalization.of(context)
                                        .translate("Face Care"),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: widgetSize.subTitle),
                                  ),
                                  trailing: Icon(Icons.arrow_forward_ios,
                                      size: widgetSize.subTitle,
                                      color: CustomColors.kTabBarIconColor),
                                ),
                                Divider(
                                  height: 1.0,
                                  color: CustomColors.kPCardColor,
                                  thickness: 1.0,
                                ),
                                ListTile(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => SeeMoreScreen(
                                            categoryName: 'Care',
                                            subCategoryName:
                                                'Eye And Lash Care'),
                                      ),
                                    );
                                  },
                                  title: Text(
                                    AppLocalization.of(context)
                                        .translate("Eye And Lash Care"),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: widgetSize.subTitle),
                                  ),
                                  trailing: Icon(Icons.arrow_forward_ios,
                                      size: widgetSize.subTitle,
                                      color: CustomColors.kTabBarIconColor),
                                ),
                                Divider(
                                  height: 1.0,
                                  color: CustomColors.kPCardColor,
                                  thickness: 1.0,
                                ),
                                ListTile(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => SeeMoreScreen(
                                            categoryName: 'Care',
                                            subCategoryName: 'Hair Care'),
                                      ),
                                    );
                                  },
                                  title: Text(
                                    AppLocalization.of(context)
                                        .translate("Hair Care"),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: widgetSize.subTitle),
                                  ),
                                  trailing: Icon(Icons.arrow_forward_ios,
                                      size: widgetSize.subTitle,
                                      color: CustomColors.kTabBarIconColor),
                                ),
                                Divider(
                                  height: 1.0,
                                  color: CustomColors.kPCardColor,
                                  thickness: 1.0,
                                ),
                                ListTile(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => SeeMoreScreen(
                                            categoryName: 'Care',
                                            subCategoryName: 'Body Care'),
                                      ),
                                    );
                                  },
                                  title: Text(
                                    AppLocalization.of(context)
                                        .translate("Body Care"),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: widgetSize.subTitle),
                                  ),
                                  trailing: Icon(Icons.arrow_forward_ios,
                                      size: widgetSize.subTitle,
                                      color: CustomColors.kTabBarIconColor),
                                ),
                                Divider(
                                  height: 1.0,
                                  color: CustomColors.kPCardColor,
                                  thickness: 1.0,
                                ),
                              ]),
                            )
                          : _isNailsActive
                              ? Container(
                                  margin: const EdgeInsets.only(
                                      left: 15.0, right: 15.0),
                                  child: Column(children: <Widget>[
                                    ListTile(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => SeeMoreScreen(
                                                categoryName: 'Nails',
                                                subCategoryName: ''),
                                          ),
                                        );
                                      },
                                      title: Text(
                                        AppLocalization.of(context)
                                            .translate("all_products"),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color:
                                                CustomColors.kTabBarIconColor,
                                            fontSize: widgetSize.subTitle),
                                      ),
                                      trailing: Icon(Icons.arrow_forward_ios,
                                          size: widgetSize.subTitle,
                                          color: CustomColors.kTabBarIconColor),
                                    ),
                                    Divider(
                                      height: 1.0,
                                      color: CustomColors.kPCardColor,
                                      thickness: 1.0,
                                    ),
                                    ListTile(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => SeeMoreScreen(
                                                categoryName: 'Nails',
                                                subCategoryName: 'Nail Polish'),
                                          ),
                                        );
                                      },
                                      title: Text(
                                        AppLocalization.of(context)
                                            .translate("Nail Polish"),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: widgetSize.subTitle),
                                      ),
                                      trailing: Icon(Icons.arrow_forward_ios,
                                          size: widgetSize.subTitle,
                                          color: CustomColors.kTabBarIconColor),
                                    ),
                                    Divider(
                                      height: 1.0,
                                      color: CustomColors.kPCardColor,
                                      thickness: 1.0,
                                    ),
                                    ListTile(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => SeeMoreScreen(
                                                categoryName: 'Nails',
                                                subCategoryName:
                                                    'Nail Polish Remover'),
                                          ),
                                        );
                                      },
                                      title: Text(
                                        AppLocalization.of(context)
                                            .translate("Nail Polish Remover"),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: widgetSize.subTitle),
                                      ),
                                      trailing: Icon(Icons.arrow_forward_ios,
                                          size: widgetSize.subTitle,
                                          color: CustomColors.kTabBarIconColor),
                                    ),
                                    Divider(
                                      height: 1.0,
                                      color: CustomColors.kPCardColor,
                                      thickness: 1.0,
                                    ),
                                    ListTile(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => SeeMoreScreen(
                                                categoryName: 'Nails',
                                                subCategoryName: 'Nail Tools'),
                                          ),
                                        );
                                      },
                                      title: Text(
                                        AppLocalization.of(context)
                                            .translate("Nail Tools"),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: widgetSize.subTitle),
                                      ),
                                      trailing: Icon(Icons.arrow_forward_ios,
                                          size: widgetSize.subTitle,
                                          color: CustomColors.kTabBarIconColor),
                                    ),
                                    Divider(
                                      height: 1.0,
                                      color: CustomColors.kPCardColor,
                                      thickness: 1.0,
                                    ),
                                    ListTile(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => SeeMoreScreen(
                                                categoryName: 'Nails',
                                                subCategoryName: 'Nail Care'),
                                          ),
                                        );
                                      },
                                      title: Text(
                                        AppLocalization.of(context)
                                            .translate("Nail Care"),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: widgetSize.subTitle),
                                      ),
                                      trailing: Icon(Icons.arrow_forward_ios,
                                          size: widgetSize.subTitle,
                                          color: CustomColors.kTabBarIconColor),
                                    ),
                                    Divider(
                                      height: 1.0,
                                      color: CustomColors.kPCardColor,
                                      thickness: 1.0,
                                    ),
                                  ]),
                                )
                              : _isDevicesActive
                                  ? Container(
                                      margin: const EdgeInsets.only(
                                          left: 15.0, right: 15.0),
                                      child: Column(children: <Widget>[
                                        ListTile(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SeeMoreScreen(
                                                        categoryName: 'Devices',
                                                        subCategoryName: ''),
                                              ),
                                            );
                                          },
                                          title: Text(
                                            AppLocalization.of(context)
                                                .translate("all_products"),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: CustomColors
                                                    .kTabBarIconColor,
                                                fontSize: widgetSize.subTitle),
                                          ),
                                          trailing: Icon(
                                              Icons.arrow_forward_ios,
                                              size: widgetSize.subTitle,
                                              color: CustomColors
                                                  .kTabBarIconColor),
                                        ),
                                        ListTile(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SeeMoreScreen(
                                                        categoryName: 'Devices',
                                                        subCategoryName:
                                                            'Hair Device'),
                                              ),
                                            );
                                          },
                                          title: Text(
                                            AppLocalization.of(context)
                                                .translate("Hair Device"),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: widgetSize.subTitle),
                                          ),
                                          trailing: Icon(
                                              Icons.arrow_forward_ios,
                                              size: widgetSize.subTitle,
                                              color: CustomColors
                                                  .kTabBarIconColor),
                                        ),
                                        Divider(
                                          height: 1.0,
                                          color: CustomColors.kPCardColor,
                                          thickness: 1.0,
                                        ),
                                        ListTile(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SeeMoreScreen(
                                                        categoryName: 'Devices',
                                                        subCategoryName:
                                                            'Body Device'),
                                              ),
                                            );
                                          },
                                          title: Text(
                                            AppLocalization.of(context)
                                                .translate("Body Device"),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: widgetSize.subTitle),
                                          ),
                                          trailing: Icon(
                                              Icons.arrow_forward_ios,
                                              size: widgetSize.subTitle,
                                              color: CustomColors
                                                  .kTabBarIconColor),
                                        ),
                                        Divider(
                                          height: 1.0,
                                          color: CustomColors.kPCardColor,
                                          thickness: 1.0,
                                        ),
                                        ListTile(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SeeMoreScreen(
                                                        categoryName: 'Devices',
                                                        subCategoryName:
                                                            'Face Device'),
                                              ),
                                            );
                                          },
                                          title: Text(
                                            AppLocalization.of(context)
                                                .translate("Face Device"),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: widgetSize.subTitle),
                                          ),
                                          trailing: Icon(
                                              Icons.arrow_forward_ios,
                                              size: widgetSize.subTitle,
                                              color: CustomColors
                                                  .kTabBarIconColor),
                                        ),
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
                                        ListTile(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SeeMoreScreen(
                                                        categoryName: 'Lenses',
                                                        subCategoryName: ''),
                                              ),
                                            );
                                          },
                                          title: Text(
                                            AppLocalization.of(context)
                                                .translate("all_products"),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: CustomColors
                                                    .kTabBarIconColor,
                                                fontSize: widgetSize.subTitle),
                                          ),
                                          trailing: Icon(
                                              Icons.arrow_forward_ios,
                                              size: widgetSize.subTitle,
                                              color: CustomColors
                                                  .kTabBarIconColor),
                                        ),
                                        ListTile(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SeeMoreScreen(
                                                        categoryName: 'Lenses',
                                                        subCategoryName:
                                                            'Pureness'),
                                              ),
                                            );
                                          },
                                          title: Text(
                                            AppLocalization.of(context)
                                                .translate("Pureness"),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: widgetSize.subTitle),
                                          ),
                                          trailing: Icon(
                                              Icons.arrow_forward_ios,
                                              size: widgetSize.subTitle,
                                              color: CustomColors
                                                  .kTabBarIconColor),
                                        ),
                                        Divider(
                                          height: 1.0,
                                          color: CustomColors.kPCardColor,
                                          thickness: 1.0,
                                        ),
                                        ListTile(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SeeMoreScreen(
                                                        categoryName: 'Lenses',
                                                        subCategoryName:
                                                            'Bella'),
                                              ),
                                            );
                                          },
                                          title: Text(
                                            AppLocalization.of(context)
                                                .translate("Bella"),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: widgetSize.subTitle),
                                          ),
                                          trailing: Icon(
                                              Icons.arrow_forward_ios,
                                              size: widgetSize.subTitle,
                                              color: CustomColors
                                                  .kTabBarIconColor),
                                        ),
                                        Divider(
                                          height: 1.0,
                                          color: CustomColors.kPCardColor,
                                          thickness: 1.0,
                                        ),
                                        ListTile(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SeeMoreScreen(
                                                        categoryName: 'Lenses',
                                                        subCategoryName:
                                                            'Diva'),
                                              ),
                                            );
                                          },
                                          title: Text(
                                            AppLocalization.of(context)
                                                .translate("Diva"),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: widgetSize.subTitle),
                                          ),
                                          trailing: Icon(
                                              Icons.arrow_forward_ios,
                                              size: widgetSize.subTitle,
                                              color: CustomColors
                                                  .kTabBarIconColor),
                                        ),
                                        Divider(
                                          height: 1.0,
                                          color: CustomColors.kPCardColor,
                                          thickness: 1.0,
                                        ),
                                        ListTile(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SeeMoreScreen(
                                                        categoryName: 'Lenses',
                                                        subCategoryName:
                                                            'Beauteous'),
                                              ),
                                            );
                                          },
                                          title: Text(
                                            AppLocalization.of(context)
                                                .translate("Beauteous"),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: widgetSize.subTitle),
                                          ),
                                          trailing: Icon(
                                              Icons.arrow_forward_ios,
                                              size: widgetSize.subTitle,
                                              color: CustomColors
                                                  .kTabBarIconColor),
                                        ),
                                        Divider(
                                          height: 1.0,
                                          color: CustomColors.kPCardColor,
                                          thickness: 1.0,
                                        ),
                                        ListTile(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SeeMoreScreen(
                                                        categoryName: 'Lenses',
                                                        subCategoryName:
                                                            'Lens me'),
                                              ),
                                            );
                                          },
                                          title: Text(
                                            AppLocalization.of(context)
                                                .translate("Lens me"),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: widgetSize.subTitle),
                                          ),
                                          trailing: Icon(
                                              Icons.arrow_forward_ios,
                                              size: widgetSize.subTitle,
                                              color: CustomColors
                                                  .kTabBarIconColor),
                                        ),
                                        Divider(
                                          height: 1.0,
                                          color: CustomColors.kPCardColor,
                                          thickness: 1.0,
                                        ),
                                        ListTile(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SeeMoreScreen(
                                                        categoryName: 'Lenses',
                                                        subCategoryName:
                                                            'Solution For Lenses'),
                                              ),
                                            );
                                          },
                                          title: Text(
                                            AppLocalization.of(context)
                                                .translate(
                                                    "Solution For Lenses"),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: widgetSize.subTitle),
                                          ),
                                          trailing: Icon(
                                              Icons.arrow_forward_ios,
                                              size: widgetSize.subTitle,
                                              color: CustomColors
                                                  .kTabBarIconColor),
                                        ),
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
    );
  }
}
