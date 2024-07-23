// select_row.dart
import 'package:flutter/material.dart';

class SelectRowPage extends StatelessWidget {
  final String bookedAddress;
  final double price;
  final String selectedZone;
  final String selectedLevel;

  const SelectRowPage({
    required this.bookedAddress,
    required this.price,
    required this.selectedZone,
    required this.selectedLevel,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int totalSlots = 8;

    return Scaffold(
      backgroundColor: const Color(0xFF2D2F41),
      body: SingleChildScrollView(
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
                      'Parking Slot',
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
                  'Row',
                  style: const TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 80),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    '$totalSlots spaces available',
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Container(
                  width: 300, // 控制虚线的总体长度
                  height: 1,
                  child: CustomPaint(
                    painter: DottedLinePainter(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Container(
                  width: 290,
                  height: 90,
                  decoration: BoxDecoration(
                    color: const Color(0xFF39C16B),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF39C16B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      // Define your onPressed functionality here
                    },
                    child: Stack(
                      children: [
                        Positioned(
                          left: 2,
                          top: 8,
                          child: Text(
                            'Row A',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                        Positioned(
                          right: 2,
                          top: 8,
                          child: Text(
                            '3 Slots Available',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                        Positioned(
                          bottom: 8,
                          left: 2,
                          child: Image.asset(
                            'smallCar.png',
                            width: 30,
                            height: 50,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Add additional buttons or rows as needed
            ],
          ),
        ),
      ),
    );
  }
}

class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    var max = size.width;
    var dashWidth = 5;
    var dashSpace = 5;
    double startX = 0;

    while (startX < max) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}