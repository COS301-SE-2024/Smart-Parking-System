import 'package:flutter/material.dart';

class HelpSection extends StatelessWidget {
  const HelpSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F37), // Original background color
        borderRadius: BorderRadius.circular(20), // Consistent with other components
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Text
          const Text(
            'Help',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32, // Adjusted font size for consistency
              fontWeight: FontWeight.bold, // Consistent font weight
            ),
          ),
          const SizedBox(height: 24),
          // Help Items
          _buildHelpItem(
            'Contact us',
            'You can reach us at support@example.com or call us at (123) 456-7890.',
          ),
          _buildHelpItem(
            'Billing details',
            'Update your billing details in your account settings. For assistance, contact our billing department.',
          ),
          _buildHelpItem(
            'Support',
            'Visit our support center or email us at support@example.com for help.',
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(String title, String content) {
    return Card(
      color: const Color(0xFF2D3447), // Consistent with other components
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Consistent rounding
      ),
      margin: const EdgeInsets.symmetric(vertical: 8), // Consistent margins
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        backgroundColor: Colors.transparent,
        collapsedBackgroundColor: Colors.transparent,
        iconColor: Colors.white,
        collapsedIconColor: Colors.white,
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18, // Adjusted font size
            fontWeight: FontWeight.w600, // Consistent font weight
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              content,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
