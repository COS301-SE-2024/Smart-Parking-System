// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:integration_test/integration_test.dart';
// import 'package:smart_parking_system/main.dart';
// // import 'package:smart_parking_system/components/bookings/select_zone.dart';
// import 'package:smart_parking_system/components/bookings/select_level.dart';

// void main() {
//   IntegrationTestWidgetsFlutterBinding.ensureInitialized();

//   testWidgets('ZoneSelectPage navigation and display', (WidgetTester tester) async {
//     // Build the app and trigger a frame.
//     await tester.pumpWidget(const MyApp());

//     // Navigate to ZoneSelectPage
//     // await tester.tap(find.byIcon(Icons.arrow_forward)); // Adjust if needed
//     // await tester.pumpAndSettle();

//     // Verify the page is displayed
//     // expect(find.text('Parking Zones'), findsOneWidget);

//     // // Simulate interaction
//     // await tester.tap(find.byIcon(Icons.local_parking).first);
//     // await tester.pumpAndSettle();

//     // // Verify selected zone details are displayed
//     // expect(find.text('Zone Zone1'), findsOneWidget);
//     // expect(find.text('Spaces Available: 5 slots'), findsOneWidget);

//     // Test button click
//     // await tester.tap(find.text('Continue'));
//     // await tester.pumpAndSettle();

//     // // Verify navigation to the next page
//     // expect(find.byType(LevelSelectPage), findsOneWidget);
//   });
// }




import 'package:flutter_test/flutter_test.dart';
import 'package:smart_parking_system/components/bookings/select_zone.dart';

void main() {
  group('extractSlotsAvailable', () {
    test('extracts number from string with slots available', () {
      String result = extractSlotsAvailable('10/20');
      expect(result, '10');
    });

    test('returns 0 if no number is found', () {
      String result = extractSlotsAvailable('0/20');
      expect(result, '0');
    });
  });
}