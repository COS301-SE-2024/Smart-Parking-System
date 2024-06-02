import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_parking_system/components/bookings/cancel_booking.dart';


void main() {
  testWidgets('CancelBookingPage initially displays the booking', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const MaterialApp(
        home: CancelBookingPage(),
      ),
    );

    // Verify that the booking is displayed.
    expect(find.text('Sandton Mall'), findsOneWidget);
  });

  testWidgets('BookingDetailsDialog is displayed on tapping a booking card', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const MaterialApp(
        home: CancelBookingPage(),
      ),
    );

    // Tap the booking card to display the details dialog.
    await tester.tap(find.byType(BookingCard));
    await tester.pumpAndSettle(); // Wait for the dialog to open.

    // Verify that the BookingDetailsDialog is displayed.
    expect(find.text('Booking reference: 2KJ234'), findsOneWidget);
  });

  testWidgets('Cancel button works and removes the booking', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const MaterialApp(
        home: CancelBookingPage(),
      ),
    );

    // Tap the booking card to display the details dialog.
    await tester.tap(find.byType(BookingCard));
    await tester.pumpAndSettle(); // Wait for the dialog to open.

    // Tap the 'Cancel booking' button.
    await tester.tap(find.text('Cancel booking'));
    await tester.pumpAndSettle(); // Wait for the confirmation dialog to open.

    // Tap the 'Yes' button to confirm the cancellation.
    await tester.tap(find.text('Yes'));
    await tester.pumpAndSettle(); // Wait for the booking to be removed.

    // Verify that the booking is removed.
    expect(find.text('Sandton Mall'), findsNothing);
  });
}
