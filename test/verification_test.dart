import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_parking_system/components/login/verification.dart';


void main() {
  const String testName = 'John';
  const String testSurname = 'Doe';
  const String testEmail = 'johndoe@example.com';
  const String testPhoneNumber = '1234567890';

  Widget createWidgetUnderTest() {
    return const MaterialApp(
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
