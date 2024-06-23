import 'package:flutter/material.dart';
import 'package:smart_parking_system/components/bookings/select_level.dart';
import 'package:smart_parking_system/components/main_page.dart';

class ZoneSelectPage extends StatefulWidget {
  const ZoneSelectPage({super.key});

  @override
  State<ZoneSelectPage> createState() => _ZoneSelectPageState();
}

class _ZoneSelectPageState extends State<ZoneSelectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF2D2F41),
        padding: const EdgeInsets.all(16),
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
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const MainPage(),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Parking Slot (Zone)',
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
              'Select prefered Zone',
              style: TextStyle(
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
                  zone: 'A',
                  entrance: 'PNP Entrance',
                  availableSlots: 2,
                  isAvailable: true,
                ),
                _buildZoneCard(
                  context: context,
                  zone: 'B',
                  entrance: 'Woolworths Entrance',
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
                  zone: 'C',
                  entrance: 'Clicks Entrance',
                  availableSlots: 1,
                  isAvailable: true,
                ),
                _buildZoneCard(
                  context: context,
                  zone: 'D',
                  entrance: 'Food Court Entrance',
                  availableSlots: 0,
                  isAvailable: false,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildZoneCard({
    required BuildContext context,
    required String zone,
    required String entrance,
    required int availableSlots,
    required bool isAvailable,
  }) {
    return GestureDetector(
      onTap: isAvailable
          ? () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const LevelSelectPage(),
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
        width: 170,
        height: 180,
        decoration: BoxDecoration(
          color: isAvailable ? const Color(0xFF2A4037) : const Color(0xFF490517),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Text(
                zone,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                'Zone $zone',
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
              Text(
                '($entrance)',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
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
