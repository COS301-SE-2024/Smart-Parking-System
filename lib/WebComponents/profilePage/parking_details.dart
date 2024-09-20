import 'package:flutter/material.dart';

class ParkingDetails extends StatelessWidget {
  const ParkingDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Parking layout details',
            style: TextStyle(
              color: Colors.black,
              fontSize: 40,
              fontWeight: FontWeight.w700,
              fontFamily: 'Roboto',
            ),
          ),
          SizedBox(height: 57),
          _buildDetailItem('Total parking slots', '10 000'),
          SizedBox(height: 34),
          _buildDetailItem('Zones', '20'),
          SizedBox(height: 26),
          _buildDetailItem('Floors', '5'),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: 'Quicksand',
          ),
        ),
        SizedBox(height: 16),
        Text(
          value,
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.w400,
            fontFamily: 'Quicksand',
          ),
        ),
      ],
    );
  }
}