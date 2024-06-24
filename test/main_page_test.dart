import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_parking_system/components/main_page.dart';
import 'package:smart_parking_system/components/parking/parking_history.dart';

void main() {
  testWidgets('Widget initialization test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: MainPage(),
    ));

    // Wait for all animations and frame settling
    await tester.pumpAndSettle();

    // Verify if key widgets are present
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget); // Check for search field
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('Tap on search field shows modal', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: MainPage(),
    ));

    // Wait for all animations and frame settling
    await tester.pumpAndSettle();

    // Tap on the search field
    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();

    // Verify if multiple ListTiles are present inside the modal
    expect(find.byType(ListTile), findsWidgets); // Check for multiple list tiles inside the modal
  });

  testWidgets('Tap on bottom navigation bar navigates correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: MainPage(),
    ));

    // Wait for all animations and frame settling
    await tester.pumpAndSettle();

    // Tap on the payment icon in the bottom navigation bar
    await tester.tap(find.byIcon(Icons.history));
    await tester.pumpAndSettle();

    // Verify if we navigated to the PaymentMethodPage
    expect(find.byType(ParkingHistoryPage), findsOneWidget);
  });

  // Add more tests as needed for other interactions and navigation scenarios
}
