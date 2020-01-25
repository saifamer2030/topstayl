class CityModel {
  final String cityNameAr;
  final String cityNameEn;
  final int isAvailable;

  CityModel({this.cityNameAr, this.cityNameEn, this.isAvailable});

  factory CityModel.fromJson(Map<String, dynamic> cityJson) {
    return CityModel(
        cityNameAr: cityJson['city_ar'],
        cityNameEn: cityJson['city_en'],
        isAvailable: cityJson['available'] as int);
  }
}
