import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:smart_parking_system/components/home/main_page.dart';
import 'package:smart_parking_system/components/login/login_main.dart';
import 'package:firebase_auth/firebase_auth.dart';


void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await dotenv.load(fileName: ".env");
    await Firebase.initializeApp();
    
    // Connect to Firebase emulators
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
    
    // Create a test user
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: 'john.doe@example.com',
        password: '123456',
      );
      print('Test user created successfully');
    } catch (e) {
      print('Test user already exists or could not be created: $e');
    }
  });

  testWidgets(
    "After inputting the email and password, should navigate to the Home Page",
    (WidgetTester tester) async { 
      await tester.pumpWidget(const MaterialApp(
        home: LoginMainPage(),
      ));

      await tester.pumpAndSettle();
      
      final logInButton = find.widgetWithText(OutlinedButton, 'Log in');
      expect(logInButton, findsOneWidget, reason: 'Log in button not found');
      await tester.tap(logInButton);
      await tester.pumpAndSettle();

      const emailText = 'john.doe@example.com';
      const passwordText = '123456';
      await tester.enterText(find.byKey(const Key('Email')), emailText);
      await tester.enterText(find.byKey(const Key('Password')), passwordText);
      
      final submitButton = find.byType(ElevatedButton);
      expect(submitButton, findsOneWidget, reason: 'Submit button not found');
      await tester.tap(submitButton);
      // After tapping the login button
      await tester.pump(Duration(seconds: 2));  // Wait for login to process

      // Check if user is logged in
      User? user = FirebaseAuth.instance.currentUser;
      print("Current user: ${user?.uid ?? 'No user logged in'}");
      
      // Increase wait time and add debug prints
      for (int i = 0; i < 5; i++) {
        await tester.pump(Duration(seconds: 5));
        print('Waiting for MainPage... Attempt ${i + 1}');
        if (find.byType(MainPage).evaluate().isNotEmpty) break;
      }

      expect(find.byType(MainPage), findsOneWidget, reason: 'MainPage not found after login');
      
      // Print current widget tree for debugging
      print('Current widget tree:');
      print(tester.allWidgets.map((w) => w.runtimeType).toList());
    },
  );
}