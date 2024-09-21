import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart'; // For TapGestureRecognizer

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Color emailUnderlineColor = Colors.white;
  Color passwordUnderlineColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    print("LoginPage build method called"); // Debug print

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "DEBUG: This text should be visible",
              style: TextStyle(fontSize: 24, color: Colors.red),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 30,
                  height: 2,
                  color: Colors.red,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'DEBUG: Changed Text',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.red,
                    ),
                  ),
                ),
                Container(
                  width: 30,
                  height: 2,
                  color: Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}