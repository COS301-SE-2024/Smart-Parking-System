import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_parking_system/components/login/login.dart';
import 'package:smart_parking_system/components/login/signup.dart';
import 'package:smart_parking_system/components/home/main_page.dart';

class LoginMainPage extends StatefulWidget {
  const LoginMainPage({super.key});

  @override
  LoginMainPageState createState() => LoginMainPageState();
}

class LoginMainPageState extends State<LoginMainPage> {
  Future<void> _checkIfLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    int? loginTimestamp = prefs.getInt('loginTimestamp');

    // Define the session duration (e.g., 1 day)
    const int sessionDuration = 2 * 60 * 60 * 1000; // 24 hours in milliseconds

    if (isLoggedIn && loginTimestamp != null) {
      int currentTime = DateTime.now().millisecondsSinceEpoch;
      if (currentTime - loginTimestamp > sessionDuration) {
        // Session has expired
        isLoggedIn = false;
        await prefs.setBool('isLoggedIn', false);
      }
    }

    if (!mounted) return;

    if (isLoggedIn) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const MainPage(), // Replace with your main page
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _checkIfLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // Background image
          SvgPicture.asset(
            'assets/Background - Small.svg',
            fit: BoxFit.fill,
          ),
          // Foreground elements
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // Logo in the middle
                Image.asset(
                  'assets/logo_small.png',
                  height: 250, // Adjust the height as needed
                  width: 250,  // Adjust the width as needed
                ),
                const SizedBox(height: 30), // Space between logo and buttons
                // Login Button
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white, side: const BorderSide(color: Colors.white, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 81,
                      vertical: 15,
                    ),
                    child: Text(
                      'Log in',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Space between buttons
                // Sign Up Button
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SignupPage(),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white, side: const BorderSide(color: Colors.white, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 70,
                      vertical: 15,
                    ),
                    child: Text(
                      'Register',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}