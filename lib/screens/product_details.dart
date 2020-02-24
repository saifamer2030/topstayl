import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:topstyle/constants/colors.dart';
import 'package:topstyle/helper/appLocalization.dart';
import 'package:topstyle/helper/size_config.dart';
import 'package:topstyle/models/cart_item_model.dart';
import 'package:topstyle/models/product_details_model.dart';
import 'package:topstyle/providers/cart_provider.dart';
import 'package:topstyle/providers/languages_provider.dart';
import 'package:topstyle/providers/network_provider.dart';
import 'package:topstyle/providers/order_provider.dart';
import 'package:topstyle/providers/user_provider.dart';
import 'package:topstyle/screens/brand_products_screen.dart';
import 'package:topstyle/screens/checkoutScreen.dart';
import 'package:topstyle/screens/login_screen.dart';
import 'package:topstyle/screens/showProductImages.dart';
import 'package:topstyle/widgets/adaptive_progress_indecator.dart';
import 'package:topstyle/widgets/connectivity_widget.dart';
import 'package:topstyle/widgets/product_listview.dart';
import 'package:topstyle/widgets/product_reviews.dart';
import 'package:topstyle/widgets/tag_shape.dart';

import '../providers/products_provider.dart';

class ProductDetails extends StatefulWidget {
  static const String routeName = 'product-details';
  final int productId;

  ProductDetails(this.productId);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails>
    with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  bool _isInit = true;
  bool _isProductChosen = false;
  bool _isSent = false;
  bool _isAddedToCart = false;
  bool _isProductAddedToCart = false;
  int oldProductId = 0;
  int _productOptionIndex = 0;
  int _itemCount = 0;
  double _initRatting = 0.0;
  List<ProductOption> productOptions;
  List<String> optionColor;
  TabController _tabController;
  String comment = '';
  String remindEmail = '';
  var _commentController = TextEditingController();
  var _remindEmailController = TextEditingController();

  ProductDetailsModel productDetails;
  ProductDetailsModelWithList productDetailsModelWithList;
  AppLanguageProvider appLanguage = AppLanguageProvider();
  UserProvider userProvider = UserProvider();

  getProductDetailsData() async {
    var token = await userProvider.isAuthenticated();
    final String lang = appLanguage.appLocal.toString();
    productDetailsModelWithList = await Provider.of<ProductsProvider>(context)
        .productDetailsData(widget.productId, lang, token['Authorization']);
    productDetails = productDetailsModelWithList.productDetailsModel;
    if (productDetails.options.length > 0) {
      _isProductChosen = true;
      _productOptionIndex = 0;
    }
    getCartData();
    setState(() {
      _isLoading = false;
    });
  }

  double totalPrice = 0.0;

  List<CartItemModel> _lists = [];
  getCartData() async {
    var token = await userProvider.isAuthenticated();
    final String lang = appLanguage.appLocal.toString();
    _lists = await Provider.of<CartItemProvider>(context)
        .fetchAllCartItem(lang, token['Authorization']);

    _lists.forEach((data) {
      totalPrice += (data.productPrice -
              (data.quantity * data.productPrice * data.discount / 100)) *
          data.quantity;
    });
  }

