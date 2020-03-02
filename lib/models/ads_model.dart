class Ads {
  final String imagePath;
  final String adsSection;
  final String adsType;
  final String adsValue;
  final int isMain;
  final String brandName;

  Ads(
      {this.imagePath,
      this.adsSection,
      this.adsType,
      this.adsValue,
      this.isMain,
      this.brandName});

  factory Ads.fromJson(json) {
    return Ads(
        imagePath: json['img_path'] as String,
        adsSection: json['ads_section'] as String,
        adsType: json['ads_type'] as String,
        adsValue: json['ads_value'],
        isMain: json['isMain'] as int,
        brandName: json['brandName'] as String);
  }
}
