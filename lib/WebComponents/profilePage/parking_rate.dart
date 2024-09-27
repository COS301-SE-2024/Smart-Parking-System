import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ParkingRate extends StatefulWidget {
  const ParkingRate({super.key});

  @override
  State<ParkingRate> createState() => _ParkingRateState();
}

class _ParkingRateState extends State<ParkingRate> {
  String rate = 'Loading...'; // Placeholder text before data loads

  @override
  void initState() {
    super.initState();
    _loadParkingRate();
  }

  Future<void> _loadParkingRate() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    var document = FirebaseFirestore.instance.collection('parkings').doc(currentUser!.uid); // Your document ID here
    var snapshot = await document.get();
    if (snapshot.exists) {
      setState(() {
        // rate = 'R' + (snapshot.data()?['price'] ?? 'N/A');
        rate = 'R${snapshot.data()?['price'] ?? 'N/A'}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Ensures the container fills the width
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F37),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Parking rate',
            style: TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.w700,
              fontFamily: 'Roboto',
            ),
          ),
          const SizedBox(height: 10),
          Text(
            rate, // Display the dynamically loaded rate
            style: const TextStyle(
              color: Color(0xFF58C6A9),
              fontSize: 128,
              fontWeight: FontWeight.w700,
              fontFamily: 'Roboto',
            ),
          ),
          const Text(
            'per hour',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              fontFamily: 'Roboto',
            ),
          ),
        ],
      ),
    );
  }
}
