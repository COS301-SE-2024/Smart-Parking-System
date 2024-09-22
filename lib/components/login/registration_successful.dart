import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_parking_system/components/common/custom_widgets.dart';
import 'package:smart_parking_system/components/home/main_page.dart';


class SuccessionPage extends StatefulWidget {
  const SuccessionPage({super.key});

  @override
  State<SuccessionPage> createState() => _SuccessionPageState();
}

class _SuccessionPageState extends State<SuccessionPage> {

  @override
  void initState() {
    super.initState();
  }
  void nextPage () {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const MainPage(),
      ),
      (Route<dynamic> route) => false,
    );
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SvgPicture.asset(
            'assets/Background - Small.svg', // Ensure you have the SVG background image in your assets folder
            fit: BoxFit.fill,
            width: double.infinity,
            height: double.infinity,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/Successmark.png', height: 100), // Ensure you have the image in your assets folder
                const SizedBox(height: 30),
                const Text(
                  'Registered Successfully',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Congratulations!',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 60),
                nextButton(
                  displayText: 'Finished', 
                  action: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const MainPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
