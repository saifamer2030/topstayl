import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:topstyle/helper/appLocalization.dart';
import 'package:topstyle/screens/login_screen.dart';

main() {
  Widget makeWidgetTestable(Widget child) {
    return MaterialApp(
      localizationsDelegates: [
        AppLocalization.delegate,
      ],
      locale: Locale('ar', ''),
      home: child,
    );
  }

  testWidgets('login test', (WidgetTester tester) async {
    LoginScreen loginScreen = LoginScreen();
    await tester.pumpWidget(makeWidgetTestable(loginScreen));
    await tester.pump();
  });
}
