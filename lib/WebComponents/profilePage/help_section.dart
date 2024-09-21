import 'package:flutter/material.dart';

class HelpSection extends StatelessWidget {
  const HelpSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F37),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Help',
            style: TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.w700,
              fontFamily: 'Roboto',
            ),
          ),
          const SizedBox(height: 39),
          _buildHelpItem(
            'Contact us',
            'You can reach us at support@example.com or call us at (123) 456-7890.',
          ),
          const SizedBox(height: 21),
          _buildHelpItem(
            'Billing details',
            'Update your billing details in your account settings. For assistance, contact our billing department.',
          ),
          const SizedBox(height: 21),
          _buildHelpItem(
            'Support',
            'Visit our support center or email us at support@example.com for help.',
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(String title, String content) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF312F4D),
        borderRadius: BorderRadius.circular(14),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 18),
        backgroundColor: const Color(0xFF312F4D),
        collapsedBackgroundColor: const Color(0xFF312F4D),
        iconColor: Colors.white,
        collapsedIconColor: Colors.white,
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            fontFamily: 'Roboto',
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Text(
              content,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontFamily: 'Roboto',
              ),
            ),
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}
