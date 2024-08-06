import 'package:flutter/material.dart';

import 'package:smart_parking_system/components/main_page.dart';
import 'package:smart_parking_system/components/parking/parking_history.dart';
import 'package:smart_parking_system/components/payment/payment_options.dart';
import 'package:smart_parking_system/components/sidebar.dart';
import 'notificationfunction.dart';

class NotificationApp extends StatefulWidget {
  const NotificationApp({super.key});

  @override
  State<NotificationApp> createState() => _NotificationPageState();
}

abstract class Notification {
  final String time;
  final String title;
  final IconData icon;
  final Color iconColor;

  Notification(this.time, this.title, this.icon, this.iconColor);
}

class BookedNotification extends Notification {
  final String location;
  final String parkingslot;

  BookedNotification(String time, this.location, this.parkingslot)
      : super(time, 'Successfully Booked', Icons.check_circle, Colors.tealAccent);
}

class AlertNotification extends Notification {
  final String description;

  AlertNotification(String time, this.description)
      : super(time, 'Parking Violation', Icons.warning, Colors.yellow);
}

class ReminderNotification extends Notification {
  final String bookingTime;
  final String location;

  ReminderNotification(String time, this.bookingTime, this.location)
      : super(time, 'Upcoming Parking Session', Icons.notification_important, Colors.green);
}



class _NotificationPageState extends State<NotificationApp> {
  int _selectedIndex = 0;

  List<Notification> today = [
    ReminderNotification('1 hour ago', '12:00 PM', 'Sandton City'),
    AlertNotification('2 hours ago', 'You have parked longer allocated duration'),
    BookedNotification('5 hours ago', 'Sandton City', 'A4c'),
    
    // Add more notifications here
  ];

  List<Notification> thisweek = [
    BookedNotification('3 days ago', 'Sandton City', 'A4c'),
    
    // Add more notifications here
  ];

  List<Notification> older = [
   
    AlertNotification('2 weeks ago', 'You have parked in a no-parking zone'),
    // Add more notifications here
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitle(title: 'Today'),
                for (var notification in today)
                _buildNotification(notification),
                const SizedBox(height: 10),
                const SectionTitle(title: 'This Week'),
                for (var notification in thisweek)
                _buildNotification(notification),
                const SizedBox(height: 10),
                const SectionTitle(title: 'Older'),
                for (var notification in older)
                _buildNotification(notification),
                
              ],
            ),
            ElevatedButton(
              onPressed: (){
                DateTime now = DateTime.now();
  
                // Create a DateTime for today at 17:00
                DateTime bookingTime = DateTime(now.year, now.month, now.day, 15, 0);
                
                // Call the bookSlot function
                bookSlot(bookingTime);
              },
              child: Text("Book time slot"),
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

Widget _buildNotification(Notification notification) {
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
            notification.icon,
            color: notification.iconColor,
            size: 30,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notification.time,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                notification.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              if (notification is BookedNotification)
                Text(
                  '${notification.location}, Parking Slot ${notification.parkingslot}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              if (notification is AlertNotification)
                Text(
                  notification.description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              if (notification is ReminderNotification)
                Text(
                  '${notification.location}, @${notification.bookingTime}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),  
            ],
          ),
        ],
      ),
    ),
  );
}
