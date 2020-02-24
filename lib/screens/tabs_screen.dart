import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topstyle/constants/colors.dart';
import 'package:topstyle/helper/appLocalization.dart';
import 'package:topstyle/helper/size_config.dart';
import 'package:topstyle/models/cart_item_model.dart';
import 'package:topstyle/providers/cart_provider.dart';
import 'package:topstyle/providers/languages_provider.dart';
import 'package:topstyle/providers/network_provider.dart';
import 'package:topstyle/providers/user_provider.dart';
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

  int num = 10;

  _buildBottomNavigationBarItem(IconData icon, String title) {
    return BottomNavigationBarItem(
        icon: Icon(
          icon,
          size: 26,
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

  List<CartItemModel> _lists = [];
  UserProvider userProvider = UserProvider();
  double totalPrice = 0.0;
  getCartData() async {
    var token = await userProvider.isAuthenticated();
    final String lang = appLanguage.appLocal.toString();
    await Provider.of<CartItemProvider>(context)
        .fetchAllCartItem(lang, token['Authorization']);
  }

  @override
  void didChangeDependencies() {
    getCartData();
    super.didChangeDependencies();
  }

  bool _isInitialized = false;
  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      screenConfig = ScreenConfig(context);
      widgetSize = WidgetSize(screenConfig);
      _isInitialized = true;
    }

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
                icon: Stack(
                  overflow: Overflow.visible,
                  children: [
                    Image.asset(
                      'assets/icons/cart.png',
                      width: 20.0,
                      height: 25.0,
                      fit: BoxFit.fill,
                      color: _selectedIndex == 2
                          ? Theme.of(context).accentColor
                          : CustomColors.kTabBarIconColor,
                    ),
                    Positioned(
                      top: 11.0,
                      bottom: 4.0,
//                      left: 2.0,
//                      right: 7.0,
                      child: Consumer<CartItemProvider>(
                        builder: (ctx, cart, _) => Container(
                          margin: cart.allItemQuantity > 9
                              ? const EdgeInsets.symmetric(
                                  horizontal: 4.0,
                                )
                              : const EdgeInsets.symmetric(horizontal: 6.0),
                          child: Text(
                            '${cart.allItemQuantity > 9 ? '9+' : cart.allItemQuantity == 0 ? '' : cart.allItemQuantity}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 11.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
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
