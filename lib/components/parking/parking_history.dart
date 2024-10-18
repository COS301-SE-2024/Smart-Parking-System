import 'package:flutter/material.dart';
import 'package:smart_parking_system/components/common/common_functions.dart';
import 'package:smart_parking_system/components/common/custom_widgets.dart';
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
  final String price;
  final String duration;
  final String discount;
  final String address;
  final String zone;
  final String level;
  final String row;
  String remainingtime;
  final DateTime endTime;

  ActiveSession(
    this.documentId,
    this.price,
    this.duration,
    this.discount,
    this.address,
    this.zone,
    this.level,
    this.row,
    this.remainingtime,
    this.endTime
  );
}

class ReservedSpot {
  final String documentId;
  final String date;
  final String time;
  final String price;
  final String duration;
  final String discount;
  final String address;
  final String zone;
  final String level;
  final String row;

  ReservedSpot(
    this.documentId,
    this.date,
    this.time,
    this.price,
    this.duration,
    this.discount,
    this.address,
    this.zone,
    this.level,
    this.row,
  );
}

class CompletedSession {
  final String documentId;
  final String date;
  final String time;
  final String price;
  final String duration;
  final String discount;
  final String address;
  final String zone;
  final String level;
  final String row;

  CompletedSession(
    this.documentId,
    this.date,
    this.time,
    this.price,
    this.duration,
    this.discount,
    this.address,
    this.zone,
    this.level,
    this.row,
  );
}

