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
  print("Handling a background message: ${message.messageId}");
  // You can add logic here to handle the background message
}

Future<void> main() async {
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
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // // Initialize FCM service
  await FCMService().init();

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

// import 'package:flutter/material.dart';
// import 'package:smart_parking_system/components/main_page.dart'; // Import your main_page.dart file here

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Smart Parking System',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MainPage(), // Set MainPage as the home screen

//     );
//   }
// }



