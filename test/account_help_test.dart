import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_parking_system/components/help/accounthelp.dart'; // Update this with the correct path

void main() {
  testWidgets('Widget initialization test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Accounthelp(),
    ));

    // Wait for all animations and frame settling
    await tester.pumpAndSettle();

    // Verify if key widgets are present
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('Account questions'), findsOneWidget); // Check if the title is correct
    expect(find.byType(ListView), findsOneWidget); // Check if ListView is present
  });

  testWidgets('Tap on ExpansionTile shows details', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Accounthelp(),
    ));

    // Wait for all animations and frame settling
    await tester.pumpAndSettle();

    // Tap on the first ExpansionTile
    await tester.tap(find.byType(ExpansionTile).first);
    await tester.pumpAndSettle();

    // Verify if the ExpansionTile content is visible
    expect(find.text('Navigate to the "My vehicles" page from the side bar and click on the plus icon'), findsOneWidget);
  });

  testWidgets('Tap on back button navigates back', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Accounthelp(),
    ));

    // Wait for all animations and frame settling
    await tester.pumpAndSettle();

    // Tap the back button
    await tester.tap(find.byIcon(Icons.arrow_back_ios));
    await tester.pumpAndSettle();

    // Verify if the widget is popped from the navigation stack
    expect(find.byType(Accounthelp), findsNothing);  // Should be removed from the widget tree
  });

  // Add more tests as needed for other interactions and navigation scenarios
}
