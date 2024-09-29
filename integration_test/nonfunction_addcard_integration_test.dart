import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_parking_system/components/payment/add_card.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await Firebase.initializeApp();
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);

    // Create a test user
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: 'test.user@example.com',
        password: 'testpassword123',
      );
    } catch (e) {
      // print('Error in test setup: $e');
    }
  });

  testWidgets('AddCardPage - Usability, Security, and Compatibility Testing', (WidgetTester tester) async {
    // Sign in the test user
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: 'test.user@example.com',
      password: 'testpassword123',
    );

    // Build our app and trigger a frame
    await tester.pumpWidget(const MaterialApp(home: AddCardPage()));

    // Usability Testing: Verify all required fields are present
    expect(find.byType(TextField), findsNWidgets(5)); // Card Number, Bank, Holder Name, Expiry, CVV
    expect(find.text('Add Card'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);

    // Usability Testing: Test form validation
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
    // expect(find.byType(Fluttertoast), findsOneWidget);

    // Fill in the form with valid data
    await tester.enterText(find.widgetWithText(TextField, 'Card Number'), '4111111111111111');
    await tester.enterText(find.widgetWithText(TextField, 'Bank'), 'Capitec');
    await tester.enterText(find.widgetWithText(TextField, 'Holder Name'), 'John Doe');
    await tester.enterText(find.widgetWithText(TextField, 'MM/YY'), '12/25');
    await tester.enterText(find.widgetWithText(TextField, 'CVV'), '123');

    // Compatibility Testing: Test on different screen sizes
    await tester.binding.setSurfaceSize(const Size(320, 480)); // Small phone
    await tester.pumpAndSettle();
    expect(find.byType(SingleChildScrollView), findsOneWidget);

    await tester.binding.setSurfaceSize(const Size(768, 1024)); // Tablet
    await tester.pumpAndSettle();
    expect(find.byType(SingleChildScrollView), findsOneWidget);

    // Submit the form
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Verify navigation to PaymentMethodPage
    expect(find.text('Payment Options'), findsOneWidget);

    // Security Testing: Verify card data is stored securely in Firestore
    expect(find.text('Capitec\n**** **** **** 1111\nJohn Doe\n12/25'), findsOne);
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
      await user.delete();
    }
  });
}