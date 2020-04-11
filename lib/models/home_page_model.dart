import 'package:topstyle/models/ads_model.dart';
import 'package:topstyle/models/products_model.dart';

class HomePageModel {
  List<Ads> ads;
  List<ProductsModel> bestSeller;
  List<ProductsModel> makeup;
  List<ProductsModel> perfume;
  List<ProductsModel> care;
  List<ProductsModel> nails;
  List<ProductsModel> lenses;
  List<ProductsModel> devices;

  HomePageModel(
      {this.ads,
      this.bestSeller,
      this.makeup,
      this.perfume,
      this.care,
      this.nails,
      this.lenses,
      this.devices});
  factory HomePageModel.fromJson(Map<String, dynamic> jsonObject) {
    return HomePageModel(
      ads: Ads.parseAds(jsonObject['ads']),
      makeup: ProductsModel.parseProducts(jsonObject['Makeup']),
      bestSeller: ProductsModel.parseProducts(jsonObject['Best_Seller']),
      perfume: ProductsModel.parseProducts(jsonObject['Perfume']),
      care: ProductsModel.parseProducts(jsonObject['Care']),
      nails: ProductsModel.parseProducts(jsonObject['Nails']),
      lenses: ProductsModel.parseProducts(jsonObject['Lenses']),
      devices: ProductsModel.parseProducts(jsonObject['Devices']),
    );
  }
}
