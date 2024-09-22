import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_parking_system/components/bookings/select_vehicle.dart';

void main() {
  group('CarCard', () {
    testWidgets('Displays the correct vehicle information', (WidgetTester tester) async {
      const carName = 'Toyota';
      const carType = 'Camry';
      const imagePath = null;
      const isSelected = true;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: CarCard(
            carName: carName,
            carType: carType,
            imagePath: imagePath,
            isSelected: isSelected,
            onSelect: () {},
            licensePlate: 'TBG0T2GP'
          ),
        ),
      ));

      expect(find.text(carName), findsOneWidget);
      expect(find.text(carType), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('Calls the onSelect callback when tapped', (WidgetTester tester) async {
      bool isSelected = false;
      onSelect() {
        isSelected = true;
      }

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: CarCard(
            carName: 'Toyota',
            carType: 'Camry',
            imagePath: null,
            isSelected: isSelected,
            onSelect: onSelect,
            licensePlate: 'TBG0T2GP'
          ),
        ),
      ));

      await tester.tap(find.byType(GestureDetector));
      await tester.pump();

      expect(isSelected, isTrue);
    });
  });
}