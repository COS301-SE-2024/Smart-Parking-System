import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_parking_system/components/common/custom_widgets.dart';
import 'package:smart_parking_system/components/payment/top_up.dart';
import 'package:smart_parking_system/components/settings/about_us.dart';
import 'package:smart_parking_system/components/home/main_page.dart';
import 'package:smart_parking_system/components/parking/parking_history.dart';
import 'package:smart_parking_system/components/payment/payment_options.dart';
import 'package:smart_parking_system/components/settings/user_profile.dart';
import 'package:smart_parking_system/components/home/sidebar.dart';
import 'package:smart_parking_system/components/vehicledetails/view_vehicle.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

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

Future<void> updateNotificationPreference(bool isEnabled) async {
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'notificationsEnabled': isEnabled,
    });
  }
}

class _SettingsPageState extends State<SettingsPage> {
  int _selectedIndex = 3;
  bool _isSwitched = true;
  bool _isFetching = true;
  String _username = 'Loading...';
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _setUserData();
  }

  Future<void> _setUserData() async {
    setState(() {
      _isFetching = true;
    });
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      String username = await getUserName(userId);
      String? profileImageUrl = await getProfileImageUrl(userId);

      // Fetch the notification preference from Firestore and set it
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      bool notificationsEnabled = userDoc.get('notificationsEnabled') ?? true;

      setState(() {
        _username = username;
        _profileImageUrl = profileImageUrl;
        _isSwitched = notificationsEnabled;
      });
    }
    setState(() {
      _isFetching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF35344A),
      body: _isFetching ? loadingWidget()
      : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                color: const Color(0xFF35344A),
                child: Stack(
                  children: [
                    Builder(
                      builder: (BuildContext context) {
                        return IconButton(
                          icon: const Icon(Icons.menu, color: Colors.white, size: 30.0),
                          onPressed: () {
                            Scaffold.of(context).openDrawer(); // Open the drawer
                          },
                        );
                      },
                    ),
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Settings',
                        style: TextStyle(
                          color: Colors.tealAccent,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey,
                      backgroundImage: _profileImageUrl != null ? NetworkImage(_profileImageUrl!) : null,
                      child: _profileImageUrl == null ? const Icon(Icons.person, size: 40, color: Colors.white) : null,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _username,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: SizedBox(
                  width: 500,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                      const Text(
                        '   Account Settings',
                        style: TextStyle(
                          color: Color(0xFFADADAD),
                          fontSize: 16,
                        ),
                      ),
                      ListTile(
                        title: const Text('Edit profile', style: TextStyle(color: Colors.white)),
                        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const UserProfilePage(),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: const Text('My vehicles', style: TextStyle(color: Colors.white)),
                        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ViewVehiclePage(),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: const Text('My payment options', style: TextStyle(color: Colors.white)),
                        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const TopUpPage(),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: const Text('Push notifications', style: TextStyle(color: Colors.white)),
                        trailing: Switch(
                          value: _isSwitched,
                          onChanged: (bool value) async {
                            setState(() {
                              _isSwitched = value;
                            });
                            await updateNotificationPreference(value);
                          },
                          activeColor: Colors.tealAccent,
                        ),
                      ),
                      const Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                      const Text(
                        '   More',
                        style: TextStyle(
                          color: Color(0xFFADADAD),
                          fontSize: 16,
                        ),
                      ),
                      ListTile(
                        title: const Text('About', style: TextStyle(color: Colors.white)),
                        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const AboutUsPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              
              
            ],
          ),
        ),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: const Color(0xFF35344A),
        ),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.6),
                spreadRadius: 1,
                blurRadius: 8,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: const Color(0xFF35344A),
            currentIndex: _selectedIndex,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined, size: 30),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.wallet, size: 30),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history, size: 30),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined, size: 30),
                label: '',
              ),
            ],
            onTap: (index) {
              setState(() {
                _selectedIndex = index;

                if (_selectedIndex == 0) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const MainPage(),
                    ),
                  );
                } else if (_selectedIndex == 1) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const PaymentMethodPage(),
                    ),
                  );
                } else if (_selectedIndex == 2) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ParkingHistoryPage(),
                    ),
                  );
                } else if (_selectedIndex == 3) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SettingsPage(),
                      ),
                    );
                }
              });
            },
            selectedItemColor: const Color(0xFF58C6A9),
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: false,
            showSelectedLabels: false,
          ),
        ),
      ),
      drawer: const SideMenu(),
    );
  }
}