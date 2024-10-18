import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:smart_parking_system/components/common/custom_widgets.dart';
import 'package:smart_parking_system/components/payment/offers.dart';
import 'package:smart_parking_system/components/payment/top_up.dart';
import 'package:smart_parking_system/components/payment/payment_successful.dart';
import 'package:intl/intl.dart';
//Firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_parking_system/components/common/toast.dart';

class ConfirmPaymentPage extends StatefulWidget {
  final String bookedAddress;
  final double price;
  final String selectedZone;
  final String selectedLevel;
  final String? selectedRow;
  final String selectedTime;
  final DateTime selectedDate;
  final double selectedDuration;
  final bool selectedDisabled;
  final String vehicleId;
  final String vehicleLogo;

  const ConfirmPaymentPage({
    required this.bookedAddress,
    required this.selectedZone,
    required this.selectedLevel,
    required this.selectedRow,
    required this.selectedTime,
    required this.selectedDate,
    required this.selectedDuration,
    required this.price,
    required this.selectedDisabled,
    required this.vehicleId,
    required this.vehicleLogo,
    super.key
  });

  @override
  State<ConfirmPaymentPage> createState() => _ConfirmPaymentPageState();
}

// Function to update slots field
String updateSlot(String slot) {
  List<String> slotsSplit = slot.split('/');
  int availableSlots = int.parse(slotsSplit[0]);
  int totalSlots = int.parse(slotsSplit[1]);

  int updatedSlots = (availableSlots > 0) ? availableSlots - 1 : 0;
  // Decrement available slots
  return '$updatedSlots/$totalSlots';
}

class _ConfirmPaymentPageState extends State<ConfirmPaymentPage> {
  //Variables
  String? licenseNum = '';
  String? carMake = '';
  String? carModel = '';
  String carLogo = 'assets/default_logo.png';
  String? startTime = '';
  String? endTime = '';
  String? bookingDate = '';
  double totalPrice = 0;
  double discountedPrice = 0;
  bool couponsApplied = false;
  bool _sufficientFunds = false;
  double _availableFunds = 0.00;
  List<String> appliedCoupons = [];
  bool _isLoading = false;
  bool _isFetching = true;

