import 'package:flutter/material.dart';
import 'package:smart_parking_system/components/main_page.dart';
import 'package:smart_parking_system/components/payment/payment_options.dart';
import 'package:smart_parking_system/components/settings/settings.dart';
import 'package:smart_parking_system/components/sidebar.dart';
//Firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_parking_system/components/common/toast.dart';

class ParkingHistoryPage extends StatefulWidget {
  const ParkingHistoryPage({super.key});

  @override
  State<ParkingHistoryPage> createState() => _ParkingHistoryPageState();
}

class ActiveSession {
  final String rate;
  final String address;
  final String parkingslot;
  final String remainingtime;

  ActiveSession(this.rate, this.address, this.parkingslot, this.remainingtime);
}

class ReservedSpot {
  final String date;
  final String time;
  final String amount;
  final String address;
  final String parkingslot;

  ReservedSpot(this.date, this.time, this.amount, this.address, this.parkingslot);
}

class CompletedSession {
  final String date;
  final String time;
  final String amount;
  final String address;
  final String parkingslot;

  CompletedSession(this.date, this.time, this.amount, this.address, this.parkingslot);
}



class _ParkingHistoryPageState extends State<ParkingHistoryPage> {
  // Variables
  String bookedLocation = '';
  String bookedZone = '';
  String bookedLevel = '';
  String bookedRow = '';
  String bookedDate = '';
  String bookedTime = '';
  double bookedPrice = 0;
  double bookedDuration = 0;
  int totalPrice = 0;

  // Get details on load
  Future<void> getDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    String? userName = user?.displayName;
    String? userId = user?.uid;

    try {
      // Get a reference to the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Query the 'bookings' collection for a document with matching userId
      QuerySnapshot querySnapshot = await firestore
          .collection('bookings')
          .where('userId', isEqualTo: userId)
          .get();
      // Check if a matching document was found
      if (querySnapshot.docs.isNotEmpty) {
        // // Loop through each document
        for (var document in querySnapshot.docs) {
          // Retrieve the fields
          String bookedLocation = document.get('address') as String;
          String bookedZone = document.get('zone') as String;
          String bookedLevel = document.get('level') as String;
          String bookedRow = document.get('row') as String;
          String bookedDate = document.get('date') as String;
          String bookedTime = document.get('time') as String;
          double bookedPrice = document.get('price') as double;
          double bookedDuration = document.get('duration') as double;

          // Calculate total price
          int totalPrice = (bookedPrice * bookedDuration).toInt();

          // Add to reservedspots list
          reservedspots.add(ReservedSpot(
            bookedDate,
            bookedTime,
            'R $totalPrice',
            bookedLocation,
            'Zone:$bookedZone Level:$bookedLevel Row:$bookedRow',
          ));
        }

        reservedspots.sort((a, b) {
          int dateComparison = a.date.compareTo(b.date);
          if (dateComparison != 0) {
            return dateComparison;
          } else {
            return a.time.compareTo(b.time);
          }
        });
      } else {
        // No matching document found
        showToast(message: 'No bookings found for user: $userName');
      }
    } catch (e) {
      // Handle any errors
      showToast(message: 'Error retrieving booking details: $e');
    }


    try {
      // Get a reference to the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      
      // Query the 'past_bookings' collection for a document with matching userId
      QuerySnapshot querySnapshot = await firestore
          .collection('past_bookings')
          .where('userId', isEqualTo: userId)
          .get();
      // Check if a matching document was found
      if (querySnapshot.docs.isNotEmpty) {
        // // Loop through each document
        for (var document in querySnapshot.docs) {
          // Retrieve the fields
          String bookedLocation = document.get('address') as String;
          String bookedZone = document.get('zone') as String;
          String bookedLevel = document.get('level') as String;
          String bookedRow = document.get('row') as String;
          String bookedDate = document.get('date') as String;
          String bookedTime = document.get('time') as String;
          int bookedPrice = document.get('price') as int;
          int bookedDuration = document.get('duration') as int;

          // Calculate total price
          int totalPrice = (bookedPrice * bookedDuration).toInt();

          // Add to reservedspots list
          completedsessions.add(CompletedSession(
            bookedDate,
            bookedTime,
            'R $totalPrice',
            bookedLocation,
            'Zone:$bookedZone Level:$bookedLevel Row:$bookedRow',
          ));
        }

        completedsessions.sort((a, b) {
          int dateComparison = a.date.compareTo(b.date);
          if (dateComparison != 0) {
            return dateComparison;
          } else {
            return a.time.compareTo(b.time);
          }
        });
      } else {
        // No matching document found
        showToast(message: 'No bookings found for user: $userName');
      }
    } catch (e) {
      // Handle any errors
      showToast(message: 'Error retrieving past booking details: $e');
    }

