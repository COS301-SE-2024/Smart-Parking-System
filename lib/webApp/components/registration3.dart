import 'package:flutter/material.dart';
import 'package:smart_parking_system/components/common/toast.dart';

import 'package:smart_parking_system/webApp/components/registration1.dart';


class Registration3 extends StatefulWidget {
  final Function onRegisterComplete;
  final ParkingSpot ps;

  const Registration3({super.key, required this.ps, required this.onRegisterComplete});

  @override
  // ignore: library_private_types_in_public_api
  _Registration3State createState() => _Registration3State();
}

class _Registration3State extends State<Registration3> {
  final TextEditingController _noZonesController = TextEditingController();
  final TextEditingController _noFloorsController = TextEditingController();
  final TextEditingController _noRowsController = TextEditingController();
  final TextEditingController _noSlotsController = TextEditingController();
  bool _isLoading = false;

  Future<void> _saveParkingDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final int noZones = int.parse(_noZonesController.text);
      final int noFloors = int.parse(_noFloorsController.text);
      final int noRows = int.parse(_noRowsController.text);
      final int noSlots = int.parse(_noSlotsController.text);

      widget.ps.noZones = noZones;
      widget.ps.noLevels = noFloors;
      widget.ps.noRows = noRows;
      widget.ps.noSlotsPerRow = noSlots;

      widget.onRegisterComplete();
    } catch (e) {
      showToast(message: 'Failed to save parking details: $e');
    }
      
    setState(() {
      _isLoading = false;
    });
  }
 
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabeledTextField('Number of zones *', 'Enter number of zones', _noZonesController),
          const SizedBox(height: 15),
          _buildLabeledTextField('Number of floors in each zone *', 'Enter number of floors', _noFloorsController),
          const SizedBox(height: 15),
          _buildLabeledTextField('Number of rows on each floor *', 'Enter number of rows', _noRowsController),
          const SizedBox(height: 15),
          _buildLabeledTextField('Number of slots in each row *', 'Enter number of slots', _noSlotsController),
          const SizedBox(height: 25),
          Center(
            child: SizedBox(
              width: 200,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  // Handle next step action
                  _saveParkingDetails();
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
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget _buildLabeledTextField(String label, String hintText, TextEditingController controller) {
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
