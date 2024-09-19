import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_parking_system/components/vehicledetails/edit_vehicle.dart';

void main() {
  group('EditVehiclePage', () {
    testWidgets('Displays the correct title', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: EditVehiclePage(
          brand: 'Toyota',
          model: 'Camry',
          color: 'Blue',
          license: 'ABC123',
          vehicleId: 'abc123',
          image: null
        ),
      ));

      expect(find.text('Car Info'), findsOneWidget);
    });

    testWidgets('Displays the correct vehicle information', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: EditVehiclePage(
          brand: 'Toyota',
          model: 'Camry',
          color: 'Blue',
          license: 'ABC123',
          vehicleId: 'abc123',
          image: null
        ),
      ));

      expect(find.text('Toyota'), findsOneWidget);
      expect(find.text('Camry'), findsOneWidget);
      expect(find.text('Blue'), findsOneWidget);
      expect(find.text('ABC123'), findsOneWidget);
    });

    testWidgets('Updates the vehicle details', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: EditVehiclePage(
          brand: 'Toyota',
          model: 'Camry',
          color: 'Blue',
          license: 'ABC123',
          vehicleId: 'abc123',
          image: null
        ),
      ));

      await tester.enterText(find.byType(TextFormField).at(0), 'Honda');
      await tester.enterText(find.byType(TextFormField).at(1), 'Civic');
      await tester.enterText(find.byType(TextFormField).at(2), 'Red');
      await tester.enterText(find.byType(TextFormField).at(3), 'DEF456');

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Add assertions to check if the vehicle details are updated correctly
    });
  });

  group('ProfileField', () {
    testWidgets('Displays the correct label and value', (WidgetTester tester) async {
      final controller = TextEditingController(text: 'Toyota');

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ProfileField(
            label: 'Vehicle Brand',
            value: 'Toyota',
            controller: controller,
          ),
        ),
      ));

      expect(find.text('Vehicle Brand'), findsOneWidget);
      expect(find.text('Toyota'), findsOneWidget);
    });

    testWidgets('Updates the value when the input changes', (WidgetTester tester) async {
      final controller = TextEditingController(text: 'Toyota');

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ProfileField(
            label: 'Vehicle Brand',
            value: 'Toyota',
            controller: controller,
          ),
        ),
      ));

      await tester.enterText(find.byType(TextFormField), 'Honda');
      await tester.pump();

      expect(controller.text, 'Honda');
    });
  });
}