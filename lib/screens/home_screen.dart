import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topstyle/constants/colors.dart';
import 'package:topstyle/helper/appLocalization.dart';
import 'package:topstyle/helper/size_config.dart';
import 'package:topstyle/models/ads_model.dart';
import 'package:topstyle/models/home_page_model.dart';
import 'package:topstyle/providers/languages_provider.dart';
import 'package:topstyle/providers/user_provider.dart';
import 'package:topstyle/screens/brand_products_screen.dart';
import 'package:topstyle/screens/product_details.dart';
import 'package:topstyle/screens/search_screen.dart';
import 'package:topstyle/screens/see_more_screen.dart';
import 'package:topstyle/widgets/adaptive_progress_indecator.dart';
import 'package:topstyle/widgets/category_item.dart';
import 'package:topstyle/widgets/product_listview.dart';

import '../providers/products_provider.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  List<Ads> slidesBanner = [];
  var _homeIndicatorKey = GlobalKey<RefreshIndicatorState>();

  Map<String, Ads> _allAds = {
    'adsBanner': null,
    'bannerA': null,
    'bannerB': null,
    'bannerMakeup': null,
    'bannerPerfume': null,
    'bannerCare': null,
    'bannerLenses': null,
    'bannerDevice': null,
    'bannerNails': null,
  };

  Widget _buildImagesSlider(BuildContext context, List<Ads> ads) {
    return Container(
      height: 215,
      width: screenConfig.screenWidth,
      child: ads.length > 0
          ? Carousel(
              images: ads
                  .map(
                    (imageUrl) => Container(
                      child: Image.network(
                        imageUrl.imagePath,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                  .toList(),
              autoplay: true,
//              dotIncreaseSize: 1.2,
//              dotSize: 10.0,
//              dotSpacing: 17.0,
              indicatorBgPadding: 0.0,
              dotBgColor: Colors.white,
//              dotColor: Color(0xff9d9d9d).withOpacity(0.5),
//              dotIncreasedColor: Color(0xff9d9d9d),
              onImageTap: (int index) {
                // write code when slide clicked go to advertisement content
                if (ads[index].adsType == 'Category') {
                  // Send it to SeeMore with Category name
                  var main = ads[index].isMain == 1 ? ads[index].adsValue : '';
                  var sub = ads[index].isMain == 1 ? ads[index].adsValue : '';
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SeeMoreScreen(
                        categoryName: main,
                        subCategoryName: sub,
                      ),
                    ),
                  );
                } else if (ads[index].adsType == 'Brand') {
                  // Send It To Brands with brand name , brand ID
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => BrandProductsScreen(
                          ads[index].brandName, ads[index].adsValue),
                    ),
                  );
                } else if (ads[index].adsType == 'Product') {
                  // send it  to product Details with product Id
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductDetails(int.parse(ads[index].adsValue)),
                    ),
                  );
                }
              },
            )
          : Container(
              color: Colors.grey,
            ),
    );
  } // image slider method

