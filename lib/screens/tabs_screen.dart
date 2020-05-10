import 'package:fimber/fimber_base.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
import 'dart:convert';
import 'dart:io' show Platform;
import '../screens/brands_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/categories_screen.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';

class TabsScreen extends StatefulWidget {
  static const String routeName = 'tabs';
  final int index ;

  const TabsScreen([this.index]);

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

FirebaseMessaging firebaseMessaging = new FirebaseMessaging();

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    new FlutterLocalNotificationsPlugin();

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
    registerNotification();
    configLocalNotification();
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

  void registerNotification() {
    firebaseMessaging.requestNotificationPermissions();

    firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print('onMessage: $message');
      showNotification(message['notification']);
      return;
    }, onResume: (Map<String, dynamic> message) {
      print('onResume: $message');
      _serialiseAndNavigate(message);
      return;
    },
        //onBackgroundMessage: myBackgroundMessageHandler,
        onLaunch: (Map<String, dynamic> message) {
      print('onLaunch: $message');
      _serialiseAndNavigate(message);
      return;
    });
  }

  void configLocalNotification() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@drawable/ic_launcher_foreground');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  void showNotification(message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid
          ? 'ccom.topstylesa.topstyle'
          : 'com.topstylesa.topstyle',
      'topstyle',
      'your channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, message['title'].toString(),
        message['body'].toString(), platformChannelSpecifics,
        payload: json.encode(message));
  }

  // ignore: missing_return
  Future _serialiseAndNavigate(Map<String, dynamic> message) {
    var notificationData = message['data'];
    var view = notificationData['view'];

    if (view != null) {
      // Navigate to the create post view
      if (view == 'cart_screen') {
        Navigator.push(
          context,
          new MaterialPageRoute(builder: (context) => CartScreen()),
        );
      } else if (view == 'categories_screen') {
        Navigator.push(
          context,
          new MaterialPageRoute(builder: (context) => CategoriesScreen()),
        );
      }
    }
  }

  Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) async {
    print("_backgroundMessageHandler");
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
      print("_backgroundMessageHandler data: $data");
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
      print("_backgroundMessageHandler notification: $notification");
      Fimber.d("=====>myBackgroundMessageHandler $message");
    }
    return Future<void>.value();
  }

  Future selectNotification(String payload) async {
    if (payload == 'cart') {
      debugPrint('notification payload: ' + payload);
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TabsScreen(2)),
      );
    }
  }
}
