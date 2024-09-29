import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_parking_system/components/login/signup.dart';
import 'package:smart_parking_system/components/login/email_verification.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await Firebase.initializeApp();

    // Use Firebase Auth and Firestore emulators if needed
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  });

  testWidgets(
    "SignupPage should allow user to sign up with email and password",
        (WidgetTester tester) async {
      // Build the SignupPage widget
      await tester.pumpWidget(const MaterialApp(
        home: SignupPage(),
      ));

      await tester.pumpAndSettle();

      // Verify that the SignupPage is displayed
      expect(find.text('Sign up'), findsOneWidget);

      // Enter valid signup details
      await tester.enterText(find.widgetWithText(TextField, 'Name'), 'Test User');
      await tester.enterText(find.widgetWithText(TextField, 'Phone'), '1234567890');
      await tester.enterText(find.widgetWithText(TextField, 'Email'), 'test.user@example.com');
      await tester.enterText(find.widgetWithText(TextField, 'Password'), 'Test@1234');

      // Tap the 'Signup' button
      final signupButton = find.text('Signup');
      await tester.ensureVisible(signupButton);
      await tester.tap(signupButton);

      // Wait for any asynchronous operations to complete
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Verify that the VerificationPage is displayed
      expect(find.byType(VerificationPage), findsOneWidget);

      // Verify that the user is created in Firebase Auth
      final User? currentUser = FirebaseAuth.instance.currentUser;
      expect(currentUser, isNotNull);
      expect(currentUser!.email, 'test.user@example.com');

      // Verify that the user data is stored in Firestore
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      final userData = userDoc.data() as Map<String, dynamic>?;
      expect(userData, isNotNull);
      expect(userData!['username'], 'Test User');
      expect(userData['email'], 'test.user@example.com');
      expect(userData['phoneNumber'], '1234567890');
    },
  );

  tearDownAll(() async {
    try {
      // Delete the test user from Firebase Auth
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await currentUser.delete();
      }

      // Delete the user document from Firestore
      final userDoc = FirebaseFirestore.instance.collection('users').doc(currentUser?.uid);
      await userDoc.delete();
    } catch (e) {
      // Handle errors during cleanup
    }
  });
}
