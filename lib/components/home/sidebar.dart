import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_parking_system/components/help/support.dart';
import 'package:smart_parking_system/components/login/login.dart';
import 'package:smart_parking_system/components/notifications/notificationspage.dart';
import 'package:smart_parking_system/components/parking/parking_history.dart';
import 'package:smart_parking_system/components/payment/payment_options.dart';
import 'package:smart_parking_system/components/settings/settings.dart';
import 'package:smart_parking_system/components/payment/promotion_code.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  Future<String> getUserName(String userId) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    String username = userDoc.get('username');
    String? surname = userDoc.get('surname');
    return surname == null ? username : '$username $surname';
  }

  Future<String?> getProfileImageUrl(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      return userDoc.get('profileImageUrl') as String?;
    } catch (e) {
      return null;
    }
  }

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false); // Set isLoggedIn to false
    if (!context.mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return FutureBuilder<Map<String, dynamic>>(
      future: user != null 
        ? Future.wait([
            getUserName(user.uid),
            getProfileImageUrl(user.uid),
          ]).then((results) => {
            'username': results[0],
            'profileImageUrl': results[1],
          })
        : Future.value({'username': 'Unknown User', 'profileImageUrl': null}),
      builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show a loading spinner while waiting
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading data')); // Handle errors
        } else {
          String userName = snapshot.data?['username'] ?? 'Unknown User';
          String? profileImageUrl = snapshot.data?['profileImageUrl'];

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
                            GestureDetector(
                              onTap: () {
                                // Navigator.of(context).push(
                                //   MaterialPageRoute(
                                //     builder: (_) => const UserProfilePage(),
                                //   ),
                                // );
                              },
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.grey,
                                backgroundImage: profileImageUrl != null
                                    ? NetworkImage(profileImageUrl)
                                    : null,
                                child: profileImageUrl == null
                                    ? const Icon(Icons.person, size: 40, color: Colors.white)
                                    : null,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.white),
                              onPressed: () {
                                Navigator.of(context).pop(true); // Close the drawer
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          userName,
                          style: const TextStyle(color: Colors.white, fontSize: 18),
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
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const PaymentMethodPage(),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.history, color: Colors.white),
                          title: const Text('Parking History', style: TextStyle(color: Colors.white)),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const ParkingHistoryPage(),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.local_offer, color: Colors.white),
                          title: const Text('Promotion code', style: TextStyle(color: Colors.white)),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const PromotionCode(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 30),
                        ListTile(
                          leading: const Icon(Icons.notifications, color: Colors.white),
                          title: const Text('Notification', style: TextStyle(color: Colors.white)),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const NotificationApp(),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.support, color: Colors.white),
                          title: const Text('Support', style: TextStyle(color: Colors.white)),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const SupportApp(),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.settings, color: Colors.white),
                          title: const Text('Settings', style: TextStyle(color: Colors.white)),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const SettingsPage(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 20.0),
                    child: Image.asset(
                      'assets/logo_small.png', // Path to the image asset
                      height: 100, // Adjust height as needed
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.white),
                    title: const Text('Logout', style: TextStyle(color: Colors.white)),
                    onTap: () => _logout(context),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
