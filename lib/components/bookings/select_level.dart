import 'package:flutter/material.dart';
import 'package:smart_parking_system/components/bookings/make_booking.dart';
// import 'package:smart_parking_system/components/bookings/select_zone.dart';

class LevelSelectPage extends StatefulWidget {
  final String bookedAddress;
  final String selectedZone;
  
  const LevelSelectPage({required this.bookedAddress, required this.selectedZone, super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LevelSelectPageState createState() => _LevelSelectPageState();
}

class _LevelSelectPageState extends State<LevelSelectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D2F41),
      body: Container(
        color: const Color(0xFF2D2F41),
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 15),
              color: const Color(0xFF2D2F41),
              child: Stack(
                children: [
                  Builder(
                    builder: (BuildContext context) {
                      return IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 30.0),
                        onPressed: () {
                          // Replace this with your main page route
                          // Navigator.of(context).pushReplacement(
                          //   MaterialPageRoute(
                          //     builder: (_) => const ZoneSelectPage(),
                          //   ),
                          // );
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Parking Slot (Level)',
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
            Text(
              'Select prefered Level (Zone ${widget.selectedZone})',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildZoneCard(
                  context: context,
                  level: '1',
                  availableSlots: 2,
                  isAvailable: true,
                ),
                _buildZoneCard(
                  context: context,
                  level: '2',
                  availableSlots: 2,
                  isAvailable: true,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildZoneCard(
                  context: context,
                  level: '3',
                  availableSlots: 1,
                  isAvailable: true,
                ),
                _buildZoneCard(
                  context: context,
                  level: '4',
                  availableSlots: 0,
                  isAvailable: false,
                ),
              ],
            ),
          ],
        ),
        ),
        
      ),
    );
  }

  Widget _buildZoneCard({
    required BuildContext context,
    required String level,
    required int availableSlots,
    required bool isAvailable,
  }) {
    return GestureDetector(
      onTap: isAvailable
          ? () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BookingPage(bookedAddress: widget.bookedAddress, selectedZone: widget.selectedZone, selectedLevel: level,),
                ),
              );
            }
          : () {
          showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: const Color(0xFF2D2F41),
              title: const Center(
                child: Text('No Slots Available!', style: TextStyle(color: Colors.white)),
              ),
              actions: [
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK', style: TextStyle(color: Color(0xFF58C6A9))),
                  ),
                ),
              ],
            );
          },
        );
      },
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: isAvailable ? const Color(0xFF2A4037) : const Color(0xFF490517),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Text(
                level,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                'Level: $level',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                'Available Slots: $availableSlots',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}