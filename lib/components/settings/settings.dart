// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:smart_parking_system/components/main_page.dart';
// import 'package:smart_parking_system/components/parking/parking_history.dart';
// import 'package:smart_parking_system/components/payment/payment_options.dart';
// import 'package:smart_parking_system/components/profile/userprofile.dart';
// import 'package:smart_parking_system/components/sidebar.dart';
// import 'package:smart_parking_system/components/vehicledetails/view_vehicle.dart';

// class SettingsPage extends StatefulWidget {
//   const SettingsPage({super.key});

//   @override
//   State<SettingsPage> createState() => _SettingsPageState();
// }

// Future<String> getUserName(String userId) async {
//   DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
//   return userDoc.get('username');
// }

// class _SettingsPageState extends State<SettingsPage> {
//   int _selectedIndex = 3;
//   bool _isSwitched = true;
//   String _username = 'John Doe';

//   @override
//   void initState() {
//     super.initState();
//     _setUsername();
//   }

//   Future<void> _setUsername() async {
//     String userId = FirebaseAuth.instance.currentUser!.uid;
//     String username = await getUserName(userId);
//     setState(() {
//       _username = username;
//     });
//   }

  

  




//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF35344A),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             const SizedBox(height: 30),
//             Container(
//               padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//               color: const Color(0xFF35344A),
//               child: Stack(
//                 children: [
//                   Builder(
//                     builder: (BuildContext context) {
//                       return IconButton(
//                         icon: const Icon(Icons.menu, color: Colors.white, size: 30.0),
//                         onPressed: () {
//                           Scaffold.of(context).openDrawer(); // Open the drawer
//                         },
//                       );
//                     },
//                   ),
//                   const Align(
//                     alignment: Alignment.center,
//                     child: Text(
//                       'Settings',
//                       style: TextStyle(
//                         color: Colors.tealAccent,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   const CircleAvatar(
//                     radius: 30,
//                     backgroundColor: Colors.grey,
//                     child: Icon(Icons.person, size: 40, color: Colors.white),
//                   ),
//                   const SizedBox(height: 10), 
//                   Text(
//                     _username, 
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const Divider(
//               color: Colors.grey,
//               thickness: 1,
//             ),
//             const Text(
//               'Account Settings',
//               style: TextStyle(
//                 color: Color(0xFFADADAD),
//                 fontSize: 16,
//               ),
//             ),
//             ListTile(
//               title: const Text('Edit profile', style: TextStyle(color: Colors.white)),
//               trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
//               onTap: () {
//                 Navigator.of(context).pushReplacement(
//                   MaterialPageRoute(
//                     builder: (_) => const UserProfilePage(),
//                   ),
//                 );
//               },
//             ),
//             ListTile(
//               title: const Text('Update vehicle details', style: TextStyle(color: Colors.white)),
//               trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
//               onTap: () {
//                 Navigator.of(context).pushReplacement(
//                   MaterialPageRoute(
//                     builder: (_) => const ViewVehiclePage(),
//                   ),
//                 );
//               },
//             ),
//             ListTile(
//               title: const Text('Add a payment method', style: TextStyle(color: Colors.white)),
//               trailing: const Icon(Icons.add, color: Colors.white, size: 20),
//               onTap: () {
//                 Navigator.of(context).pushReplacement(
//                   MaterialPageRoute(
//                     builder: (_) => const PaymentMethodPage(),
//                   ),
//                 );
//               },
//             ),
//             ListTile(
//               title: const Text('Push notifications', style: TextStyle(color: Colors.white)),
//               trailing: Switch(
//                 value: _isSwitched,
//                 onChanged: (bool value) {
//                   setState(() {
//                     _isSwitched = value;
//                   });
//                 },
//                 activeColor: Colors.tealAccent,
//               ),
//             ),
//             const Divider(
//               color: Colors.grey,
//               thickness: 1,
//             ),
//             const Text(
//               'More',
//               style: TextStyle(
//                 color: Color(0xFFADADAD),
//                 fontSize: 16,
//               ),
//             ),
//             const ListTile(
//               title: Text('About us', style: TextStyle(color: Colors.white)),
//               trailing: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
//             ),
//             const ListTile(
//               title: Text('Privacy policy', style: TextStyle(color: Colors.white)),
//               trailing: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
//             ),
//           ],
//         ),
//         ),   
//       ),
//       bottomNavigationBar: Theme(
//         data: Theme.of(context).copyWith(
//           canvasColor: const Color(0xFF35344A),
//         ),
//         child: Container(
//           decoration: BoxDecoration(
//             // color: const Color(0xFF2C2C54),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.6),
//                 spreadRadius: 1,
//                 blurRadius: 8,
//                 offset: const Offset(0, -3),
//               ),
//             ],
//           ),
//           child: BottomNavigationBar(
//             type: BottomNavigationBarType.fixed,
//             backgroundColor: const Color(0xFF35344A), // To ensure the Container color is visible
//             currentIndex: _selectedIndex,
//             items: const [
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.home_outlined, size: 30),
//                 label: '',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.wallet, size: 30),
//                 label: '',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.history, size: 30),
//                 label: '',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.settings_outlined, size: 30),
//                 label: '',
//               ),
//             ],
//             onTap: (index) {
//               setState(() {
//                 _selectedIndex = index;

