import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:smart_parking_system/WebComponents/dashboard/sidebar.dart';
import 'package:smart_parking_system/WebComponents/dashboard/header.dart';
import 'package:smart_parking_system/WebComponents/dashboard/stats_cards.dart';
import 'package:smart_parking_system/WebComponents/dashboard/booking_billings.dart';
import 'package:smart_parking_system/WebComponents/dashboard/invoices.dart';
import 'package:smart_parking_system/WebComponents/dashboard/booking_details.dart';
import 'package:smart_parking_system/WebComponents/dashboard/dashboard_screen.dart';

// Mock classes for Firebase dependencies
class MockFirebaseAuth extends Mock {
  // Add any methods that your app calls on FirebaseAuth
}

class MockFirebaseFirestore extends Mock {
  // Add any methods that your app calls on FirebaseFirestore
}

// Mock provider for Firebase services
class MockFirebaseProvider extends ChangeNotifier {
  final MockFirebaseAuth auth = MockFirebaseAuth();
  final MockFirebaseFirestore firestore = MockFirebaseFirestore();
}

void main() {
  late DashboardScreen dashboardScreen;
  late MockFirebaseProvider mockFirebaseProvider;

  setUp(() {
    mockFirebaseProvider = MockFirebaseProvider();
    dashboardScreen = const DashboardScreen();
  });

  Widget createTestableWidget(Widget child) {
    return MaterialApp(
      home: ChangeNotifierProvider<MockFirebaseProvider>.value(
        value: mockFirebaseProvider,
        child: child,
      ),
    );
  }

  testWidgets('DashboardScreen layout test', (WidgetTester tester) async {
    await tester.pumpWidget(createTestableWidget(dashboardScreen));

    // Verify that the Sidebar is present
    expect(find.byType(Sidebar), findsOneWidget);

    // Verify that the Header is present
    expect(find.byType(Header), findsOneWidget);

    // Verify that the StatsCards are present
    expect(find.byType(StatsCards), findsOneWidget);

    // Verify that the BookingBillings section is present
    expect(find.byType(BookingBillings), findsOneWidget);

    // Verify that the Invoices section is present
    expect(find.byType(Invoices), findsOneWidget);

    // Verify that the BookingDetails section is present
    expect(find.byType(BookingDetails), findsOneWidget);
  });

  testWidgets('Sidebar interaction test', (WidgetTester tester) async {
    await tester.pumpWidget(createTestableWidget(dashboardScreen));

    // Add your sidebar interaction tests here
  });
}