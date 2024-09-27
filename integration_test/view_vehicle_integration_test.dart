import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:smart_parking_system/components/vehicledetails/view_vehicle.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await Firebase.initializeApp();
    
    // Connect to Firebase emulators
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
    
    // Create a test user
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: 'test.user@example.com',
        password: 'testpassword123',
      );
      
      // Add a test vehicle to Firestore
      await FirebaseFirestore.instance.collection('vehicles').add({
        'userId': userCredential.user!.uid,
        'vehicleBrand': 'Toyota',
        'vehicleModel': 'Corolla',
        'vehicleColor': 'Blue',
        'licenseNumber': 'ABC123',
      });
    } catch (e) {
      // print('Error in test setup: $e');
    }
  });

  testWidgets(
    "ViewVehiclePage should display user's vehicles",
    (WidgetTester tester) async {
      // Sign in the test user
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: 'test.user@example.com',
        password: 'testpassword123',
      );

      await tester.pumpWidget(const MaterialApp(
        home: ViewVehiclePage(),
      ));

      // Wait for the page to load and fetch vehicles
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Verify that the page title is displayed
      expect(find.text('My Vehicles'), findsOneWidget);

      // Verify that the add vehicle button is present
      expect(find.byIcon(Icons.add_circle_outline), findsOneWidget);

      // Verify that the test vehicle is displayed
      expect(find.text('Toyota'), findsOneWidget);
      expect(find.text('Corolla'), findsOneWidget);
      expect(find.text('Blue'), findsOneWidget);

      // Verify that the edit button is present
      expect(find.widgetWithText(OutlinedButton, 'edit'), findsOneWidget);

      // Test editing a vehicle
      await tester.tap(find.widgetWithText(OutlinedButton, 'edit'));
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Verify that we've navigated to the EditVehiclePage
      expect(find.text('Car Info'), findsOneWidget);

      // Navigate back to ViewVehiclePage
      await tester.tap(find.byIcon(Icons.arrow_back_ios));
      await tester.pumpAndSettle();

      // Test adding a new vehicle
      await tester.tap(find.byIcon(Icons.add_circle_outline));
      await tester.pumpAndSettle();

      // Verify that we've navigated to the AddVehiclePage
      expect(find.text('Car Info'), findsOneWidget);
    },
  );

  tearDownAll(() async {
    // Clean up: delete test user and their vehicles
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      
      // Delete test vehicles
      QuerySnapshot vehicles = await FirebaseFirestore.instance
          .collection('vehicles')
          .where('userId', isEqualTo: userId)
          .get();
      
      for (var doc in vehicles.docs) {
        await doc.reference.delete();
      }

      // Delete test user
      await FirebaseAuth.instance.currentUser!.delete();
    } catch (e) {
      // print('Error in test cleanup: $e');
    }
  });
}