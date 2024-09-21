import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(70),
                              bottomRight: Radius.circular(70),
                            ),
                          ),
                          color: const Color(0xFF23223A),
                          elevation: 6.0,
                          child: SingleChildScrollView( // Wrap here
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
                                // Step indicators with arrow-like design
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildStyledStepIndicator(1, true),
                                    const SizedBox(width: 10),
                                    _buildStyledStepIndicator(2, false),
                                    const SizedBox(width: 10),
                                    _buildStyledStepIndicator(3, false),
                                    const SizedBox(width: 10),
                                    _buildStyledStepIndicator(4, false),
                                    const SizedBox(width: 10),
                                    _buildStyledStepIndicator(5, false),
                                  ],
                                ),
                                const SizedBox(height: 40),
                                const Text(
                                  'Get started',
                                  style: TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  'Please enter your details',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 40),
                                _buildLabeledTextField('Account holder name *', 'Enter your name'),
                                const SizedBox(height: 15),
                                _buildLabeledTextField('Company name *', 'Enter company name'),
                                const SizedBox(height: 15),
                                _buildLabeledTextField('Email *', 'Enter your email'),
                                const SizedBox(height: 15),
                                _buildLabeledTextField('Password *', 'Enter your password', obscureText: true),
                                const SizedBox(height: 25),
                                Center(
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
                                const SizedBox(height: 15),
                                Center(
                                  child: RichText(
                                    text: TextSpan(
                                      text: "Already have an account? ",
                                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                                      children: [
                                        TextSpan(
                                          text: 'Log in here',
                                          style: const TextStyle(
                                            color: Color(0xFF58C6A9),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              // Navigate to login page
                                            },
                                        ),
                                      ],
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
                ),
                Expanded(
                  flex: 1,
                  child: Image.asset(
                    'assets/parking.png',
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

  // Build the styled step indicator with arrow-like shape
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

  // Build labeled text field
  Widget _buildLabeledTextField(String label, String hintText, {bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        _buildTextField(hintText, obscureText: obscureText),
      ],
    );
  }

  Widget _buildTextField(String hintText, {bool obscureText = false}) {
    return TextField(
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      cursorColor: const Color(0xFF58C6A9),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF58C6A9)),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 8),
      ),
    );
  }
}

// ArrowClipper class to create the arrow-like shape
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

 
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
