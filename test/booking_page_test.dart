import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_parking_system/components/bookings/make_booking.dart';// Adjust the import path as necessary
import 'package:smart_parking_system/components/bookings/bookspace.dart'; // Adjust the import path as necessary

void main() {
  testWidgets('BookingPage displays initial elements correctly', (WidgetTester tester) async {
    // Build the BookingPage widget
    await tester.pumpWidget(
      const MaterialApp(
        home: BookingPage(),
      ),
    );

    // Verify the presence of the app bar
    expect(find.byType(AppBar), findsOneWidget);

    // Verify the presence of the initial elements
    expect(find.text('Sandton City'), findsOneWidget);
    expect(find.text('R10/hr'), findsOneWidget);
    expect(find.text('Choose the available space'), findsOneWidget);
    expect(find.text('Zones:'), findsOneWidget);
  });

  testWidgets('BookingPage displays zones and allows selection', (WidgetTester tester) async {
    // Build the BookingPage widget
    await tester.pumpWidget(
      const MaterialApp(
        home: BookingPage(),
      ),
    );

    // Verify the presence of zones
    for (var i = 0; i < 7; i++) {
      expect(find.text('Zone ${String.fromCharCode(65 + i)}'), findsWidgets);
    }

    // Tap on the first zone and verify selection
    await tester.tap(find.text('Zone A').first);
    await tester.pump();

    // Verify that the zone selection is updated
    expect(find.text('Choose Zone A'), findsOneWidget);
  });

  testWidgets('BookingPage displays levels after zone selection and allows selection', (WidgetTester tester) async {
    // Build the BookingPage widget
    await tester.pumpWidget(
      const MaterialApp(
        home: BookingPage(),
      ),
    );

    // Tap on a zone and verify level selection
    await tester.ensureVisible(find.text('Zone A'));
    await tester.tap(find.text('Zone A').first);
    await tester.pump();
    await tester.ensureVisible(find.text('Choose Zone A'));
    await tester.tap(find.text('Choose Zone A'));
    await tester.pump();
    await tester.pumpAndSettle();

    // Verify the presence of levels
    for (var i = 1; i <= 4; i++) {
      expect(find.text('Level $i'), findsWidgets);
    }

    // Tap on the first level and verify selection
    await tester.tap(find.text('Level 1').first);
    await tester.pump();
    await tester.pumpAndSettle();

    // Verify that the level selection is updated
    expect(find.text('Choose Level 1'), findsOneWidget);
  });
}
