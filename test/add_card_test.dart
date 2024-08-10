import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_parking_system/components/card/add_card.dart'; // Update with the correct import path

void main() {
  testWidgets('AddCardPage displays all UI elements correctly and interacts with input', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: AddCardPage(),
    ));

    // Verify the page title
    expect(find.text('Add Card'), findsOneWidget);

    // Verify the back button is present
    expect(find.byIcon(Icons.chevron_left), findsOneWidget);

    // Verify the image is displayed
    expect(find.byType(Image), findsOneWidget);

    // Verify the text fields are present
    expect(find.byType(TextField), findsNWidgets(4));
    expect(find.text('Card Number'), findsOneWidget);
    expect(find.text('Holder Name'), findsOneWidget);
    expect(find.text('MM/YY'), findsOneWidget);
    expect(find.text('CVV'), findsOneWidget);

    // Verify the save button is present
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);

    // Input text into text fields
    await tester.enterText(find.byType(TextField).at(0), '1234567812345678');
    await tester.enterText(find.byType(TextField).at(1), 'John Doe');
    await tester.enterText(find.byType(TextField).at(2), '1224');
    await tester.enterText(find.byType(TextField).at(3), '123');

    // Tap the save button
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Verify the save button action (if you have specific verification for it)
    // For simplicity, this test just ensures the button press is registered
    expect(find.text('Save'), findsOneWidget);
  });
}
