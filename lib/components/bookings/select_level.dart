import 'package:flutter/material.dart';
import 'package:smart_parking_system/components/bookings/make_booking.dart';

class LevelSelectPage extends StatefulWidget {
  final String bookedAddress;
  final double price;
  final String selectedZone;
  
  const LevelSelectPage({required this.bookedAddress, required this.price, required this.selectedZone, super.key});

  @override
  State<LevelSelectPage> createState() => _LevelSelectPageState();
}

class _LevelSelectPageState extends State<LevelSelectPage> {
  String? selectedLevel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D2F41),
      body: SafeArea(
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
                    onPressed: () => Navigator.of(context).pop(),
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
                  child: const Text(
                    '120 spaces available',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // const Center(
              //   child: Text(
              //     'Parking',
              //     style: TextStyle(color: Color(0xFF58C6A9), fontSize: 16, fontWeight: FontWeight.bold),
              //   ),
              // ),
              // const Center(
              //   child: Text(
              //     'Floors',
              //     style: TextStyle(color: Color(0xFF58C6A9), fontSize: 16, fontWeight: FontWeight.bold),
              //   ),
              // ),
              const SizedBox(height: 16),
              Center(
                child: Container(
                  width: 330,
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    // border: Border.all(color: Colors.white., width: 2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    children: [
                      _buildLevelButton('L2', 0),
                      _buildLevelButton('L1', 30),
                      _buildLevelButton('Ground', 30),
                      _buildLevelButton('B1', 0),
                      _buildLevelButton('B2', 30),
                    ],
                  ),
                ),
              ),
              const Spacer(),
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
                                builder: (_) => BookingPage(
                                  bookedAddress: widget.bookedAddress,
                                  price: widget.price,
                                  selectedZone: widget.selectedZone,
                                  selectedLevel: selectedLevel!,
                                ),
                              ),
                            );
                          }
                        : null,
                    child: const Text('Continue', style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLevelButton(String level, int slots) {
    bool isSelected = selectedLevel == level;
    bool isAvailable = slots > 0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isAvailable
              ? (isSelected ? const Color(0xFF58C6A9) : const Color(0xFF39C16B))
              : const Color(0xFFA81D1D),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        ),
        onPressed: isAvailable
            ? () {
                setState(() {
                  selectedLevel = level;
                });
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
        child: Row(
          children: [
            const Icon(Icons.directions_car, color: Colors.white),
            const SizedBox(width: 10),
            Text(level, style: const TextStyle(color: Colors.white, fontSize: 18)),
            const Spacer(),
            Text('$slots Slots', style: const TextStyle(color: Colors.white, fontSize: 18)),
          ]
        ),
      ),
    );
  }
}