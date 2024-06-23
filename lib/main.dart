import 'package:flutter/material.dart';
import 'package:smart_parking_system/components/login/login_main.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Signup & Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginMainPage(),
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