//  Widget _buildImagesSlider(BuildContext context, List<Ads> ads) {
//    return Container(
//      height: 215,
//      child: Column(
//        children: <Widget>[
//          Flexible(
//              child: SizedBox(
//                  height: 215,
////                  width: screenConfig.screenWidth,
//                  child: PageView.builder(
//                      controller: _controller,
//                      itemCount: ads.length,
//                      itemBuilder: (context, index) => Card(
//                            child: Image(
//                              image: NetworkImage(ads[index].imagePath),
//                              fit: BoxFit.cover,
//                            ),
//                          ))))
//        ],
//      ),
//    );
//  }

  Widget _buildCategoryTitleWithSeeMore(
      String title, Function action, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(
              top: 20.0, left: 16.0, right: 16.0, bottom: 10.0),
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
          ),
        ),
        GestureDetector(
          onTap: action,
          child: Container(
            margin: const EdgeInsets.only(
                top: 20.0, right: 16.0, left: 16.0, bottom: 10.0),
            child: Row(
              children: <Widget>[
                Text(
                  title == AppLocalization.of(context).translate("best_sellers")
                      ? ''
                      : AppLocalization.of(context).translate("see_more"),
                  style: TextStyle(fontSize: widgetSize.subTitle),
                ),
                title == AppLocalization.of(context).translate("best_sellers")
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 16.0,
                        ),
                      ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildCategoryBanner(Ads categoryBanner, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (categoryBanner.adsType == 'Category') {
          // Send it to SeeMore with Category name
          var main = categoryBanner.isMain == 1 ? categoryBanner.adsValue : '';
          var sub = categoryBanner.isMain == 1 ? categoryBanner.adsValue : '';
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SeeMoreScreen(
                categoryName: main,
                subCategoryName: sub,
              ),
            ),
          );
        } else if (categoryBanner.adsType == 'Brand') {
          // Send It To Brands with brand name , brand ID
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => BrandProductsScreen(
                  categoryBanner.brandName, categoryBanner.adsValue),
            ),
          );
        } else if (categoryBanner.adsType == 'Product') {
          // send it  to product Details with product Id
          print(categoryBanner.imagePath);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  ProductDetails(int.parse(categoryBanner.adsValue)),
            ),
          );
        }
      },
      child: Container(
        height: 150,
        margin: const EdgeInsets.only(
            left: 16.0, right: 16.0, top: 30.0, bottom: 20.0),
        child: categoryBanner.imagePath == ''
            ? Container()
            : Image(
                image: NetworkImage(categoryBanner.imagePath),
                fit: BoxFit.fill,
              ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0), color: Colors.grey),
      ),
    );
  }

  Widget _buildTowBanner(Ads childBanner, BuildContext context) {
    return Expanded(
      child: Container(
        child: childBanner.imagePath == ''
            ? Container()
            : GestureDetector(
                onTap: () {
                  if (childBanner.adsType == 'Category') {
                    // Send it to SeeMore with Category name
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SeeMoreScreen(
                          categoryName: childBanner.isMain == 1
                              ? childBanner.adsValue
                              : '',
                          subCategoryName: childBanner.isMain == 1
                              ? childBanner.adsValue
                              : '',
                        ),
                      ),
                    );
                  } else if (childBanner.adsType == 'Brand') {
                    // Send It To Brands with brand name , brand ID
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BrandProductsScreen(
                            childBanner.brandName, childBanner.adsValue),
                      ),
                    );
                  } else if (childBanner.adsType == 'Product') {
                    // send it  to product Details with product Id
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetails(int.parse(childBanner.adsValue)),
                      ),
                    );
                  }
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    childBanner.imagePath,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  bool _isLoading = true, _isInit = true, _contentVisible = false;
  final UserProvider userProvider = UserProvider();
  final AppLanguageProvider appLanguageProvider = AppLanguageProvider();
  HomePageModel homePageModel;

  fetchHomeData() async {
    print('Home calling');
    var token = await userProvider.isAuthenticated();
    var lang = appLanguageProvider.appLocal.toString();
    Provider.of<ProductsProvider>(context, listen: false)
        .fetchAllProducts(lang, token['Authorization'])
        .then((data) {
      List<Ads> _imagesAds = [];
      setState(() {
        homePageModel = data;
        _imagesAds = homePageModel.ads;
        if (_imagesAds != null) {
          _imagesAds.forEach((slide) {
            if (slide.adsSection == 'Slide') {
              slidesBanner.add(slide);
            } else if (slide.adsSection == 'A') {
              _allAds['bannerA'] = slide;
            } else if (slide.adsSection == 'B') {
              _allAds['bannerB'] = slide;
            } else if (slide.adsSection == 'Devices') {
              _allAds['bannerDevice'] = slide;
            } else if (slide.adsSection == 'Makeup') {
              _allAds['bannerMakeup'] = slide;
            } else if (slide.adsSection == 'Perfume') {
              _allAds['bannerPerfume'] = slide;
            } else if (slide.adsSection == 'Lenses') {
              _allAds['bannerLenses'] = slide;
            } else if (slide.adsSection == 'Care') {
              _allAds['bannerCare'] = slide;
            } else if (slide.adsSection == 'Nails') {
              _allAds['bannerNails'] = slide;
            } else if (slide.adsSection == 'Ads') {
              _allAds['adsBanner'] = slide;
            }
          });
        }
        _isLoading = false;
      });
      Future.delayed(Duration(milliseconds: 1500), () {
        setState(() {
          _contentVisible = true;
        });
      });
    });
  }

  _drawAdsBanner(Ads ads, BuildContext context) {
    return ads != null
        ? GestureDetector(
            onTap: () {
              if (_allAds['adsBanner'].adsType == 'Category') {
                // Send it to SeeMore with Category name
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SeeMoreScreen(
                      categoryName: _allAds['adsBanner'].isMain == 1
                          ? _allAds['adsBanner'].adsValue
                          : '',
                      subCategoryName: _allAds['adsBanner'].isMain == 1
                          ? _allAds['adsBanner'].adsValue
                          : '',
                    ),
                  ),
                );
              } else if (_allAds['adsBanner'].adsType == 'Brand') {
                // Send It To Brands with brand name , brand ID
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BrandProductsScreen(
                        _allAds['adsBanner'].brandName,
                        _allAds['adsBanner'].adsValue),
                  ),
                );
              } else if (_allAds['adsBanner'].adsType == 'Product') {
                // send it  to product Details with product Id
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProductDetails(
                        int.parse(_allAds['adsBanner'].adsValue)),
                  ),
                );
              }
            },
            child: Container(
              height: 200.0,
              margin: const EdgeInsets.all(16.0),
              child: Image.network(
                _allAds['adsBanner'].imagePath,
                fit: BoxFit.cover,
              ),
            ))
        : Container();
  }

  _drawCategoryList(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 16.0, left: 16.0),
      // categories listView  Section
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: <Widget>[
          CategoryItem(
              color: CustomColors.kCategoryColor1,
              icon: 'assets/icons/makeup.png',
              size: 80.0,
              categoryName: AppLocalization.of(context).translate('Makeup'),
              action: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SeeMoreScreen(
                      categoryName: 'Makeup',
                      subCategoryName: '',
                    ),
                  ),
                );
              }),
          CategoryItem(
              color: CustomColors.kCategoryColor2,
              icon: 'assets/icons/perfume.png',
              size: 80.0,
              categoryName: AppLocalization.of(context).translate('Perfume'),
              action: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SeeMoreScreen(
                      categoryName: 'Perfume',
                      subCategoryName: '',
                    ),
                  ),
                );
              }),
          CategoryItem(
              color: CustomColors.kCategoryColor3,
              icon: 'assets/icons/care.png',
              size: 80.0,
              categoryName: AppLocalization.of(context).translate('Care'),
              action: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SeeMoreScreen(
                      categoryName: 'Care',
                      subCategoryName: '',
                    ),
                  ),
                );
              }),
          CategoryItem(
              color: CustomColors.kCategoryColor4,
              icon: 'assets/icons/nails.png',
              size: 80.0,
              categoryName: AppLocalization.of(context).translate('Nails'),
              action: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SeeMoreScreen(
                      categoryName: 'Nails',
                      subCategoryName: '',
                    ),
                  ),
                );
              }),
          CategoryItem(
              color: CustomColors.kCategoryColor5,
              icon: 'assets/icons/device.png',
              size: 80.0,
              categoryName: AppLocalization.of(context).translate('Devices'),
              action: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SeeMoreScreen(
                      categoryName: 'Devices',
                      subCategoryName: '',
                    ),
                  ),
                );
              }),
          CategoryItem(
              color: CustomColors.kCategoryColor6,
              icon: 'assets/icons/lensess.png',
              size: 80.0,
              categoryName: AppLocalization.of(context).translate('Lenses'),
              action: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SeeMoreScreen(
                      categoryName: 'Lenses',
                      subCategoryName: '',
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }

  _drawTwinBanner(BuildContext context) {
    return _allAds['bannerA'] == null && _allAds['bannerB'] == null
        ? Container()
        : Container(
            margin: const EdgeInsets.only(
                left: 16.0, right: 16.0, top: 10.0, bottom: 5.0),
            height: 230.0,
            child: Row(
              children: <Widget>[
                _allAds['bannerA'] == null
                    ? Container()
                    : _buildTowBanner(_allAds['bannerA'], context),
                SizedBox(
                  width: 10.0,
                ),
                _allAds['bannerB'] == null
                    ? Container()
                    : _buildTowBanner(_allAds['bannerB'], context),
              ],
            ),
          );
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      fetchHomeData();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _doRefresh() async {
    fetchHomeData();
  }

  ScreenConfig screenConfig;
  WidgetSize widgetSize;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    screenConfig = ScreenConfig(context);
    widgetSize = WidgetSize(screenConfig);
    return _isLoading
        ? Center(
            child: AdaptiveProgressIndicator(),
          )
        : AnimatedOpacity(
            opacity: _contentVisible ? 1 : 0,
            duration: Duration(milliseconds: 700),
            child: RefreshIndicator(
              key: _homeIndicatorKey,
              onRefresh: _doRefresh,
              child: Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: Text(
                    AppLocalization.of(context).translate('app_name'),
                    style: TextStyle(
                        fontSize: widgetSize.mainTitle,
                        fontWeight: FontWeight.bold),
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
                body: SingleChildScrollView(
                    child: homePageModel != null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              slidesBanner.length > 0
                                  ? _buildImagesSlider(context, slidesBanner)
                                  : Container(),
                              _drawAdsBanner(_allAds['adsBanner'], context),
                              Container(
                                margin: const EdgeInsets.only(
                                    top: 20.0,
                                    right: 16.0,
                                    left: 16.0,
                                    bottom: 10.0),
                                child: Text(
                                  AppLocalization.of(context)
                                      .translate("category_in_nav_bar"),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: widgetSize.content),
                                ),
                              ),
                              _drawCategoryList(context),
                              _drawTwinBanner(context),
                              _buildCategoryTitleWithSeeMore(
                                  AppLocalization.of(context)
                                      .translate("best_sellers"),
                                  () {},
                                  context),
                              Container(
                                height: widgetSize.productCardSize,
                                child: homePageModel != null
                                    ? ProductListView(homePageModel.bestSeller)
                                    : Container(),
                              ),
                              _allAds['bannerMakeup'] == null
                                  ? Container()
                                  : _buildCategoryBanner(
                                      _allAds['bannerMakeup'], context),
                              _buildCategoryTitleWithSeeMore(
                                  AppLocalization.of(context)
                                      .translate("Makeup"), () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => SeeMoreScreen(
                                          categoryName: 'Makeup',
                                          subCategoryName: '',
                                        )));
                              }, context),
                              Container(
                                  height: widgetSize.productCardSize,
                                  child: homePageModel != null
                                      ? ProductListView(homePageModel.makeup)
                                      : Container()),
                              _allAds['bannerPerfume'] == null
                                  ? Container()
                                  : _buildCategoryBanner(
                                      _allAds['bannerPerfume'], context),
                              _buildCategoryTitleWithSeeMore(
                                  AppLocalization.of(context)
                                      .translate("Perfume"), () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => SeeMoreScreen(
                                          categoryName: 'Perfume',
                                          subCategoryName: '',
                                        )));
                              }, context),
                              Container(
                                  height: widgetSize.productCardSize,
                                  child: homePageModel != null
                                      ? ProductListView(homePageModel.perfume)
                                      : Container()),
                              _allAds['bannerCare'] == null
                                  ? Container()
                                  : _buildCategoryBanner(
                                      _allAds['bannerCare'], context),
                              _buildCategoryTitleWithSeeMore(
                                  AppLocalization.of(context).translate("Care"),
                                  () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => SeeMoreScreen(
                                          categoryName: 'Care',
                                          subCategoryName: '',
                                        )));
                              }, context),
                              Container(
                                  height: widgetSize.productCardSize,
                                  child: homePageModel != null
                                      ? ProductListView(homePageModel.care)
                                      : Container()),
                              _allAds['bannerNails'] == null
                                  ? Container()
                                  : _buildCategoryBanner(
                                      _allAds['bannerNails'], context),
                              _buildCategoryTitleWithSeeMore(
                                  AppLocalization.of(context)
                                      .translate("Nails"), () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => SeeMoreScreen(
                                        categoryName: 'Nails',
                                        subCategoryName: '')));
                              }, context),
                              Container(
                                  height: widgetSize.productCardSize,
                                  child: homePageModel != null
                                      ? ProductListView(homePageModel.nails)
                                      : Container()),
                              _allAds['bannerLenses'] == null
                                  ? Container()
                                  : _buildCategoryBanner(
                                      _allAds['bannerLenses'], context),
                              _buildCategoryTitleWithSeeMore(
                                  AppLocalization.of(context)
                                      .translate("Lenses"), () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => SeeMoreScreen(
                                        categoryName: 'Lenses',
                                        subCategoryName: '')));
                              }, context),
                              Container(
                                  height: widgetSize.productCardSize,
                                  child: homePageModel != null
                                      ? ProductListView(homePageModel.lenses)
                                      : Container()),
                              _allAds['bannerDevice'] == null
                                  ? Container()
                                  : _buildCategoryBanner(
                                      _allAds['bannerDevice'], context),
                              _buildCategoryTitleWithSeeMore(
                                  AppLocalization.of(context)
                                      .translate("Devices"), () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => SeeMoreScreen(
                                        categoryName: 'Devices',
                                        subCategoryName: '')));
                              }, context),
                              Container(
                                  height: widgetSize.productCardSize,
                                  child: homePageModel != null
                                      ? ProductListView(homePageModel.devices)
                                      : Container()),
                            ],
                          )
                        : Container(
                            height: screenConfig.screenHeight,
                            width: screenConfig.screenWidth,
                            child: Center(
                              child: Text(AppLocalization.of(context)
                                  .translate('home_page_hint')),
                            ),
                          )),
              ),
            ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
