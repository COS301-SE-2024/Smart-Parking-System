import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:smart_parking_system/components/login/login.dart';
import 'dart:convert';

import 'package:smart_parking_system/components/login/verification.dart';

// Mock the http.Client with a custom implementation for testing
void main() {
  group('LoginPage', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginPage()));

      expect(find.text('Enter your details'), findsNothing);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

     testWidgets('displays error message for empty email and password', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginPage()));

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter your Password'), findsOneWidget);
    }); 

    
    testWidgets('login failed', (WidgetTester tester) async {
      final mockClient = MockClient((request) async {
        return http.Response('Unauthorized', 401);
      });

      await tester.pumpWidget(MaterialApp(
        home: LoginPage(),
        builder: (context, child) {
          return Material(
            child: Builder(
              builder: (context) {
                return Scaffold(
                  body: child,
                );
              },
            ),
          );
        },
      ));

      await tester.enterText(find.byType(TextFormField).at(0), 'test@test.com');
      await tester.enterText(find.byType(TextFormField).at(1), 'wrongpassword');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(find.text('Login failed'), findsOneWidget);
    });
  });
}