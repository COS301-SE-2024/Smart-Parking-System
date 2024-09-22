import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_parking_system/WebComponents/dashboard/dashboard_screen.dart';
import 'package:smart_parking_system/components/common/common_functions.dart';
import 'package:smart_parking_system/components/common/toast.dart';

class Registration5 extends StatefulWidget {
  const Registration5({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _Registration5State createState() => _Registration5State();
}

class _Registration5State extends State<Registration5> {
  final TextEditingController _billingNameController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _accountTypeController = TextEditingController();
  final TextEditingController _bankController = TextEditingController();

  Future<void> _saveCardDetails() async {
    User? user = FirebaseAuth.instance.currentUser;

    final String billingName = _billingNameController.text;
    final String accountNumber = _accountNumberController.text.replaceAll(RegExp(r'\s+'), '');
    final String accountType = _accountTypeController.text;
    final String bank = _bankController.text;

    if (!isValidString(accountNumber, r'^[0-9]{8,12}$')) {
      showToast(message: "Invalid Account Number. Must be 8-12 digits long.");
      return;
    }
    if(!isValidString(billingName, r'^[a-zA-Z/\s]+$')){showToast(message: "Invalid Holder Name"); return;}
    if(!isValidString(accountType, r'^[a-zA-Z/\s]+$')){showToast(message: "Invalid Holder Name"); return;}
    if(!isValidString(bank, r'^[a-zA-Z]+$')){showToast(message: "Invalid Bank Name"); return;}



    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('client_cards').add({
          'userId': user.uid,
          'billingName': billingName,
          'accountNumber': accountNumber,
          'accountType': accountType,
          'bank': bank,
        });

        if (mounted) {  // Check if the widget is still mounted
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const DashboardScreen(),
            ),
          );
        }
      } catch (e) {
        // 这里可以添加更多错误处理逻辑，例如显示错误消息给用户
        if (mounted) {  // Check if the widget is still mounted
          showToast(message: 'Failed to save card details: $e');
        }
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          _buildLabeledTextField('Enter billing name *', 'Enter name'),
          const SizedBox(height: 15),
          _buildLabeledTextField('Account number *', 'Enter number'),
          const SizedBox(height: 15),
          _buildLabeledTextField('Account type *', 'Enter type'),
          const SizedBox(height: 15),
          _buildLabeledTextField('Bank *', 'Enter bank name'),
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
                child: const Text(
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

  Widget _buildLabeledTextField(String label, String hintText, {bool obscureText = false}) {
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
        if (label == 'Enter billing name *')
          _buildBillingNameTextField(hintText, obscureText: obscureText)
        else if (label == 'Account number *')
          _buildAccountNumberTextField(hintText, obscureText: obscureText)
        else if (label == 'Account type *')
          _buildAccountTypeTextField(hintText, obscureText: obscureText)
        else if (label == 'Bank *')
          _buildBankTextField(hintText, obscureText: obscureText),
      ],
    );
  }

  Widget _buildBillingNameTextField(String hintText, {bool obscureText = false}) {
    return TextField(
      controller: _billingNameController,
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
    );
  }

  Widget _buildAccountNumberTextField(String hintText, {bool obscureText = false}) {
    return TextField(
      controller: _accountNumberController,
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
    );
  }

  Widget _buildAccountTypeTextField(String hintText, {bool obscureText = false}) {
    return TextField(
      controller: _accountTypeController,
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
    );
  }

  Widget _buildBankTextField(String hintText, {bool obscureText = false}) {
    return TextField(
      controller: _bankController,
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
    );
  }
}