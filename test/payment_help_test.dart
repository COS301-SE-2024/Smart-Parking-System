import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_parking_system/components/help/paymentshelp.dart'; // Update this import
void main() {
  testWidgets('Paymentshelp displays initial UI correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Paymentshelp(),
      ),
    );

    // Add a delay to allow the widget to build completely
    await tester.pumpAndSettle();

    // Print the widget tree for debugging
    debugDumpApp();

    // Check if initial UI elements are displayed
    expect(find.text('Payment questions'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back_ios), findsOneWidget);
    
    // Use more flexible text finding
    expect(find.textContaining('How do I add a new card'), findsOneWidget);
    expect(find.textContaining('How do I apply a coupon'), findsOneWidget);
    expect(find.textContaining('How do I top up'), findsOneWidget);
  });

  testWidgets('Paymentshelp expands question sections', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Paymentshelp(),
      ),
    );

    await tester.pumpAndSettle();

    // Find and tap each ExpansionTile
    final expansionTiles = find.byType(ExpansionTile);
    for (int i = 0; i < expansionTiles.evaluate().length; i++) {
      await tester.tap(expansionTiles.at(i));
      await tester.pumpAndSettle();
    }

    // Check if the expanded content is displayed
    expect(find.textContaining('Open "Payment methods page'), findsWidgets);
    expect(find.textContaining('Click on "Add a new card"'), findsOneWidget);
    expect(find.textContaining('When directed to the payments method page'), findsOneWidget);
    expect(find.textContaining('Click on "Top up"'), findsOneWidget);
    expect(find.textContaining('Enter the amount you wish to top up'), findsOneWidget);
  });

  testWidgets('Paymentshelp navigates back when back button is pressed', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
              return ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const Paymentshelp(),
                  ));
                },
                child: const Text('Go to Paymentshelp'),
              );
            },
          ),
        ),
      ),
    );

    // Navigate to Paymentshelp
    await tester.tap(find.text('Go to Paymentshelp'));
    await tester.pumpAndSettle();

    // Check if we're on the Paymentshelp page
    expect(find.byType(Paymentshelp), findsOneWidget);

    // Tap the back button
    await tester.tap(find.byIcon(Icons.arrow_back_ios));
    await tester.pumpAndSettle();

    // Check if we've navigated back
    expect(find.byType(Paymentshelp), findsNothing);
  });

  testWidgets('Paymentshelp does not display images', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Paymentshelp(),
      ),
    );

    await tester.pumpAndSettle();

    // Expand all sections
    final expansionTiles = find.byType(ExpansionTile);
    for (int i = 0; i < expansionTiles.evaluate().length; i++) {
      await tester.tap(expansionTiles.at(i));
      await tester.pumpAndSettle();
    }

    // Check that no images are displayed
    expect(find.byType(Image), findsNothing);
  });
}
