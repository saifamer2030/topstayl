import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topstyle/constants/colors.dart';
import 'package:topstyle/helper/appLocalization.dart';
import 'package:topstyle/helper/size_config.dart';
import 'package:topstyle/providers/languages_provider.dart';
import 'package:topstyle/providers/network_provider.dart';
import 'package:topstyle/screens/search_screen.dart';
import 'package:topstyle/widgets/connectivity_widget.dart';

import '../screens/brands_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/categories_screen.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';

class TabsScreen extends StatefulWidget {
  static const String routeName = 'tabs';

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  final List<Map<String, Object>> _mainPages = [
    {'page': HomeScreen(), 'title_en': 'Top Style', 'title_ar': "توب ستايل"},
    {
      'page': CategoriesScreen(),
      'title_en': 'Categories',
      'title_ar': "الاقسام"
    },
    {'page': CartScreen(), 'title_en': 'Shopping Cart', 'title_ar': 'السلة'},
    {'page': BrandsScreen(), 'title_en': 'Brands', 'title_ar': "الماركات"},
    {'page': ProfileScreen(), 'title_en': 'My Profile', 'title_ar': "حسابي"}
  ];

  int _selectedIndex = 0;

  void _selectedPage(int currentIndex) {
    setState(() {
      _selectedIndex = currentIndex;
    });
  }

  _buildBottomNavigationBarItem(IconData icon, String title) {
    return BottomNavigationBarItem(
        icon: Icon(
          icon,
        ),
        title: FittedBox(
          child: Text(
            title,
            style: TextStyle(fontSize: widgetSize.iconText),
          ),
        ));
  }

  AppLanguageProvider appLanguage = AppLanguageProvider();
  ScreenConfig screenConfig;
  WidgetSize widgetSize;

  @override
  Widget build(BuildContext context) {
    screenConfig = ScreenConfig(context);
    widgetSize = WidgetSize(screenConfig);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appLanguage.fetchLocale().toString() != 'en'
              ? _mainPages[_selectedIndex]['title_ar']
              : _mainPages[_selectedIndex]['title_en'],
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: widgetSize.mainTitle),
        ),
        centerTitle: true,
        elevation: 4.0,
        actions: <Widget>[
          _selectedIndex == 0 || _selectedIndex == 1 || _selectedIndex == 3
              ? IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    showSearch(context: context, delegate: SearchProduct());
                  },
                )
              : Container(),
        ],
      ),
      body: Provider<NetworkProvider>.value(
        value: NetworkProvider(),
        child: Consumer<NetworkProvider>(
          builder: (context, value, _) => Center(
              child: ConnectivityWidget(
            networkProvider: value,
            child: _mainPages[_selectedIndex]['page'],
          )),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: Offset(1, -2),
              blurRadius: 10.0),
        ]),
        child: BottomNavigationBar(
          onTap: _selectedPage,
          backgroundColor: Colors.white,
          selectedItemColor: Theme.of(context).accentColor,
          unselectedItemColor: CustomColors.kTabBarIconColor,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
          currentIndex: _selectedIndex,
          items: [
            _buildBottomNavigationBarItem(CupertinoIcons.home,
                AppLocalization.of(context).translate("home_in_nav_bar")),
            _buildBottomNavigationBarItem(Icons.format_list_bulleted,
                AppLocalization.of(context).translate("category_in_nav_bar")),
            BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/icons/cart.png',
                  width: 22.0,
                  height: 24.0,
                  fit: BoxFit.fitHeight,
                  color: _selectedIndex == 2
                      ? Theme.of(context).accentColor
                      : CustomColors.kTabBarIconColor,
                ),
                // ),
                // Badge(child: Image.asset('assets/icons/cart.png'), value: ''),
                title: Text(
                  AppLocalization.of(context).translate("cart_in_nav_bar"),
                  style: TextStyle(fontSize: 13.0),
                )),
            _buildBottomNavigationBarItem(CupertinoIcons.tag,
                AppLocalization.of(context).translate("brand_in_nav_bar")),
            _buildBottomNavigationBarItem(CupertinoIcons.profile_circled,
                AppLocalization.of(context).translate("profile_in_nav_bar")),
          ],
        ),
      ),
    );
  }
}
