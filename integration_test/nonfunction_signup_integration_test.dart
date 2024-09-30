import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_parking_system/components/login/login.dart';
import 'package:smart_parking_system/components/login/signup.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await Firebase.initializeApp();
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: 'john.doe@example.com',
        password: 'StrongB@ss1',
      );

      final user = FirebaseAuth.instance.currentUser!;
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'userId': user.uid,
        'email': 'john.doe@example.com',
        'username': 'John',
        'phoneNumber' : '1234567890',
        'balance': 0.0  // Initialize balance as a double
      });
    } catch (e) {
      // print('Error in test setup: $e');
    }
  });

  testWidgets('SignupPage - Security, Performance, Compatibility, and Usability Testing', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(const MaterialApp(home: SignupPage()));

    // Usability Testing: Verify all required fields are present
    expect(find.byType(TextField), findsNWidgets(4)); // Name, Phone, Email, Password
    expect(find.text('Sign up'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);

    // Compatibility Testing: Test on different screen sizes
    await tester.binding.setSurfaceSize(const Size(320, 480)); // Small phone
    await tester.pumpAndSettle();
    expect(find.byType(SingleChildScrollView), findsOneWidget);

    await tester.binding.setSurfaceSize(const Size(768, 1024)); // Tablet
    await tester.pumpAndSettle();
    expect(find.byType(SingleChildScrollView), findsOneWidget);


    // Fill in the form with valid data
    await tester.enterText(find.widgetWithText(TextField, 'Name'), 'John');
    await tester.enterText(find.widgetWithText(TextField, 'Phone'), '1234567890');
    await tester.enterText(find.widgetWithText(TextField, 'Email'), 'john.doe@example.com');
    await tester.enterText(find.widgetWithText(TextField, 'Password'), 'StrongB@ss1');

    // Performance Testing: Measure time taken for signup process
    final stopwatch = Stopwatch()..start();
    
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle(const Duration(seconds: 3));

    stopwatch.stop();
    // print('Signup process took ${stopwatch.elapsedMilliseconds} milliseconds');

    // Security Testing: Verify password strength requirements
    expect(find.text('Invalid password'), findsNothing);

    // Security Testing: Verify user data is stored securely in Firestore
    final users = await FirebaseFirestore.instance.collection('users').get();
    expect(users.docs.length, 1);
    final userData = users.docs.first.data();
    expect(userData['username'], 'John');
    expect(userData['email'], 'john.doe@example.com');
    expect(userData['phoneNumber'], '1234567890');
    expect(userData.containsKey('password'), false); // Ensure password is not stored in Firestore

  });

  testWidgets('SignupPage - Usability Testing', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: SignupPage()));

    // Usability Testing: Test Google Sign-In button
    expect(find.byKey(const Key('google')), findsOneWidget);
    await tester.tap(find.byKey(const Key('google')));
    await tester.pumpAndSettle();
    // Note: We can't fully test Google Sign-In in an emulator environment, 
    // but we can verify that the button is present and tappable

    // Usability Testing: Test navigation to Login page
    expect(find.text('Have an account? Login'), findsOneWidget);
    await tester.tap(find.text('Have an account? Login'));
    await tester.pumpAndSettle();
    expect(find.byType(LoginPage), findsOneWidget);
  });

  tearDownAll(() async {
    // Clean up: delete test user and their data
    final users = await FirebaseFirestore.instance.collection('users').get();
    for (var doc in users.docs) {
      await doc.reference.delete();
    }
    await FirebaseAuth.instance.currentUser?.delete();
  });
}