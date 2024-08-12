import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  final Widget? child;
  const SplashScreen({super.key, this.child});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 5),(){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => widget.child!), (route) => false);
      }
    );
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    // return const Scaffold(
    //   body: Center(
    //     child: Text(
    //       "Welcome to Flutter Firebase",
    //         style: TextStyle(
    //         color: Colors.tealAccent,
    //         fontSize: 24,
    //         fontWeight: FontWeight.bold
    //       ),
    //     ),
    //   )
    // );
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

