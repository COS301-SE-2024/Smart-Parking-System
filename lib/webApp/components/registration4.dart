import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_parking_system/components/common/toast.dart';
import 'package:smart_parking_system/webApp/components/registration5.dart';

class Registration4 extends StatefulWidget {
  final Function onRegisterComplete;

  const Registration4({super.key, required this.onRegisterComplete});

  @override
  // ignore: library_private_types_in_public_api
  _Registration4State createState() => _Registration4State();
}

class _Registration4State extends State<Registration4> {
  double _pricePerHour = 20.0; // Default price

  Future<void> _clientRegisterParkingDetails() async {

    try {
      User? user = FirebaseAuth.instance.currentUser;
      
      if (user != null) {
        // Query for existing document
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('client_parking_details')
            .where('userId', isEqualTo: user.uid)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // Document exists, update it
          await querySnapshot.docs.first.reference.update({
            'pricingPerHour': _pricePerHour,
          });
          showToast(message: 'Parking Detail updated Successfully!');
        } else {
          // Document doesn't exist, add new one
          await FirebaseFirestore.instance.collection('client_parking_details').add({
            'userId': user.uid,
            'location': null,
            'operationHours': null,
            'pricingPerHour': _pricePerHour,
          });
          showToast(message: 'Parking Detail added Successfully!');
        }

        // ignore: use_build_context_synchronously
        widget.onRegisterComplete();
      } else {
        showToast(message: 'User not logged in');
      }
    } catch (e) {
      showToast(message: 'Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          _buildPriceText(),
          const SizedBox(height: 15),
          _buildPriceSlider(),
          const SizedBox(height: 25),
          Center(
            child: SizedBox(
              width: 200,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  // Handle next step action
                  _clientRegisterParkingDetails();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF58C6A9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Select pricing per hour *",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "R${_pricePerHour.toInt()}",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceSlider() {
    return Slider(
      value: _pricePerHour,
      min: 10,
      max: 100,
      divisions: 90,
      activeColor: const Color(0xFF58C6A9),
      inactiveColor: Colors.grey,
      onChanged: (value) {
        setState(() {
          _pricePerHour = value;
        });
      },
    );
  }
}