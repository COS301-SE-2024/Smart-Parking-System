import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:smart_parking_system/components/payment/offers.dart';
import 'package:smart_parking_system/components/payment/payment_successfull.dart';
import  'package:smart_parking_system/components/card/add_card.dart';
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
  double? totalPrice = 0;

  String cardNumber = '';
  String cardNumberFormatted = '';
  List<Map<String, dynamic>> cards = [];
  int? _selectedCard;

  //Functions
  Future<void> _bookspace() async {
    if (_selectedCard == null) return;

    try {
      User? user = FirebaseAuth.instance.currentUser;

      _updateSlotAvailability();

      String? fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken == null) {
        return;
      }
      String dateTime = '$bookingDate ${startTime!}';
      DateTime parkingTimeUtc = DateTime.parse(dateTime).toUtc();

      final notificationTimeUtc = parkingTimeUtc.subtract(const Duration(hours: 2));

      if (user != null) {
        await FirebaseFirestore.instance.collection('bookings').add({
          'userId': user.uid,
          'zone': widget.selectedZone,
          'level': widget.selectedLevel,
          'row': widget.selectedRow,
          'time': startTime,
          'date': bookingDate,
          'duration': widget.selectedDuration,
          'price': widget.price,
          'address': widget.bookedAddress,
          'disabled': widget.selectedDisabled,
          'vehicleId': widget.vehicleId,
          'vehicleLogo': widget.vehicleLogo,
          'card': cardNumber,
          'sent': false,
          'fcmToken': fcmToken,
          'notificationTime': notificationTimeUtc,
        });

        showToast(message: 'Booked Successfully!');
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const PaymentSuccessionPage(),
          ),
        );
      }
    } catch (e) {
      showToast(message: 'Error: $e');
    }
  }

  Future<void> _updateSlotAvailability() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      QuerySnapshot parkingQuerySnapshot = await firestore
          .collection('parkings')
          .where('name', isEqualTo: widget.bookedAddress)
          .limit(1)
          .get();

      if (parkingQuerySnapshot.docs.isNotEmpty) {
        var parkingDocument = parkingQuerySnapshot.docs.first;
        String updatedSlot = updateSlot(parkingDocument.get('slots_available') as String);
        parkingDocument.reference.update({'slots_available': updatedSlot});
      } else {
        showToast(message: 'No parking found for update: ${widget.bookedAddress}');
      }
    } catch (e) {
      showToast(message: 'Error updating slot availability: $e');
    }
    setState(() {});
  }

  Future<void> getDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    String? userName = user?.displayName;
    String? userId = user?.uid;

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

      QuerySnapshot querySnapshot = await firestore.collection('cards').where('userId', isEqualTo: userId).get();
      if (querySnapshot.docs.isNotEmpty) {
        cards = querySnapshot.docs.map((doc) {
          cardNumber = doc.get('cardNumber') as String;
          String cardType = doc.get('cardType') as String;
          String bank = doc.get('bank') as String;

          cardNumberFormatted = ('*' * (cardNumber.length - 4)) + (cardNumber.substring(cardNumber.length - 4));
          cardNumberFormatted = cardNumberFormatted.replaceAllMapped(
              RegExp(r'.{4}'), (match) => '${match.group(0)} ').trim();

          return {
            'cardNumber': cardNumberFormatted,
            'cardType': cardType,
            'bank': bank,
          };
        }).toList();
      } else {
        showToast(message: 'No cards found for user: $userName');
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

      setState(() {});
    } catch (e) {
      showToast(message: 'ERROR: $e');
    }
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
      body: Padding(
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
                      Navigator.of(context).pop();
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
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: AssetImage(carLogo),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 25),
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
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const OfferPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Credits & Debit Cards',
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
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    if (cards.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const AddCardPage(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Add New Card',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    else
                      ...cards.asMap().entries.map((entry) {
                        int idx = entry.key;
                        Map<String, dynamic> card = entry.value;
                        return Card(
                          elevation: 0,
                          color: Colors.transparent,
                          child: ListTile(
                            leading: SizedBox(
                              width: 50,
                              child: Image.asset('assets/${card['cardType'].toLowerCase()}.png'),
                            ),
                            title: Text(
                              '${card['bank']} ${card['cardNumber']}',
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Colors.white),
                            ),
                            trailing: Radio(
                              value: idx,
                              groupValue: _selectedCard,
                              onChanged: (value) {
                                setState(() {
                                  _selectedCard = value as int;
                                });
                              },
                              activeColor: const Color(0xFF58C6A9),
                            ),
                          ),
                        );
                      }),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.white),
                      children: [
                        const TextSpan(
                          text: 'Total\n',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                        TextSpan(
                          text: 'ZAR $totalPrice',
                          style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 180),
                  ElevatedButton(
                    onPressed: _selectedCard != null ? _bookspace : null,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 5,
                      ),
                      backgroundColor: _selectedCard != null ? const Color(0xFF58C6A9) : Colors.grey,
                    ),
                    child: const Text(
                      'Pay',
                      style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.w300),
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
