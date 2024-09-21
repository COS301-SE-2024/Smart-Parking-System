import 'package:flutter/material.dart';

class Registration4 extends StatefulWidget {
  const Registration4({Key? key}) : super(key: key);

  @override
  _Registration4State createState() => _Registration4State();
}

class _Registration4State extends State<Registration4> {
  double _pricePerHour = 20.0; // Default price

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A1A2E),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/backW.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.zero,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 600,
                        height: MediaQuery.of(context).size.height, // Full height
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(70),
                              bottomRight: Radius.circular(70),
                            ),
                          ),
                          color: const Color(0xFF23223A),
                          elevation: 6.0,
                          child: Column(
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  padding: const EdgeInsets.all(30.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Image.asset(
                                          'assets/logo2.png',
                                          height: 70,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          _buildStyledStepIndicator(1, false),
                                          const SizedBox(width: 10),
                                          _buildStyledStepIndicator(2, false),
                                          const SizedBox(width: 10),
                                          _buildStyledStepIndicator(3, false),
                                          const SizedBox(width: 10),
                                          _buildStyledStepIndicator(4, true), // Current step
                                          const SizedBox(width: 10),
                                          _buildStyledStepIndicator(5, false),
                                        ],
                                      ),
                                      const SizedBox(height: 120), // Increased space above pricing
                                      // Center the pricing and slider
                                      Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center, // Center pricing and slider
                                          children: [
                                            Text(
                                              "Select pricing per hour*",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Center(
                                              child: Text(
                                                "R${_pricePerHour.toInt()}",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 50,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Slider(
                                              value: _pricePerHour,
                                              min: 10,
                                              max: 100,
                                              divisions: 9,
                                              activeColor: const Color(0xFF58C6A9),
                                              inactiveColor: Colors.grey,
                                              onChanged: (double value) {
                                                setState(() {
                                                  _pricePerHour = value;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 25),
                                    ],
                                  ),
                                ),
                              ),
                              // Align button at the bottom
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 30.0),
                                  child: SizedBox(
                                    width: 200,
                                    height: 40,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // Handle next step action
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF58C6A9),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                      child: const Text(
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
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Image.asset(
                    'assets/parking.png', // Replace with the 3D model asset for parking visual
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Function to create custom arrow step indicators
  Widget _buildStyledStepIndicator(int step, bool isActive) {
    return ClipPath(
      clipper: ArrowClipper(),
      child: Container(
        width: 85,
        height: 80,
        color: isActive ? const Color(0xFF58C6A9) : const Color(0xFF2B2B45),
        child: Center(
          child: Text(
            step.toString(),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

// Custom clipper to create the arrow shape for step indicators
class ArrowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, size.height * 0.25);
    path.lineTo(size.width * 0.9, size.height * 0.25);
    path.lineTo(size.width, size.height * 0.5);
    path.lineTo(size.width * 0.9, size.height * 0.75);
    path.lineTo(0, size.height * 0.75);
    path.lineTo(size.width * 0.1, size.height * 0.5);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
