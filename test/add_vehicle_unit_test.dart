import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_parking_system/components/vehicledetails/add_vehicle.dart';


void main() {
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