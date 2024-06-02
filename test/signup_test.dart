import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_parking_system/components/login/signup.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'dart:convert';

void main() {
  // Mock the HTTP client
  final client = MockClient((request) async {
    if (request.url.toString() == 'http://192.168.42.36:3000/signup' && request.method == 'POST') {
      final body = jsonDecode(request.body);
      if (body['password'] == 'correct_password') {
        return http.Response('{"message": "Signup successful"}', 201);
      } else {
        return http.Response('{"message": "Signup failed"}', 400);
      }
    }
    return http.Response('Not Found', 404);
  });

  testWidgets('SignupPage renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
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
    await tester.pumpWidget(MaterialApp(
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
    await tester.pumpWidget(MaterialApp(
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
