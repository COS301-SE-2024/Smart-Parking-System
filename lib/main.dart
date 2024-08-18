import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:smart_parking_system/components/login/login_main.dart';
import 'package:smart_parking_system/components/splashscreen/splash_screen.dart';
import 'package:smart_parking_system/components/notifications/notificationfunction.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
}

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();

  print('Initializing Firebase...');

  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: "AIzaSyCd4Kz1yjrJXE85hrZ91RZ_iVdC0fnmqrY",
          appId: "1:808791551084:web:6cf351cf1ebb0a5238fc49",
          messagingSenderId: "808791551084",
          projectId: "parkme-c2508",
        ),
      );
    } else {
      await Firebase.initializeApp();
    }
    print('Firebase initialized successfully.');
  } catch (e) {
    print('Firebase initialization failed: $e');
  }

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  try {
    print('Initializing FCMService...');
    await FCMService().init();
    print('FCMService initialized successfully.');
  } catch (e) {
    print('FCMService initialization failed: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Signup & Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(
        child: LoginMainPage(),
      ),
    );
  }
}