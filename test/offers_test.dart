import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_parking_system/components/payment/offers.dart';

void main() {
  testWidgets('OfferPage UI Test', (WidgetTester tester) async {
    // Build the OfferPage widget
    await tester.pumpWidget(const MaterialApp(
      home: OfferPage(),
    ));

    // Wait for all animations and frame settling
    await tester.pumpAndSettle();

    // Verify if the initial UI elements are rendered correctly

    // 1. Verify the presence of IconButton with arrow back icon
    expect(find.byIcon(Icons.arrow_back_ios), findsOneWidget);

    // 2. Verify the text 'Offers'
    expect(find.text('Offers'), findsOneWidget);

    // 3. Verify the presence of 'Apply' button
    expect(find.text('Apply'), findsOneWidget);

    // 4. Verify the presence of 'Start Invite' button
    expect(find.text('Start Invite'), findsOneWidget);

    // 5. Verify the presence of 'Invite your friend to get the coupon' text
    expect(find.text('Invite your friend to get the coupon'), findsOneWidget);

    // 6. Verify the presence of 'The Available Coupon' text
    expect(find.text('The Available Coupon'), findsOneWidget);
  });
}
