import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:topstyle/helper/appLocalization.dart';
import 'package:topstyle/providers/languages_provider.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  static const String routeName = 'privacy-policy';

  final AppLanguageProvider appLanguage = AppLanguageProvider();

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url:
          'https://topstylesa.com/api/privacy/${appLanguage.fetchLocale().toString()}',
      appBar: AppBar(
        title: Text(
          AppLocalization.of(context).translate('privacy_policy'),
          style: TextStyle(fontSize: 18.0),
        ),
        centerTitle: true,
      ),
    );
  }
}
