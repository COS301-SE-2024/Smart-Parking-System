import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_parking_system/components/login/card_registration.dart';

void main() {
  group('AddCardRegistrationPage Tests', () {
    testWidgets('AddCardRegistrationPage displays initial UI correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AddCardRegistrationPage(),
        ),
      );

      // Check for the presence of key UI elements
      expect(find.text('Add Card'), findsOneWidget);
      expect(find.byType(TextField), findsAtLeastNWidgets(1));
      expect(find.text('Continue'), findsOneWidget);
      expect(find.text('Skip for now'), findsOneWidget);
    });

    testWidgets('AddCardRegistrationPage can input text', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AddCardRegistrationPage(),
        ),
      );

      // Find the first TextField and enter some text
      final textField = find.byType(TextField).first;
      await tester.enterText(textField, 'Test Input');
      
      // Verify the text was entered
      expect(find.text('Test Input'), findsOneWidget);
    });
  });
}