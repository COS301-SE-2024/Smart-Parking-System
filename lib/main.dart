import 'package:flutter/material.dart';
import 'package:smart_parking_system/components/login/login_main.dart';
import 'components/login/login.dart';

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



