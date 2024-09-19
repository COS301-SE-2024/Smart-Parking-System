// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:smart_parking_system/components/login/login_main.dart';
// import 'package:smart_parking_system/components/splashscreen/splash_screen.dart';
// import 'package:smart_parking_system/components/notifications/notificationfunction.dart';
// import 'package:smart_parking_system/WebComponents/hello_web_page.dart';
//
//
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   // You can add logic here to handle the background message
// }
//
// Future<void> main() async {
//
//   await dotenv.load(fileName: ".env");
//   WidgetsFlutterBinding.ensureInitialized();
//   // Initialize Firebase
//   //dotenv.env['API_KEY']!
//   if (kIsWeb) {
//     await Firebase.initializeApp(
//       options:  FirebaseOptions(
//         apiKey: dotenv.env['API_KEY']!,
//         appId: "1:808791551084:web:6cf351cf1ebb0a5238fc49",
//         messagingSenderId: "808791551084",
//         projectId: "parkme-c2508",
//         storageBucket: "gs://parkme-c2508.appspot.com",
//       ),
//     );
//       html.window.navigator.serviceWorker?.register('firebase-messaging-sw.js')
//         .then((registration) {
//       print('Service Worker registered successfully');
//     }).catchError((error) {
//       print('Service Worker registration failed: $error');
//     });
//   } else {
//     await Firebase.initializeApp();
//   }
//
//   // Get a reference to the storage service
//
//   // final FirebaseStorage storage = FirebaseStorage.instanceFor(bucket: 'gs://parkme-c2508.appspot.com');
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//
//   // // Initialize FCM service
//   await FCMService().init();
//
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     // Conditional widget based on platform
//     Widget homeWidget;
//
//     // Check if the platform is web
//     if (kIsWeb) {
//       homeWidget = const HelloWebPage(); // Web-specific page
//     } else {
//       homeWidget = const SplashScreen(child: LoginMainPage()); // Default for other platforms
//     }
//
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Signup & Login',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: homeWidget,
//     );
//   }
// }
//

import 'package:flutter/material.dart';
import 'package:smart_parking_system/WebComponents/dashboard/dashboard_screen.dart';

//display hello web page
void main() {
  runApp(const MaterialApp(
    home: DashboardScreen(),
  ));
}