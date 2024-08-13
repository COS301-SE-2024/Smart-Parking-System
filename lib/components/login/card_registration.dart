import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_parking_system/components/common/toast.dart';
import 'package:smart_parking_system/components/login/vehicle_registration.dart';

class AddCardRegistrationPage extends StatelessWidget {
  const AddCardRegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController cardNumberController = TextEditingController();
    final TextEditingController holderNameController = TextEditingController();
    final TextEditingController expiryController = TextEditingController();
    final TextEditingController cvvController = TextEditingController();
    final TextEditingController bankController = TextEditingController();

    Future<void> addCardDetails() async {
      try {
        User? user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          await FirebaseFirestore.instance.collection('cards').add({
            'userId': user.uid, // Add the userId field
            'cardNumber': cardNumberController.text,
            'holderName': holderNameController.text,
            'expiry': expiryController.text,
            'cvv': cvvController.text,
            'bank': bankController.text,
          });

          showToast(message: 'Card Added Successfully!');
          // ignore: use_build_context_synchronously
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const CarRegistration(),
            ),
          );
        }
      } catch (e) {
        showToast(message: 'Error: $e');
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFF35344A),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: 550,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40.0), // Space from the top
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
                  const SizedBox(height: 40.0),
                  Center(
                    child: ShaderMask(
                      shaderCallback: (bounds) {
                        return const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.transparent,
                            Colors.white,
                            Colors.white,
                            Colors.transparent
                          ],
                          stops: [0.0, 0.1, 0.9, 1.0],
                        ).createShader(bounds);
                      },
                      blendMode: BlendMode.dstIn,
                      child: Image.asset('assets/main_add_card.png'),
                    ),
                  ),
                  const SizedBox(height: 40.0),
                  TextField(
                    controller: cardNumberController,
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
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 10.0),
                  TextField(
                    controller: bankController,
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
                  ),
                  const SizedBox(height: 10.0),
                  TextField(
                    controller: holderNameController,
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
                          controller: expiryController,
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
                          style: const TextStyle(color: Colors.white)
                        ),
                      ),
                      const SizedBox(width: 120.0),
                      Expanded(
                        child: TextField(
                          controller: cvvController,
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
                          style: const TextStyle(color: Colors.white)
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 60.0),
                  Center(
                    child: ElevatedButton(
                      onPressed: addCardDetails,
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
                        'Continue',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Center(
                    child: GestureDetector(
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
                              color: Colors.white,
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
                              color: Colors.white,
                              thickness: 1,
                              indent: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
