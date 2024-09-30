import 'package:firebase_auth/firebase_auth.dart';
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
  int rowsPerZone = 25;  // Given that one zone has 25 rows

  @override
  void initState() {
    super.initState();
    _loadParkingData();
  }

  Future<void> _loadParkingData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    // var collection = FirebaseFirestore.instance.collection('parkings').doc('FRT...').collection('zones');
    // var collection = FirebaseFirestore.instance.collection('parkings').doc(currentUser!.uid).collection('zones');
    var collection = FirebaseFirestore.instance.collection('parkings').doc('FRT...').collection('zones');
    var snapshot = await collection.get();
    if (snapshot.docs.isNotEmpty) {
      int slots = 0;
      for (var doc in snapshot.docs) {
        slots += int.parse(doc.data()['slots_available'].split('/')[1]); // Assuming the format 'available/total'
      }
      setState(() {
        totalSlots = slots;
        totalZones = snapshot.docs.length;
        totalFloors = 5;
      });
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
