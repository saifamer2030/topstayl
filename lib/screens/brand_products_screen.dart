import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topstyle/helper/appLocalization.dart';
import 'package:topstyle/models/products_model.dart';
import 'package:topstyle/providers/network_provider.dart';
import 'package:topstyle/providers/products_provider.dart';
import 'package:topstyle/widgets/adaptive_progress_indecator.dart';
import 'package:topstyle/widgets/connectivity_widget.dart';
import 'package:topstyle/widgets/product_item.dart';

class BrandProductsScreen extends StatefulWidget {
  final String brandName;
  final String brandId;

  BrandProductsScreen(this.brandName, this.brandId);

  @override
  _BrandProductsScreenState createState() => _BrandProductsScreenState();
}

class _BrandProductsScreenState extends State<BrandProductsScreen> {
  bool _isLoading = true;
  bool _isInit = true;
  int pageNumber = 1;
  int lastPage = 0;
  int pageNumberOrdered = 1;
  bool loaded = false;
  List<ProductsModel> _products = [];
  ScrollController _controller = ScrollController();

  getBrandProducts(int pageNumber) async {
    Provider.of<ProductsProvider>(context)
        .allDataWithSpecificBrand(widget.brandId, pageNumber)
        .then((products) {
      var list = products['data'] as List;
      _products.addAll(List<ProductsModel>.from(list));
      lastPage = products['last_page'];
      print('call product num $pageNumber and lenght is ${_products.length}');
      setState(() {
        _isLoading = false;
      });
    });
  }

  loadMore() async {
    pageNumber++;
    if (pageNumber <= lastPage) getBrandProducts(pageNumber);
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      double _maxScroll = _controller.position.maxScrollExtent;
      double _currentScroll = _controller.position.pixels;
      double _delta = _maxScroll * 0.20 / pageNumberOrdered;
      if (_maxScroll - _currentScroll <= _delta) {
        if (loaded == false) {
          loaded = true;
          loadMore();
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      getBrandProducts(pageNumber);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Provider<NetworkProvider>.value(
      value: NetworkProvider(),
      child: Consumer<NetworkProvider>(
        builder: (context, value, _) => Center(
            child: Scaffold(
          body: ConnectivityWidget(
            networkProvider: value,
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  widget.brandName,
                  style: TextStyle(fontSize: 18.0),
                ),
                centerTitle: true,
              ),
              body: _isLoading
                  ? Center(
                      child: AdaptiveProgressIndicator(),
                    )
                  : _products.length > 1
                      ? GridView.builder(
                          controller: _controller,
                          itemCount: _products.length,
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 10.0,
                                  crossAxisSpacing: 10.0,
                                  childAspectRatio: 2 / 3.4),
                          itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                            value: _products[i],
                            child: ProductItem(),
                          ),
                        )
                      : Center(
                          child: Text(AppLocalization.of(context)
                              .translate('no_products')),
                        ),
            ),
          ),
        )),
      ),
    );
  }
}
