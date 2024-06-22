import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


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
                 ElevatedButton(
                  onPressed: () {
                    
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 150,
                      vertical: 20,
                    ),
                    backgroundColor: const Color(0xFF58C6A9),
                  ),
                  child: const Text(
                    'Finished',
                    style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500),
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
