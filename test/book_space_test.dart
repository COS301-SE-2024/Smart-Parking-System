import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_parking_system/components/bookings/bookspace.dart';
import 'package:smart_parking_system/components/bookings/cancel_booking.dart';

//Comment test

void main() {
  testWidgets('BookSpaceScreen displays initial UI correctly', (WidgetTester tester) async {
    
      await tester.pumpWidget(
        const MaterialApp(
          home: BookSpaceScreen(),
        ),
      );

      // Check if initial UI elements are displayed
      expect(find.text('Sandton City'), findsOneWidget);
      expect(find.text('Space 2C'), findsOneWidget);
      expect(find.text('Estimate Duration'), findsOneWidget);
      expect(find.text('Check-in Time:'), findsOneWidget);
      expect(find.text('Specifications'), findsOneWidget);
      expect(find.text('Disabled Parking'), findsOneWidget);
      expect(find.text('Request Car Washing (R100)'), findsOneWidget);
      expect(find.text('Book Space'), findsOneWidget);
   
  });

  testWidgets('BookSpaceScreen changes estimated duration slider', (WidgetTester tester) async {
    
      await tester.pumpWidget(
        const MaterialApp(
          home: BookSpaceScreen(),
        ),
      );

      // Find the slider and change its value
      final slider = find.byType(Slider);
      expect(slider, findsOneWidget);
      await tester.drag(slider, const Offset(200.0, 0.0));
      await tester.pumpAndSettle(); 
  });

  testWidgets('BookSpaceScreen selects check-in time', (WidgetTester tester) async {
    
      await tester.pumpWidget(
        const MaterialApp(
          home: BookSpaceScreen(),
        ),
      );

      // Tap the edit icon to select time
      await tester.tap(find.byIcon(Icons.edit));
      await tester.pumpAndSettle();

      // Pick a time
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Check if the time is displayed
      expect(find.textContaining(RegExp(r'\d{1,2}:\d{2} [AP]M')), findsOneWidget);
    
  });

  testWidgets('BookSpaceScreen enables and disables switches', (WidgetTester tester) async {
    
      await tester.pumpWidget(
        const MaterialApp(
          home: BookSpaceScreen(),
        ),
      );

      // Find the switches and change their state
      await tester.tap(find.byType(SwitchListTile).at(0));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(SwitchListTile).at(1));
      await tester.pumpAndSettle();

      // Check if the switches are toggled
      final switchTiles = find.byType(SwitchListTile);
      expect(tester.widget<SwitchListTile>(switchTiles.at(0)).value, isTrue);
      expect(tester.widget<SwitchListTile>(switchTiles.at(1)).value, isTrue);
    
  });

  testWidgets('BookSpaceScreen shows booking confirmation dialog and navigates to CancelBookingPage', (WidgetTester tester) async {
    
      await tester.pumpWidget(
        const MaterialApp(
          home: BookSpaceScreen(),
        ),
      );

      // Tap the 'Book Space' button
      await tester.tap(find.text('Book Space'));
      await tester.pumpAndSettle();

      // Check if the confirmation dialog is displayed
      expect(find.text('Space Successfully Booked'), findsOneWidget);

      // Tap the 'View Booking Details' button
      await tester.tap(find.text('View Booking Details'));
      await tester.pumpAndSettle();

      // Check if navigated to CancelBookingPage
      expect(find.byType(CancelBookingPage), findsOneWidget);
    
  });
}
