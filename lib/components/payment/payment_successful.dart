import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_parking_system/components/common/custom_widgets.dart';
import 'package:smart_parking_system/components/parking/parking_history.dart';


class PaymentSuccessionPage extends StatefulWidget {
  const PaymentSuccessionPage({super.key});

  @override
  State<PaymentSuccessionPage> createState() => _PaymentSuccessionPageState();
}

class _PaymentSuccessionPageState extends State<PaymentSuccessionPage> {
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
                  'Payment Successful',
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
                        builder: (_) => const ParkingHistoryPage(),
                      ),
                    );
                  },
                ),
                //  ElevatedButton(
                //   onPressed: () {
                //     Navigator.of(context).push(
                //         MaterialPageRoute(
                //           builder: (_) => const ParkingHistoryPage(),
                //         ),
                //       );
                //   },
                //   style: ElevatedButton.styleFrom(
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(40.0),
                //     ),
                //     padding: const EdgeInsets.symmetric(
                //       horizontal: 150,
                //       vertical: 20,
                //     ),
                //     backgroundColor: const Color(0xFF58C6A9),
                //   ),
                //   child: const Text(
                //     'Finished',
                //     style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
