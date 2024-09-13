import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:smart_parking_system/components/common/toast.dart';
import 'package:smart_parking_system/components/login/vehicle_registration.dart';

class AddCardRegistrationPage extends StatefulWidget {
  const AddCardRegistrationPage({super.key});

  @override
  State<AddCardRegistrationPage> createState() => _AddCardRegistrationPageState();
}

class _AddCardRegistrationPageState extends State<AddCardRegistrationPage> {
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _holderNameController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _bankController = TextEditingController();
  bool isLoading = false;

  Future<void> addCardDetails() async {
      setState((){
        isLoading = true;
      });
      if (_cardNumberController.text.isEmpty ||
          _holderNameController.text.isEmpty ||
          _expiryController.text.isEmpty ||
          _cvvController.text.isEmpty ||
          _bankController.text.isEmpty) {
        showToast(message: 'Please fill in all fields');
        setState((){
          isLoading = false;
        });
        return;
      }

      if (_cardNumberController.text.length != 16 || !RegExp(r'^[0-9]+$').hasMatch(_cardNumberController.text)) {
        showToast(message: 'Invalid card number. Please enter 16 digits.');
        setState((){
          isLoading = false;
        });
        return;
      }

      // Validate expiry date format (MM/YY)
      if (!RegExp(r'^(0[1-9]|1[0-2])/[0-9]{2}$').hasMatch(_expiryController.text)) {
        showToast(message: 'Invalid expiry date. Use MM/YY format.');
        setState((){
          isLoading = false;
        });
        return;
      }

      // Validate CVV (should be 3 digits)
      if (_cvvController.text.length != 3 || !RegExp(r'^[0-9]+$').hasMatch(_cvvController.text)) {
        showToast(message: 'Invalid CVV. Please enter 3 digits.');
        setState((){
          isLoading = false;
        });
        return;
      }

      try {
        User? user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          await FirebaseFirestore.instance.collection('cards').add({
            'userId': user.uid, // Add the userId field
            'cardNumber': _cardNumberController.text,
            'holderName': _holderNameController.text,
            'expiry': _expiryController.text,
            'cvv': _cvvController.text,
            'bank': _bankController.text,
          });

          showToast(message: 'Card Added Successfully!');
          // ignore: use_build_context_synchronously
          setState((){
            isLoading = false;
          });
          if(mounted) { // Check if the widget is still in the tree
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const CarRegistration(),
              ),
            );
          }
        }
      } catch (e) {
        setState((){
          isLoading = false;
        });
        showToast(message: 'Error: $e');
      }
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF35344A),
      body: SingleChildScrollView(
        child: Center(
        child: SizedBox(
          width: 550,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Stack(
                  children: [
                    Center(
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
                const SizedBox(height: 10.0),
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
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10.0),
                TextField(
                  controller: _bankController,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.transparent,
                    labelText: 'Bank',
                    labelStyle: TextStyle(color: Colors.grey),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
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
                  style: const TextStyle(color: Colors.white),
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
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          _ExpiryDateInputFormatter(),
                        ],
                        maxLength: 5,
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
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.number,
                        maxLength: 3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30.0),
                ElevatedButton(
                      onPressed: () {
                        addCardDetails();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 100,
                          vertical: 12,
                        ),
                        backgroundColor: const Color(0xFF58C6A9),
                      ),
                      child: isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.0,
                            ),
                          )
                        : const Text(
                        'Continue',
                        style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w400),
                      ),
                    ),
                  const SizedBox(height: 20.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => const CarRegistration(),
                        ),
                      );
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Divider(
                            color: Color.fromARGB(255, 199, 199, 199),
                            thickness: 1,
                            endIndent: 10,
                          ),
                        ),
                        Text(
                          'Skip for now',
                          style: TextStyle(
                            color: Color(0xFF58C6A9),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Color.fromARGB(255, 199, 199, 199),
                            thickness: 1,
                            indent: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      )
      
    );
  }
}

class _ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 2 == 0 && nonZeroIndex != text.length) {
        buffer.write('/');
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}
