import 'package:flutter/material.dart';

class ParkingRate extends StatelessWidget {
  const ParkingRate({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Parking rate',
            style: TextStyle(
              color: Colors.black,
              fontSize: 40,
              fontWeight: FontWeight.w700,
              fontFamily: 'Roboto',
            ),
          ),
          SizedBox(height: 59),
          Text(
            'R20',
            style: TextStyle(
              color: Colors.black,
              fontSize: 128,
              fontWeight: FontWeight.w700,
              fontFamily: 'Roboto',
            ),
          ),
          SizedBox(height: 73),
          Text(
            'per hour',
            style: TextStyle(
              color: Colors.black,
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