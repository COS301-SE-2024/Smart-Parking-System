import 'package:flutter/material.dart';
import 'package:smart_parking_system/components/home/main_page.dart';
import 'package:smart_parking_system/components/payment/payment_options.dart';
import 'package:smart_parking_system/components/settings/settings.dart';
import 'package:smart_parking_system/components/home/sidebar.dart';
//Firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_parking_system/components/common/toast.dart';
import 'dart:async';

class ParkingHistoryPage extends StatefulWidget {
  const ParkingHistoryPage({super.key});

  @override
  State<ParkingHistoryPage> createState() => _ParkingHistoryPageState();
}

class ActiveSession {
  final String documentId;
  final String rate;
  final String address;
  final String parkingslot;
  String remainingtime;
  final DateTime endTime;

  ActiveSession(this.documentId, this.rate, this.address, this.parkingslot, this.remainingtime, this.endTime);
}

class ReservedSpot {
  final String documentId;
  final String date;
  final String time;
  final String amount;
  final String address;
  final String parkingslot;

  ReservedSpot(this.documentId, this.date, this.time, this.amount, this.address, this.parkingslot);
}

class CompletedSession {
  final String documentId;
  final String date;
  final String time;
  final String amount;
  final String address;
  final String parkingslot;

  CompletedSession(this.documentId, this.date, this.time, this.amount, this.address, this.parkingslot);
}

