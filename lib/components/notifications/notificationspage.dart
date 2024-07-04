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

class _NotificationPageState extends State<NotificationApp> {
  int _selectedIndex = 0;


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
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Notifications',
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
            Container(
                padding: const EdgeInsets.all(20),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionTitle(title: 'Today'),
                    NotificationCard(
                      time: '9:01am',
                      title: 'Booked Successful',
                      subtitle: 'View Details',
                      icon: Icons.check_circle,
                      iconColor: Colors.tealAccent,
                    ),
                    SizedBox(height: 10),
                    SectionTitle(title: 'Yesterday'),
                    NotificationCard(
                      time: '9:01am',
                      title: 'Booked Successful',
                      subtitle: 'View Invoice',
                      icon: Icons.check_circle,
                      iconColor: Colors.tealAccent,
                    ),
                    SizedBox(height: 10),
                    SectionTitle(title: 'This week'),
                    NotificationCard(
                      time: '9:01am',
                      title: 'Alert',
                      subtitle: 'You have booked a Space at 9:10 am',
                      icon: Icons.warning,
                      iconColor: Colors.yellow,
                    ),
                    NotificationCard(
                      time: '9:01am',
                      title: 'Alert',
                      subtitle: 'You have booked a Space at 9:10 am',
                      icon: Icons.warning,
                      iconColor: Colors.yellow,
                    ),
                    NotificationCard(
                      time: '9:01am',
                      title: 'Alert',
                      subtitle: 'You have booked a Space at 9:10 am',
                      icon: Icons.warning,
                      iconColor: Colors.yellow,
                    ),
                    NotificationCard(
                      time: '9:01am',
                      title: 'Alert',
                      subtitle: 'You have booked a Space at 9:10 am',
                      icon: Icons.warning,
                      iconColor: Colors.yellow,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: const Color(0xFF35344A),),
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

              if(_selectedIndex == 0){
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const MainPage(),
                  ),
                );
              } else if(_selectedIndex == 1){
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const PaymentMethodPage(),
                  ),
                );
              } else if(_selectedIndex == 2){
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const ParkingHistoryPage(),
                  ),
                );
              } else if(_selectedIndex == 3){
              
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   backgroundColor: const Color(0xFF58C6A9),
      //   shape: const CircleBorder(),
      //   child: const Icon(
      //     Icons.near_me,
      //     color: Colors.white,
      //   ), 
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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

class NotificationCard extends StatelessWidget {
  final String time;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;

  const NotificationCard({
    super.key,
    required this.time,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
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
              icon,
              color: iconColor,
              size: 30,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  time,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.tealAccent,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