  //Functions
  Future<void> _topup() async {
    if(mounted){
      final result = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const TopUpPage(),
        ),
      );
      if (result == true) {
        getDetails();
      }
    }
  }

  Future<void> _bookspace() async {
    try {
      setState((){
        _isLoading = true;
      });
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        if(_sufficientFunds){

          String? fcmToken = await FirebaseMessaging.instance.getToken();
          if (fcmToken == null) { return; }
          String dateTime = '$bookingDate ${startTime!}';
          DateTime parkingTimeUtc = DateTime.parse(dateTime).toUtc();
          final notificationTimeUtc = parkingTimeUtc.subtract(const Duration(hours: 2));

          await FirebaseFirestore.instance.collection('bookings').add({
            'userId': user.uid,
            'zone': widget.selectedZone,
            'level': widget.selectedLevel,
            'row': widget.selectedRow,
            'time': startTime,
            'date': bookingDate,
            'duration': widget.selectedDuration,
            'price': totalPrice.toDouble(),
            'discount': discountedPrice.toDouble(),
            'address': widget.bookedAddress,
            'disabled': widget.selectedDisabled,
            'vehicleId': widget.vehicleId,
            'sent': false,
            'fcmToken': fcmToken,
            'notificationTime': notificationTimeUtc,
          });

          if (couponsApplied) {
            QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                .collection('coupons')
                .where('userId', isEqualTo: user.uid)
                .where('applied', isEqualTo: true)
                .get();

            for (var doc in querySnapshot.docs) {
              await doc.reference.delete();
            }
          }

          await _updateWallet();
          await _updateSlotAvailability();
          await _makeNotifications();
          showToast(message: 'Booked Successfully!');

          if(mounted){
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const PaymentSuccessionPage(),
              ),
            );
          }
        } else {
          showToast(message: 'Error: Insufficient funds');
        }
      }
    } catch (e) {
      showToast(message: 'Error: $e');
    } finally {
      setState((){
        _isLoading = false;
      });
    }
  }

  Future<void> _updateWallet() async {
    double price = ((totalPrice - discountedPrice) < 0 ? 0.00 : totalPrice - discountedPrice);
    User? user = FirebaseAuth.instance.currentUser;

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .get();

      final data = userDoc.data() as Map<String, dynamic>;
      double currentBalance = data['balance']?.toDouble() ?? 0.0;

      if (price <= currentBalance) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid)
            .update({'balance': (currentBalance - price).toDouble()});
      } else {
        showToast(message: 'Insufficient funds');
      }
    } catch (e) {
      //
    }
  }

  Future<void> checkFunds() async {
    double price = ((totalPrice - discountedPrice) < 0 ? 0.00 : totalPrice - discountedPrice);
    User? user = FirebaseAuth.instance.currentUser;

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .get();

      final data = userDoc.data() as Map<String, dynamic>;
      
      setState(() {
        _sufficientFunds = price <= data['balance']?.toDouble();
        // _availableFunds = data['balance']?.toDouble() ?? 0.00;
        double balance = data['balance']?.toDouble() ?? 0.0;
        _availableFunds = (balance * 100).truncateToDouble() / 100;
      });
    } catch (e) {
      //
    }
  }

  Future<void> checkCoupons() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('coupons')
          .where('userId', isEqualTo: user.uid)
          .where('applied', isEqualTo: true)
          .get();

      setState(() {
        discountedPrice = 0;
        if (querySnapshot.docs.isNotEmpty) {
          couponsApplied = true;
          appliedCoupons = querySnapshot.docs.map((doc) {
            double amount = (doc.get('amount') as num).toDouble();
            discountedPrice += amount;
            return 'ZAR R$amount OFF';
          }).toList();
        } else {
          couponsApplied = false;
          appliedCoupons.clear();
        }
      });
    } catch (e) {
      showToast(message: 'Error checking coupons: $e');
    }
  }

  Future<void> _makeNotifications() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      String? fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken == null) {
        return;
      }
      String dateTime = '$bookingDate ${startTime!}';
      DateTime parkingTimeUtc = DateTime.parse(dateTime).toUtc();
     
      final notificationTimeUtc = parkingTimeUtc.subtract(const Duration(hours: 2));

      if (user != null) {
        await FirebaseFirestore.instance.collection('notifications').add({
          'address': widget.bookedAddress,
          'fcmToken': fcmToken,
          'notificationTime': notificationTimeUtc,
          'parkingTime': parkingTimeUtc,
          'sent': false,
          'type': 'Booking',
          'parkingSlot': 'Zone : ${widget.selectedZone}, Level : ${widget.selectedLevel}, Row : ${widget.selectedRow}', 
          'userId': user.uid,
        });
      }
    } catch (e) {
      showToast(message: 'Error: $e');
    }
  }

    // Get details on load
  Future<void> _updateSlotAvailability() async {
    try {
      // Get a reference to the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Query the 'parkings' collection for a document with matching name
      QuerySnapshot parkingQuerySnapshot = await firestore
          .collection('parkings')
          .where('name', isEqualTo: widget.bookedAddress)
          .limit(1)
          .get();

      if (parkingQuerySnapshot.docs.isNotEmpty) {  // Check if there are any documents
        var parkingDocument = parkingQuerySnapshot.docs.first;
        String updatedSlot = updateSlot(parkingDocument.get('slots_available') as String);
        parkingDocument.reference.update({'slots_available': updatedSlot});
      } else {
        // No parking found
        showToast(message: 'No parking found for update: ${widget.bookedAddress}');
      }


      if (parkingQuerySnapshot.docs.isNotEmpty) {  // Check if a matching document was found
        DocumentSnapshot parkingDocumentSnapshot = parkingQuerySnapshot.docs[0];  // Get the document snapshot

        CollectionReference zonesCollection = parkingDocumentSnapshot.reference.collection('zones');  // Get the subcollection 'zones'
        DocumentSnapshot zoneDocumentSnapshot = await zonesCollection.doc(widget.selectedZone).get();  // Query the 'zones' subcollection for a document with matching id

        QuerySnapshot zonesQuerySnapshot = await zonesCollection.get();  // Query the 'rows' subcollection for all documents
        if (zonesQuerySnapshot.docs.isNotEmpty) {  // Check if there are any documents
          for (var zoneDocument in zonesQuerySnapshot.docs) {  // Loop through each document
            // Update the fields
            String updatedSlot = updateSlot(zoneDocument.get('slots') as String);
            if( zoneDocument.id == widget.selectedZone){
              zoneDocument.reference.update({'slots': updatedSlot});
            }
          }
        } else {
          // No zones found
          showToast(message: 'No zone found for update: ${widget.selectedZone}');
        }
      
        if (zoneDocumentSnapshot.exists) {  // Check if a matching document was found
          CollectionReference levelsCollection = zoneDocumentSnapshot.reference.collection('levels');  // Get the subcollection 'levels'
          DocumentSnapshot levelDocumentSnapshot = await levelsCollection.doc(widget.selectedLevel).get();  // Query the 'levels' subcollection for a document with matching id

          QuerySnapshot levelsQuerySnapshot = await levelsCollection.get();  // Query the 'rows' subcollection for all documents
          if (levelsQuerySnapshot.docs.isNotEmpty) {  // Check if there are any documents
            for (var levelDocument in levelsQuerySnapshot.docs) {  // Loop through each document
              // Update the fields
              String updatedSlot = updateSlot(levelDocument.get('slots') as String);
              if( levelDocument.id == widget.selectedLevel){
                levelDocument.reference.update({'slots': updatedSlot});
              }
            }
          } else {
            // No levels found
            showToast(message: 'No level found for update: ${widget.selectedLevel}');
          }
        
          if (levelDocumentSnapshot.exists) {  // Check if a matching document was found

            CollectionReference rowsCollection = levelDocumentSnapshot.reference.collection('rows');  // Get the subcollection 'rows'
            QuerySnapshot rowsQuerySnapshot = await rowsCollection.get();  // Query the 'rows' subcollection for all documents
            if (rowsQuerySnapshot.docs.isNotEmpty) {  // Check if there are any documents
              for (var rowDocument in rowsQuerySnapshot.docs) {  // Loop through each document
                // Update the fields
                String updatedSlot = updateSlot(rowDocument.get('slots') as String);
                if( rowDocument.id == widget.selectedRow){
                  rowDocument.reference.update({'slots': updatedSlot});
                }
              }
            } else {
              // No rows found
              showToast(message: 'No row found for update: ${widget.selectedRow}');
            }
          } else {
            // No level found
            showToast(message: 'No level found: ${widget.selectedLevel}');
          }
        } else {
          // No zone found
          showToast(message: 'No zone found: ${widget.selectedZone}');
        }
      } else {
        // No parking found
        showToast(message: 'No parking found: ${widget.bookedAddress}');
      }
    } catch (e) {
      // Handle any errors
      showToast(message: 'Error updating slot availability: $e');
    }

    setState(() {}); // This will trigger a rebuild with the new values
  }

  Future<void> getDetails() async {
    setState(() {
      _isFetching = true;
    });
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      DocumentSnapshot document = await firestore.collection('vehicles').doc(widget.vehicleId).get();

      if (document.exists) {
        licenseNum = document.get('licenseNumber') as String?;
        carMake = document.get('vehicleBrand') as String?;
        carModel = document.get('vehicleModel') as String?;
        carLogo = widget.vehicleLogo;
      } else {
        showToast(message: 'No car found for vehicleId: ${widget.vehicleId}');
      }
    } catch (e) {
      showToast(message: 'Error retrieving user details: $e');
    }

    try {
      DateTime tempStartTime;
      if (widget.selectedTime.toLowerCase().contains('am') || widget.selectedTime.toLowerCase().contains('pm')) {
        tempStartTime = DateFormat('hh:mm a').parse(widget.selectedTime);
      } else {
        tempStartTime = DateFormat('HH:mm').parse(widget.selectedTime);
      }
      startTime = DateFormat('HH:mm').format(tempStartTime);
      endTime = DateFormat('HH:mm').format(tempStartTime.add(Duration(minutes: (widget.selectedDuration * 60).round())));
      bookingDate = DateFormat('yyyy-MM-dd').format(widget.selectedDate);
      totalPrice = widget.price * widget.selectedDuration;

      await checkCoupons();
      await checkFunds();
      setState(() {});
    } catch (e) {
      showToast(message: 'ERROR: $e');
    }
    setState(() {
      _isFetching = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getDetails();
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
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 30),
                  ),
                  const Text(
                    'Confirm Payment',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Color(0xFF58C6A9)),
                  ),
                  const SizedBox(width: 48), // Adjust the width as needed
                ],
              ),
              const SizedBox(height: 35),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF35344A),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 90,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: NetworkImage(carLogo),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(color: Colors.white),
                              children: [
                                const TextSpan(
                                  text: 'Plate : ',
                                  style: TextStyle(fontWeight: FontWeight.w200, fontSize: 16),
                                ),
                                TextSpan(
                                  text: licenseNum,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 1),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(color: Colors.white),
                              children: [
                                const TextSpan(
                                  text: 'Car Model : ',
                                  style: TextStyle(fontWeight: FontWeight.w200, fontSize: 16),
                                ),
                                TextSpan(
                                  text: '$carMake $carModel',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Location:',
                            style: TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 1),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(color: Colors.white),
                              children: [
                                TextSpan(
                                  text: widget.bookedAddress,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'Zone: ',
                              style: const TextStyle(color: Colors.white),
                              children: <TextSpan>[
                                TextSpan(
                                  text: widget.selectedZone,
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'Level: ',
                              style: const TextStyle(color: Colors.white),
                              children: <TextSpan>[
                                TextSpan(
                                  text: widget.selectedLevel,
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'Row: ',
                              style: const TextStyle(color: Colors.white),
                              children: <TextSpan>[
                                TextSpan(
                                  text: widget.selectedRow,
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'Check-in Time and Date:',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Image.asset('assets/Line-7.png', height: 70),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      style: const TextStyle(color: Colors.white),
                                      children: [
                                        TextSpan(
                                          text: '$startTime  ',
                                          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                                        ),
                                        TextSpan(
                                          text: bookingDate,
                                          style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 25),
                                  RichText(
                                    text: TextSpan(
                                      style: const TextStyle(color: Colors.white),
                                      children: [
                                        TextSpan(
                                          text: endTime,
                                          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.local_activity, color: Color(0xFF58C6A9)),
                title: const Text('Offers', style: TextStyle(color: Colors.white)),
                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                onTap: () async {
                  final result = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const OfferPage(),
                    ),
                  );
                  if (result == true) {
                    getDetails();
                  }
                },
              ),
              if (couponsApplied) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Coupons have been applied!',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                ),
                for (var coupon in appliedCoupons)
                  ListTile(
                    leading: const Icon(Icons.local_activity, color: Color(0xFF58C6A9)),
                    title: Text(
                      coupon,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF58C6A9)),
                    ),
                  ),
              ],
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Totals',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF58C6A9)),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF35344A),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Aligns text to the left
                      children: [
                        SizedBox(height: 5),
                        Text(
                          'Available Balance',
                          style: TextStyle(fontSize: 17, color: Colors.white,),// fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Parking Cost',
                          style: TextStyle(fontSize: 17, color: Colors.white,),// fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Discount',
                          style: TextStyle(fontSize: 17, color: Colors.white,),// fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Total',
                          style: TextStyle(fontSize: 17, color: Colors.white,),// fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                      ],
                    ),
                    const SizedBox(width: 60),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Aligns text to the left
                      children: [
                        const SizedBox(height: 5),
                        Text(
                          'R $_availableFunds',
                          style: const TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          'R $totalPrice',
                          style: const TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'R $discountedPrice',
                          style: const TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'R ${(totalPrice - discountedPrice) < 0 ? 0.00 : totalPrice - discountedPrice}',
                          style: const TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _sufficientFunds == true ? _bookspace : _topup,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 5,
                      ),
                      backgroundColor: const Color(0xFF58C6A9),
                    ),
                    child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.0,
                              ),
                            )
                          : Text(
                              _sufficientFunds == true ? 'Pay' : 'Top Up',
                              style: const TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.w300),
                            ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
