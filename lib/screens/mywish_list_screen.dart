import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topstyle/helper/appLocalization.dart';
import 'package:topstyle/models/products_model.dart';
import 'package:topstyle/providers/languages_provider.dart';
import 'package:topstyle/providers/products_provider.dart';
import 'package:topstyle/providers/user_provider.dart';
import 'package:topstyle/widgets/adaptive_progress_indecator.dart';
import 'package:topstyle/widgets/product_item.dart';

class MyWishListScreen extends StatefulWidget {
  static const String routeName = 'mywish-list-screen';

  @override
  _MyWishListScreenState createState() => _MyWishListScreenState();
}

class _MyWishListScreenState extends State<MyWishListScreen> {
  bool _init = false;
  bool _isLoading = true;
  List<ProductsModel> _products;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_init) {
      fetchFavoriteData();
    }
    _init = true;
  }

  final AppLanguageProvider languageProvider = AppLanguageProvider();
  final UserProvider userProvider = UserProvider();
  fetchFavoriteData() async {
    var lang = languageProvider.appLocal.toString();
    var token = await userProvider.isAuthenticated();
    Provider.of<ProductsProvider>(context, listen: false)
        .allFavoriteProducts(lang, token['Authorization'])
        .then((list) {
      if (list.length <= 0) {
        _products = [];
      } else {
        _products = list;
      }
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // final prod = Provider.of<ProductsProvider>(context).favorite;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppLocalization.of(context).translate("wish_list"),
          style: TextStyle(fontSize: 18.0),
        ),
      ),
      body: Container(
        child: _isLoading
            ? Center(
                child: AdaptiveProgressIndicator(),
              )
            : _products.length != 0
                ? GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 2 / 3.3,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0),
                    itemBuilder: (context, index) =>
                        ChangeNotifierProvider.value(
                            value: _products[index], child: ProductItem()),
                    itemCount: _products.length,
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.favorite,
                          size: 55,
                        ),
                        Text(AppLocalization.of(context)
                            .translate("your_favorite_empty"))
                      ],
                    ),
                  ),
      ),
    );
  }
}
