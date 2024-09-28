import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:smart_parking_system/components/vehicledetails/add_vehicle.dart';
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
    "AddVehiclePage should allow adding a new vehicle",
    (WidgetTester tester) async {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: 'test.user@example.com',
        password: 'testpassword123',
      );

      await tester.pumpWidget(const MaterialApp(
        home: AddVehiclePage(),
      ));

      await tester.pumpAndSettle();

      expect(find.text('Car Info'), findsOneWidget);

      await tester.enterText(find.widgetWithText(TextFormField, 'Vehicle Brand'), 'Honda');
      await tester.enterText(find.widgetWithText(TextFormField, 'Vehicle Model'), 'Civic');
      await tester.enterText(find.widgetWithText(TextFormField, 'Color'), 'Red');
      await tester.enterText(find.widgetWithText(TextFormField, 'License Number'), 'XYZ789GP');

      // Debug: Print all ElevatedButtons in the widget tree
      find.byType(ElevatedButton).evaluate().forEach((element) {
        // print('ElevatedButton found: ${element.widget}');
      });

      // Try to find the button using different methods
      // final addVehicleButtonByText = find.widgetWithText(ElevatedButton, 'Add Vehicle');
      final addVehicleButtonByType = find.byType(ElevatedButton);

      // print('Button found by text: ${addVehicleButtonByText.evaluate().length}');
      // print('Buttons found by type: ${addVehicleButtonByType.evaluate().length}');

      // If multiple buttons are found, try to tap the last one (assuming it's at the bottom of the page)
      final buttonToTap = addVehicleButtonByType.last;

      // Attempt to scroll to the button
      await tester.ensureVisible(buttonToTap);
      await tester.pumpAndSettle();

      // Tap the button
      await tester.tap(buttonToTap);
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Verify navigation and new vehicle display
      expect(find.text('My Vehicles'), findsOneWidget);
      expect(find.text('Honda'), findsOneWidget);
      expect(find.text('Civic'), findsOneWidget);
      expect(find.text('Red'), findsOneWidget);
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