    setState((){}); // This will trigger a rebuild with the new values
  }

  int _selectedIndex = 2;

  List<ActiveSession> activesessions = [
    // Add more sessions here
  ];

  List<ReservedSpot> reservedspots = [
    // Add more sessions here
  ];

  List<CompletedSession> completedsessions = [
    // Add more sessions here
  ];

  @override
  void initState() {
    super.initState();
    getDetails();
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
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
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
                      'Parking History',
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
            const Text(
              'Active Session',
              style: TextStyle(
                color: Colors.tealAccent,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: activesessions.expand((activesession) => [
                _buildActiveSessionItem(activesession),
                const SizedBox(height: 10),
              ]).toList(),
            ),
            const SizedBox(height: 20),
            // Reserved Spots
             const Text(
                'Reserved Spots',
                style: TextStyle(
                  color: Colors.tealAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: reservedspots.expand((reservedspot) => [
                _buildReservedSpotItem(reservedspot),
                const SizedBox(height: 10),
              ]).toList(),
            ),
            const SizedBox(height: 20),
            // Completed Sessions
            const Text(
              'Completed Sessions',
              style: TextStyle(
                color: Colors.tealAccent,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),          
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: completedsessions.expand((completedsession) => [
                _buildSessionItem(completedsession),
                const SizedBox(height: 10),
              ]).toList(),
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
                  // Do nothing, already on this page
                } else if (_selectedIndex == 3) {
                  // Handle settings navigation
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

    Widget _buildSessionItem(CompletedSession completedsession) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF35344A),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.check_circle, color: Colors.tealAccent, size: 30),
              const SizedBox(width: 10),
              Text(
                '${completedsession.address} Car Park A\nSpace ${completedsession.parkingslot}',
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.right, 
              ),
            ],
          ),
          const SizedBox(height: 5),
          const Divider(
            color: Color.fromARGB(255, 199, 199, 199), // Color of the lines
            thickness: 1, // Thickness of the lines
          ),
          const SizedBox(height: 5), 
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                completedsession.date,
                style: const TextStyle(color: Colors.grey),
              ),
              Text(
                completedsession.time,
                style: const TextStyle(color: Colors.grey),
              ),
              Text(
                completedsession.amount,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReservedSpotItem(ReservedSpot reservedspot) {
    return Container(
      padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF35344A),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 30),
              const SizedBox(width: 10),
              Text(
                '${reservedspot.address}\n${reservedspot.parkingslot}',
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.right, 
              ),
            ],
          ),
          const SizedBox(height: 5),
          const Divider(
            color: Color.fromARGB(255, 199, 199, 199), // Color of the lines
            thickness: 1, // Thickness of the lines
          ),
          const SizedBox(height: 5), 
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                    reservedspot.date,
                    style: const TextStyle(color: Colors.grey),
                  ),
              Text(
                reservedspot.time,
                style: const TextStyle(color: Colors.grey),
              ),
              Text(
                reservedspot.amount,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _buildActiveSessionItem(ActiveSession activeSession) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFF35344A),
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.white.withOpacity(0.2),
          spreadRadius: 1,
          blurRadius: 8,
          offset: const Offset(0, 3), // changes position of shadow
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF58C6A9),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'R20/Hr',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Sandton City Car Park A\nSpace 4c',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.right,  
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Divider(
          color: Color.fromARGB(255, 199, 199, 199), // Color of the lines
          thickness: 1, // Thickness of the lines
        ),
        const SizedBox(height: 10),      
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Time Remaining',
              style: TextStyle(color: Colors.grey),
            ),
            Text(
              '01hr : 30min',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    ),
  
  );
}

class CustomCenterDockedFABLocation extends FloatingActionButtonLocation {
  final double offset;

  CustomCenterDockedFABLocation(this.offset);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    // Position the FAB slightly higher than centerDocked
    final double fabX = (scaffoldGeometry.scaffoldSize.width / 2) -
        (scaffoldGeometry.floatingActionButtonSize.width / 2);
    final double fabY = scaffoldGeometry.scaffoldSize.height -
        scaffoldGeometry.bottomSheetSize.height -
        scaffoldGeometry.snackBarSize.height -
        (scaffoldGeometry.floatingActionButtonSize.height / 2) - 
        offset;
    return Offset(fabX, fabY);
  }
}
