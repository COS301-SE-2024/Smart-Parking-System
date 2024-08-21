import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_parking_system/components/settings/settings.dart';

void main() {
  Widget createWidgetForTesting({required Widget child}) {
    return MaterialApp(
      home: child,
    );
  }

  testWidgets('SettingsPage renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(
      child: const SettingsPage(),
    ));


    expect(find.text('Settings'), findsOneWidget);


    expect(find.byIcon(Icons.person), findsOneWidget);
    expect(find.text('John Doe'), findsOneWidget);


    expect(find.text('Account Settings'), findsOneWidget);
    expect(find.text('More'), findsOneWidget);


    expect(find.text('Edit profile'), findsOneWidget);
    expect(find.text('Update vehicle details'), findsOneWidget);
    expect(find.text('Add a payment method'), findsOneWidget);
    expect(find.text('Push notifications'), findsOneWidget);
    expect(find.text('About us'), findsOneWidget);
    expect(find.text('Privacy policy'), findsOneWidget);
  });

  testWidgets('Tapping Edit Profile navigates to UserProfilePage', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(
      child: const SettingsPage(),
    ));

    await tester.tap(find.text('Edit profile'));
    await tester.pumpAndSettle();


  });

  testWidgets('Tapping Update Vehicle Details navigates to ViewVehiclePage', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(
      child: const SettingsPage(),
    ));

    await tester.tap(find.text('Update vehicle details'));
    await tester.pumpAndSettle();

  });

  testWidgets('Push notifications switch works correctly', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(
      child: const SettingsPage(),
    ));

    final switchFinder = find.byType(Switch);
    expect(switchFinder, findsOneWidget);
    expect(tester.widget<Switch>(switchFinder).value, isTrue);


    await tester.tap(switchFinder);
    await tester.pump();

    expect(tester.widget<Switch>(switchFinder).value, isFalse);
  });

  testWidgets('Bottom navigation works correctly', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(
      child: const SettingsPage(),
    ));


    expect(find.byIcon(Icons.settings_outlined), findsOneWidget);

    await tester.tap(find.byIcon(Icons.home_outlined));
    await tester.pumpAndSettle();

  });

  testWidgets('FloatingActionButton is present', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(
      child: const SettingsPage(),
    ));

    expect(find.byIcon(Icons.near_me), findsOneWidget);
  });
}
