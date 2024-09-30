import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ParkingDetails extends StatefulWidget {
  const ParkingDetails({super.key});

  @override
  State<ParkingDetails> createState() => _ParkingDetailsState();
}

class _ParkingDetailsState extends State<ParkingDetails> {
  int totalSlots = 750;
  int totalZones = 3;
  int totalFloors = 3;
  int rowsPerZone = 25;

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

        if (kDebugMode) {
          print('Parking document found with ID: ${parkingDoc.id}');
          print('Parking document data: ${parkingDoc.data()}');
        }

        var zonesCollection = parkingDocRef.collection('zones');
        var zonesSnapshot = await zonesCollection.get();

        if (kDebugMode) {
          print('Fetched zones snapshot. Number of zones: ${zonesSnapshot.docs.length}');
        }

        if (zonesSnapshot.docs.isNotEmpty) {
          int slots = 0;
          for (var doc in zonesSnapshot.docs) {
            var data = doc.data();
            if (kDebugMode) {
              print('Zone document ID: ${doc.id}');
              print('Zone document data: $data');
            }

            var slotsAvailableStr = data['slots_available']; // Format 'available/total'
            if (slotsAvailableStr != null && slotsAvailableStr.contains('/')) {
              var parts = slotsAvailableStr.split('/');
              if (parts.length == 2) {
                var totalSlotsStr = parts[1];
                slots += int.parse(totalSlotsStr);
                if (kDebugMode) {
                  print('Total slots in this zone: $totalSlotsStr');
                  print('Accumulated slots: $slots');
                }
              } else {
                if (kDebugMode) {
                  print('Unexpected slots_available format in zone ${doc.id}: $slotsAvailableStr');
                }
              }
            } else {
              if (kDebugMode) {
                print('slots_available is null or improperly formatted in zone ${doc.id}');
              }
            }
          }
          setState(() {
            totalSlots = slots;
            totalZones = zonesSnapshot.docs.length;
            totalFloors = 3; // Update as necessary
          });
          if (kDebugMode) {
            print('Updated state with totalSlots: $totalSlots, totalZones: $totalZones, totalFloors: $totalFloors');
          }
        } else {
          if (kDebugMode) {
            print('No zones found in the zones subcollection.');
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
