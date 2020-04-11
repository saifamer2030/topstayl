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

class _TabsScreenState extends State<TabsScreen>
    with SingleTickerProviderStateMixin {
  List<Widget> _mainPages = [
    HomeScreen(),
    CategoriesScreen(),
    CartScreen(),
    BrandsScreen(),
    ProfileScreen()
  ];

  AppLanguageProvider appLanguage = AppLanguageProvider();
  ScreenConfig screenConfig;
  WidgetSize widgetSize;
  TabController _tabController;
  int _selectedIndex = 0;

  List<CartItemModel> _lists = [];
  UserProvider userProvider = UserProvider();
  double totalPrice = 0.0;
  getCartData() async {
    var token = await userProvider.isAuthenticated();
    final String lang = appLanguage.appLocal.toString();
    await Provider.of<CartItemProvider>(context, listen: false)
        .fetchAllCartItem(lang, token['Authorization']);
  }

  @override
  void initState() {
    _tabController = new TabController(vsync: this, length: 5, initialIndex: 0);
    getCartData();
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Tab> _listOfTabs(BuildContext context) {
    final List<Tab> _tabs = [
      Tab(
        text: AppLocalization.of(context).translate("home_in_nav_bar"),
        icon: Icon(
          CupertinoIcons.home,
          size: 26,
        ),
      ),
      Tab(
        text: AppLocalization.of(context).translate("category_in_nav_bar"),
        icon: Icon(
          Icons.format_list_bulleted,
          size: 26,
        ),
      ),
      Tab(
        text: AppLocalization.of(context).translate("cart_in_nav_bar"),
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
                    style:
                        TextStyle(fontSize: 11.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      Tab(
        text: AppLocalization.of(context).translate("brand_in_nav_bar"),
        icon: Icon(
          CupertinoIcons.tag,
          size: 26,
        ),
      ),
      Tab(
        text: AppLocalization.of(context).translate("profile_in_nav_bar"),
        icon: Icon(
          CupertinoIcons.profile_circled,
          size: 26,
        ),
      ),
    ];
    return _tabs;
  }

  @override
  Widget build(BuildContext context) {
    screenConfig = ScreenConfig(context);
    widgetSize = WidgetSize(screenConfig);
    return Scaffold(
      body: Provider<NetworkProvider>.value(
        value: NetworkProvider(),
        child: Consumer<NetworkProvider>(
          builder: (context, value, _) => Center(
              child: ConnectivityWidget(
            networkProvider: value,
            child: TabBarView(
              controller: _tabController,
              physics: NeverScrollableScrollPhysics(),
              children: _mainPages,
            ),
          )),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: Offset(1, -2),
              blurRadius: 10.0),
        ]),
        child: TabBar(
            controller: _tabController,
            labelColor: CustomColors.kAccentColor,
            unselectedLabelColor: Colors.black87,
            labelStyle: TextStyle(
                fontSize: widgetSize.iconText - 2, fontFamily: 'tajawal'),
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            tabs: _listOfTabs(context)),
      ),
    );
  }
}