//                 if (_selectedIndex == 0) {
//                   Navigator.of(context).pushReplacement(
//                     MaterialPageRoute(
//                       builder: (context) => const MainPage(),
//                     ),
//                   );
//                 } else if (_selectedIndex == 1) {
//                   Navigator.of(context).pushReplacement(
//                     MaterialPageRoute(
//                       builder: (context) => const PaymentMethodPage(),
//                     ),
//                   );
//                 } else if (_selectedIndex == 2) {
//                   Navigator.of(context).pushReplacement(
//                     MaterialPageRoute(
//                       builder: (context) => const ParkingHistoryPage(),
//                     ),
//                   );
//                 } else if (_selectedIndex == 3) {
//                   // Add navigation if necessary
//                 }
//               });
//             },
//             selectedItemColor: const Color(0xFF58C6A9),
//             unselectedItemColor: Colors.grey,
//             showUnselectedLabels: false,
//             showSelectedLabels: false,
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {},
//         backgroundColor: const Color(0xFF58C6A9),
//         shape: const CircleBorder(),
//         child: const Icon(
//           Icons.near_me,
//           color: Colors.white,
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       drawer: const SideMenu(),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_parking_system/components/settings/aboutus.dart'; 
import 'package:smart_parking_system/components/main_page.dart';
import 'package:smart_parking_system/components/parking/parking_history.dart';
import 'package:smart_parking_system/components/payment/payment_options.dart';
import 'package:smart_parking_system/components/profile/userprofile.dart';
import 'package:smart_parking_system/components/sidebar.dart';
import 'package:smart_parking_system/components/vehicledetails/view_vehicle.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

Future<String> getUserName(String userId) async {
  DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
  return userDoc.get('username');
}

class _SettingsPageState extends State<SettingsPage> {
  int _selectedIndex = 3;
  bool _isSwitched = true;
  String _username = 'John Doe';

  @override
  void initState() {
    super.initState();
    _setUsername();
  }

  Future<void> _setUsername() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    String username = await getUserName(userId);
    setState(() {
      _username = username;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF35344A),
      body: Padding(
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
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, size: 40, color: Colors.white),
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
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            const Text(
              'Account Settings',
              style: TextStyle(
                color: Color(0xFFADADAD),
                fontSize: 16,
              ),
            ),
            ListTile(
              title: const Text('Edit profile', style: TextStyle(color: Colors.white)),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => const UserProfilePage(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Update vehicle details', style: TextStyle(color: Colors.white)),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => const ViewVehiclePage(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Add a payment method', style: TextStyle(color: Colors.white)),
              trailing: const Icon(Icons.add, color: Colors.white, size: 20),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => const PaymentMethodPage(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Push notifications', style: TextStyle(color: Colors.white)),
              trailing: Switch(
                value: _isSwitched,
                onChanged: (bool value) {
                  setState(() {
                    _isSwitched = value;
                  });
                },
                activeColor: Colors.tealAccent,
              ),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            const Text(
              'More',
              style: TextStyle(
                color: Color(0xFFADADAD),
                fontSize: 16,
              ),
            ),
            ListTile(
              title: const Text('About us', style: TextStyle(color: Colors.white)),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const AboutUsPage(),
                  ),
                );
              },
            ),
            const ListTile(
              title: Text('Privacy policy', style: TextStyle(color: Colors.white)),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
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
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const MainPage(),
                    ),
                  );
                } else if (_selectedIndex == 1) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const PaymentMethodPage(),
                    ),
                  );
                } else if (_selectedIndex == 2) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const ParkingHistoryPage(),
                    ),
                  );
                } else if (_selectedIndex == 3) {
                  // Add navigation if necessary
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF58C6A9),
        shape: const CircleBorder(),
        child: const Icon(
          Icons.near_me,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      drawer: const SideMenu(),
    );
  }
}
