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
      backgroundColor: const Color(0xFF1A1A2E),
      body: Container(
        height: MediaQuery.of(context).size.height, // Constrain the height
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildImage(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/backW.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: const Color(0xFF23223A),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/logo2.png',
                    height: 70,
                  ),
                  const SizedBox(height: 24),
                  _buildStepIndicators(),
                  const SizedBox(height: 48),
                  _buildPriceText(),
                  const SizedBox(height: 16),
                  _buildPriceSlider(),
                  const SizedBox(height: 24),
                  _buildNextButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(5, (index) =>
          _buildStyledStepIndicator(index + 1, index == 3)),
    );
  }

  Widget _buildPriceText() {
    return Column(
      children: [
        const Text(
          "Select pricing per hour*",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "R${_pricePerHour.toInt()}",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 50,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceSlider() {
    return Slider(
      value: _pricePerHour,
      min: 10,
      max: 100,
      divisions: 9,
      activeColor: const Color(0xFF58C6A9),
      inactiveColor: Colors.grey,
      onChanged: (value) {
        setState(() {
          _pricePerHour = value;
        });
      },
    );
  }

  Widget _buildNextButton() {
    return ElevatedButton(
      onPressed: () {
        // Handle next step action
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF58C6A9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
      ),
      child: const Text(
        'Next',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      height: 300, // Define a fixed height for the image
      constraints: const BoxConstraints(
        maxHeight: 300,
      ),
      child: Image.asset(
        'assets/parking.png',
        fit: BoxFit.cover,
        width: double.infinity,
      ),
    );
  }

  Widget _buildStyledStepIndicator(int step, bool isActive) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF58C6A9) : const Color(0xFF2B2B45),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          step.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
