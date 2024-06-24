import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_parking_system/components/login/login_main.dart';

void main() {
  testWidgets('LoginMainPage UI Test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: LoginMainPage(),
    ));

    // Verify the background SVG image
    expect(find.byType(SvgPicture), findsOneWidget);

    // Verify the logo image
    expect(find.byType(Image), findsOneWidget);

    // Verify the Login Button
    expect(find.widgetWithText(OutlinedButton, 'Log in'), findsOneWidget);
    
    // Verify the Register Button
    expect(find.widgetWithText(OutlinedButton, 'Register'), findsOneWidget);
  });
}
