import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:topstyle/helper/api_util.dart';
import 'package:topstyle/helper/appLocalization.dart';
import 'package:topstyle/helper/size_config.dart';
import 'package:topstyle/providers/languages_provider.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  static const String routeName = 'privacy-policy';

  final AppLanguageProvider appLanguage = AppLanguageProvider();
  ScreenConfig screenConfig;
  WidgetSize widgetSize;
  @override
  Widget build(BuildContext context) {
    screenConfig = ScreenConfig(context);
    widgetSize = WidgetSize(screenConfig);
    return WebviewScaffold(
      url: '${ApiUtil.BASE_URL}privacy/${appLanguage.fetchLocale().toString()}',
      appBar: AppBar(
        title: Text(
          AppLocalization.of(context).translate('privacy_policy'),
          style: TextStyle(fontSize: widgetSize.mainTitle),
        ),
        centerTitle: true,
      ),
    );
  }
}
