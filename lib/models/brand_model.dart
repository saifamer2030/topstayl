class BrandModel {
  final int brandId;
  final String brandName;
  final String brandImage;

  BrandModel({this.brandId, this.brandName, this.brandImage});

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
        brandId: json['id'] as int,
        brandName: json['name'] as String,
        brandImage: json['image'] as String);
  }

  static List<BrandModel> parsedJson(jsonData) {
    var _list = jsonData as List;
    List<BrandModel> _brands =
        _list.map((data) => BrandModel.fromJson(data)).toList();
    return _brands;
  }
}
