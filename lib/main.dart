//mobile config
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:smart_parking_system/components/login/login_main.dart';
// import 'package:smart_parking_system/components/splashscreen/splash_screen.dart';
// import 'package:smart_parking_system/components/notifications/notificationfunction.dart';


// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   // You can add logic here to handle the background message
// }


// Future<void> main() async {
//   await dotenv.load(fileName: ".env");
//   WidgetsFlutterBinding.ensureInitialized();
//   // Initialize Firebase
//   //dotenv.env['API_KEY']!
//   if (kIsWeb) {
//     await Firebase.initializeApp(
//       options: FirebaseOptions(
//         apiKey: dotenv.env['API_KEY']!,
//         appId: "1:808791551084:web:6cf351cf1ebb0a5238fc49",
//         messagingSenderId: "808791551084",
//         projectId: "parkme-c2508",
//         storageBucket: "gs://parkme-c2508.appspot.com",
//       ),
//     );
//   } else {
//     await Firebase.initializeApp();
//   }

//   // Get a reference to the storage service
  
//   // final FirebaseStorage storage = FirebaseStorage.instanceFor(bucket: 'gs://parkme-c2508.appspot.com');
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//   // // Initialize FCM service
//   await FCMService().init();

//   runApp(const MyApp());
// }



// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Login Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         // You can customize the theme further here
//       ),
//       home: const Splash(), // This should now work correctly
//     );
//   }
// }




//web config
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:smart_parking_system/webApp/components/splash.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',

    );
  }


  static FirebaseOptions web = FirebaseOptions(
    apiKey: dotenv.env['API_KEY_WEB']!,
    authDomain: "parkme-c2508.firebaseapp.com",
    projectId: "parkme-c2508",
    storageBucket: "parkme-c2508.appspot.com",
    messagingSenderId: "808791551084",
    appId: "1:808791551084:web:6cf351cf1ebb0a5238fc49",
    measurementId: "G-BCFGSF79S8"
  );
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      home: const Splash(),
    );
  }
}

