import 'package:flutter/material.dart';

class Registration4 extends StatefulWidget {
  const Registration4({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _Registration4State createState() => _Registration4State();
}

class _Registration4State extends State<Registration4> {
  double _pricePerHour = 20.0; // Default price

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          _buildPriceText(),
          const SizedBox(height: 15),
          _buildPriceSlider(),
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
        ],
      ),
    );
  }

  Widget _buildPriceText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Select pricing per hour *",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "R${_pricePerHour.toInt()}",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceSlider() {
    return Slider(
      value: _pricePerHour,
      min: 10,
      max: 100,
      divisions: 90,
      activeColor: const Color(0xFF58C6A9),
      inactiveColor: Colors.grey,
      onChanged: (value) {
        setState(() {
          _pricePerHour = value;
        });
      },
    );
  }
}