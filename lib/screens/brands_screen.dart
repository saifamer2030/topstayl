import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topstyle/constants/colors.dart';
import 'package:topstyle/helper/appLocalization.dart';
import 'package:topstyle/helper/size_config.dart';
import 'package:topstyle/models/brand_model.dart';
import 'package:topstyle/providers/brands_provider.dart';
import 'package:topstyle/widgets/adaptive_progress_indecator.dart';
import 'package:topstyle/widgets/brand_item.dart';

class BrandsScreen extends StatefulWidget {
  @override
  _BrandsScreenState createState() => _BrandsScreenState();
}

class _BrandsScreenState extends State<BrandsScreen> {
  List<BrandModel> _brands = [];
  List<BrandModel> _filteredBrands = [];
  String searchKey = '';
  bool _isLoading = true;
  bool _isInit = true;

  getBrandData() async {
    setState(() {
      _isLoading = true;
    });
    _brands = await Provider.of<BrandsProvider>(context, listen: false)
        .allBrandsData();
    _brands.sort((a, b) => a.brandName.compareTo(b.brandName));
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      getBrandData();
    }
    setState(() {
      _isInit = false;
    });
    super.didChangeDependencies();
  }

  onSearchTextChanged(String text) async {
    _filteredBrands.clear();
    if (text.isEmpty || text == '') {
      setState(() {
        _filteredBrands.clear();
      });
      return;
    }
    _brands.forEach((userDetail) {
      if (userDetail.brandName.toLowerCase().contains(text.toLowerCase()))
        setState(() {
          _filteredBrands.add(userDetail);
        });
    });
    print(_filteredBrands.length);
  }

  ScreenConfig screenConfig;
  WidgetSize widgetSize;
  @override
  Widget build(BuildContext context) {
    screenConfig = ScreenConfig(context);
    widgetSize = WidgetSize(screenConfig);
    return _isLoading
        ? Center(
            child: AdaptiveProgressIndicator(),
          )
        : Container(
            margin:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: _brands.length > 0 || _filteredBrands.length > 0
                ? Column(
                    children: <Widget>[
                      Container(
                          height: 45.0,
                          margin: const EdgeInsets.only(bottom: 24.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 1.0, color: CustomColors.kPCardColor),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0),
                                hintText: AppLocalization.of(context)
                                    .translate("brand_search_hint"),
                                hintStyle: TextStyle(
                                    color: CustomColors.kTabBarIconColor),
                              ),
//
                              onChanged: (val) {
                                onSearchTextChanged(val);
                              },
                            ),
                          )),
                      Expanded(
                        child:
                            _filteredBrands.length > 0 && searchKey != null ||
                                    searchKey != ''
                                ? ListView.builder(
                                    addAutomaticKeepAlives: true,
                                    itemCount: _filteredBrands.length,
                                    itemBuilder: (context, index) => Container(
                                      margin: const EdgeInsets.only(top: 16.0),
                                      child: BrandItem(
                                          _filteredBrands[index].brandId,
                                          _filteredBrands[index].brandName,
                                          _filteredBrands[index].brandImage,
                                          widgetSize.content),
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: _brands.length,
                                    itemBuilder: (context, index) => Container(
                                      margin: const EdgeInsets.only(top: 16.0),
                                      child: BrandItem(
                                          _brands[index].brandId,
                                          _brands[index].brandName,
                                          _brands[index].brandImage,
                                          widgetSize.content),
                                    ),
                                  ),
                      ),
                    ],
                  )
                : Center(
                    child: Text(
                      AppLocalization.of(context).translate('no_brands'),
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
          );
  }
}
