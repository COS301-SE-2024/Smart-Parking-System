import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_parking_system/components/parking/parking_history.dart';
//Firebase
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:smart_parking_system/components/common/toast.dart';


class PaymentSuccessionPage extends StatefulWidget {
  // final String selectedZone;
  // final String selectedLevel;
  // final String selectedRow;
  // final String selectedTime;
  // final double selectedDuration;
  // final double price;
  // final bool selectedDisabled;
  // final bool selectedWash;

  // const PaymentSuccessionPage({required this.selectedZone, required this.selectedLevel, required this.selectedRow, required this.selectedTime, required this.selectedDuration, required this.price, required this.selectedDisabled, required this.selectedWash, super.key});
  const PaymentSuccessionPage({super.key});

  @override
  State<PaymentSuccessionPage> createState() => _PaymentSuccessionPageState();
}

class _PaymentSuccessionPageState extends State<PaymentSuccessionPage> {
  @override
  void initState() {
    super.initState();
  }
  // Future<void> _bookspace() async {
  //   try {
  //     User? user = FirebaseAuth.instance.currentUser;

  //     if (user != null) {
  //       await FirebaseFirestore.instance.collection('bookings').add({
  //         'userId': user.uid, // Add the userId field
  //         'zone': widget.selectedZone,
  //         'level': widget.selectedLevel,
  //         'row': widget.selectedRow,
  //         'time': widget.selectedTime,
  //         'duration': widget.selectedDuration,
  //         'price': widget.price,
  //         'disabled': widget.selectedDisabled,
  //         'wash': widget.selectedWash,
  //       });

  //       showToast(message: 'Vehicle Added Successfully!');
  //       // ignore: use_build_context_synchronously
  //       Navigator.of(context).pushReplacement(
  //         MaterialPageRoute(
  //           builder: (context) => const SuccessionPage(),
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     showToast(message: 'Error: $e');
  //   }
  // }

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
                 ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => const ParkingHistoryPage(),
                        ),
                      );
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
