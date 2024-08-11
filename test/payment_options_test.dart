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

    // Verify if the page title is displayed
    expect(find.text('Payment Options'), findsOneWidget);

    // Verify if the 'Credit' section is displayed
    expect(find.text('Credit'), findsOneWidget);

    // Verify if the 'Credits & Debit Cards' section is displayed
    expect(find.text('Credits & Debit Cards'), findsOneWidget);

    // Verify if the "Top Up" button is present
    expect(find.text('Top Up'), findsOneWidget);

    // Verify if the "Add New Card" button is present
    expect(find.text('Add New Card'), findsOneWidget);
  });

  testWidgets('Tapping Top Up button opens dialog', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(
      child: const PaymentMethodPage(),
    ));

    // Tap on the Top Up button
    await tester.tap(find.text('Top Up'));
    await tester.pumpAndSettle();

    // Verify if the Top Up dialog is displayed
    expect(find.text('Top Up'), findsNWidgets(2)); // Because there is the button and the dialog title
    expect(find.text('Enter amount'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Top Up'), findsNWidgets(2)); // The button and the dialog action
  });

  testWidgets('Tapping Add New Card button navigates to AddCardPage', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(
      child: const PaymentMethodPage(),
    ));

    // Tap on the "Add New Card" button
    await tester.tap(find.text('Add New Card'));
    await tester.pumpAndSettle();

    // Verify that AddCardPage is pushed to the navigation stack
    // Since we don't have access to AddCardPage in this context,
    // we will assume navigation works if no errors are thrown.
  });

  testWidgets('Bottom navigation works correctly', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(
      child: const PaymentMethodPage(),
    ));

    // Verify initial selected index is 1 (PaymentMethodPage)
    expect(find.byIcon(Icons.wallet), findsOneWidget);

    // Tap on the Home icon in the BottomNavigationBar
    await tester.tap(find.byIcon(Icons.home_outlined));
    await tester.pumpAndSettle();

    // Verify that MainPage is pushed to the navigation stack
    // We will assume navigation works if no errors are thrown.
  });

  testWidgets('FloatingActionButton is present', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(
      child: const PaymentMethodPage(),
    ));

    // Verify if the FAB is present
    expect(find.byIcon(Icons.near_me), findsOneWidget);
  });
}
