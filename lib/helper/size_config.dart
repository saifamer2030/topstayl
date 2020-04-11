import 'package:flutter/material.dart';

enum ScreenType { SMALL, MEDIUM, LARGE }

class ScreenConfig {
  BuildContext context;
  ScreenConfig(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    _init();
  }

  double screenWidth;
  double screenHeight;
  ScreenType screenType;

  _init() {
    if (screenWidth >= 320 && screenWidth < 375) {
      screenType = ScreenType.SMALL;
    } else if (screenWidth >= 375 && screenWidth < 414) {
      screenType = ScreenType.MEDIUM;
    } else if (screenWidth >= 414) {
      screenType = ScreenType.LARGE;
    }
  }
}

class WidgetSize {
  ScreenConfig screenConfig;
  double mainTitle;
  double subTitle;
  double content;
  double content2;
  double iconText;
  double categoryCard;
  double textField;
  double textFieldError;
  double favoriteIconSize;
  double productCardSize;
  WidgetSize(ScreenConfig screenConfig) {
    this.screenConfig = screenConfig;
    _init();
  }

  _init() {
    switch (this.screenConfig.screenType) {
      case ScreenType.SMALL:
        this.mainTitle = 16.0;
        this.subTitle = 12.0;
        this.content = 14.0;
        this.content2 = 13.0;
        this.iconText = 10.0;
        this.categoryCard = 60.0;
        this.textField = 40.0;
        this.textFieldError = 10.0;
        this.favoriteIconSize = 25.0;
        this.productCardSize = 260.0;
        break;
      case ScreenType.MEDIUM:
        this.mainTitle = 18.0;
        this.subTitle = 14.0;
        this.content = 18.0;
        this.content2 = 15.0;
        this.iconText = 12.0;
        this.categoryCard = 80.0;
        this.textField = 45.0;
        this.textFieldError = 12.0;
        this.favoriteIconSize = 27.0;
        this.productCardSize = 300.0;
        break;
      case ScreenType.LARGE:
        this.mainTitle = 20.0;
        this.subTitle = 16.0;
        this.content = 18.0;
        this.content2 = 15.0;
        this.iconText = 12.0;
        this.categoryCard = 80.0;
        this.textField = 45.0;
        this.textFieldError = 12.0;
        this.favoriteIconSize = 30.0;
        this.productCardSize = 310.0;
        break;
      default:
        this.mainTitle = 18.0;
        this.content = 18.0;
        this.iconText = 13.0;

        break;
    }
  }
}
