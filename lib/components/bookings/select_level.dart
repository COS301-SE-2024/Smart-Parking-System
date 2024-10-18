import 'package:flutter/material.dart';
import 'package:smart_parking_system/components/bookings/select_row.dart';
//Firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_parking_system/components/common/custom_widgets.dart';
import 'package:smart_parking_system/components/common/toast.dart';
import 'package:smart_parking_system/components/common/common_functions.dart';

class LevelSelectPage extends StatefulWidget {
  final String bookedAddress;
  final double price;
  final String selectedZone;
  final bool futureBooking;

  const LevelSelectPage({
    required this.bookedAddress,
    required this.price,
    required this.selectedZone,
    required this.futureBooking,
    super.key
  });

  @override
  State<LevelSelectPage> createState() => _LevelSelectPageState();
}

class Level {
  final String level;
  final int slots;

  Level(this.level, this.slots);
}

class _LevelSelectPageState extends State<LevelSelectPage> {
  String? selectedLevel;
  int totalSlots = 0;
  late bool futureBooking;
  bool _isFetching = true;

  List<Level> levels = [
    // Add more levels here
  ];

    // Get details on load
  Future<void> getDetails() async {
    setState(() {
      _isFetching = true;
    });
    try {
      // Get a reference to the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Query the 'parkings' collection for a document with matching name
      QuerySnapshot querySnapshot = await firestore
          .collection('parkings')
          .where('name', isEqualTo: widget.bookedAddress)
          .get();

      // Check if a matching document was found
      if (querySnapshot.docs.isNotEmpty) {
        // Get the document snapshot
        DocumentSnapshot parkingDocumentSnapshot = querySnapshot.docs[0];

        // Get the subcollection 'zones'
        CollectionReference zonesCollection = parkingDocumentSnapshot.reference.collection('zones');

        // Query the 'zones' subcollection for a document with matching id
        DocumentSnapshot zoneDocumentSnapshot = await zonesCollection.doc(widget.selectedZone).get();

        // Check if a matching document was found
        if (zoneDocumentSnapshot.exists) {
          // Get the subcollection 'levels'
          CollectionReference levelsCollection = zoneDocumentSnapshot.reference.collection('levels');

          // Query the 'levels' subcollection for all documents
          QuerySnapshot levelsQuerySnapshot = await levelsCollection.get();

          // Check if there are any documents
          if (levelsQuerySnapshot.docs.isNotEmpty) {
            // Loop through each document
            for (var levelDocument in levelsQuerySnapshot.docs) {
              // Retrieve the fields
              String level = levelDocument.id;
              String slots = levelDocument.get('slots') as String;

              // Calculate total price
              int availableSlots = extractSlotsAvailable(slots);

              // Add to levels list
              levels.add(Level(
                level,
                availableSlots,
              ));
            }

            // Sort the levels list
            levels.sort((a, b) {
              int comparison = b.level.compareTo(a.level);
              if (comparison != 0) {
                return comparison;
              } else {
                return a.level.compareTo(b.level);
              }
            });
          } else {
            // No levels found
            showToast(message: 'No levels found for zone: ${widget.selectedZone}');
          }
        } else {
          // No zone found
          showToast(message: 'No zone found: ${widget.selectedZone}');
        }
      } else {
        // No parking found
        showToast(message: 'No parking found: ${widget.bookedAddress}');
      }

      // Calculate total slots
      totalSlots = levels.fold(0, (tot, level) => tot + level.slots);
    } catch (e) {
      // Handle any errors
      showToast(message: 'Error retrieving level details: $e');
    }

    setState(() {
      _isFetching = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getDetails();
    futureBooking = widget.futureBooking;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D2F41),
      body: _isFetching ? loadingWidget()
      : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 30.0),
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                  const Expanded(
                    child: Text(
                      'Parking Floors',
                      style: TextStyle(color: Color(0xFF58C6A9), fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 48), // To balance the back button
                ],
              ),
              const SizedBox(height: 40),
              const Center(
                child: Text(
                  'Choose your parking',
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
              Center(
                child: Text(
                  'Floor on Zone ${widget.selectedZone}',
                  style: const TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 80),
                  decoration: BoxDecoration(
                    // color: Colors.white,
                    border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    '$totalSlots spaces available',
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Center(
                child: Container(
                  width: 330,
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: levels.expand((levels) => [
                      _buildLevelButton(levels),
                    ]).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: SizedBox(
                  width: 160,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedLevel != null ? const Color(0xFF58C6A9) : const Color(0xFF5B5B5B),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    onPressed: selectedLevel != null
                        ? () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => SelectRowPage( // 导航到 SelectRowPage
                            bookedAddress: widget.bookedAddress,
                            price: widget.price,
                            selectedZone: widget.selectedZone,
                            selectedLevel: selectedLevel!,
                            futureBooking: futureBooking,
                          ),
                        ),
                      );
                    }
                        : null,
                    child: const Text('Continue', style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLevelButton(Level levels) {
    bool isSelected = selectedLevel == levels.level;
    bool isAvailable = levels.slots > 0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isAvailable
              ? (isSelected ? const Color(0xFF58C6A9) : const Color(0xFF39C16B))
              : const Color(0xFFC0C0C0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        ),
        onPressed: isAvailable
            ? () {
                setState(() {
                  selectedLevel = levels.level;
                  futureBooking = false;
                });
              }
            : () {
                setState(() {
                  selectedLevel = levels.level;
                  futureBooking = true;
                  showToast(message: 'This must be a future booking');
                });
              },
        child: Row(
            children: [
              const Icon(Icons.directions_car, color: Colors.white),
              const SizedBox(width: 10),
              Text(levels.level, style: const TextStyle(color: Colors.white, fontSize: 18)),
              const Spacer(),
              Text('${levels.slots} Slots', style: const TextStyle(color: Colors.white, fontSize: 18)),
            ]
        ),
      ),
    );
  }
}