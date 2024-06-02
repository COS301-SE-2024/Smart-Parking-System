import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_parking_system/components/login/signup.dart';

void main() {
  // Mock the HTTP client

  testWidgets('SignupPage renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: SignupPage(
        name: 'Test',
        surname: 'User',
        email: 'test@example.com',
        phoneNumber: '1234567890',
      ),
    ));

    expect(find.text('Enter your Password'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Confirm Password'), findsOneWidget);
  });

  testWidgets('Password and confirm password validation works', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: SignupPage(
        name: 'Test',
        surname: 'User',
        email: 'test@example.com',
        phoneNumber: '1234567890',
      ),
    ));

    await tester.enterText(find.byType(TextFormField).at(0), 'password');
    await tester.enterText(find.byType(TextFormField).at(1), 'different_password');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.text('The Passwords are not the same'), findsOneWidget);
  }); 

   testWidgets('Signup process shows error message on failure', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: SignupPage(
        name: 'Test',
        surname: 'User',
        email: 'test@example.com',
        phoneNumber: '1234567890',
      ),
    ));

    await tester.enterText(find.byType(TextFormField).at(0), 'wrong_password');
    await tester.enterText(find.byType(TextFormField).at(1), 'wrong_password');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.text('Signup failed'), findsOneWidget);
  }); 
}