class _ParkingHistoryPageState extends State<ParkingHistoryPage> {
  // Variables
  List<ActiveSession> activesessions = [];
  List<ReservedSpot> reservedspots = [];
  List<CompletedSession> completedsessions = [];
  User? user = FirebaseAuth.instance.currentUser;
  bool _isFetching = true;

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
    setState(() {
      _isFetching = true;
    });
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
    setState(() {
      _isFetching = false;
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
            'R ${int.parse(bookingData['price'] - bookingData['discount'])}',
            session.duration,
            session.discount,
            session.address,
            session.zone,
            session.level,
            session.row,
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
            spot.price,
            spot.duration,
            spot.discount,
            spot.address,
            spot.zone,
            spot.level,
            spot.row,
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
  Future<void> _updateSlotAvailability(String bookedAddress, String selectedZone, String selectedLevel, String selectedRow) async {
    try {
      // Get a reference to the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Query the 'parkings' collection for a document with matching name
      QuerySnapshot parkingQuerySnapshot = await firestore
          .collection('parkings')
          .where('name', isEqualTo: bookedAddress)
          .limit(1)
          .get();

      if (parkingQuerySnapshot.docs.isNotEmpty) {  // Check if there are any documents
        var parkingDocument = parkingQuerySnapshot.docs.first;
        String updatedSlot = updateSlot(parkingDocument.get('slots_available') as String);
        parkingDocument.reference.update({'slots_available': updatedSlot});
      } else {
        // No parking found
        showToast(message: 'No parking found for update: $bookedAddress');
      }


      if (parkingQuerySnapshot.docs.isNotEmpty) {  // Check if a matching document was found
        DocumentSnapshot parkingDocumentSnapshot = parkingQuerySnapshot.docs[0];  // Get the document snapshot

        CollectionReference zonesCollection = parkingDocumentSnapshot.reference.collection('zones');  // Get the subcollection 'zones'
        DocumentSnapshot zoneDocumentSnapshot = await zonesCollection.doc(selectedZone).get();  // Query the 'zones' subcollection for a document with matching id

        QuerySnapshot zonesQuerySnapshot = await zonesCollection.get();  // Query the 'rows' subcollection for all documents
        if (zonesQuerySnapshot.docs.isNotEmpty) {  // Check if there are any documents
          for (var zoneDocument in zonesQuerySnapshot.docs) {  // Loop through each document
            // Update the fields
            String updatedSlot = updateSlot(zoneDocument.get('slots') as String);
            if( zoneDocument.id == selectedZone){
              zoneDocument.reference.update({'slots': updatedSlot});
            }
          }
        } else {
          // No zones found
          showToast(message: 'No zone found for update: $selectedZone');
        }
      
        if (zoneDocumentSnapshot.exists) {  // Check if a matching document was found
          CollectionReference levelsCollection = zoneDocumentSnapshot.reference.collection('levels');  // Get the subcollection 'levels'
          DocumentSnapshot levelDocumentSnapshot = await levelsCollection.doc(selectedLevel).get();  // Query the 'levels' subcollection for a document with matching id

          QuerySnapshot levelsQuerySnapshot = await levelsCollection.get();  // Query the 'rows' subcollection for all documents
          if (levelsQuerySnapshot.docs.isNotEmpty) {  // Check if there are any documents
            for (var levelDocument in levelsQuerySnapshot.docs) {  // Loop through each document
              // Update the fields
              String updatedSlot = updateSlot(levelDocument.get('slots') as String);
              if( levelDocument.id == selectedLevel){
                levelDocument.reference.update({'slots': updatedSlot});
              }
            }
          } else {
            // No levels found
            showToast(message: 'No level found for update: $selectedLevel');
          }
        
          if (levelDocumentSnapshot.exists) {  // Check if a matching document was found

            CollectionReference rowsCollection = levelDocumentSnapshot.reference.collection('rows');  // Get the subcollection 'rows'
            QuerySnapshot rowsQuerySnapshot = await rowsCollection.get();  // Query the 'rows' subcollection for all documents
            if (rowsQuerySnapshot.docs.isNotEmpty) {  // Check if there are any documents
              for (var rowDocument in rowsQuerySnapshot.docs) {  // Loop through each document
                // Update the fields
                String updatedSlot = updateSlot(rowDocument.get('slots') as String);
                if( rowDocument.id == selectedRow){
                  rowDocument.reference.update({'slots': updatedSlot});
                }
              }
            } else {
              // No rows found
              showToast(message: 'No row found for update: $selectedRow');
            }
          } else {
            // No level found
            showToast(message: 'No level found: $selectedLevel');
          }
        } else {
          // No zone found
          showToast(message: 'No zone found: $selectedZone');
        }
      } else {
        // No parking found
        showToast(message: 'No parking found: $bookedAddress');
      }
    } catch (e) {
      // Handle any errors
      showToast(message: 'Error updating slot availability: $e');
    }

    setState(() {}); // This will trigger a rebuild with the new values
  }
  String updateSlot(String slot) {
    List<String> slotsSplit = slot.split('/');
    int availableSlots = int.parse(slotsSplit[0]);
    int totalSlots = int.parse(slotsSplit[1]);

    int updatedSlots = (availableSlots < totalSlots) ? availableSlots + 1 : totalSlots;
    // Decrement available slots
    return '$updatedSlots/$totalSlots';
  }
  // Get details on load
  Future<void> getDetails() async {
    setState(() {
      _isFetching = true;
    });
    // String? userName = user?.displayName;
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
          int bookedPrice = 0;
          int bookedDuration = 0;
          int bookedDiscount = 0;

          try {
            bookedPrice = document.get('price') as int;
          } catch (e) {
            try {
              bookedPrice = (document.get('price') as double).toInt();
            } catch (e) {
              bookedPrice = int.parse(document.get('price') as String);
            }
          }
          try {
            bookedDuration = document.get('duration') as int;
          } catch (e) {
            try {
              bookedDuration = (document.get('duration') as double).toInt();
            } catch (e) {
              bookedDuration = int.parse(document.get('duration') as String);
            }
          }
          try {
            bookedDiscount = document.get('discount') as int;
          } catch (e) {
            try {
              bookedDiscount = (document.get('discount') as double).toInt();
            } catch (e) {
              bookedDiscount = int.parse(document.get('discount') as String);
            }
          }

          // Parse booking date and time
          DateTime bookingDateTime = DateTime.parse('$bookedDate $bookedTime');
          DateTime bookingEndDateTime = bookingDateTime.add(Duration(hours: bookedDuration));
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
              'R ${bookedPrice/bookedDuration}',
              bookedDuration.toString(),
              bookedDiscount.toString(),
              bookedLocation,
              bookedZone,
              bookedLevel,
              bookedRow,
              '${remainingDuration.inHours}h ${remainingDuration.inMinutes % 60}m',
              bookingEndDateTime,
            ));
          } else {
            // Booking is in the future, add to 'reservedspots'
            reservedspots.add(ReservedSpot(
              documentId,
              bookedDate,
              bookedTime,
              'R ${bookedPrice-bookedDiscount}',
              bookedDuration.toString(),
              bookedDiscount.toString(),
              bookedLocation,
              bookedZone,
              bookedLevel,
              bookedRow,
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
          int bookedPrice = 0;
          int bookedDuration = 0;
          int bookedDiscount = 0;

          try {
            bookedPrice = document.get('price') as int;
          } catch (e) {
            try {
              bookedPrice = (document.get('price') as double).toInt();
            } catch (e) {
              bookedPrice = int.parse(document.get('price') as String);
            }
          }
          try {
            bookedDuration = document.get('duration') as int;
          } catch (e) {
            try {
              bookedDuration = (document.get('duration') as double).toInt();
            } catch (e) {
              bookedDuration = int.parse(document.get('duration') as String);
            }
          }
          try {
            bookedDiscount = document.get('discount') as int;
          } catch (e) {
            try {
              bookedDiscount = (document.get('discount') as double).toInt();
            } catch (e) {
              bookedDiscount = int.parse(document.get('discount') as String);
            }
          }

          // Add to completedsessions list
          completedsessions.add(CompletedSession(
            documentId,
            bookedDate,
            bookedTime,
            'R ${bookedPrice-bookedDiscount}',
            bookedDuration.toString(),
            bookedDiscount.toString(),
            bookedLocation,
            bookedZone,
            bookedLevel,
            bookedRow,
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
      }
    } catch (e) {
      // Handle any errors
      showToast(message: 'Error retrieving past booking details: $e');
    }

    
    setState(() {
      _isFetching = false;
    });
  }

  void _showDeleteConfirmation(BuildContext context, ReservedSpot reservedspot) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Cancel Booking", style: TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold),),
          backgroundColor: const Color(0xFF35344A),
          content: const Text("Are you sure you want to cancel this booking?", style: TextStyle(color: Colors.white),),
          actions: <Widget>[
            TextButton(
              child: const Text("No", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            TextButton(
              child: const Text("Yes", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              onPressed: () {
                _deleteBooking(reservedspot);
                Navigator.of(context).pop(true);
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
      
      // Get the current booking document
      DocumentSnapshot bookingDoc = await firestore.collection('bookings').doc(reservedspot.documentId).get();
      
      if (bookingDoc.exists) {
        Map<String, dynamic> bookingData = bookingDoc.data() as Map<String, dynamic>;
        
        int price = 0;
        try {
          price = bookingData['price'] as int;
        } catch (e) {
          try {
            price = (bookingData['price'] as double).toInt();
          } catch (e) {
            price = int.parse(bookingData['price'] as String);
          }
        }
        int discount = 0;
        try {
          discount = bookingData['discount'] as int;
        } catch (e) {
          try {
            discount = (bookingData['discount'] as double).toInt();
          } catch (e) {
            discount = int.parse(bookingData['discount'] as String);
          }
        }
        int refundAmount = 0;
        if (price - discount > 0) {refundAmount = price - discount;}

        _refund(refundAmount);
        
        _updateSlotAvailability(bookingData['address'], bookingData['zone'], bookingData['level'], bookingData['row']);

        // Query the 'bookings' collection to find the document to delete
        await firestore.collection('bookings').doc(reservedspot.documentId).delete();

        // Remove the booking from the local list
        setState(() {
          reservedspots.removeWhere((spot) => spot.documentId == reservedspot.documentId);
        });

        showToast(message: 'Booking cancelled successfully');
      } else {
        showToast(message: 'Booking not found');
      }

    } catch (e) {
      showToast(message: 'Error cancelling booking: $e');
    }
  }

  void _showEndConfirmation(BuildContext context, ActiveSession activesession) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("End Sesssion Early", style: TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold),),
          backgroundColor: const Color(0xFF35344A),
          content: const Text("Are you sure you want to end this session early?", style: TextStyle(color: Colors.white),),
          actions: <Widget>[
            TextButton(
              child: const Text("No", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            TextButton(
              child: const Text("Yes", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              onPressed: () {
                _endSession(activesession);
                Navigator.of(context).pop(true);
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
        
        // Update the duration and calculate the final price
        int price = 0;
        try {
          price = bookingData['price'] as int;
        } catch (e) {
          try {
            price = (bookingData['price'] as double).toInt();
          } catch (e) {
            price = int.parse(bookingData['price'] as String);
          }
        }
        int duration = 0;
        try {
          duration = bookingData['duration'] as int;
        } catch (e) {
          try {
            duration = (bookingData['duration'] as double).toInt();
          } catch (e) {
            duration = int.parse(bookingData['duration'] as String);
          }
        }
        int discount = 0;
        try {
          discount = bookingData['discount'] as int;
        } catch (e) {
          try {
            discount = (bookingData['discount'] as double).toInt();
          } catch (e) {
            discount = int.parse(bookingData['discount'] as String);
          }
        }
        bookingData['duration'] = actualDurationHours;
        double rate = price/duration;
        double didPaid = (price - discount).toDouble();
        double shouldPaid = rate * actualDurationHours;
        int refundAmount = 0;
        if (didPaid - shouldPaid > 0) {refundAmount = (didPaid - shouldPaid).toInt();}

        _refund(refundAmount);
        
        _updateSlotAvailability(bookingData['address'], bookingData['zone'], bookingData['level'], bookingData['row']);
        
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
            'R ${didPaid-refundAmount}',
            activesession.duration,
            activesession.discount,
            activesession.address,
            activesession.zone,
            activesession.level,
            activesession.row,
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
  
  // void _refund(double price, double discount, int finalPrice) async {
  void _refund(int refundAmount) async {
    // double refundAmount = (price - discount) - finalPrice;

    //Refund Amount as credit here
    try {
      String? userId = user?.uid;
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      if (userId != null) {
        DocumentSnapshot userDocument = await firestore
            .collection('users')
            .doc(userId)
            .get();

        if (userDocument.exists) {
          double amount = userDocument.get('balance') as double;
          amount = amount+refundAmount;

          userDocument.reference.update({'balance': amount});
          showToast(message: "Refund : $refundAmount");
        } else {
          showToast(message: 'No balance found for update: $userId');
        }
      } else {
        showToast(message: 'User ID is null');
      }
    } catch (e) {
      showToast(message: 'Error updating slot availability: $e');
    }
    setState(() {});
  }

  int _selectedIndex = 2;

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
            Center(
              child: Container(
                width: 500,
                alignment: Alignment.topLeft,
                child: Column(
                  children: [
                    const Text(
                      'Active Session',
                      style: TextStyle(
                        color: Colors.tealAccent,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if(activesessions.isEmpty)
                      const Text('No Sessions', style: TextStyle(color: Colors.grey, fontSize: 16),),
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
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    if(reservedspots.isEmpty)
                      const Text('No Sessions', style: TextStyle(color: Colors.grey, fontSize: 16),),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: reservedspots.expand((reservedspot) => [
                        _buildReservedSessionItem(reservedspot),
                        const SizedBox(height: 10),
                      ]).toList(),
                    ),

                  ],
                )
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: 500,
                child: ExpansionTile(
                  title: const Text(
                    'Completed Sessions',
                    style: TextStyle(
                      color: Colors.tealAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  iconColor: Colors.white,
                  collapsedIconColor: Colors.white,
                  children: completedsessions.map((completedsession) => 
                    Column(
                      children: [
                        _buildCompletedSessionItem(completedsession),
                        const SizedBox(height: 10),
                      ],
                    )
                  ).toList(),
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
            blurRadius: 3,
            offset: const Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _locationTextCompleted(completedsession.address, completedsession.zone, completedsession.level, completedsession.row),
              const Spacer(),
              Text(
                completedsession.price,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          // const SizedBox(height: 5),
          // const Divider(
          //   color: Color.fromARGB(255, 199, 199, 199), // Color of the lines
          //   thickness: 1, // Thickness of the lines
          // ),
          const SizedBox(height: 5), 
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '${completedsession.date} @ ${completedsession.time}',
                style: const TextStyle(color: Colors.grey),
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
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     const Icon(Icons.star, color: Colors.white, size: 30),
          //     const SizedBox(width: 10),
          //     _locationText(reservedspot.address, reservedspot.zone, reservedspot.level, reservedspot.row),
          //   ],
          // ),
          Row(
            children: [
              const Spacer(),
              _locationText(reservedspot.address, reservedspot.zone, reservedspot.level, reservedspot.row),
              const Spacer(),
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
                reservedspot.price,
                style: const TextStyle(color: Colors.white),
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red.withOpacity(0.8)),
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
                  color: const Color(0xFF58C6A9).withOpacity(0.4),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'R ${extractPrice(activesession.price).toString()}/Hr',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              _locationText(activesession.address, activesession.zone, activesession.level, activesession.row),
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
                icon: Icon(Icons.delete,color: Colors.red.withOpacity(0.8)),
                onPressed: () => _showEndConfirmation(context, activesession),
              ),
            ],
          ),
        ],
      ),
    
    );
  }

  Widget _locationText(String location, String zone, String level, String row) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children:[
        Text(
          location,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),
        ),
        Row(
          children: [
            Text(
              'Zone:',
              style: TextStyle(color: Colors.white.withOpacity(0.7)), 
            ),
            Text(
              zone,
              style: const TextStyle(color: Color(0xFF58C6A9), fontWeight: FontWeight.bold),
            ),
            Text(
              '    Level:',
              style: TextStyle(color: Colors.white.withOpacity(0.7)),
            ),
            Text(
              level,
              style: const TextStyle(color: Color(0xFF58C6A9), fontWeight: FontWeight.bold),
            ),
            Text(
              '    Row:',
              style: TextStyle(color: Colors.white.withOpacity(0.7)),
            ),
            Text(
              row,
              style: const TextStyle(color: Color(0xFF58C6A9), fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ]
    );
  }

  Widget _locationTextCompleted(String location, String zone, String level, String row) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[
        Text(
          location,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),
        ),
        Row(
          children: [
            Text(
              'Zone:',
              style: TextStyle(color: Colors.white.withOpacity(0.7)), 
            ),
            Text(
              zone,
              style: const TextStyle(color: Color(0xFF58C6A9), fontWeight: FontWeight.bold),
            ),
            Text(
              '    Level:',
              style: TextStyle(color: Colors.white.withOpacity(0.7)),
            ),
            Text(
              level,
              style: const TextStyle(color: Color(0xFF58C6A9), fontWeight: FontWeight.bold),
            ),
            Text(
              '    Row:',
              style: TextStyle(color: Colors.white.withOpacity(0.7)),
            ),
            Text(
              row,
              style: const TextStyle(color: Color(0xFF58C6A9), fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ]
    );
  }
}