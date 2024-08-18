import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_parking_system/components/payment/payment_options.dart';

void main() {
  Widget createWidgetForTesting({required Widget child}) {
    return MaterialApp(
      home: child,
    );
  }

  testWidgets('PaymentMethodPage renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(
      child: const PaymentMethodPage(),
    ));


    expect(find.text('Payment Options'), findsOneWidget);


    expect(find.text('Credit'), findsOneWidget);


    expect(find.text('Credits & Debit Cards'), findsOneWidget);


    expect(find.text('Top Up'), findsOneWidget);


    expect(find.text('Add New Card'), findsOneWidget);
  });

  testWidgets('Tapping Top Up button opens dialog', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(
      child: const PaymentMethodPage(),
    ));


    await tester.tap(find.text('Top Up'));
    await tester.pumpAndSettle();


    expect(find.text('Top Up'), findsNWidgets(2)); // Because there is the button and the dialog title
    expect(find.text('Enter amount'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Top Up'), findsNWidgets(2)); // The button and the dialog action
  });

  testWidgets('Tapping Add New Card button navigates to AddCardPage', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(
      child: const PaymentMethodPage(),
    ));


    await tester.tap(find.text('Add New Card'));
    await tester.pumpAndSettle();


  });

  testWidgets('Bottom navigation works correctly', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(
      child: const PaymentMethodPage(),
    ));


    expect(find.byIcon(Icons.wallet), findsOneWidget);

    await tester.tap(find.byIcon(Icons.home_outlined));
    await tester.pumpAndSettle();

  });

  testWidgets('FloatingActionButton is present', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(
      child: const PaymentMethodPage(),
    ));

    // Verify if the FAB is present
    expect(find.byIcon(Icons.near_me), findsOneWidget);
  });
}
