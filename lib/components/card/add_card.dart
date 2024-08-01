import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smart_parking_system/components/payment/payment_options.dart';


class AddCardPage extends StatefulWidget {
  const AddCardPage({super.key});

  @override
  _AddCardPageState createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> {
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _holderNameController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  Future<void> _saveCardDetails() async {
    // Replace 'userId' with the actual user ID
    String userId = "lhfXz2ynvue4ZOQJ5XQ9QT6oghu1";

    await FirebaseFirestore.instance.collection('cards').doc(userId).set({
      'cardNumber': _cardNumberController.text,
      'holderName': _holderNameController.text,
      'expiry': _expiryController.text,
      'cvv': _cvvController.text,
      'userId': userId,
    });

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const PaymentMethodPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF35344A),
      body: Center(
        child: SizedBox(
          width: 550,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(Icons.chevron_left, color: Colors.white, size: 35),
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const PaymentMethodPage(),
                            ),
                          );
                        },
                      ),
                    ),
                    const Center(
                      child: Text(
                        'Add Card',
                        style: TextStyle(
                          color: Color(0xFF58C6A9),
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40.0),
                Center(
                  child: ShaderMask(
                    shaderCallback: (bounds) {
                      return const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Colors.transparent, Colors.white, Colors.white, Colors.transparent],
                        stops: [0.0, 0.1, 0.9, 1.0],
                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.dstIn,
                    child: Image.asset('assets/main_add_card.png'),
                  ),
                ),
                const SizedBox(height: 40.0),
                TextField(
                  controller: _cardNumberController,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.transparent,
                    labelText: 'Card Number',
                    labelStyle: TextStyle(color: Colors.grey),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10.0),
                TextField(
                  controller: _holderNameController,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.transparent,
                    labelText: 'Holder Name',
                    labelStyle: TextStyle(color: Colors.grey),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _expiryController,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.transparent,
                          labelText: 'MM/YY',
                          labelStyle: TextStyle(color: Colors.grey),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          counterStyle: TextStyle(color: Colors.grey),
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                      ),
                    ),
                    const SizedBox(width: 120.0),
                    Expanded(
                      child: TextField(
                        controller: _cvvController,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.transparent,
                          labelText: 'CVV',
                          labelStyle: TextStyle(color: Colors.grey),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          counterStyle: TextStyle(color: Colors.grey),
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 60.0),
                Center(
                  child: ElevatedButton(
                    onPressed: _saveCardDetails,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 150,
                        vertical: 20,
                      ),
                      backgroundColor: const Color(0xFF58C6A9),
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const SizedBox(height: 100.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
