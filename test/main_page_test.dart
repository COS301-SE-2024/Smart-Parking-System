import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_parking_system/components/main_page.dart';

void main() {
  testWidgets('Widget initialization test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: MainPage(),
    ));

    // Wait for all animations and frame settling
    await tester.pumpAndSettle();

    // Verify if key widgets are present
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget); // Check for search field
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}
