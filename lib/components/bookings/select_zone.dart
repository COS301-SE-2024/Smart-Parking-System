import 'package:flutter/material.dart';
import 'package:smart_parking_system/components/bookings/select_level.dart';
//Firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_parking_system/components/common/toast.dart';

class ZoneSelectPage extends StatefulWidget {
  final double price;
  final String bookedAddress;
  const ZoneSelectPage({required this.bookedAddress, required this.price, super.key});

  @override
  State<ZoneSelectPage> createState() => _ZoneSelectPageState();
}

class Zone {
  final String zone;
  final int slots;
  final int timeDistance;
  final double x;
  final double y;

  Zone(this.zone, this.slots, this.timeDistance, this.x, this.y);
}

String extractSlotsAvailable(String slots) {
  RegExp regex = RegExp(r'^\d+');
  Match? match = regex.firstMatch(slots);

  if (match != null) {
    String number = match.group(0)!;
    return number;
  }
  return "0";
}

class _ZoneSelectPageState extends State<ZoneSelectPage> {
  String? selectedZone;
  int totalSlots = 0;
  List<Zone> zones = [];

  Future<void> getDetails() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot = await firestore
          .collection('parkings')
          .where('name', isEqualTo: widget.bookedAddress)
          .get();

      DocumentSnapshot documentSnapshot = querySnapshot.docs[0];

      if (documentSnapshot.exists) {
        CollectionReference zonesCollection = documentSnapshot.reference.collection('zones');
        QuerySnapshot zonesQuerySnapshot = await zonesCollection.get();
        if (zonesQuerySnapshot.docs.isNotEmpty) {
          for (var zoneDocument in zonesQuerySnapshot.docs) {
            String zone = zoneDocument.id;
            String slots = zoneDocument.get('slots') as String;
            int x = zoneDocument.get('x') as int;
            int y = zoneDocument.get('y') as int;

            int availableSlots = int.parse(extractSlotsAvailable(slots));

            zones.add(Zone(
              zone,
              availableSlots,
              5,
              double.parse(x.toString()),
              double.parse(y.toString()),
            ));
          }

          zones.sort((a, b) => a.zone.compareTo(b.zone));
        } else {
          showToast(message: 'No zones found for parking: ${widget.bookedAddress}');
        }
      } else {
        showToast(message: 'No parkings found called: ${widget.bookedAddress}');
      }
      totalSlots = zones.fold(0, (tot, zone) => tot + zone.slots);
    } catch (e) {
      showToast(message: 'Error retrieving zone details: $e');
    }

    setState(() {});
  }

  void selectZone(String zone) {
    setState(() {
      selectedZone = zone;
    });
  }

  @override
  void initState() {
    super.initState();
    getDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D2F41),
      body: Container(
        color: const Color(0xFF2D2F41),
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Container(
            color: const Color(0xFF2D2F41),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 15),
                  color: const Color(0xFF2D2F41),
                  child: Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 30.0),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Parking Zones',
                          style: TextStyle(
                            color: Colors.tealAccent,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Text(
                  'Choose Your Parking\nZone',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.white),
                  ),
                  child: Text(
                    '$totalSlots spaces available',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: selectedZone == null ? Colors.green : const Color(0xFF58C6A9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Icon(Icons.local_parking, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Denotes a Parking Zone',
                      style: TextStyle(
                        color: Colors.tealAccent,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                LayoutBuilder(
                  builder: (context, constraints) {
                    // Calculate the size of the map based on the screen width
                    double mapWidth = constraints.maxWidth * 0.8;
                    double mapHeight = mapWidth * 0.67; // Maintain aspect ratio of the image

                    return SizedBox(
                      width: mapWidth,
                      height: mapHeight,
                      child: Stack(
                        children: [
                          Image.asset(
                            'assets/s-map.png', // Replace with your image path
                            width: mapWidth,
                            height: mapHeight,
                            fit: BoxFit.contain,
                          ),
                          ...zones.map((zone) => _buildZoneButton(zone)),
                        ],
                      ),
                    );
                  },
                ),
                if (selectedZone != null) ...[
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF34354A),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Zone $selectedZone',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Spaces Available: ${zones.firstWhere((z) => z.zone == selectedZone).slots} slots',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Distance to Zone: ${zones.firstWhere((z) => z.zone == selectedZone).timeDistance} mins drive',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    width: 160,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedZone != null ? const Color(0xFF58C6A9) : const Color(0xFF5B5B5B),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      onPressed: selectedZone != null
                          ? () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => LevelSelectPage(
                              bookedAddress: widget.bookedAddress,
                              price: widget.price,
                              selectedZone: selectedZone!,
                            ),
                          ),
                        );
                      }
                          : null,
                      child: const Text('Continue', style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildZoneButton(Zone zones) {
    return Positioned(
      left: zones.x,
      top: zones.y,
      child: GestureDetector(
        onTap: () {
          selectZone(zones.zone);
        },
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: selectedZone == zones.zone ? const Color(0xFF58C6A9) : Colors.green,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Icon(Icons.local_parking, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
