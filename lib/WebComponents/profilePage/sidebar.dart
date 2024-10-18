import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_parking_system/WebComponents/dashboard/dashboard_screen.dart';
import 'package:smart_parking_system/webApp/components/splash.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false); // Set isLoggedIn to false
    if (!context.mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SplashScreen(),
      ),
    );
  }

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
              'assets/logo_small.jpg', // Replace with your local asset for logo
              width: 197,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 34),
          _buildDashboardMenu(context),
          const SizedBox(height: 34),
          _buildAccountPages(),
          const SizedBox(height: 27),
          _buildProfileMenuItem(),
          const SizedBox(height: 34),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.white),
            title: const Text('Logout', style: TextStyle(color: Colors.white)),
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardMenu(BuildContext context) {
    return _buildMenuItem(
      'Dashboard',
      'assets/Component 1.png', // Replace with your local asset for dashboard icon
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      },
    );
  }

  Widget _buildAccountPages() {
    return const Padding(
      padding: EdgeInsets.only(left: 29.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'ACCOUNT PAGES',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileMenuItem() {
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
            'Profile',
            'assets/Frame 1171275427.png', // Replace with your local asset for profile icon
            isSelected: true,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSubMenuItem('Parking Layout'),
              _buildSubMenuItem('Parking Rate'),
              _buildSubMenuItem('Help'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String title, String iconUrl, {bool isSelected = false, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          children: [
            Image.asset(
              iconUrl, // Use local asset icon here
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

  static Widget _buildSubMenuItem(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 61.0, top: 8.0, bottom: 8.0),//test
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
