import 'package:flutter/material.dart';

class Registration5 extends StatefulWidget {
  const Registration5({Key? key}) : super(key: key);

  @override
  _Registration5State createState() => _Registration5State();
}

class _Registration5State extends State<Registration5> {
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
        _buildTextField(hintText, obscureText: obscureText),
      ],
    );
  }

  Widget _buildTextField(String hintText, {bool obscureText = false}) {
    return TextField(
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
        contentPadding: EdgeInsets.symmetric(vertical: 8),
      ),
    );
  }
}