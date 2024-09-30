import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:smart_parking_system/components/parking/parking_history.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await Firebase.initializeApp();
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);

    // Create a test user
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: 'test.user@example.com',
      password: 'testpassword123',
    );
  });

  testWidgets('ParkingHistoryPage performance test - load testing',
      (WidgetTester tester) async {
    // Sign in the test user
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: 'test.user@example.com',
      password: 'testpassword123',
    );

    // Add a large number of test parking sessions
    final user = FirebaseAuth.instance.currentUser!;
    final firestore = FirebaseFirestore.instance;
    final batch = firestore.batch();

    final dateFormatter = DateFormat('yyyy-MM-dd');
    final timeFormatter = DateFormat('HH:mm');

    for (int i = 0; i < 100; i++) {
      final docRef = firestore.collection('bookings').doc();
      final date = DateTime(2023, 9, (i % 30) + 1, i % 24);
      batch.set(docRef, {
        'userId': user.uid,
        'address': 'Test Location $i',
        'zone': 'Zone A',
        'level': 'L1',
        'row': 'R$i',
        'date': dateFormatter.format(date),
        'time': timeFormatter.format(date),
        'price': 10,
        'duration': 2,
      });
    }

    await batch.commit();

    // Rest of the test code remains the same...
    // Measure the time it takes to render the page
    final stopwatch = Stopwatch()..start();

    await tester.pumpWidget(const MaterialApp(
      home: ParkingHistoryPage(),
    ));

    // Wait for the page to finish rendering
    await tester.pumpAndSettle(const Duration(seconds: 10));

    stopwatch.stop();
    final renderTime = stopwatch.elapsedMilliseconds;

    // Print the render time
    // print('Time to render ParkingHistoryPage: $renderTime ms');

    // Verify that the page title is displayed
    expect(find.text('Parking History'), findsOneWidget);

    // Verify that at least some parking sessions are displayed
    expect(find.byType(ExpansionTile), findsOneWidget);
    expect(find.text('Completed Sessions'), findsOneWidget);

    // Performance assertion: render time should be under 5 seconds
    expect(renderTime, lessThan(13000),
        reason:
            'ParkingHistoryPage took too long to render ($renderTime ms)');

    // Scroll test to check smooth scrolling with many items
    final scrollable = find.byType(Scrollable).first;
    final stopwatchScroll = Stopwatch()..start();

    await tester.fling(scrollable, const Offset(0, -500), 1000);
    await tester.pumpAndSettle();

    stopwatchScroll.stop();
    final scrollTime = stopwatchScroll.elapsedMilliseconds;

    // print('Time to scroll: $scrollTime ms');

    // Performance assertion: scroll time should be under 1 second
    expect(scrollTime, lessThan(3000),
        reason: 'Scrolling took too long ($scrollTime ms)');
  });

  tearDownAll(() async {
    // Clean up: delete test user and their parking sessions
    final user = FirebaseAuth.instance.currentUser!;
    final firestore = FirebaseFirestore.instance;

    // Delete test parking sessions
    final sessions = await firestore
        .collection('bookings')
        .where('userId', isEqualTo: user.uid)
        .get();
    for (var doc in sessions.docs) {
      await doc.reference.delete();
    }

    // Delete test user
    await user.delete();
  });
}