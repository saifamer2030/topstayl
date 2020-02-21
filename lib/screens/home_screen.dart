import 'dart:convert';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:topstyle/constants/colors.dart';
import 'package:topstyle/helper/appLocalization.dart';
import 'package:topstyle/helper/size_config.dart';
import 'package:topstyle/models/ads_model.dart';
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
  List<Ads> _images = [];
  List<Ads> slidesBanner = [];
  Ads adsBanner;
  Ads bannerA;
  Ads bannerB;
  Ads bannerMakeup;
  Ads bannerPerfume;
  Ads bannerCare;
  Ads bannerLenses;
  Ads bannerDevice;
  Ads bannerNails;
  List<Ads> category = [];

  Widget _buildImagesSlider() {
    return Container(
      height: 240,
      width: double.infinity,
      child: slidesBanner.length > 0
          ? Carousel(
              //boxFit: BoxFit.fitHeight,
              images: slidesBanner
                  .map(
                    (imageUrl) => Container(
                      padding: EdgeInsets.only(bottom: 40.0),
                      child: Image.network(
                        imageUrl.imagePath,
                        fit: BoxFit.contain,
                      ),
                    ),
                  )
                  .toList(),
              autoplay: true,
              dotIncreaseSize: 1.2,
              dotSize: 10.0,
              dotSpacing: 17.0,
              indicatorBgPadding: 0.0,
              dotBgColor: Colors.white,
              dotColor: Color(0xff9d9d9d).withOpacity(0.5),
              dotIncreasedColor: Color(0xff9d9d9d),
              onImageTap: (int index) {
                // write code when slide clicked go to advertisement content
                print(index);
              },
            )
          : Container(
              color: Colors.grey,
            ),
    );
  } // image slider method

  Widget _buildCategoryTitleWithSeeMore(String title, Function action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(
              top: 20.0, left: 16.0, right: 16.0, bottom: 10.0),
          child: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
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

  Widget _buildCategoryBanner(String bannerUrl, Function action) {
    return GestureDetector(
      onTap: action,
      child: Container(
        height: 150,
        margin: const EdgeInsets.only(
            left: 16.0, right: 16.0, top: 30.0, bottom: 20.0),
        child: bannerUrl == ''
            ? Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.grey),
              )
            : Image.network(
                bannerUrl,
                fit: BoxFit.fill,
              ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0), color: Colors.grey),
      ),
    );
  }

  Widget _buildTowBanner(String bannerUrl) {
    return Expanded(
      child: Container(
        child: bannerUrl == ''
            ? Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.grey),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  bannerUrl,
                  fit: BoxFit.fill,
                ),
              ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  bool _isLoading = true;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      SharedPreferences.getInstance().then((prefs) {
        if (prefs.getString('userData') != null) {
          final data = jsonDecode(prefs.getString('userData')) as Map;
          Provider.of<ProductsProvider>(context, listen: false)
              .fetchAllProducts(
                  prefs.getString('language_code') == null
                      ? 'ar'
                      : prefs.getString('language_code'),
                  data['userToken'])
              .then((value) {
            _images = value;
            _images.forEach(
              (slide) {
                if (slide.adsSection == 'Slide') {
                  slidesBanner.add(slide);
                } else if (slide.adsSection == 'A') {
                  bannerA = slide;
                } else if (slide.adsSection == 'B') {
                  bannerB = slide;
                } else if (slide.adsSection == 'Devices') {
                  bannerDevice = slide;
                } else if (slide.adsSection == 'Makeup') {
                  bannerMakeup = slide;
                } else if (slide.adsSection == 'Perfume') {
                  bannerPerfume = slide;
                } else if (slide.adsSection == 'Lenses') {
                  bannerLenses = slide;
                } else if (slide.adsSection == 'Care') {
                  bannerCare = slide;
                } else if (slide.adsSection == 'Nails') {
                  bannerCare = slide;
                } else if (slide.adsSection == 'Ads') {
                  adsBanner = slide;
                }
              },
            );
            setState(() {
              _isLoading = false;
            });
          });
        } else {
//          print('User not Registered');
          Provider.of<ProductsProvider>(context, listen: false)
              .fetchAllProducts(
                  prefs.getString('language_code') == null
                      ? 'ar'
                      : prefs.getString('language_code'),
                  'none')
              .then((value) {
            _images = value;
            _images.forEach(
              (slide) {
                if (slide.adsSection == 'Slide') {
                  slidesBanner.add(slide);
                } else if (slide.adsSection == 'A') {
                  bannerA = slide;
                } else if (slide.adsSection == 'B') {
                  bannerB = slide;
                } else if (slide.adsSection == 'Devices') {
                  bannerDevice = slide;
                } else if (slide.adsSection == 'Makeup') {
                  bannerMakeup = slide;
                } else if (slide.adsSection == 'Perfume') {
                  bannerPerfume = slide;
                } else if (slide.adsSection == 'Lenses') {
                  bannerLenses = slide;
                } else if (slide.adsSection == 'Care') {
                  bannerCare = slide;
                } else if (slide.adsSection == 'Nails') {
                  bannerCare = slide;
                } else if (slide.adsSection == 'Ads') {
                  adsBanner = slide;
                }
              },
            );
            setState(() {
              _isLoading = false;
            });
          });
        }
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  ScreenConfig screenConfig;
  WidgetSize widgetSize;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    screenConfig = ScreenConfig(context);
    widgetSize = WidgetSize(screenConfig);
    final makeupProducts = Provider.of<ProductsProvider>(
      context,
    ).makeup;
    final bestSellerProducts =
        Provider.of<ProductsProvider>(context).bestSeller;
    final perfumesProducts = Provider.of<ProductsProvider>(context).perfume;
    final careProducts = Provider.of<ProductsProvider>(context).care;
    final nailsProducts = Provider.of<ProductsProvider>(context).nails;
    final lensesProducts = Provider.of<ProductsProvider>(context).lenses;
    final devicesProducts = Provider.of<ProductsProvider>(context).devices;
    return SingleChildScrollView(
      child: !_isLoading
          ? Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  slidesBanner.length > 0 ? _buildImagesSlider() : Container(),
                  adsBanner != null
                      ? GestureDetector(
                          onTap: () {
                            if (adsBanner.adsType == 'Category') {
                              String categoryName = adsBanner.adsValue;
//                              print(categoryName);
//                              Navigator.of(context).push(MaterialPageRoute(
//                                  builder: (context) =>
//                                      SeeMoreScreen('adsBanner.adsType')));

                              // Send it to SeeMore with Category name
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => SeeMoreScreen(
                                    categoryName: 'Makeup',
                                    subCategoryName: '',
                                  ),
                                ),
                              );
                            } else if (adsBanner.adsType == 'Brand') {
                              // Send It To Brands with brand name , brand ID
                            } else if (adsBanner.adsType == 'Product') {
                              // send it  to product Details with product Id
                            }
                          },
                          child: Container(
                            height: 200.0,
                            margin: const EdgeInsets.all(16.0),
                            child: Image.network(
                              adsBanner.imagePath,
                              fit: BoxFit.cover,
                            ),
                          ))
                      : Container(),
                  Container(
                    margin: const EdgeInsets.only(
                        top: 20.0, right: 16.0, left: 16.0, bottom: 10.0),
                    child: Text(
                      AppLocalization.of(context)
                          .translate("category_in_nav_bar"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: widgetSize.content),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 16.0, left: 16.0),
                    // categories listView  Section
                    height: 100,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        CategoryItem(
                            color: CustomColors.kCategoryColor1,
                            icon: 'assets/icons/makeup.png',
                            size: 80.0,
                            categoryName:
                                AppLocalization.of(context).translate('Makeup'),
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
                            categoryName: AppLocalization.of(context)
                                .translate('Perfume'),
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
                            categoryName:
                                AppLocalization.of(context).translate('Care'),
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
                            categoryName:
                                AppLocalization.of(context).translate('Nails'),
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
                            categoryName: AppLocalization.of(context)
                                .translate('Devices'),
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
                            categoryName:
                                AppLocalization.of(context).translate('Lenses'),
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
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        left: 16.0, right: 16.0, top: 30.0, bottom: 10.0),
                    height: 230.0,
                    child: Row(
                      children: <Widget>[
                        bannerA == null
                            ? _buildTowBanner('')
                            : _buildTowBanner(bannerA.imagePath),
                        SizedBox(
                          width: 10.0,
                        ),
                        bannerB == null
                            ? _buildTowBanner('')
                            : _buildTowBanner(bannerB.imagePath),
                      ],
                    ),
                  ),
                  _buildCategoryTitleWithSeeMore(
                      AppLocalization.of(context).translate("best_sellers"),
                      () {}),
                  Container(
                    height: widgetSize.productCardSize,
                    child: ProductListView(bestSellerProducts),
                  ),
                  bannerMakeup == null
                      ? _buildCategoryBanner('', null)
                      : _buildCategoryBanner(bannerMakeup.imagePath, () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SeeMoreScreen(
                                    categoryName: 'Makeup',
                                    subCategoryName: '',
                                  )));
                        }),
                  _buildCategoryTitleWithSeeMore(
                      AppLocalization.of(context).translate("Makeup"), () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SeeMoreScreen(
                              categoryName: 'Makeup',
                              subCategoryName: '',
                            )));
                  }),
                  Container(
                      height: widgetSize.productCardSize,
                      child: ProductListView(makeupProducts)),
                  bannerPerfume == null
                      ? _buildCategoryBanner('', null)
                      : _buildCategoryBanner(bannerPerfume.imagePath, () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SeeMoreScreen(
                                    categoryName: 'Perfume',
                                    subCategoryName: '',
                                  )));
                        }),
                  _buildCategoryTitleWithSeeMore(
                      AppLocalization.of(context).translate("Perfume"), () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SeeMoreScreen(
                              categoryName: 'Perfume',
                              subCategoryName: '',
                            )));
                  }),
                  Container(
                      height: widgetSize.productCardSize,
                      child: ProductListView(perfumesProducts)),
                  bannerCare == null
                      ? _buildCategoryBanner('', null)
                      : _buildCategoryBanner(bannerCare.imagePath, () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SeeMoreScreen(
                                    categoryName: 'Care',
                                    subCategoryName: '',
                                  )));
                        }),
                  _buildCategoryTitleWithSeeMore(
                      AppLocalization.of(context).translate("Care"), () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SeeMoreScreen(
                              categoryName: 'Care',
                              subCategoryName: '',
                            )));
                  }),
                  Container(
                      height: widgetSize.productCardSize,
                      child: ProductListView(careProducts)),
                  bannerNails == null
                      ? _buildCategoryBanner('', null)
                      : _buildCategoryBanner(bannerNails.imagePath, () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SeeMoreScreen(
                                  categoryName: 'Nails', subCategoryName: '')));
                        }),
                  _buildCategoryTitleWithSeeMore(
                      AppLocalization.of(context).translate("Nails"), () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SeeMoreScreen(
                            categoryName: 'Nails', subCategoryName: '')));
                  }),
                  Container(
                      height: widgetSize.productCardSize,
                      child: ProductListView(nailsProducts)),
                  bannerLenses == null
                      ? _buildCategoryBanner('', null)
                      : _buildCategoryBanner(bannerLenses.imagePath, () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SeeMoreScreen(
                                  categoryName: 'Lenses',
                                  subCategoryName: '')));
                        }),
                  _buildCategoryTitleWithSeeMore(
                      AppLocalization.of(context).translate("Lenses"), () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SeeMoreScreen(
                            categoryName: 'Lenses', subCategoryName: '')));
                  }),
                  Container(
                      height: widgetSize.productCardSize,
                      child: ProductListView(lensesProducts)),
                  bannerDevice == null
                      ? _buildCategoryBanner('', null)
                      : _buildCategoryBanner(bannerDevice.imagePath, () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SeeMoreScreen(
                                  categoryName: 'Devices',
                                  subCategoryName: '')));
                        }),
                  _buildCategoryTitleWithSeeMore(
                      AppLocalization.of(context).translate("Devices"), () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SeeMoreScreen(
                            categoryName: 'Devices', subCategoryName: '')));
                  }),
                  Container(
                      height: widgetSize.productCardSize,
                      child: ProductListView(devicesProducts)),
                ],
              ),
            )
          : Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: AdaptiveProgressIndicator(),
              ),
            ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
