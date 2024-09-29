import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_parking_system/components/bookings/confirm_booking.dart';
import 'package:smart_parking_system/components/bookings/select_vehicle.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    "ConfirmBookingPage should allow user to select booking options and navigate to ChooseVehiclePage",
        (WidgetTester tester) async {
      // Define test parameters
      const String bookedAddress = '123 Test Street';
      const double price = 10.0;
      const String selectedZone = 'A';
      const String selectedLevel = '1';
      const String selectedRow = '5';

      // Create a NavigatorObserver to monitor navigation events
      final navigatorObserver = TestNavigatorObserver();

      // Build the ConfirmBookingPage widget
      await tester.pumpWidget(MaterialApp(
        home: const ConfirmBookingPage(
          bookedAddress: bookedAddress,
          price: price,
          selectedZone: selectedZone,
          selectedLevel: selectedLevel,
          selectedRow: selectedRow,
        ),
        navigatorObservers: [navigatorObserver],
      ));

      await tester.pumpAndSettle();

      // Verify that the ConfirmBookingPage is displayed
      expect(find.text('Confirm Booking'), findsOneWidget);

      // Interact with the slider to change the duration
      final sliderFinder = find.byType(Slider);
      expect(sliderFinder, findsOneWidget);

      // Move the slider to 5 hours
      await tester.drag(sliderFinder, const Offset(300.0, 0.0));
      await tester.pumpAndSettle();

      // Verify that the duration label updates
      expect(find.textContaining('5 hours'), findsWidgets);

      // Tap on the check-in time to open the time picker
      await tester.tap(find.textContaining('Check-in Time:'));
      await tester.pumpAndSettle();

      // Since time picker dialogs are not part of the widget tree in tests, we need to simulate the selection
      // For this example, we will assume the default time is selected and tap 'OK'
      // You may need to adjust this depending on your implementation
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Tap on the check-in date to open the date picker
      await tester.tap(find.textContaining('Check-in Date:'));
      await tester.pumpAndSettle();

      // Simulate selecting a date and tap 'OK'
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Toggle the disabled parking switch
      final switchFinder = find.byType(Switch);
      expect(switchFinder, findsOneWidget);
      await tester.tap(switchFinder);
      await tester.pumpAndSettle();

      // Press the "Book Space" button
      final bookSpaceButton = find.text('Book Space');
      await tester.tap(bookSpaceButton);
      await tester.pumpAndSettle();

      // Verify that navigation to ChooseVehiclePage occurred
      expect(navigatorObserver.navigationCount, 1);
      expect(find.byType(ChooseVehiclePage), findsOneWidget);

      // Verify that the parameters passed to ChooseVehiclePage are correct
      final ChooseVehiclePage chooseVehiclePage = tester.widget(find.byType(ChooseVehiclePage));
      expect(chooseVehiclePage.bookedAddress, bookedAddress);
      expect(chooseVehiclePage.selectedZone, selectedZone);
      expect(chooseVehiclePage.selectedLevel, selectedLevel);
      expect(chooseVehiclePage.selectedRow, selectedRow);
      expect(chooseVehiclePage.selectedDuration, 5.0);
      expect(chooseVehiclePage.selectedDisabled, true);
      // Additional assertions can be made for selectedTime, selectedDate, price

      // Optionally, you can verify the values of selectedTime and selectedDate
      // based on the interactions you performed earlier.
    },
  );
}

class TestNavigatorObserver extends NavigatorObserver {
  int navigationCount = 0;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    navigationCount++;
    super.didPush(route, previousRoute);
  }
}
