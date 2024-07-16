import 'package:flutter/material.dart';
import 'package:smart_parking_system/components/payment/offers.dart';
import 'package:smart_parking_system/components/payment/payment_successfull.dart';
import 'package:intl/intl.dart';
//Firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_parking_system/components/common/toast.dart';

class ConfirmPaymentPage extends StatefulWidget {
  final String bookedAddress;
  final String selectedZone;
  final String selectedLevel;
  final String selectedRow;
  final String selectedTime;
  final double selectedDuration;
  final double price;
  final bool selectedDisabled;
  final bool selectedWash;

  const ConfirmPaymentPage({required this.bookedAddress, required this.selectedZone, required this.selectedLevel, required this.selectedRow, required this.selectedTime, required this.selectedDuration, required this.price, required this.selectedDisabled, required this.selectedWash, super.key});

  @override
  State<ConfirmPaymentPage> createState() => _ConfirmPaymentPageState();
}

class _ConfirmPaymentPageState extends State<ConfirmPaymentPage> {
    //Variables
  String? licenseNum = '';
  String? carMake = '';
  String? carModel = '';
  String? startTime = '';
  String? endTime = '';
  String? bookingDate = '';
  double? totalPrice = 0;
    //Functions
  Future<void> _bookspace() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await FirebaseFirestore.instance.collection('bookings').add({
          'userId': user.uid, // Add the userId field
          'zone': widget.selectedZone,
          'level': widget.selectedLevel,
          'row': widget.selectedRow,
          'time': startTime,
          'duration': widget.selectedDuration,
          'price': widget.price,
          'disabled': widget.selectedDisabled,
          'wash': widget.selectedWash,
        });

