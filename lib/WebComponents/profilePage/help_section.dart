import 'package:flutter/material.dart';

class HelpSection extends StatelessWidget {
  const HelpSection({super.key});

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
            'Help',
            style: TextStyle(
              color: Colors.black,
              fontSize: 40,
              fontWeight: FontWeight.w700,
              fontFamily: 'Roboto',
            ),
          ),
          SizedBox(height: 39),
          _buildHelpItem('Contact us'),
          SizedBox(height: 21),
          _buildHelpItem('Billing details'),
          SizedBox(height: 21),
          _buildHelpItem('Support'),
        ],
      ),
    );
  }

  Widget _buildHelpItem(String title) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 18),
      decoration: BoxDecoration(
        color: Color(0xFF312F4D),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          fontFamily: 'Roboto',
        ),
      ),
    );
  }
}