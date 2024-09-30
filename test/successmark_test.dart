import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_parking_system/components/login/registration_successful.dart';
// import 'package:smart_parking_system/components/home/main_page.dart';

void main() {
  testWidgets('SuccessionPage UI Test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: SuccessionPage(),
    ));

    // Verify the background SVG image
    expect(find.byType(SvgPicture), findsOneWidget);

    // Verify the success mark image
    expect(find.byType(Image), findsOneWidget);

    // Verify the text widgets
    expect(find.text('Registered Successfully'), findsOneWidget);
    expect(find.text('Congratulations!'), findsOneWidget);

    // Verify the Finished button
    expect(find.widgetWithText(ElevatedButton, 'Finished'), findsOneWidget);
  });

  // testWidgets('SuccessionPage Button Navigation Test', (WidgetTester tester) async {
  //   await tester.pumpWidget(const MaterialApp(
  //     home: SuccessionPage(),
  //   ));

  //   // Tap the Finished Button and wait for navigation
  //   await tester.tap(find.widgetWithText(ElevatedButton, 'Finished'));
  //   await tester.pumpAndSettle();

  //   // Verify that MainPage is pushed onto the Navigator stack
  //   expect(find.byType(MainPage), findsOneWidget);
  // });
}
