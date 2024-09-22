import 'package:flutter/material.dart';

class ParkingRate extends StatelessWidget {
  const ParkingRate({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Add this line to expand width
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F37),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Parking rate',
            style: TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.w700,
              fontFamily: 'Roboto',
            ),
          ),
          SizedBox(height: 30),
          Text(
            'R20',
            style: TextStyle(
              color: Color (0xFF58C6A9),
              fontSize: 128,
              fontWeight: FontWeight.w700,
              fontFamily: 'Roboto',
            ),
          ),
          Text(
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
