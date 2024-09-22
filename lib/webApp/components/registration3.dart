import 'package:flutter/material.dart';

class Registration3 extends StatefulWidget {
  const Registration3({Key? key}) : super(key: key);

  @override
  _Registration3State createState() => _Registration3State();
}

class _Registration3State extends State<Registration3> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabeledTextField('Number of zones *', 'Enter number of zones'),
          const SizedBox(height: 15),
          _buildLabeledTextField('Number of floors in each zone *', 'Enter number of floors'),
          const SizedBox(height: 15),
          _buildLabeledTextField('Number of rows on each floor *', 'Enter number of rows'),
          const SizedBox(height: 15),
          _buildLabeledTextField('Number of slots in each row *', 'Enter number of slots'),
          const SizedBox(height: 25),
          Center(
            child: SizedBox(
              width: 200,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  // Handle next step action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF58C6A9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget _buildLabeledTextField(String label, String hintText) {
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
        ),
      ],
    );
  }
}
