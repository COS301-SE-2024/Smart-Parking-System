import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
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
    if (currentUser == null) {
      // Handle the case when the user is not logged in
      setState(() {
        rate = 'N/A';
      });
      return;
    }

    try {
      // Query the 'parkings' collection where 'userId' equals the current user's UID
      var parkingQuerySnapshot = await FirebaseFirestore.instance
          .collection('parkings')
          .where('userId', isEqualTo: currentUser.uid)
          .get();

      if (parkingQuerySnapshot.docs.isNotEmpty) {
        // Assuming the user has only one parking document
        var parkingDoc = parkingQuerySnapshot.docs.first;
        var price = parkingDoc.data()['price'] ?? 'N/A';
        setState(() {
          rate = 'R$price';
        });
      } else {
        // Handle the case when there is no parking document for the current user
        setState(() {
          rate = 'N/A';
        });
        if (kDebugMode) {
          print('No parking document found for the current user.');
        }
      }
    } catch (e) {
      // Handle any errors
      if (kDebugMode) {
        print('Error loading parking rate: $e');
      }
      setState(() {
        rate = 'N/A';
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
