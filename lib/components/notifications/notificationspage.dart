import 'package:flutter/material.dart';

import 'package:smart_parking_system/components/main_page.dart';
import 'package:smart_parking_system/components/parking/parking_history.dart';
import 'package:smart_parking_system/components/payment/payment_options.dart';
import 'package:smart_parking_system/components/sidebar.dart';

class NotificationApp extends StatefulWidget {
  const NotificationApp({super.key});

  @override
  State<NotificationApp> createState() => _NotificationPageState();
}

class BookedNotification {
  final String time;
  final String title = 'Successfully Booked';
  final String location;
  final String parkingslot;
  final IconData icon = Icons.check_circle;
  final Color iconColor = Colors.tealAccent;

  BookedNotification(this.time, this.location, this.parkingslot);
}

class AlertNotification {
  final String time;
  final String title = 'Parking Violation';
  final String description;
  final IconData icon = Icons.warning;
  final Color iconColor = Colors.yellow;

  AlertNotification(this.time, this.description);
}



class _NotificationPageState extends State<NotificationApp> {
  int _selectedIndex = 0;

  List<BookedNotification> bookednotifications = [
   BookedNotification('4 hours ago', 'Sandton City', 'A3C'),
    // Add more sessions here
  ];

  List<AlertNotification> alertnotifications = [
   AlertNotification('2 Weeks ago', 'You violated parking regulations'),
    // Add more sessions here
  ];

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D2F41),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 15),
              color: const Color(0xFF2D2F41),
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
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      appBarTitle,
                      style: const TextStyle(
                        color: Colors.tealAccent,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
                padding: const EdgeInsets.all(20),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionTitle(title: 'Today'),
                    
                    SizedBox(height: 10),
                    SectionTitle(title: 'This Week'),
                    
                    SizedBox(height: 10),
                    SectionTitle(title: 'Older'),
                    
                  ],
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: const Color(0xFF35344A),
        ),
        child: Container(
          decoration: BoxDecoration(
            // color: const Color(0xFF2C2C54),
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
            backgroundColor: const Color(0xFF35344A), // To ensure the Container color is visible
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
                  // 设置页的操作可以放在这里
                }
              });
            },
            selectedItemColor: Colors.grey,
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

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}


// ignore: unused_element
Widget _buildBookNotification(BookedNotification bNotification) {
  return Card(
    color: const Color(0xFF3A3E5B),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          Icon(
            bNotification.icon,
            color: bNotification.iconColor,
            size: 30,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                bNotification.time,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                bNotification.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '${bNotification.location}, Slot ${bNotification.parkingslot}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  //fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

// ignore: unused_element
Widget _buildAlertNotification(AlertNotification aNotification) {
  return Card(
    color: const Color(0xFF3A3E5B),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          Icon(
            aNotification.icon,
            color: aNotification.iconColor,
            size: 30,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                aNotification.time,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                aNotification.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                aNotification.description,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  //fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
