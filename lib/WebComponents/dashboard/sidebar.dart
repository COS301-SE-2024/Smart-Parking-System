import 'package:flutter/material.dart';
import 'package:smart_parking_system/WebComponents/profilePage/parking_layout_section.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: const Color(0xFF35344A), // Main background color of the sidebar
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Image.asset(
              'assets/icons/logo.png', // Replace with your local asset
              width: 197,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 34),
          _buildDashboardMenu(),
          const SizedBox(height: 34),
          _buildAccountPages(),
          const SizedBox(height: 27),
          _buildProfileMenuItem(context),
        ],
      ),
    );
  }

  Widget _buildDashboardMenu() {
    return Container(
      width: 220, // Set the width of the container
      height: 154, // Adjusted height to prevent overflow
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F37), // Set the background color of the container
        borderRadius: BorderRadius.circular(20), // Set the border radius to 20
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMenuItem(
            'Dashboard',
            'assets/icons/dashboard_icon.png', // Replace with your local asset
            isSelected: true,
            onTap: () {},
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSubMenuItem('Parking Fees'),
              _buildSubMenuItem('Invoices'),
              _buildSubMenuItem('Booking Details'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileMenuItem(BuildContext context) {
    return _buildMenuItem(
      'Profile',
      'assets/icons/profile_icon.png', // Replace with your local asset
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ParkingLayoutScreen()),
        );
      },
    );
  }

  Widget _buildMenuItem(String title, String iconPath, {bool isSelected = false, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          children: [
            Image.asset(
              iconPath,
              width: 30,
              height: 30,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 15),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white.withOpacity(0.8),
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
