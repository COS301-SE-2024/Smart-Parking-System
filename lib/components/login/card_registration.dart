import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_parking_system/components/common/toast.dart';
import 'package:smart_parking_system/components/common/custom_widgets.dart';
import 'package:smart_parking_system/components/common/common_functions.dart';
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

        final String cardNumber = cardNumberController.text.replaceAll(RegExp(r'\s+'), '');
        final String holderName = holderNameController.text;
        final String expiry = expiryController.text;
        final String cvv = cvvController.text;
        final String bank = bankController.text;
        if(!isValidString(cardNumber, r'^(?:4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14}|3[47][0-9]{13}|3(?:0[0-5]|[68][0-9])[0-9]{11}|6(?:011|5[0-9]{2})[0-9]{12}|(?:2131|1800|35\d{3})\d{11})$')){showToast(message: "Invalid Card Number, Remove any spaces"); return;}
        if(!isValidString(holderName, r'^[a-zA-Z/\s]+$')){showToast(message: "Invalid Holder Name"); return;}
        if(!isValidString(expiry, r'^\d{2}/\d{2}$')){showToast(message: "Invalid Expiry, format: 00/00"); return;}
        if(!isValidString(cvv, r'^\d{3}$')){showToast(message: "Invalid CVV, format 000"); return;}
        if(!isValidString(bank, r'^[a-zA-Z]+$')){showToast(message: "Invalid Bank Name"); return;}
        Map<String, String> cardPatterns = {
          'visa': r'^4[0-9]{12}(?:[0-9]{3})?$',
          'mastercard': r'^5[1-5][0-9]{14}$',
          'american express': r'^3[47][0-9]{13}$',
          'diners club': r'^3(?:0[0-5]|[68][0-9])[0-9]{11}$',
          'discover': r'^6(?:011|5[0-9]{2})[0-9]{12}$',
          'jcb': r'^(?:2131|1800|35\d{3})\d{11}$'
        };
        String cardType = '';
        for (var entry in cardPatterns.entries) {
          if (RegExp(entry.value).hasMatch(cardNumber)) {
            cardType = entry.key;
          }
        }

        if (user != null) {
          await FirebaseFirestore.instance.collection('cards').add({
            'userId': user.uid, // Add the userId field
            'cardNumber': cardNumber,
            'holderName': holderName,
            'expiry': expiry,
            'cvv': cvv,
            'bank': bank,
            'cardType': cardType
          });

          showToast(message: 'Card Added Successfully!');
          if(context.mounted) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const CarRegistration(),
              ),
            );
          }
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
                    style: const TextStyle(color: Colors.white),
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
                  nextButtonWithSkip(
                    displayText: 'Continue',
                    action: addCardDetails,
                    nextPage: const CarRegistration(),
                    context: context
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