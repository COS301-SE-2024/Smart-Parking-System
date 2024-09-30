import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_parking_system/components/payment/payment_options.dart';
import 'package:smart_parking_system/components/payment/add_card.dart';
import 'package:smart_parking_system/components/card/edit_card.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await Firebase.initializeApp();
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);

    // Create a test user
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: 'test@example.com',
      password: 'password123',
    );

    // Initialize user document with balance
    final user = FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'userId': user.uid,
      'email': 'test@example.com',
      'username': 'John',
      'balance': 0.0  // Initialize balance as a double
    });
  });

  group('PaymentMethodPage - Scalability, Reliability, Maintainability, and Security Testing', () {
    testWidgets('Scalability - Handle multiple cards', (WidgetTester tester) async {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password123',
      );

      // Add multiple cards to the user
      final user = FirebaseAuth.instance.currentUser!;
      final cardsCollection = FirebaseFirestore.instance.collection('cards');
      for (int i = 0; i < 10; i++) {
        await cardsCollection.add({
          'userId': user.uid,
          'bank': 'Bank $i',
          'cardNumber': '1234567890123456',
          'holderName': 'Test User',
          'expiry': '12/25',
          'cvv': '123',
          'cardType': 'visa',
        });
      }

      await tester.pumpWidget(const MaterialApp(home: PaymentMethodPage()));
      await tester.pumpAndSettle();

      // Verify that all cards are displayed
      expect(find.byType(Card), findsNWidgets(10));

      // Verify that the page is scrollable
      await tester.dragFrom(tester.getCenter(find.byType(SingleChildScrollView)), const Offset(0, -500));
      await tester.pumpAndSettle();

      // Verify that the 'Add New Card' button is visible after scrolling
      expect(find.text('Add New Card'), findsOneWidget);
    });

    // testWidgets('Reliability - Error handling for network issues', (WidgetTester tester) async {
    //   await FirebaseAuth.instance.signInWithEmailAndPassword(
    //     email: 'test@example.com',
    //     password: 'password123',
    //   );

    //   // Simulate network error
    //   FirebaseFirestore.instance.disableNetwork();

    //   await tester.pumpWidget(const MaterialApp(home: PaymentMethodPage()));
    //   await tester.pumpAndSettle();

    //   // Verify that an error message is displayed
    //   expect(find.text('Error fetching cards. Please try again.'), findsOneWidget);

    //   // Re-enable network
    //   FirebaseFirestore.instance.enableNetwork();
    // });

    testWidgets('Maintainability - Modular components', (WidgetTester tester) async {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password123',
      );

      await tester.pumpWidget(const MaterialApp(home: PaymentMethodPage()));
      await tester.pumpAndSettle();

      // Verify that modular components are used
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);

      // Scroll to the bottom of the page
      await tester.dragUntilVisible(
        find.text('Add New Card'),
        find.byType(SingleChildScrollView),
        const Offset(0, -500),
      );
      await tester.pumpAndSettle();

      // Test navigation to AddCardPage
      await tester.tap(find.text('Add New Card'));
      await tester.pumpAndSettle(const Duration(seconds: 5));
      expect(find.byType(AddCardPage), findsOneWidget);

      // Go back to PaymentMethodPage
      final backButton = find.byIcon(Icons.arrow_back);
      if (backButton.evaluate().isNotEmpty) {
        await tester.tap(backButton);
      } else {
        // If there's no back icon, try finding a button with 'Back' text
        final textBackButton = find.text('Back');
        if (textBackButton.evaluate().isNotEmpty) {
          await tester.tap(textBackButton);
        } else {
          // If we can't find a back button, we'll just pop the current route
          Navigator.of(tester.element(find.byType(AddCardPage))).pop();
        }
      }
      await tester.pumpAndSettle();

      // Verify we're back on the PaymentMethodPage
      expect(find.byType(PaymentMethodPage), findsOneWidget);


      // Test navigation to EditCardPage
      await tester.tap(find.text('Edit Card').last);
      await tester.pumpAndSettle(const Duration(seconds: 5));
      expect(find.byType(EditCardPage), findsOneWidget);

      // No need to go back again, as we're just testing navigation
    });

    testWidgets('Security - Sensitive data handling', (WidgetTester tester) async {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password123',
      );
      final user = FirebaseAuth.instance.currentUser!;

      await tester.pumpWidget(const MaterialApp(home: PaymentMethodPage()));
      await tester.pumpAndSettle();

      // Verify that full card numbers are not displayed
      expect(find.textContaining('**** **** ****'), findsWidgets);
      expect(find.textContaining('1234567890123456'), findsNothing);

      // Verify that CVV is not displayed
      expect(find.text('123'), findsNothing);

      // Test top-up functionality
      await tester.tap(find.text('Top Up'));
      await tester.pumpAndSettle();

      // Enter an amount and confirm
      await tester.enterText(find.byType(TextField), '100');
      await tester.tap(find.text('Top Up').last);
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Verify that the balance has been updated
      expect(find.textContaining('ZAR 100.00'), findsOneWidget);

      // Verify that the transaction is recorded in Firestore
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      // print('User document data: ${userDoc.data()}');
      
      // Check if 'balance' exists and is a number
      expect(userDoc.data(), containsPair('balance', isA<num>()));
      
      // If it exists, check its value
      final balance = userDoc.data()?['balance'];
      if (balance != null) {
        expect(balance, 100.0);  // Compare with 100.0 instead of 100
      } else {
        fail('Balance field not found in user document');
      }
    });
  });

  tearDownAll(() async {
    // Clean up: delete test user and their data
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('cards')
          .where('userId', isEqualTo: user.uid)
          .get()
          .then((snapshot) {
        for (DocumentSnapshot doc in snapshot.docs) {
          doc.reference.delete();
        }
      });
      await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();
      await user.delete();
    }
  });
}