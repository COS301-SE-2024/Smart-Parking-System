import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_parking_system/WebComponents/dashboard/dashboard_screen.dart';
import 'package:smart_parking_system/components/common/common_functions.dart';
import 'package:smart_parking_system/components/common/toast.dart';
import 'package:smart_parking_system/webApp/components/registration4.dart';

class Registration3 extends StatefulWidget {
  final Function onRegisterComplete;

  const Registration3({super.key, required this.onRegisterComplete});

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
    User? user = FirebaseAuth.instance.currentUser;

    final int noZones = int.parse(_noZonesController.text);
    final int noFloors = int.parse(_noFloorsController.text);
    final int noRows = int.parse(_noRowsController.text);
    final int noSlots = int.parse(_noSlotsController.text);
    final int totalSlots = noZones * noFloors * noRows * noSlots;
    // List of predefined level names
    List<String> levels = ['B2', 'B1', 'Ground', 'L1', 'L2'];
    List<String> alphabet = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'];
    setState(() {
      _isLoading = true;
    });

    if (user != null) {
      try {
        DocumentReference parkingDoc = await FirebaseFirestore.instance.collection('parkings').add({
          'userId': user.uid,
          'latitude': null, // Replace with actual data if available
          'longitude': null, // Replace with actual data if available
          'name': null, // Replace with actual parking name if available
          'price': null, // Replace with actual price if needed
          'slots_available': totalSlots, // Total number of slots available across all zones
        });
        int totalZoneSlots = (totalSlots / noZones).floor();
        for (int zoneIndex = 1; zoneIndex <= noZones; zoneIndex++) {
          // Create a zone document
          
          DocumentReference zoneDoc = parkingDoc.collection('zones').doc(alphabet[zoneIndex-1]);
          await zoneDoc.set({
            'slots': totalZoneSlots, // Slots per zone
            'x': null,
            'y': null,
          });
          
          // Loop over predefined levels and create documents for each level
          for (int levelIndex = 0; levelIndex < noFloors; levelIndex++) {
            if (levelIndex < levels.length) {
              String levelName = levels[levelIndex];
              
              // Add the level document
              DocumentReference levelDoc = zoneDoc.collection('levels').doc(levelName);
              await levelDoc.set({
                'slots': totalZoneSlots / noFloors, // Slots per zone
              });
              
              // Add rows to each level
              for (int rowIndex = 1; rowIndex <= noRows; rowIndex++) {
                await levelDoc.collection('rows').doc(alphabet[rowIndex-1]).set({
                  'slots': noSlots, // Total number of slots in the row
                });
              }
            }
          }
        }

        setState(() {
          _isLoading = false;
        });

        widget.onRegisterComplete();
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        if (mounted) {
          showToast(message: 'Failed to save parking details: $e');
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

  Widget _buildLabeledTextField(String label, String hintText) {

    TextEditingController getController(String label) {
      switch (label) {
        case 'Number of zones *':
          return _noZonesController;
        case 'Number of floors in each zone *':
          return _noFloorsController;
        case 'Number of rows on each floor *':
          return _noRowsController;
        case 'Number of slots in each row *':
          return _noSlotsController;
        default:
          return TextEditingController(); // Default controller if no match
      }
    }

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
          controller: getController(label),
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
