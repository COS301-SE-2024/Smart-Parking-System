import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 240, // Set the width of the sidebar
      child: Container(
        color: const Color(0xFF35344A), // Updated background color
        child: Column(
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, size: 40, color: Colors.grey),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the drawer
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'John Doe',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.payment, color: Colors.white),
                    title: const Text('Payment methods', style: TextStyle(color: Colors.white)),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.history, color: Colors.white),
                    title: const Text('Parking History', style: TextStyle(color: Colors.white)),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.local_offer, color: Colors.white),
                    title: const Text('Promotion code', style: TextStyle(color: Colors.white)),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.notifications, color: Colors.white),
                    title: const Text('Notification', style: TextStyle(color: Colors.white)),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.support, color: Colors.white),
                    title: const Text('Support', style: TextStyle(color: Colors.white)),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings, color: Colors.white),
                    title: const Text('Settings', style: TextStyle(color: Colors.white)),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 20.0),
              child: Image.asset(
                '../assets/logo.jpg', // Path to the image asset
                height: 120, // Adjust height as needed
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.white),
              title: const Text('Logout', style: TextStyle(color: Colors.white)),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
