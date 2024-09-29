import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:smart_parking_system/components/vehicledetails/edit_vehicle.dart';
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
    "EditVehiclePage should allow editing an existing vehicle",
    (WidgetTester tester) async {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: 'test.user@example.com',
        password: 'testpassword123',
      );

      // Create a test vehicle document
      final testVehicleRef = await FirebaseFirestore.instance.collection('vehicles').add({
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'vehicleBrand': 'Toyota',
        'vehicleModel': 'Corolla',
        'vehicleColor': 'Blue',
        'licenseNumber': 'ABC123GP',
      });

      await tester.pumpWidget(MaterialApp(
        home: EditVehiclePage(
          brand: 'Toyota',
          model: 'Corolla',
          color: 'Blue',
          license: 'ABC123GP',
          vehicleId: testVehicleRef.id,
          image: null,
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.text('Car Info'), findsOneWidget);

      // Verify initial values
      expect(find.text('Toyota'), findsOneWidget);
      expect(find.text('Corolla'), findsOneWidget);
      expect(find.text('Blue'), findsOneWidget);
      expect(find.text('ABC123GP'), findsOneWidget);
      const Duration(seconds: 5);
      // Edit the vehicle details
      await tester.enterText(find.widgetWithText(TextFormField, 'Vehicle Brand'), 'Honda');
      await tester.enterText(find.byType(TextFormField).at(0), 'Honda');
      await tester.enterText(find.widgetWithText(TextFormField, 'Vehicle Model'), 'Civic');
      await tester.enterText(find.byType(TextFormField).at(1), 'Civic');
      await tester.enterText(find.widgetWithText(TextFormField, 'Color'), 'Red');
      await tester.enterText(find.byType(TextFormField).at(2), 'Red');
      await tester.enterText(find.widgetWithText(TextFormField, 'License Number'), 'XYZ789GP');
      await tester.enterText(find.byType(TextFormField).at(3), 'XYZ789GP');

      // Find and tap the 'Save' button
      final saveButton = find.widgetWithText(ElevatedButton, 'Save');
      await tester.ensureVisible(saveButton);
      await tester.tap(saveButton);
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Verify the success dialog
      expect(find.text('Successfully Updated!'), findsOneWidget);
      
      // Tap 'OK' on the success dialog
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Verify the updated data in Firestore
      final updatedDoc = await testVehicleRef.get();
      expect(updatedDoc.data()!['vehicleBrand'], 'Honda');
      expect(updatedDoc.data()!['vehicleModel'], 'Civic');
      expect(updatedDoc.data()!['vehicleColor'], 'Red');
      expect(updatedDoc.data()!['licenseNumber'], 'XYZ789GP');
    },
  );

  tearDownAll(() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      
      QuerySnapshot vehicles = await FirebaseFirestore.instance
          .collection('vehicles')
          .where('userId', isEqualTo: userId)
          .get();
      
      for (var doc in vehicles.docs) {
        await doc.reference.delete();
      }

      await FirebaseAuth.instance.currentUser!.delete();
    } catch (e) {
      // print('Error in test cleanup: $e');
    }
  });
}