class _ParkingHistoryPageState extends State<ParkingHistoryPage> {
  // Variables
  List<ActiveSession> activesessions = [];
  List<ReservedSpot> reservedspots = [];
  List<CompletedSession> completedsessions = [];

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    getDetails().then((_) {
      _startTimer();
    });
  }
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
  void _startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      setState(() {
        List<ActiveSession> finishedSessions = [];
        for (var session in activesessions) {
          Duration remaining = session.endTime.difference(DateTime.now());
          if (remaining.isNegative) {
            finishedSessions.add(session);
          } else {
            if (remaining.inHours < 1 && remaining.inMinutes % 60 < 1) {
              session.remainingtime = 'less than 1 minute';
            } else {
              session.remainingtime = '${remaining.inHours}h ${remaining.inMinutes % 60}m';
            }
          }
        }
        if (finishedSessions.isNotEmpty) {
          _moveFinishedSessionsToCompleted(finishedSessions);
        }

        // Check and update reserved spots
        _checkAndUpdateReservedSpots();
      });
    });
  }
  void _moveFinishedSessionsToCompleted(List<ActiveSession> finishedSessions) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    for (var session in finishedSessions) {
      try {
        // Find the corresponding booking document
        DocumentSnapshot bookingDoc = await firestore.collection('bookings').doc(session.documentId).get();

        if (bookingDoc.exists) {
          var bookingData = bookingDoc.data() as Map<String, dynamic>;

          // Move the booking to past_bookings collection
          await firestore.collection('past_bookings').add(bookingData);

          // Delete the booking from bookings collection
          await bookingDoc.reference.delete();

          // Add to completedsessions list
          completedsessions.add(CompletedSession(
            session.documentId,
            bookingData['date'],
            bookingData['time'],
            'R ${(bookingData['price'] * bookingData['duration']).toInt()}',
            session.address,
            session.parkingslot,
          ));

          // Remove from activesessions list
          activesessions.remove(session);
        }
      } catch (e) {
        showToast(message: 'Error moving finished session: $e');
      }
    }

    // Sort completedsessions list
    completedsessions.sort((b, a) {
      int dateComparison = a.date.compareTo(b.date);
      if (dateComparison != 0) {
        return dateComparison;
      } else {
        return a.time.compareTo(b.time);
      }
    });

    // Trigger a rebuild
    setState(() {});
  }
  void _checkAndUpdateReservedSpots() {
    DateTime now = DateTime.now();
    List<ReservedSpot> spotsToActivate = [];

    for (var spot in reservedspots) {
      DateTime spotDateTime = DateTime.parse('${spot.date} ${spot.time}');
      if (now.isAfter(spotDateTime) || now.isAtSameMomentAs(spotDateTime)) {
        spotsToActivate.add(spot);
      }
    }

    if (spotsToActivate.isNotEmpty) {
      setState(() {
        for (var spot in spotsToActivate) {
          // Calculate end time (assuming duration is stored somewhere, let's say it's 2 hours for this example)
          DateTime endTime = DateTime.parse('${spot.date} ${spot.time}').add(const Duration(hours: 2));
          
          // Add to active sessions
          activesessions.add(ActiveSession(
            spot.documentId,
            spot.amount,
            spot.address,
            spot.parkingslot,
            '2h 0m', // Initial remaining time
            endTime,
          ));

          // Remove from reserved spots
          reservedspots.remove(spot);
        }

        // Sort active sessions
        activesessions.sort((a, b) => a.endTime.compareTo(b.endTime));
      });
    }
  }

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
        // Loop through each document
        for (var document in querySnapshot.docs) {
          // Retrieve the fields
          String documentId = document.id;
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

          // Parse booking date and time
          DateTime bookingDateTime = DateTime.parse('$bookedDate $bookedTime');
          DateTime bookingEndDateTime = bookingDateTime.add(Duration(hours: bookedDuration.toInt()));
          DateTime currentDateTime = DateTime.now();

          // Check booking status
          if (currentDateTime.isAfter(bookingEndDateTime)) {
            // Booking is in the past, add to 'past_bookings' and remove from 'bookings'
            await firestore.collection('past_bookings').add(document.data() as Map<String, dynamic>);
            await document.reference.delete();
          } else if (currentDateTime.isAfter(bookingDateTime) && currentDateTime.isBefore(bookingEndDateTime)) {
            // Booking is currently in progress, add to 'activesessions'
            Duration remainingDuration = bookingEndDateTime.difference(currentDateTime);
            activesessions.add(ActiveSession(
              documentId,
              'R ${bookedPrice.toInt()}',
              bookedLocation,
              'Zone:$bookedZone Level:$bookedLevel Row:$bookedRow',
              '${remainingDuration.inHours}h ${remainingDuration.inMinutes % 60}m',
              bookingEndDateTime,
            ));
          } else {
            // Booking is in the future, add to 'reservedspots'
            reservedspots.add(ReservedSpot(
              documentId,
              bookedDate,
              bookedTime,
              'R $totalPrice',
              bookedLocation,
              'Zone:$bookedZone Level:$bookedLevel Row:$bookedRow',
            ));
          }
        }

        activesessions.sort((a, b) {
          return a.remainingtime.compareTo(b.remainingtime);
        });
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
        // Loop through each document
        for (var document in querySnapshot.docs) {
          // Retrieve the fields
          String documentId = document.id;
          String bookedLocation = document.get('address') as String;
          String bookedZone = document.get('zone') as String;
          String bookedLevel = document.get('level') as String;
          String bookedRow = document.get('row') as String;
          String bookedDate = document.get('date') as String;
          String bookedTime = document.get('time') as String;
          // Calculate total price
          int totalPrice;
          try{
            int bookedPrice = document.get('price') as int;
            int bookedDuration = document.get('duration') as int;
            // Calculate total price
            totalPrice = (bookedPrice * bookedDuration).toInt();
          } catch (e) {
            try {
              int bookedPrice = document.get('price') as int;
              double bookedDuration = document.get('duration') as double;
              // Calculate total price
              totalPrice = (bookedPrice * bookedDuration).toInt();
            } catch (e) {
              try {
                double bookedPrice = document.get('price') as double;
                int bookedDuration = document.get('duration') as int;
                // Calculate total price
                totalPrice = (bookedPrice * bookedDuration).toInt();
              } catch (e) {
                double bookedPrice = document.get('price') as double;
                double bookedDuration = document.get('duration') as double;
                // Calculate total price
                totalPrice = (bookedPrice * bookedDuration).toInt();
              }
            }
          }

          // Add to completedsessions list
          completedsessions.add(CompletedSession(
            documentId,
            bookedDate,
            bookedTime,
            'R $totalPrice',
            bookedLocation,
            'Zone:$bookedZone Level:$bookedLevel Row:$bookedRow',
          ));
           // showToast(message: 'HERE1');
        }
            // showToast(message: 'HERE1');

        completedsessions.sort((b, a) {
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

    setState(() {}); // This will trigger a rebuild with the new values
  }

  void _showDeleteConfirmation(BuildContext context, ReservedSpot reservedspot) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Cancel Booking"),
          content: const Text("Are you sure you want to cancel this booking?"),
          actions: <Widget>[
            TextButton(
              child: const Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Yes"),
              onPressed: () {
                _deleteBooking(reservedspot);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  void _deleteBooking(ReservedSpot reservedspot) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      
      // Query the 'bookings' collection to find the document to delete
      await firestore.collection('bookings').doc(reservedspot.documentId).delete();

      // Remove the booking from the local list
      setState(() {
        reservedspots.removeWhere((spot) => spot.documentId == reservedspot.documentId);
      });

      showToast(message: 'Booking cancelled successfully');
    } catch (e) {
      showToast(message: 'Error cancelling booking: $e');
    }
  }

  void _showEndConfirmation(BuildContext context, ActiveSession activesession) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("End Sesssion Early"),
          content: const Text("Are you sure you want to end this session early?"),
          actions: <Widget>[
            TextButton(
              child: const Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Yes"),
              onPressed: () {
                _endSession(activesession);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  void _endSession(ActiveSession activesession) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      
      // Get the current booking document
      DocumentSnapshot bookingDoc = await firestore.collection('bookings').doc(activesession.documentId).get();
      
      if (bookingDoc.exists) {
        Map<String, dynamic> bookingData = bookingDoc.data() as Map<String, dynamic>;
        
        // Calculate the actual duration
        DateTime startTime = DateTime.parse('${bookingData['date']} ${bookingData['time']}');
        DateTime endTime = DateTime.now();
        double actualDurationHours = endTime.difference(startTime).inHours + ((endTime.difference(startTime).inMinutes % 60) / 60);
        
        double oldDuration = bookingData['duration'];
        // Update the duration and calculate the final price
        bookingData['duration'] = actualDurationHours;
        double price = bookingData['price'] as double;
        int finalPrice = (price * actualDurationHours).toInt();

        _refund(price, oldDuration, finalPrice);
        
        // Add the booking to past_bookings
        await firestore.collection('past_bookings').add(bookingData);
        
        // Delete the booking from bookings
        await firestore.collection('bookings').doc(activesession.documentId).delete();

        // Update local lists
        setState(() {
          activesessions.removeWhere((session) => session.documentId == activesession.documentId);
          completedsessions.add(CompletedSession(
            activesession.documentId,
            bookingData['date'],
            bookingData['time'],
            'R $finalPrice',
            activesession.address,
            activesession.parkingslot,
          ));
          
          // Sort completedsessions
          completedsessions.sort((b, a) {
            int dateComparison = a.date.compareTo(b.date);
            return dateComparison != 0 ? dateComparison : a.time.compareTo(b.time);
          });
        });

        showToast(message: 'Session ended successfully');
      } else {
        showToast(message: 'Booking not found');
      }
    } catch (e) {
      showToast(message: 'Error ending session: $e');
    }
  }
  
  void _refund(double price, double oldDuration, int finalPrice) {                                                //Add code for refund here
    double refundAmount = (price * oldDuration) - finalPrice;
    showToast(message: "Refund : $refundAmount");

    //Refund Amount as credit here
  }

  int _selectedIndex = 2;

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
                _buildReservedSessionItem(reservedspot),
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
                _buildCompletedSessionItem(completedsession),
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

  Widget _buildCompletedSessionItem(CompletedSession completedsession) {
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
                '${completedsession.address}\nSpace ${completedsession.parkingslot}',
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

  Widget _buildReservedSessionItem(ReservedSpot reservedspot) {
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
              const Icon(Icons.star, color: Colors.tealAccent, size: 30),
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
                '${reservedspot.date} @ ${reservedspot.time}',
                style: const TextStyle(color: Colors.grey),
              ),
              Text(
                reservedspot.amount,
                style: const TextStyle(color: Colors.white),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _showDeleteConfirmation(context, reservedspot),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActiveSessionItem(ActiveSession activesession) {
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
                child: Text(
                  '${activesession.rate}/Hr',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '${activesession.address}\n${activesession.parkingslot}',
                style: const TextStyle(color: Colors.white),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Time Remaining : ',
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  activesession.remainingtime,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ]
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _showEndConfirmation(context, activesession),
              ),
            ],
          ),
        ],
      ),
    
    );
  }
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
