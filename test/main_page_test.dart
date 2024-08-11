import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/mockito.dart';
import 'package:smart_parking_system/components/main_page.dart';
import 'package:location/location.dart';

// Mock classes
class MockLocation extends Mock implements Location {}
class MockGoogleMapController extends Mock implements GoogleMapController {}

void main() {
  late MainPage mainPage;
  late MockLocation mockLocation;
  late MockGoogleMapController mockMapController;

  setUp(() {
    mainPage = const MainPage();
    mockLocation = MockLocation();
    mockMapController = MockGoogleMapController();
  });


  testWidgets('GoogleMap widget test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: mainPage));

    // Verify that the GoogleMap widget is present
    expect(find.byType(GoogleMap), findsOneWidget);
  });

  testWidgets('Search bar interaction test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: mainPage));

    // Tap the search bar
    await tester.tap(find.byType(TextField));
    await tester.pump();

    // Verify that the modal becomes visible
    expect(find.byType(Container), findsWidgets);

    // Tap the close button on the modal
    await tester.tap(find.byIcon(Icons.close));
    await tester.pump();

    // Verify that the modal is hidden
    expect(find.byIcon(Icons.close), findsNothing);
  });


  testWidgets('Floating action button test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: mainPage));

    // Verify that the floating action button is present
    expect(find.byType(FloatingActionButton), findsOneWidget);

    // Tap the floating action button
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    // Verify the expected behavior after tapping the button
    // Add your specific checks here
  });

  testWidgets('Parking info modal test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: mainPage));

    // Tap the search bar to show the modal
    await tester.tap(find.byType(TextField));
    await tester.pump();

    // Tap on the parking location to show parking info
    await tester.tap(find.byType(ListTile).last);
    await tester.pumpAndSettle();

    // Verify that the parking info modal is shown
    expect(find.text('View Parking'), findsOneWidget);
  });

 
}