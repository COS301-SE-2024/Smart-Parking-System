import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:smart_parking_system/components/card/edit_card.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await Firebase.initializeApp();
    
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
    
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: 'test.user@example.com',
        password: 'testpassword123',
      );
    } catch (e) {
      // print('Error in test setup: $e');
    }
  });

  testWidgets(
    "EditCardPage should allow editing an existing card",
    (WidgetTester tester) async {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: 'test.user@example.com',
        password: 'testpassword123',
      );

      // Create a test card document
      final testCardRef = await FirebaseFirestore.instance.collection('cards').add({
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'cardNumber': '4111111111111111',
        'cvv': '123',
        'holderName': 'John Doe',
        'expiry': '12/25',
        'bank': 'Test Bank',
        'cardType': 'visa'
      });

      await tester.pumpWidget(MaterialApp(
        home: EditCardPage(
          cardId: testCardRef.id,
          cardNumber: '4111111111111111',
          cvv: '123',
          name: 'John Doe',
          expiry: '12/25',
          bank: 'Test Bank',
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.text('Edit Card'), findsOneWidget);

      // Verify initial values
      expect(find.text('4111111111111111'), findsOneWidget);
      expect(find.text('123'), findsOneWidget);
      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('12/25'), findsOneWidget);
      expect(find.text('Test Bank'), findsOneWidget);

      // Edit the card details
      await tester.enterText(find.widgetWithText(TextField, 'Card Number'), '5555555555554444');
      await tester.enterText(find.byType(TextField).at(0), '5555555555554444');
      await tester.enterText(find.widgetWithText(TextField, 'Bank'), 'Capitec');
      await tester.enterText(find.byType(TextField).at(1), 'Capitec');
      await tester.enterText(find.widgetWithText(TextField, 'Holder Name'), 'Jane Smith');
      await tester.enterText(find.byType(TextField).at(2), 'Jane Smith');
      await tester.enterText(find.widgetWithText(TextField, 'MM/YY'), '06/28');
      await tester.enterText(find.byType(TextField).at(3), '06/28');
      await tester.enterText(find.widgetWithText(TextField, 'CVV'), '321');
      await tester.enterText(find.byType(TextField).at(4), '321');


      // Find and tap the 'Save' button
      final saveButton = find.widgetWithText(ElevatedButton, 'Save');
      await tester.ensureVisible(saveButton);
      await tester.tap(saveButton);
      await tester.pumpAndSettle(const Duration(seconds: 5));
     
      // Verify the updated data in Firestore
      final updatedDoc = await testCardRef.get();
      expect(updatedDoc.data()!['cardNumber'], '5555555555554444');
      expect(updatedDoc.data()!['cvv'], '321');
      expect(updatedDoc.data()!['holderName'], 'Jane Smith');
      expect(updatedDoc.data()!['expiry'], '06/28');
      expect(updatedDoc.data()!['bank'], 'Capitec');
      expect(updatedDoc.data()!['cardType'], 'mastercard');
    },
  );

  tearDownAll(() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      
      QuerySnapshot cards = await FirebaseFirestore.instance
          .collection('cards')
          .where('userId', isEqualTo: userId)
          .get();
      
      for (var doc in cards.docs) {
        await doc.reference.delete();
      }

      await FirebaseAuth.instance.currentUser!.delete();
    } catch (e) {
      // print('Error in test cleanup: $e');
    }
  });
}