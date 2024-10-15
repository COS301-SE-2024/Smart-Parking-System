import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_parking_system/components/common/common_functions.dart';
import 'package:smart_parking_system/components/common/toast.dart';



class Registration6 extends StatefulWidget {
  final Function onRegisterComplete;
  // final ParkingSpot ps;

  const Registration6({super.key, required this.onRegisterComplete});

  @override
  // ignore: library_private_types_in_public_api
  _Registration6State createState() => _Registration6State();
}

class _Registration6State extends State<Registration6> {
  final TextEditingController _billingNameController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _accountTypeController = TextEditingController();
  final TextEditingController _bankController = TextEditingController();
  bool _isLoading = false;

  Future<void> _saveCardDetails() async {
    setState((){
      _isLoading = true;
    });

    User? user = FirebaseAuth.instance.currentUser;

    final String billingName = _billingNameController.text;
    final String accountNumber = _accountNumberController.text.replaceAll(RegExp(r'\s+'), '');
    final String accountType = _accountTypeController.text;
    final String bank = _bankController.text;

    if(!isValidString(accountNumber, r'^[0-9]{8,12}$')){showToast(message: "Invalid Account Number. Must be 8-12 digits long."); return;}
    if(!isValidString(billingName, r'^[a-zA-Z/\s]+$')){showToast(message: "Invalid Holder Name"); return;}
    if(!isValidString(accountType, r'^[a-zA-Z/\s]+$')){showToast(message: "Invalid Holder Name"); return;}
    if(!isValidString(bank, r'^[a-zA-Z/\s]+$')){showToast(message: "Invalid Bank Name"); return;}



    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('client_cards').add({
          'userId': user.uid,
          'billingName': billingName,
          'accountNumber': accountNumber,
          'accountType': accountType,
          'bank': bank,
        });
        
        widget.onRegisterComplete();
      } catch (e) {
        showToast(message: 'Failed to save card details: $e');
      }
    }
    setState((){
      _isLoading = false;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          _buildLabeledTextField('Enter billing name *', 'Enter name', _billingNameController),
          const SizedBox(height: 15),
          _buildLabeledTextField('Account number *', 'Enter number', _accountNumberController),
          const SizedBox(height: 15),
          _buildLabeledTextField('Account type *', 'Enter type', _accountTypeController),
          const SizedBox(height: 15),
          _buildLabeledTextField('Bank *', 'Enter bank name', _bankController),
          const SizedBox(height: 25),
          Center(
            child: SizedBox(
              width: 200,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  // Handle the submission or navigation to the next step
                  _saveCardDetails();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF58C6A9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
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
                : const Text(
                  'Join',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabeledTextField(String label, String hintText, TextEditingController controller, {bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          obscureText: obscureText,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          cursorColor: const Color(0xFF58C6A9),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF58C6A9)),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
          ),
        )
      ],
    );
  }
}
