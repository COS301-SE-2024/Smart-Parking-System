import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_parking_system/components/bookings/make_booking.dart';

void main() {
  testWidgets('Widget initialization test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: BookingPage(selectedZone: 'A', selectedLevel: '1', bookedAddress: 'Sandton City Center',),
    ));

    expect(find.text('Parking Slot'), findsOneWidget);
    expect(find.byType(IconButton), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(Dash), findsWidgets);
  });

  testWidgets('Slot availability test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: BookingPage(selectedZone: 'A', selectedLevel: '1', bookedAddress: 'Sandton City Center',),
    ));

    expect(find.text('2 slots Available'), findsOneWidget);
    // Add more checks based on your UI structure
    // expect(find.text('Main Entrance'), findsOneWidget);
    expect(find.text('A'), findsOneWidget);
    expect(find.text('0 slots Available'), findsOneWidget);
  });
}
