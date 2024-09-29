import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_parking_system/components/card/edit_card.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await Firebase.initializeApp();

    // Use Firebase Auth and Firestore emulators if needed
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: 'john.doe@example.com',
        password: '1234567',
      );
    } catch (e) {
      // User might already exist
    }
  });

  testWidgets(
    "EditCardPage should allow editing an existing card",
        (WidgetTester tester) async {
      // Sign in the test user
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: 'test.user@example.com',
        password: 'testpassword123',
      );

      // Create a test card document
      final testCardRef = await FirebaseFirestore.instance.collection('cards').add({
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'cardNumber': '4111111111111111',
        'cvv': '123',
        'holderName': 'Test User',
        'expiry': '12/24',
        'bank': 'Test Bank',
        'cardType': 'visa',
      });

      // Build the EditCardPage widget
      await tester.pumpWidget(MaterialApp(
        home: EditCardPage(
          cardId: testCardRef.id,
          cardNumber: '4111111111111111',
          cvv: '123',
          name: 'Test User',
          expiry: '12/24',
          bank: 'Test Bank',
        ),
      ));

      await tester.pumpAndSettle();

      // Verify that the EditCardPage is displayed
      expect(find.text('Edit Card'), findsOneWidget);

      // Optionally verify initial values (if needed)

      // Edit the card details
      await tester.enterText(find.widgetWithText(TextField, 'Card Number'), '5555555555554444');
      await tester.enterText(find.widgetWithText(TextField, 'Bank'), 'New Bank');
      await tester.enterText(find.widgetWithText(TextField, 'Holder Name'), 'New Name');
      await tester.enterText(find.widgetWithText(TextField, 'MM/YY'), '11/25');
      await tester.enterText(find.widgetWithText(TextField, 'CVV'), '456');

      // Tap the 'Save' button
      final saveButton = find.text('Save');
      await tester.ensureVisible(saveButton);
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      // Since the page pops after saving, verify that we're no longer on the EditCardPage
      expect(find.text('Edit Card'), findsNothing);

      // Verify the updated data in Firestore
      final updatedDoc = await testCardRef.get();
      final data = updatedDoc.data();
      expect(data!['cardNumber'], '5555555555554444');
      expect(data['cvv'], '456');
      expect(data['holderName'], 'New Name');
      expect(data['expiry'], '11/25');
      expect(data['bank'], 'New Bank');
    },
  );

  tearDownAll(() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Delete test cards
      QuerySnapshot cards = await FirebaseFirestore.instance
          .collection('cards')
          .where('userId', isEqualTo: userId)
          .get();

      for (var doc in cards.docs) {
        await doc.reference.delete();
      }

      // Delete the test user
      await FirebaseAuth.instance.currentUser!.delete();
    } catch (e) {
      // Handle errors during cleanup
    }
  });
}
