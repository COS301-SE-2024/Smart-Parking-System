import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_parking_system/components/vehicledetails/view_vehicle.dart';

void main() {
  group('ViewVehiclePage', () {
    testWidgets('Displays the correct title', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ViewVehiclePage()));
      expect(find.text('My Vehicles'), findsOneWidget);
    });

    testWidgets('Displays the add vehicle button', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ViewVehiclePage()));
      expect(find.byIcon(Icons.add_circle_outline), findsOneWidget);
    });
  });

  group('CarCard', () {
    testWidgets('Displays the correct vehicle information', (WidgetTester tester) async {
      const carName = 'Toyota';
      const carType = 'Camry';
      const carColor = 'Blue';
      const lisenseNumber = 'ABC123';
      const imagePath = null;
      const vehicleId = 'abc123';

      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: CarCard(
            carName: carName,
            carType: carType,
            carColor: carColor,
            lisenseNumber: lisenseNumber,
            imagePath: imagePath,
            vehicleId: vehicleId,
          ),
        ),
      ));

      expect(find.text(carName), findsOneWidget);
      expect(find.text(carType), findsOneWidget);
      expect(find.text(carColor), findsOneWidget);
      // expect(find.text(lisenseNumber), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });
  });
}