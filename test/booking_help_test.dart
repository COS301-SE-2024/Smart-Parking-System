import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_parking_system/components/help/bookinghelp.dart';
void main() {
  testWidgets('Bookinghelp displays initial UI correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
       const MaterialApp(
        home: Bookinghelp(),
      ),
    );

    // Check if initial UI elements are displayed
    expect(find.text('Booking questions'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back_ios), findsOneWidget);
    expect(find.text('How do I make a booking'), findsOneWidget);
    expect(find.text('How do I check my booking'), findsOneWidget);
  });

  testWidgets('Bookinghelp expands "How do I check my booking" section', (WidgetTester tester) async {
    await tester.pumpWidget(
     const MaterialApp(
        home: Bookinghelp(),
      ),
    );

    // Tap to expand the "How do I check my booking" section
    await tester.tap(find.text('How do I check my booking'));
    await tester.pumpAndSettle();

    // Check if the expanded content is displayed
    expect(find.text('You can view your current and past bookings by navigating to the booking history page'), findsOneWidget);
  });

  testWidgets('Bookinghelp navigates back when back button is pressed', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
              return ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const Bookinghelp(),
                  ));
                },
                child: const Text('Go to Bookinghelp'),
              );
            },
          ),
        ),
      ),
    );

    // Navigate to Bookinghelp
    await tester.tap(find.text('Go to Bookinghelp'));
    await tester.pumpAndSettle();

    // Check if we're on the Bookinghelp page
    expect(find.byType(Bookinghelp), findsOneWidget);

    // Tap the back button
    await tester.tap(find.byIcon(Icons.arrow_back_ios));
    await tester.pumpAndSettle();

    // Check if we've navigated back
    expect(find.byType(Bookinghelp), findsNothing);
  });
}
