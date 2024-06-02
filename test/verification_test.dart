import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:smart_parking_system/components/login/signup.dart';
import 'package:smart_parking_system/components/login/verification.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MockClient extends Mock implements http.Client {}

@GenerateMocks([http.Client])
void main() {
  final String testName = 'John';
  final String testSurname = 'Doe';
  final String testEmail = 'johndoe@example.com';
  final String testPhoneNumber = '1234567890';

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: VerificationPage(
        name: testName,
        surname: testSurname,
        email: testEmail,
        phoneNumber: testPhoneNumber,
      ),
    );
  }

  group('VerificationPage', () {
     testWidgets('renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Interactively expedite revolutionary ROI after bricks-and-clicks alignments.'), findsOneWidget);
      expect(find.text("Didn't receive OTP?"), findsOneWidget);
      expect(find.text('Verify'), findsOneWidget);
    });
  });
}
