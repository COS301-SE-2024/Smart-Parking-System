import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_parking_system/components/vehicledetails/view_vehicle.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('ViewVehiclePage Integration Tests', () {
    setupFirebaseAuth();
    setupFirebaseFirestore();

    testWidgets('Fetch and display user vehicles', (WidgetTester tester) async {
      await Firebase.initializeApp();

      // Add test data to Firestore
      final user = await FirebaseAuth.instance.signInAnonymously();
      await FirebaseFirestore.instance.collection('vehicles').add({
        'userId': user.user!.uid,
        'vehicleBrand': 'Tesla',
        'vehicleModel': 'Model 3',
        'vehicleColor': 'Red',
        'licenseNumber': 'ABC123'
      });

      await tester.pumpWidget(const MaterialApp(home: ViewVehiclePage()));

      // Wait for the data to be fetched and displayed
      await tester.pumpAndSettle();

      // Verify that the vehicle information is displayed
      expect(find.text('Tesla'), findsOneWidget);
      expect(find.text('Model 3'), findsOneWidget);
      expect(find.text('Red'), findsOneWidget);
      expect(find.text('ABC123'), findsOneWidget);

      // Clean up test data
      await FirebaseFirestore.instance.terminate();
      await FirebaseAuth.instance.signOut();
    });
  });
}

void setupFirebaseAuth() {
  // Setup Firebase Auth for testing
  setUpAll(() async {
    await Firebase.initializeApp();
    FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  });

  tearDownAll(() async {
    await FirebaseAuth.instance.signOut();
  });
}

void setupFirebaseFirestore() {
  // Setup Firestore for testing
  setUpAll(() async {
    await Firebase.initializeApp();
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  });

  tearDownAll(() async {
    await FirebaseFirestore.instance.terminate();
  });
}