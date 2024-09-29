import 'package:flutter/material.dart';
import 'package:smart_parking_system/components/common/toast.dart';

import 'package:smart_parking_system/webApp/components/registration1.dart';

class Registration5 extends StatefulWidget {
  final Function onRegisterComplete;
  final ParkingSpot ps;

  const Registration5({super.key, required this.ps, required this.onRegisterComplete});

  @override
  // ignore: library_private_types_in_public_api
  _Registration5State createState() => _Registration5State();
}

class _Registration5State extends State<Registration5> {
  double _pricePerHour = 20; // Default price
  bool _isLoading = false;

  Future<void> _clientRegisterParkingDetails() async {
    setState((){
      _isLoading = true;
    });
    
    try {
      widget.ps.price = _pricePerHour.toString();
      
      widget.onRegisterComplete();
    } catch (e) {
      showToast(message: 'Error: $e');
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
                  _clientRegisterParkingDetails();
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
      max: 50,
      divisions: 40,
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
