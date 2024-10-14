import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_parking_system/components/common/common_functions.dart';

class ParkingDetails extends StatefulWidget {
  const ParkingDetails({super.key});

  @override
  State<ParkingDetails> createState() => _ParkingDetailsState();
}

class _ParkingDetailsState extends State<ParkingDetails> {
  int totalSlots = 0;
  int totalZones = 0;
  int totalFloors = 0;
  int rowsPerZone = 0;

  @override
  void initState() {
    super.initState();
    _loadParkingData();
  }

  Future<void> _loadParkingData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      // Handle the case when the user is not logged in
      if (kDebugMode) {
        print('No user is currently logged in.');
      }
      return;
    }

    try {
      if (kDebugMode) {
        print('Current user UID: ${currentUser.uid}');
      }

      // Query the 'parkings' collection where 'userId' equals the current user's UID
      var parkingQuerySnapshot = await FirebaseFirestore.instance
          .collection('parkings')
          .where('userId', isEqualTo: currentUser.uid)
          .get();

      if (parkingQuerySnapshot.docs.isNotEmpty) {
        // Assuming the user has only one parking document
        var parkingDoc = parkingQuerySnapshot.docs.first;
        var parkingDocRef = parkingDoc.reference;

        int totalSlotsAvailable = extractTotalSlotsAvailable(parkingDoc.get('slots_available') as String);

        var zonesSnapshot = await parkingDocRef.collection('zones').get();
        if (kDebugMode) {
          print('Fetched zones snapshot. Number of zones: ${zonesSnapshot.docs.length}');
        }

        if (zonesSnapshot.docs.isNotEmpty) {
          // Assuming the user has only one parking document
          var zonesDoc = zonesSnapshot.docs.first;
          var zonesDocRef = zonesDoc.reference;

          var levelsSnapshot = await zonesDocRef.collection('levels').get();
          if (kDebugMode) {
            print('Fetched levels snapshot. Number of levels: ${levelsSnapshot.docs.length}');
          }
          
          
          if (levelsSnapshot.docs.isNotEmpty) {
            // Assuming the user has only one parking document
            var levelsDoc = levelsSnapshot.docs.first;
            var levelsDocRef = levelsDoc.reference;

            var rowsSnapshot = await levelsDocRef.collection('rows').get();
            if (kDebugMode) {
              print('Fetched rows snapshot. Number of rows: ${rowsSnapshot.docs.length}');
            }

            setState(() {
              totalSlots = totalSlotsAvailable;
              totalZones = zonesSnapshot.docs.length;
              totalFloors = levelsSnapshot.docs.length;
              rowsPerZone = rowsSnapshot.docs.length;
            });
            if (kDebugMode) {
              print('Updated state with totalSlots: $totalSlots, totalZones: $totalZones, totalFloors: $totalFloors, rowsPerZone: $rowsPerZone');
            }

          } else {
            if (kDebugMode) {
              print('No zone document found for the current user UID: ${currentUser.uid}');
            }
          }
        } else {
          if (kDebugMode) {
            print('No zone document found for the current user UID: ${currentUser.uid}');
          }
        }
      } else {
        // Handle the case when there is no parking document for the current user
        if (kDebugMode) {
          print('No parking document found for the current user UID: ${currentUser.uid}');
        }
      }
    } catch (e) {
      // Handle any errors
      if (kDebugMode) {
        print('Error loading parking data: $e');
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1A1F37),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Parking Layout Details',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 44),
            _buildDetailItem('Total Parking Slots', totalSlots.toString()),
            _buildDetailItem('Zones', totalZones.toString()),
            _buildDetailItem('Floors', totalFloors.toString()),
            _buildDetailItem('Rows per Zone', rowsPerZone.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