        showToast(message: 'Booked Successfully!');
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const PaymentSuccessionPage(),
          ),
        );
      }
    } catch (e) {
      showToast(message: 'Error: $e');
    }
  }

  Future<void> getDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    String? userName = user?.displayName;
    String? userId = user?.uid;

    try {
      // Get a reference to the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      
      // Query the 'cars' collection for a document with matching userId
      QuerySnapshot querySnapshot = await firestore
          .collection('vehicles')
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();
      // Check if a matching document was found
      if (querySnapshot.docs.isNotEmpty) {
        // Get the first (and should be only) document
        DocumentSnapshot document = querySnapshot.docs.first;
        // Retrieve the licenseNumber field
        licenseNum = document.get('licenseNumber') as String?;
        carMake = document.get('vehicleBrand') as String?;
        carModel = document.get('vehicleModel') as String?;
      } else {
        // No matching document found
        showToast(message: 'No car found for userId: $userName');
      }
    } catch (e) {
      // Handle any errors
      showToast(message: 'Error retrieving user details: $e');
    }


    //endTime calc
    DateTime tempStartTime;
    if (widget.selectedTime.toLowerCase().contains('am') || widget.selectedTime.toLowerCase().contains('pm')) {
      tempStartTime = DateFormat('hh:mm a').parse(widget.selectedTime);
    } else {
      tempStartTime = DateFormat('HH:mm').parse(widget.selectedTime);
    }
    startTime = DateFormat('HH:mm').format(tempStartTime);
    endTime = DateFormat('HH:mm').format(tempStartTime.add(Duration(minutes: (widget.selectedDuration * 60).round())));
    //booking date
    bookingDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    //total price calc
    totalPrice = widget.price * widget.selectedDuration;

    setState((){
      // This will trigger a rebuild with the new values
    });
  }


    //Output
  int _selectedCard = 1;

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
                  icon: const Icon(Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const Text(
                  'Confirm Payment',
                  style: TextStyle(
                    fontSize: 24, 
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF58C6A9),
                  ),
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
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child:Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100, // Adjust the width as needed
                    height: 100, // Adjust the height as needed
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: const DecorationImage(
                        image: AssetImage('assets/car.png'),
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
                              style: TextStyle(
                                fontWeight: FontWeight.w200,
                              ),
                            ),
                            TextSpan(
                              text: licenseNum,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold, 
                              ),
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
                              text: 'Car Modal : ',
                              style: TextStyle(
                                fontWeight: FontWeight.w200,
                              ),
                            ),
                            TextSpan(
                              text: '$carMake $carModel',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold, 
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Address:',
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 1),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(color: Colors.white),
                          children: [
                            TextSpan(
                              text: 'Zone ${widget.selectedZone}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: ' ${widget.selectedLevel}${widget.selectedRow} - ${widget.bookedAddress}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold, 
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Hourly parking ticket',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w200
                        ),
                      ),
                      const SizedBox(height: 5), // Spacer
                      const Text(
                        'Parking Time:',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                      const SizedBox(height: 10), 
                      Row(
                        children: [
                          Image.asset('assets/Line-7.png', height: 70), // Image
                          const SizedBox(width: 8), // Spacer
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              
                              RichText(
                                text: TextSpan(
                                  style: const TextStyle(color: Colors.white),
                                  children: [
                                    TextSpan(
                                      text: '$startTime         ',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18
                                      ),
                                    ),
                                    TextSpan(
                                      text: bookingDate,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w200, 
                                        fontSize: 14
                                      ),
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
                                      text: '$endTime         ',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18
                                      ),
                                    ),
                                    TextSpan(
                                      text: bookingDate,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w200,
                                        fontSize: 14
                                      ),
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
                Navigator.of(context).pushReplacement(
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
                style: TextStyle(
                  fontSize: 20, 
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF58C6A9),
                ),
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
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  Card(
                    elevation: 0, // Set elevation to 0
                    color: Colors.transparent, // Set color to transparent
                    child: ListTile(
                      leading: SizedBox(
                        width: 50, // Set the desired width of the image
                        child: Image.asset('assets/mastercard.png'),
                      ),
                      title: const Text(
                        'FNB Bank **** **** **** 8395',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      trailing: Radio(
                        value: 1,
                        groupValue: _selectedCard,
                        onChanged: (value) {
                          setState(() {
                            _selectedCard = value as int;
                          });
                        },
                        activeColor: const Color(0xFF58C6A9), // Set the color here
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Card(
                    elevation: 0, // Set elevation to 0
                    color: Colors.transparent, // Set color to transparent
                    child: ListTile(
                      leading: SizedBox(
                        width: 50, // Set the desired width of the image
                        child: Image.asset('assets/visa.png'),
                      ),
                      title: const Text(
                        'Capitec Bank **** **** **** 6246',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      trailing: Radio(
                        value: 2,
                        groupValue: _selectedCard,
                        onChanged: (value) {
                          setState(() {
                            _selectedCard = value as int;
                          });
                        },
                        activeColor: const Color(0xFF58C6A9), // Set the color here
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GestureDetector(
                      onTap: () {
                        // Insert here what Top Up does
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.add,
                            color: Color(0xFF58C6A9),
                          ),
                          SizedBox(width: 10),
                          Text('Add New Card',
                            style: TextStyle(
                              color: Color(0xFF58C6A9)
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
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
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17
                        ),
                      ),
                      TextSpan(
                        text: 'ZAR $totalPrice',
                        style: const TextStyle(
                          fontWeight: FontWeight.w400, 
                          fontSize: 20
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 180),
                ElevatedButton(
                  onPressed: () {
                    _bookspace();
                    // Navigator.of(context).pushReplacement(
                    //     MaterialPageRoute(
                    //       builder: (_) => PaymentSuccessionPage(selectedZone: widget.selectedZone, selectedLevel: widget.selectedLevel, selectedRow: widget.selectedRow, selectedTime: widget.selectedTime, selectedDuration: widget.selectedDuration, price: widget.price, selectedDisabled: widget.selectedDisabled, selectedWash: widget.selectedWash,),
                    //     ),
                    //   );
                  },
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
