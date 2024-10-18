import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:smart_parking_system/components/common/custom_widgets.dart';
import 'package:smart_parking_system/components/common/toast.dart';
import 'package:smart_parking_system/components/home/main_page.dart';
import 'package:smart_parking_system/components/parking/parking_history.dart';
import 'package:smart_parking_system/components/payment/payment_options.dart';
import 'package:smart_parking_system/components/home/sidebar.dart';
import 'package:smart_parking_system/components/settings/settings.dart';
// import 'notificationfunction.dart';

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


  List<Notification> today = [
    // ReminderNotification('1 hour ago', '12:00 PM', 'Sandton City'),
    // AlertNotification('2 hours ago', 'You have parked longer allocated duration'),
    // BookedNotification('5 hours ago', 'Sandton City', 'A4c'),
    
    // Add more notifications here
  ];

  List<Notification> thisweek = [
    // BookedNotification('3 days ago', 'Sandton City', 'A4c'),
    
    // Add more notifications here
  ];

  List<Notification> older = [
   
    // AlertNotification('2 weeks ago', 'You have parked in a no-parking zone'),
    // Add more notifications here
  ];


class _NotificationPageState extends State<NotificationApp> {
  int _selectedIndex = 0;
  late List<Map<String, dynamic>> notificationData = [];
  bool _isFetching = false;

  @override
  void initState() {
    super.initState();
    fetchUserNotifications();
  }

  @override
  void dispose() {
    today.clear();
    thisweek.clear();
    older.clear();
    notificationData.clear();
    super.dispose();
  }

  Future<void> fetchUserNotifications() async {
    setState(() {
      _isFetching = true;
    });
    try {
      String currentUserId = FirebaseAuth.instance.currentUser!.uid;
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('notifications')
          .where('userId', isEqualTo: currentUserId)
          .get();
      List<Map<String, dynamic>> fetchedNotifications = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return data;
      }).toList();
      if (fetchedNotifications.isEmpty) {
        showToast(message: 'You have had no notifications!');
      }

      final now = DateTime.now();

      for (var element in fetchedNotifications) {
        Timestamp parkingTimestamp = element["parkingTime"];
        String updatedDateString = DateFormat('yyyy-MM-dd - kk:mm').format(parkingTimestamp.toDate());
        // showToast(message: 'Here is the updatedDateString : ${element["parkingSlot"]}');
        
        // Now you can use the `updatedDateString` variable in your notification creation
        if (element["type"] == "Reminder" && element["sent"] == true) {
          var tempNotification = ReminderNotification(
            "Parking begins in 2 hours!",
            updatedDateString,
            element["address"],
          );
          setState(() {
            Duration difference = now.difference(parkingTimestamp.toDate());
            if (difference.inDays < 1) {
              today.add(tempNotification);
            } else if (difference.inDays < 7) {
              thisweek.add(tempNotification);
            } else {
              older.add(tempNotification);
            }
          });
        } else if (element["type"] == "Booking") {
          
          var tempNotification = BookedNotification(
            updatedDateString,
            element["address"],
            element["parkingSlot"],
          );
          setState(() {
            Duration difference = now.difference(parkingTimestamp.toDate());
            if (difference.inDays < 1) {
              today.add(tempNotification);
            } else if (difference.inDays < 7) {
              thisweek.add(tempNotification);
            } else {
              older.add(tempNotification);
            }
          });
        } else if (element["type"] == "Alert") {
          var tempNotification = AlertNotification(
            updatedDateString,
            element["description"],
          );
          setState(() {
            Duration difference = now.difference(parkingTimestamp.toDate());
            if (difference.inDays < 1) {
              today.add(tempNotification);
            } else if (difference.inDays < 7) {
              thisweek.add(tempNotification);
            } else {
              older.add(tempNotification);
            }
          });
        }
      }

      setState(() {
        notificationData = fetchedNotifications;
        _isFetching = false;
      });
    } catch (e) {
      setState(() {
        _isFetching = false;
      });
    }
  }

  Future<void> clearAllNotifications() async {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    if (currentUserId.isEmpty) return;

    try {
      WriteBatch batch = FirebaseFirestore.instance.batch();

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('notifications')
          .where('userId', isEqualTo: currentUserId)
          .get();

      for (var doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();

      setState(() {
        notificationData.clear();
        today.clear();
        thisweek.clear();
        older.clear();
      });
      
      showToast(message: 'All notifications cleared successfully');
    } catch (e) {
      showToast(message: 'Failed to clear notifications : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D2F41),
      body: _isFetching ? loadingWidget()
      : SingleChildScrollView(
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
                  Align(
                    alignment: Alignment.topRight,
                    child: ElevatedButton(
                      onPressed: clearAllNotifications,
                      style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 58, 58, 58)),
                      ),
                      child: const Text(
                        "Clear all",
                        style: TextStyle(
                          color: Colors.white
                        ),
                      )
                    )
                  )
                ],
              ),
            ),
            // IconButton(
            //           icon: const Icon(Icons.delete_sweep),
            //           color: Colors.red,
            //           onPressed: clearAllNotifications,
            //           tooltip: 'Clear All Notifications',
            //         ),
            Center(
              child: SizedBox(
                width: 500,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionTitle(title: 'Today'),
                    for (var notification in today)
                    _buildNotification(notification),
                    if(today.isEmpty)
                          const Text('       -', style: TextStyle(color: Colors.white, fontSize: 25),),
                    const SizedBox(height: 10),
                    const SectionTitle(title: 'This Week'),
                    for (var notification in thisweek)
                    _buildNotification(notification),
                    if(thisweek.isEmpty)
                          const Text('       -', style: TextStyle(color: Colors.white, fontSize: 25),),
                    const SizedBox(height: 10),
                    const SectionTitle(title: 'Older'),
                    for (var notification in older)
                    _buildNotification(notification),
                    if(older.isEmpty)
                          const Text('       -', style: TextStyle(color: Colors.white, fontSize: 25),),
                    
                    
                  ],
                ),
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
                  ' • ${notification.location}\n • ${notification.parkingslot}',
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
