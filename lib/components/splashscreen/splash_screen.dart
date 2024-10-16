import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_parking_system/components/home/main_page.dart';

class SplashScreen extends StatefulWidget {
  final Widget? child;
  const SplashScreen({super.key, this.child});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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
    Future.delayed(
      const Duration(seconds: 5),(){
        _checkIfLoggedIn();
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => widget.child!),
            (route) => false,
          );
        }
      }
    );
    super.initState();
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
                  height: 300, // Adjust the height as needed
                  width: 300,  // Adjust the width as needed
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }



}