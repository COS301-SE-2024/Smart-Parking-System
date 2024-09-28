import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_parking_system/components/common/toast.dart';
import 'package:smart_parking_system/webApp/components/registration1.dart';

class Registration6 extends StatefulWidget {
  final Function onRegisterComplete;

  const Registration6({super.key, required this.onRegisterComplete});

  @override
  _Registration6State createState() => _Registration6State();
}

class _Registration6State extends State<Registration6> {
  final TextEditingController _parkingNameController = TextEditingController();
  final TextEditingController _parkingDescriptionController = TextEditingController();
  bool _isLoading = false;
  List<Offset> _markers = [];

  Future<void> _saveParkingDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final String parkingName = _parkingNameController.text;
      final String parkingDescription = _parkingDescriptionController.text;

      if (parkingName.isEmpty || parkingDescription.isEmpty || _markers.isEmpty) {
        showToast(message: 'Please fill out all fields and add a marker.');
        return;
      }

      // Save logic for parking name, description, and markers goes here

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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          const Text(
            'Pin the parking zones below *',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          const Text(
            'Select the area on the map to place a parking zone to indicate the zones at your parking location',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: GestureDetector(
                onTapUp: (TapUpDetails details) {
                  setState(() {
                    _markers.add(details.localPosition);
                  });
                },
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/map_placeholder.png',
                      height: 400,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    ..._markers.map((offset) => Positioned(
                      left: offset.dx - 15,
                      top: offset.dy - 30,
                      child: Icon(Icons.local_parking, color: Colors.green, size: 30),
                    )).toList(),
                  ],
                ),
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.local_parking, color: Colors.green, size: 30),
              SizedBox(width: 10),
              Text(
                'Denotes a Parking Zone',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),

          const SizedBox(height: 15),
          Center(
            child: SizedBox(
              width: 200,
              height: 40,
              child: ElevatedButton(
                onPressed: _saveParkingDetails,
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
                        'Save',
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
}