  Widget _buildProductDetailsCarousel() {
    return Container(
        height: 400.0,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5.0,
                offset: Offset(1, 3),
              ),
            ],
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0))),
        padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 20.0),
        child: Stack(
          children: <Widget>[
            Carousel(
              images: _isProductChosen
                  ? productDetails.options[_productOptionIndex].media
                      .map((selectedOption) => Container(
                            width: 300.0,
                            height: 200.0,
                            child: Container(
                              padding: EdgeInsets.all(16.0),
                              child: Image.network(
                                selectedOption,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ))
                      .toList()
                  : productDetails.options[0].media
                      .map((option) => Container(
                            width: 300.0,
                            height: 200.0,
                            child: Image.network(
                              option,
                              fit: BoxFit.contain,
                            ),
                          ))
                      .toList(),
              autoplay: false,
              dotIncreaseSize: 1.2,
              dotSize: 12.0,
              dotSpacing: 20.0,
              indicatorBgPadding: 0.0,
              dotBgColor: Colors.white,
              dotColor: Color(0xff9d9d9d).withOpacity(0.5),
              dotIncreasedColor: Color(0xff9d9d9d),
              onImageTap: (int index) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ShowProductImage(productDetails
                        .options[_productOptionIndex].media[index]),
                    fullscreenDialog: true));
              },
            )
          ],
        ));
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      getProductDetailsData();
    }
    _isInit = false;
  }

  Widget _buildProductOption() {
    productOptions = productDetails.options;
    optionColor = productOptions.map((color) => color.value).toList();
    return optionColor.length > 0
        ? ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(left: 4.0, right: 4.0),
              child: GestureDetector(
                onTap: () {
                  print(index);
                  setState(() {
                    _isProductChosen = true;
                    _productOptionIndex = index;
//              print(productDetails.options[_productOptionIndex].media.length);
                  });
                },
                child: productDetails.options[0].type == 'color'
                    ? Container(
                        width: 30.0,
                        height: 30.0,
                        decoration: BoxDecoration(
                          border: _productOptionIndex == index
                              ? Border.all(
                                  width: 2,
                                  color: Color(int.parse(
                                      '0xFF${productDetails.options[index].value}')))
                              : null,
                          shape: BoxShape.circle,
                          color: _productOptionIndex == index
                              ? Color(int.parse(
                                  '0xFF${productDetails.options[index].value}'))
                              : Colors.white,
                          //borderRadius: BorderRadius.circular(22.0),
                        ),
                        child: Container(
                          width: 28.0,
                          height: 28.0,
                          decoration: BoxDecoration(
                              border: _productOptionIndex == index
                                  ? Border.all(width: 2, color: Colors.white)
                                  : null,
                              shape: BoxShape.circle,
                              color: Color(int.parse(
                                  '0xFF${productDetails.options[index].value}'))),
                          child: productOptions[index].quantity > 1
                              ? Container()
                              : Center(
                                  child: Icon(
                                    Icons.clear,
                                    size: 17,
                                    color: Colors.white,
                                  ),
                                ),
                        ))
                    : Container(
                        width: 60.0,
                        height: 30.0,
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.0),
                          color: Color(0xFFe8e8e8),
                          border: _productOptionIndex == index
                              ? Border.all(width: 1.5, color: Colors.black)
                              : null,
                        ),
                        child: Center(
                            child: productOptions[index].quantity > 0
                                ? Text(
                                    '${productOptions[index].value} ${AppLocalization.of(context).translate("ml")}',
                                    style: TextStyle(fontSize: 12.0),
                                  )
                                : Row(
                                    children: <Widget>[
                                      Text(
                                        '${productOptions[index].value} ${AppLocalization.of(context).translate("ml")}',
                                        style: TextStyle(fontSize: 12.0),
                                      ),
                                      Icon(
                                        Icons.clear,
                                        size: 15,
                                        color: CustomColors.kTabBarIconColor,
                                      ),
                                    ],
                                  )),
                      ),
              ),
            ),
            itemCount: productOptions.length,
          )
        : Container();
  }

  Future<int> _sendYourComment() async {
    var token = await userProvider.isAuthenticated();
    int response = await Provider.of<ProductsProvider>(context).submitComment(
        comment, productDetails.id, _initRatting, token['Authorization']);
    if (response == 1) {
      _commentController.clear();
      _initRatting = 0.0;
    }
    return response;
  }

  _showCommentDialog() async {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              content: StatefulBuilder(
                builder: (context, setSetter) => Container(
                  height: 200,
                  width: double.infinity,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            AppLocalization.of(context)
                                .translate("review_product"),
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                setSetter(() {
                                  _initRatting = 1.0;
                                });
                              },
                              child: Icon(
                                _initRatting >= 1.0
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Color(0xfffdcc0d),
                              ),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            GestureDetector(
                              onTap: () {
                                setSetter(() {
                                  _initRatting = 2.0;
                                });
                              },
                              child: Icon(
                                _initRatting >= 2.0
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Color(0xfffdcc0d),
                              ),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            GestureDetector(
                              onTap: () {
                                setSetter(() {
                                  _initRatting = 3.0;
                                });
                              },
                              child: Icon(
                                _initRatting >= 3.0
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Color(0xfffdcc0d),
                              ),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            GestureDetector(
                              onTap: () {
                                setSetter(() {
                                  _initRatting = 4.0;
                                });
                              },
                              child: Icon(
                                _initRatting >= 4.0
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Color(0xfffdcc0d),
                              ),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            GestureDetector(
                              onTap: () {
                                setSetter(() {
                                  _initRatting = 5.0;
                                });
                              },
                              child: Icon(
                                _initRatting >= 5.0
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Color(0xfffdcc0d),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          child: TextField(
                            controller: _remindEmailController,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                  color: CustomColors.kTabBarIconColor),
                              hintText: AppLocalization.of(context)
                                  .translate("comment_hint"),
                            ),
                            onChanged: (c) {
                              setSetter(() {
                                comment = c;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        GestureDetector(
                          onTap: (_initRatting > 0.0) && (comment != '')
                              ? () {
                                  setSetter(() {
                                    _isSent = true;
                                  });
                                  _sendYourComment().then((response) {
                                    if (response == 1) {
                                      setSetter(() {
                                        _isSent = false;
                                        comment = '';
                                        _initRatting = 0.0;
                                      });
                                      Navigator.of(context).pop();
                                    } else {
                                      setSetter(() {
                                        _isSent = false;
                                      });
                                    }
                                  });
                                }
                              : null,
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: _initRatting > 0.0 && comment != ''
                                      ? CustomColors.kTabBarIconColor
                                      : Colors.grey),
                              width: double.infinity,
                              height: 40.0,
                              child: Center(
                                  child: _isSent
                                      ? AdaptiveProgressIndicator()
                                      : Text(
                                          AppLocalization.of(context)
                                              .translate("submit_your_review"),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ))),
                        ),
                      ]),
                ),
              ),
            ));
  }

  getMoreComment() async {
    // We have to do it
  }

  _remindMe(int poid) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        content: StatefulBuilder(
            builder: (context, setSetter) => Container(
                  height: 150,
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: FittedBox(
                          child: Text(
                            AppLocalization.of(context)
                                .translate("remind email hint"),
                            style: TextStyle(fontSize: widgetSize.subTitle),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        child: TextField(
                          decoration: InputDecoration(
                            hintStyle:
                                TextStyle(color: CustomColors.kTabBarIconColor),
                            hintText:
                                AppLocalization.of(context).translate("email"),
                          ),
                          onChanged: (c) {
                            Pattern pattern =
                                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                            RegExp regex = new RegExp(pattern);
                            if (regex.hasMatch(c)) {
                              setSetter(() {
                                remindEmail = c;
                              });
                            } else {
                              setSetter(() {
                                remindEmail = null;
                              });
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      GestureDetector(
                        onTap: (remindEmail != '' &&
                                remindEmail != null &&
                                remindEmail.contains('@'))
                            ? () async {
                                setSetter(() {
                                  _isSent = true;
                                });
                                int result =
                                    await Provider.of<ProductsProvider>(context)
                                        .sendEmailReminder(
                                            remindEmail, poid.toString());
                                if (result == 1) {
                                  setSetter(() {
                                    remindEmail = '';
                                  });
                                }
                                setSetter(() {
                                  _isSent = false;
                                });
                                Navigator.of(context).pop();
                              }
                            : null,
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: remindEmail != '' &&
                                        remindEmail != null &&
                                        remindEmail.contains('@')
                                    ? CustomColors.kAccentColor
                                    : Colors.grey),
                            width: double.infinity,
                            height: widgetSize.textField,
                            child: Center(
                                child: _isSent
                                    ? AdaptiveProgressIndicator()
                                    : Text(
                                        AppLocalization.of(context)
                                            .translate("Remind_me"),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ))),
                      ),
                    ],
                  ),
                )),
      ),
    );
  }

  ScreenConfig screenConfig;
  WidgetSize widgetSize;

  @override
  Widget build(BuildContext context) {
    screenConfig = ScreenConfig(context);
    widgetSize = WidgetSize(screenConfig);
    return _isLoading
        ? Scaffold(
            body: Center(
              child: AdaptiveProgressIndicator(),
            ),
          )
        : Provider<NetworkProvider>.value(
            value: NetworkProvider(),
            child: Consumer<NetworkProvider>(
              builder: (context, value, _) => Center(
                  child: Scaffold(
                body: ConnectivityWidget(
                  networkProvider: value,
                  child: Scaffold(
                      backgroundColor: Colors.white,
                      appBar: AppBar(
                        elevation: 3.0,
                        centerTitle: true,
                        title: Text(
                          AppLocalization.of(context).translate("details"),
                          style: TextStyle(
                              fontSize: widgetSize.mainTitle,
                              fontWeight: FontWeight.bold),
                        ),
                        actions: <Widget>[
                          Consumer<CartItemProvider>(
                              builder: (ctx, cart, _) => Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Stack(
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
                                          child: Consumer<CartItemProvider>(
                                            builder: (ctx, cart, _) =>
                                                Container(
                                              margin: cart.allItemQuantity > 9
                                                  ? const EdgeInsets.symmetric(
                                                      horizontal: 4.0,
                                                    )
                                                  : const EdgeInsets.symmetric(
                                                      horizontal: 6.0),
                                              child: Text(
                                                '${cart.allItemQuantity > 9 ? '9+' : cart.allItemQuantity == 0 ? '' : cart.allItemQuantity}',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 11.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
//                                Badge(
//                              value: cart.allItemQuantity > 99
//                                  ? '99+'
//                                  : cart.allItemQuantity.toString(),
//                              //shoppingCartItem.allItemQuantity,
//                              child: GestureDetector(
//                                child: Container(
//                                  margin: const EdgeInsets.only(
//                                      left: 20.0, right: 20.0),
//                                  child: Image.asset(
//                                    'assets/icons/cart.png',
//                                    width: 22.0,
//                                    height: 22.0,
//                                    fit: BoxFit.fitHeight,
//                                  ),
//                                ),
//                                onTap: () {
////                        print(cart.allItemQuantity);
//                                  cart.allItemQuantity > 0
//                                      ? showModalBottomSheet(
////                      isScrollControlled: true,
//                                          shape: RoundedRectangleBorder(
//                                              borderRadius: BorderRadius.only(
//                                                  topLeft:
//                                                      Radius.circular(16.0),
//                                                  topRight:
//                                                      Radius.circular(16.0))),
//                                          context: context,
//                                          backgroundColor:
//                                              Theme.of(context).primaryColor,
//                                          builder: (ctx) => CartScreen())
//                                      : showModalBottomSheet(
//                                          context: context,
//                                          backgroundColor:
//                                              Theme.of(context).primaryColor,
//                                          shape: RoundedRectangleBorder(
//                                              borderRadius: BorderRadius.only(
//                                                  topLeft:
//                                                      Radius.circular(16.0),
//                                                  topRight:
//                                                      Radius.circular(16.0))),
//                                          builder: (context) {
//                                            return Container(
//                                              height: 90.0,
//                                              child: Center(
//                                                child: Text(AppLocalization.of(
//                                                        context)
//                                                    .translate("empty_cart")),
//                                              ),
//                                            );
//                                          });
//                                },
//                              ),
//                              color: Colors.red,
//                            ),
                              )
                        ],
                      ),
                      body: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _buildProductDetailsCarousel(),
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 16.0, right: 16.0, top: 20.0),
                              child: Wrap(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  BrandProductsScreen(
                                                      productDetails.brand,
                                                      productDetails.brandId
                                                          .toString())));
                                    },
                                    child: Text(
                                      productDetails.brand,
                                      style: TextStyle(
                                          color: Color(0xFF009bff),
                                          fontSize: widgetSize.subTitle),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                left: 16.0,
                                right: 16.0,
                                top: 10.0,
                              ),
                              child: Wrap(
                                children: <Widget>[
                                  Text(
                                    productDetails.name,
                                    style: TextStyle(
                                        color: CustomColors.kTabBarIconColor,
                                        fontSize: widgetSize.content,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 16.0, right: 16.0, top: 32.0),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    _isProductChosen
                                        ? '${productDetails.options[_productOptionIndex].price.toStringAsFixed(2)} ${AppLocalization.of(context).translate("sar")}'
                                        : '${productDetails.options[0].price.toStringAsFixed(2)} ${AppLocalization.of(context).translate("sar")}',
                                    style: productDetails.discount == 0
                                        ? TextStyle(
                                            fontSize: widgetSize.content,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Theme.of(context).accentColor,
                                          )
                                        : TextStyle(
                                            fontSize: widgetSize.content,
//                                  fontWeight: FontWeight.bold,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  productDetails.discount == 0
                                      ? Container()
                                      : Text(
                                          _isProductChosen
                                              ? '${((productDetails.options[_productOptionIndex].price) - ((productDetails.options[_productOptionIndex].price) * (productDetails.discount) / 100)).toStringAsFixed(2)} ${AppLocalization.of(context).translate("sar")}'
                                              : '${((productDetails.options[0].price) - ((productDetails.options[0].price) * (productDetails.discount) / 100)).toStringAsFixed(2)} ${AppLocalization.of(context).translate("sar")}',
                                          style: TextStyle(
                                            fontSize: widgetSize.content,
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  productDetails.discount == 0
                                      ? Container()
                                      : TagShape(productDetails.discount),
//                        Text('40 SAR'),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 16.0, right: 16.0, top: 5.0),
                              child: Text(
                                '(${AppLocalization.of(context).translate('vat_included')})',
                                style: TextStyle(
                                    fontSize: widgetSize.textFieldError,
                                    color: Colors.grey),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 16.0, right: 16.0, top: 10.0),
                              child: Wrap(
                                children: <Widget>[
                                  productDetails.options[0].type == 'color'
                                      ? Text(
                                          _isProductChosen &&
                                                  productDetails
                                                          .options[
                                                              _productOptionIndex]
                                                          .optionName !=
                                                      null
                                              ? '${AppLocalization.of(context).translate("color")} ${productDetails.options[_productOptionIndex].optionName}'
                                              : '',
                                          style: TextStyle(
                                              color:
                                                  CustomColors.kTabBarIconColor,
                                              fontSize: widgetSize.content),
                                        )
                                      : productDetails.options[0].type == 'size'
                                          ? Text(
                                              _isProductChosen &&
                                                      productDetails
                                                              .options[
                                                                  _productOptionIndex]
                                                              .value !=
                                                          null
                                                  ? '${AppLocalization.of(context).translate("size")} ${productDetails.options[_productOptionIndex].value} ${AppLocalization.of(context).translate("ml")}'
                                                  : '',
                                              style: TextStyle(
                                                  color: CustomColors
                                                      .kTabBarIconColor,
                                                  fontSize: widgetSize.content))
                                          : Container(),
                                ],
                              ),
                            ),
                            productDetails.options[0].type == 'color' ||
                                    productDetails.options[0].type == 'size'
                                ? Container(
                                    width: double.infinity,
                                    height: 30.0,
                                    margin: const EdgeInsets.only(
                                      left: 16.0,
                                      right: 16.0,
                                      top: 10.0,
                                    ),
                                    child: _buildProductOption(),
                                  )
                                : Container(),
                            Container(
                              margin: const EdgeInsets.only(
                                left: 16.0,
                                right: 16.0,
                                top: 15.0,
                              ),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    productDetails.ratting >= 1
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Color(0xfffdcc0d),
                                  ),
                                  Icon(
                                    productDetails.ratting >= 2
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Color(0xfffdcc0d),
                                  ),
                                  Icon(
                                    productDetails.ratting >= 3
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Color(0xfffdcc0d),
                                  ),
                                  Icon(
                                    productDetails.ratting >= 4
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Color(0xfffdcc0d),
                                  ),
                                  Icon(
                                    productDetails.ratting >= 5
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Color(0xfffdcc0d),
                                  ),
                                  SizedBox(
                                    width: 7.0,
                                  ),
                                  productDetails.reviewers == 0
                                      ? GestureDetector(
                                          onTap: () async {
                                            var token = await userProvider
                                                .isAuthenticated();
                                            if (token['Authorization'] !=
                                                'none') {
                                              _showCommentDialog();
//
                                            } else {
                                              Navigator.of(context).pushNamed(
                                                  LoginScreen.routeName,
                                                  arguments: productDetails.id
                                                      .toString());
                                              SharedPreferences.getInstance()
                                                  .then((prefs) {
                                                prefs.setString(
                                                    "redirection", 'toDetails');
                                              });
                                            }
                                          },
                                          child: Text(
                                            '(${AppLocalization.of(context).translate("be_the_first_to_review")})',
                                            style: TextStyle(
                                                fontSize: widgetSize.subTitle),
                                          ),
                                        )
                                      : Text(
                                          '(${productDetails.reviewers} ${AppLocalization.of(context).translate("review")})',
                                          style: TextStyle(
                                              fontSize: widgetSize.subTitle),
                                        ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Divider(
                              height: 1.0,
                              color: CustomColors.kPCardColor,
                              thickness: 1.0,
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                left: 16.0,
                                right: 16.0,
                                top: 15.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                      child: Row(
                                    children: <Widget>[
                                      SvgPicture.asset(
                                        'assets/icons/delivary.svg',
                                        width: 28.0,
                                        height: 20.0,
                                        fit: BoxFit.fitHeight,
                                        color: CustomColors.kTabBarIconColor,
                                      ),
                                      SizedBox(
                                        width: 8.0,
                                      ),
                                      Text(
                                        AppLocalization.of(context)
                                            .translate("fast_delivery"),
                                        style: TextStyle(
                                            fontSize:
                                                widgetSize.textFieldError),
                                      )
                                    ],
                                  )),
                                  Expanded(
                                    child: Row(
                                      children: <Widget>[
                                        SvgPicture.asset(
                                          'assets/icons/orignal.svg',
                                          width: 20.0,
                                          height: 20.0,
                                          fit: BoxFit.fitHeight,
                                          color: CustomColors.kTabBarIconColor,
                                        ),
                                        SizedBox(
                                          width: 8.0,
                                        ),
                                        Text(
                                          AppLocalization.of(context)
                                              .translate("original_product"),
                                          style: TextStyle(
                                              fontSize:
                                                  widgetSize.textFieldError),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 16.0,
                                  right: 16.0,
                                  top: 20.0,
                                  bottom: 20.0),
                              child: Row(
                                children: <Widget>[
                                  SvgPicture.asset(
                                    'assets/icons/cash.svg',
                                    width: 20.0,
                                    height: 20.0,
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(
                                    AppLocalization.of(context)
                                        .translate("payment_when_receiving"),
                                    style: TextStyle(
                                        fontSize: widgetSize.textFieldError),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              height: 1.0,
                              color: CustomColors.kPCardColor,
                              thickness: 1.0,
                            ),
                            Container(
                              decoration:
                                  new BoxDecoration(color: Colors.white),
                              child: new TabBar(
                                  controller: _tabController,
                                  indicatorColor: Theme.of(context).accentColor,
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  tabs: [
                                    Tab(
                                      text: AppLocalization.of(context)
                                          .translate("details"),
                                    ),
                                    Tab(
                                      text: AppLocalization.of(context)
                                          .translate("specification"),
                                    ),
                                  ]),
                            ),
                            Container(
                              height: 100.0,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 10.0),
                              child: new TabBarView(
                                controller: _tabController,
                                children: [
                                  SingleChildScrollView(
                                    child: Wrap(spacing: 10.0, children: [
                                      Text(
                                        productDetails.description,
                                        style: TextStyle(
                                            fontSize: widgetSize.content2),
                                        softWrap: true,
                                      ),
                                    ]),
                                  ),
                                  SingleChildScrollView(
                                    child: Wrap(
                                      children: [
                                        Text(
                                          _isProductChosen
                                              ? productDetails.options[_productOptionIndex].specification ==
                                                      ''
                                                  ? AppLocalization.of(context)
                                                      .translate(
                                                          'no_specification')
                                                  : productDetails
                                                      .options[
                                                          _productOptionIndex]
                                                      .specification
                                              : productDetails.options[0]
                                                          .specification ==
                                                      ''
                                                  ? AppLocalization.of(context)
                                                      .translate(
                                                          'no_specification')
                                                  : productDetails
                                                      .options[0].specification,
                                          style: TextStyle(
                                              fontSize: widgetSize.content2),
                                          softWrap: true,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Divider(
                              height: 1.0,
                              color: CustomColors.kPCardColor,
                              thickness: 1.0,
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 16.0, right: 16.0),
                              child: Text(
                                productDetails.reviewers > 0
                                    ? '${AppLocalization.of(context).translate("review")} (${productDetails.reviewers})'
                                    : '',
                                style: TextStyle(
                                    fontSize: widgetSize.content,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                AppLocalization.of(context)
                                    .translate("review_product"),
                                style: TextStyle(fontSize: widgetSize.content),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: GestureDetector(
                                onTap: () async {
                                  var token =
                                      await userProvider.isAuthenticated();
                                  if (token['Authorization'] != 'none') {
                                    _showCommentDialog();
//
                                  } else {
                                    Navigator.of(context).pushNamed(
                                        LoginScreen.routeName,
                                        arguments:
                                            productDetails.id.toString());
                                    SharedPreferences.getInstance()
                                        .then((prefs) {
                                      prefs.setString(
                                          "redirection", 'toDetails');
                                    });
                                  }
//
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Icon(
                                      Icons.star_border,
                                      color: Color(0xfffdcc0d),
                                    ),
                                    Icon(
                                      Icons.star_border,
                                      color: Color(0xfffdcc0d),
                                    ),
                                    Icon(
                                      Icons.star_border,
                                      color: Color(0xfffdcc0d),
                                    ),
                                    Icon(
                                      Icons.star_border,
                                      color: Color(0xfffdcc0d),
                                    ),
                                    Icon(
                                      Icons.star_border,
                                      color: Color(0xfffdcc0d),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Divider(
                              height: 1.0,
                              color: CustomColors.kPCardColor,
                              thickness: 1.0,
                            ),
                            ProductReviews(productDetails.reviews),
                            SizedBox(
                              height: 5.0,
                            ),
                            Divider(
                              height: 1.0,
                              color: CustomColors.kPCardColor,
                              thickness: 1.0,
                            ),
                            productDetails.reviews.length > 0
                                ? FlatButton(
                                    onPressed: () {
                                      getMoreComment();
                                    },
                                    child: Center(
                                      child: Text(
                                        AppLocalization.of(context)
                                            .translate("see_more_review"),
                                        style: TextStyle(
                                          fontSize: widgetSize.content2,
                                          decoration: TextDecoration.underline,
                                          decorationColor: Colors.black,
                                          color: CustomColors.kTabBarIconColor,
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                            productDetailsModelWithList.mayAlsoLike.length > 0
                                ? Container(
                                    margin: const EdgeInsets.only(
                                        left: 16.0, right: 16.0, top: 10.0),
                                    child: Text(
                                      AppLocalization.of(context)
                                          .translate("you_may_also_like"),
                                      style: TextStyle(
                                          fontSize: widgetSize.content,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                : Container(),
                            productDetailsModelWithList.mayAlsoLike.length > 0
                                ? Container(
                                    height: 330.0,
                                    child: ProductListView(
                                        productDetailsModelWithList
                                            .mayAlsoLike),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                      bottomNavigationBar: Container(
                        height: widgetSize.textField,
                        margin: const EdgeInsets.only(
                            left: 16.0, right: 16.0, bottom: 22.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              flex: 4,
                              child: Container(
                                height: widgetSize.textField,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: _isProductChosen
                                      ? Theme.of(context).accentColor
                                      : Colors.grey,
                                ),
                                child: Consumer<CartItemProvider>(
                                  builder: (ctx, _cartProvider, _) =>
                                      FlatButton(
                                    onPressed: (_isAddedToCart &&
                                            oldProductId ==
                                                productDetails
                                                    .options[
                                                        _productOptionIndex]
                                                    .id)
                                        ? null
                                        : (productDetails
                                                        .options[
                                                            _productOptionIndex]
                                                        .quantity >
                                                    0 &&
                                                productDetails
                                                        .options[
                                                            _productOptionIndex]
                                                        .isAvailable ==
                                                    1)
                                            ? () async {
                                                setState(() {
                                                  _isProductAddedToCart = true;
                                                });
                                                var token = await userProvider
                                                    .isAuthenticated();
                                                var lang = appLanguage.appLocal
                                                    .toString();

                                                int response = await _cartProvider
                                                    .addCartItem(
                                                        productDetails
                                                            .options[
                                                                _productOptionIndex]
                                                            .id,
                                                        lang,
                                                        1,
                                                        token['Authorization']);
                                                if (response == 0 ||
                                                    response == 1) {
                                                  setState(() {
                                                    _isAddedToCart = true;
                                                    oldProductId = productDetails
                                                        .options[
                                                            _productOptionIndex]
                                                        .id;
                                                    _isProductAddedToCart =
                                                        false;
                                                  });

                                                  showModalBottomSheet(
                                                      backgroundColor:
                                                          Color(0xFFe8e8e8),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  10.0),
                                                          topLeft:
                                                              Radius.circular(
                                                                  10.0),
                                                        ),
                                                      ),
                                                      context: context,
                                                      builder:
                                                          (context) =>
                                                              Container(
                                                                height: 150.0,
                                                                padding: const EdgeInsets
                                                                        .only(
                                                                    left: 16.0,
                                                                    right: 16.0,
                                                                    top: 20.0,
                                                                    bottom:
                                                                        15.0),
                                                                child: Column(
                                                                  children: <
                                                                      Widget>[
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: <
                                                                          Widget>[
                                                                        Text(
                                                                          AppLocalization.of(context)
                                                                              .translate("added_successfully_to_cart"),
                                                                          style: TextStyle(
                                                                              fontSize: widgetSize.content,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              5.0,
                                                                        ),
                                                                        Container(
                                                                          margin:
                                                                              const EdgeInsets.only(bottom: 6.0),
                                                                          child:
                                                                              Icon(
                                                                            Icons.check_circle,
                                                                            color:
                                                                                CustomColors.kPAddedToCartIconColor,
                                                                            size:
                                                                                27,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      width:
                                                                          5.0,
                                                                    ),
                                                                    Text(
                                                                      '${AppLocalization.of(context).translate('total_purchase')} (${_cartProvider.allItemQuantity} ${AppLocalization.of(context).translate('order_items')}) ${(totalPrice + (productDetails.options[_productOptionIndex].price - (productDetails.discount * productDetails.options[_productOptionIndex].price / 100))).toStringAsFixed(2)} ${AppLocalization.of(context).translate('sar')}',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              widgetSize.textFieldError),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          20.0,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceEvenly,
                                                                      children: <
                                                                          Widget>[
                                                                        GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                44.0,
                                                                            width:
                                                                                MediaQuery.of(context).size.width / 2 - 30,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: CustomColors.kTabBarIconColor,
                                                                              borderRadius: BorderRadius.circular(10.0),
                                                                            ),
                                                                            child:
                                                                                Center(
                                                                              child: Text(
                                                                                '${AppLocalization.of(context).translate("continue_shopping")}',
                                                                                style: TextStyle(color: Colors.white, fontSize: widgetSize.content),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        GestureDetector(
                                                                          onTap:
                                                                              () async {
                                                                            var token =
                                                                                await userProvider.isAuthenticated();
                                                                            if (token['Authorization'] ==
                                                                                'none') {
                                                                              Navigator.of(context).pushNamed(LoginScreen.routeName);
                                                                              SharedPreferences.getInstance().then((prefs) {
                                                                                prefs.setString("redirection", 'toPayment');
                                                                              });
                                                                            } else {
                                                                              var token = await userProvider.isAuthenticated();
                                                                              Provider.of<OrdersProvider>(context).getUserAddresses(token['Authorization']).then((address) {
                                                                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => CheckoutScreen(0, address)));
                                                                              });
                                                                            }
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                44.0,
                                                                            width:
                                                                                MediaQuery.of(context).size.width / 2 - 30,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Theme.of(context).accentColor,
                                                                              borderRadius: BorderRadius.circular(10.0),
                                                                            ),
                                                                            child:
                                                                                Center(
                                                                              child: Text(
                                                                                '${AppLocalization.of(context).translate("checkout")}',
                                                                                style: TextStyle(color: Colors.white, fontSize: widgetSize.content),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ));
                                                } else {
                                                  print(
                                                      'the comming reponse is $response');
                                                }
                                              }
                                            : () {
                                                _remindMe(productDetails
                                                    .options[
                                                        _productOptionIndex]
                                                    .id);
                                              }
                                    // : null,
                                    ,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        (productDetails
                                                        .options[
                                                            _productOptionIndex]
                                                        .quantity >
                                                    0 &&
                                                productDetails
                                                        .options[
                                                            _productOptionIndex]
                                                        .isAvailable ==
                                                    1)
                                            ? (_isAddedToCart &&
                                                    oldProductId ==
                                                        productDetails
                                                            .options[
                                                                _productOptionIndex]
                                                            .id)
                                                ? Icon(
                                                    Icons.check_circle,
                                                    color: CustomColors
                                                        .kPAddedToCartIconColor,
                                                    size: 25,
                                                  )
                                                : Image.asset(
                                                    'assets/icons/cart.png',
                                                    color: Colors.white,
                                                    height: 22.0,
                                                    width: 22.0,
                                                    fit: BoxFit.fitHeight,
                                                  )
                                            : Container(),
                                        SizedBox(
                                          width: 8.0,
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(top: 6.0),
                                          child: !_isProductAddedToCart
                                              ? Text(
                                                  (productDetails
                                                                  .options[
                                                                      _productOptionIndex]
                                                                  .quantity >
                                                              0 &&
                                                          productDetails
                                                                  .options[
                                                                      _productOptionIndex]
                                                                  .isAvailable ==
                                                              1)
                                                      ? (_isAddedToCart &&
                                                              oldProductId ==
                                                                  productDetails
                                                                      .options[
                                                                          _productOptionIndex]
                                                                      .id)
                                                          ? AppLocalization.of(
                                                                  context)
                                                              .translate(
                                                                  "added_successfully_to_cart")
                                                          : AppLocalization.of(
                                                                  context)
                                                              .translate(
                                                                  "add_to_cart")
                                                      : AppLocalization.of(
                                                              context)
                                                          .translate(
                                                              "Remind_me"),

//                                        : AppLocalization.of(context)
//                                                .translate("select_one_option"),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                          widgetSize.content,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              : AdaptiveProgressIndicator(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Consumer<ProductDetailsModel>(
                                builder: (context, prod, child) =>
                                    FloatingActionButton(
                                        backgroundColor: Colors.white,
//                                        Color(0xFFe8e8e8),
                                        onPressed: () async {
                                          var user = await userProvider
                                              .isAuthenticated();
                                          if (user['Authorization'] != 'none') {
                                            prod.toggleFavoriteStatus(
                                                productDetails.id,
                                                user['Authorization']);
                                            productDetails.isFavorite == 0
                                                ? productDetails.isFavorite = 1
                                                : productDetails.isFavorite = 0;
                                          } else {
                                            Navigator.of(context).pushNamed(
                                                LoginScreen.routeName,
                                                arguments: 'home');
                                          }
                                        },
                                        child: productDetails.isFavorite == 1
                                            ? Icon(
                                                Icons.favorite,
                                                color: Colors.red,
                                                size:
                                                    widgetSize.favoriteIconSize,
                                              )
                                            : Icon(
                                                Icons.favorite_border,
                                                size:
                                                    widgetSize.favoriteIconSize,
                                                color: CustomColors
                                                    .kTabBarIconColor,
                                              )
//                    ),
                                        ),
                              ),
                            )
                          ],
                        ),
                      )),
                ),
              )),
            ),
          );
  }
}
