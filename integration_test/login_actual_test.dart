import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:smart_parking_system/components/home/main_page.dart';
import 'package:smart_parking_system/components/login/login_main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    "After inputting the email and password, should navigate to the Home Page",
    (WidgetTester tester) async { 
      await dotenv.load(fileName: ".env");
      WidgetsFlutterBinding.ensureInitialized();
      // Initialize Firebase
      //dotenv.env['API_KEY']!
      if (kIsWeb) {
        await Firebase.initializeApp(
          options: FirebaseOptions(
            apiKey: dotenv.env['API_KEY']!,
            appId: "1:808791551084:web:6cf351cf1ebb0a5238fc49",
            messagingSenderId: "808791551084",
            projectId: "parkme-c2508",
            storageBucket: "gs://parkme-c2508.appspot.com",
          ),
        );
      } else {
        await Firebase.initializeApp();
      }
      // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // // Initialize FCM service
      // await FCMService().init();
      
      //Test login
      
      await tester.pumpWidget(const MaterialApp(
        home: LoginMainPage(),
      ));

      await tester.tap(find.widgetWithText(OutlinedButton, 'Log in'));
      await tester.pumpAndSettle();

      // Input this text
      const emailText = 'john.doe@example.com';
      const passwordText = '123456';
      await tester.enterText(find.byKey(const Key('Email')), emailText);
      await tester.enterText(find.byKey(const Key('Password')), passwordText);
      // Tap on a FAB
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // We should be in the DisplayPage that displays the inputted text
      expect(find.byType(MainPage), findsOneWidget);
    },
  );

}