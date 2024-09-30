import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:smart_parking_system/components/notifications/notificationspage.dart';
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
      
      // Add test notifications to Firestore
      final now = DateTime.now();
      
      await FirebaseFirestore.instance.collection('notifications').add({
        'userId': userCredential.user!.uid,
        'type': 'Reminder',
        'sent': true,
        'parkingTime': Timestamp.fromDate(now.add(const Duration(hours: 2))),
        'address': 'Test Location',
      });

      await FirebaseFirestore.instance.collection('notifications').add({
        'userId': userCredential.user!.uid,
        'type': 'Booking',
        'parkingTime': Timestamp.fromDate(now.subtract(const Duration(days: 1))),
        'address': 'Sandton City',
        'parkingSlot': 'A4c',
      });

      await FirebaseFirestore.instance.collection('notifications').add({
        'userId': userCredential.user!.uid,
        'type': 'Alert',
        'parkingTime': Timestamp.fromDate(now.subtract(const Duration(days: 10))),
        'description': 'You have parked in a no-parking zone',
      });
    } catch (e) {
      // print('Error in test setup: $e');
    }
  });

  testWidgets(
    "NotificationApp should display user's notifications",
    (WidgetTester tester) async {
      // Sign in the test user
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: 'test.user@example.com',
        password: 'testpassword123',
      );

      await tester.pumpWidget(const MaterialApp(
        home: NotificationApp(),
      ));

      // Wait for the page to load and fetch notifications
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Verify that the page title is displayed
      expect(find.text('Notifications'), findsOneWidget);

      // Verify that the "Clear all" button is present
      expect(find.text('Clear all'), findsOneWidget);

      // Verify that the section titles are displayed
      expect(find.text('Today'), findsOneWidget);
      expect(find.text('This Week'), findsOneWidget);
      expect(find.text('Older'), findsOneWidget);

      // Verify that the test notifications are displayed
      expect(find.text('Upcoming Parking Session'), findsOneWidget);
      expect(find.text('Successfully Booked'), findsOneWidget);
      expect(find.text('Parking Violation'), findsOneWidget);

      // Test clearing all notifications
      await tester.tap(find.text('Clear all'));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      
      

      // Verify that all notifications are removed
      expect(find.text('Upcoming Parking Session'), findsNothing);
      expect(find.text('Successfully Booked'), findsNothing);
      expect(find.text('Parking Violation'), findsNothing);

      
    },
  );

  tearDownAll(() async {
    // Clean up: delete test user and their notifications
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      
      // Delete test notifications
      QuerySnapshot notifications = await FirebaseFirestore.instance
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .get();
      
      for (var doc in notifications.docs) {
        await doc.reference.delete();
      }

      // Delete test user
      await FirebaseAuth.instance.currentUser!.delete();
    } catch (e) {
      // print('Error in test cleanup: $e');
    }
  });
}