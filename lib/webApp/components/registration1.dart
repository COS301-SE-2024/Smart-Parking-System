import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:smart_parking_system/components/common/toast.dart';
import 'package:smart_parking_system/components/firebase/firebase_auth_services.dart';
import 'package:smart_parking_system/components/firebase/firebase_common_functions.dart';
import 'package:smart_parking_system/webApp/components/login.dart';
import 'package:smart_parking_system/WebComponents/dashboard/dashboard_screen.dart';

import 'package:smart_parking_system/webApp/components/registration2.dart';
import 'package:smart_parking_system/webApp/components/registration3.dart';
import 'package:smart_parking_system/webApp/components/registration4.dart';
import 'package:smart_parking_system/webApp/components/registration5.dart';
import 'package:smart_parking_system/webApp/components/registration6.dart';

class RegistrationPage extends StatefulWidget {
  final int currentStep;

  const RegistrationPage({super.key, this.currentStep = 1});

  @override
  // ignore: library_private_types_in_public_api
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  late int _currentStep;
  ParkingSpot parkingSpot = ParkingSpot();

  @override
  void initState() {
    super.initState();
    _currentStep = widget.currentStep;
  }

  void _goToNextStep() {
    if (_currentStep < 6) {
      if (_currentStep == 5) { addParking(); }
      setState(() {
        _currentStep++;
      });
    }
  }

  void addParking() {
    // User ID
    final User? user = FirebaseAuth.instance.currentUser;
    parkingSpot.userId = user!.uid;

    addParkingToFirestore(
      userId: parkingSpot.userId,
      parkingName: parkingSpot.name,
      operationHours: parkingSpot.operationHours,
      posLatitude: parkingSpot.latitude,
      posLongitude: parkingSpot.longitude,
      noZones: parkingSpot.noZones,
      noBasementLevels: parkingSpot.noBasementLevels,
      noUpperLevels: parkingSpot.noUpperLevels,
      noRows: parkingSpot.noRows,
      noSlotsPerRow: parkingSpot.noSlotsPerRow,
      pricePerHour: parkingSpot.price,
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

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
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (screenWidth > 1000) {
                  return Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: _buildFormCard(),
                      ),
                      Expanded(
                        flex: 1,
                        child: Image.asset(
                          'assets/parking.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  );
                } else {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildFormCard(),
                        const SizedBox(height: 20),
                        Image.asset(
                          'assets/parking.png',
                          fit: BoxFit.cover,
                          width: screenWidth * 0.9,
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard() {
    return Padding(
      padding: EdgeInsets.zero,
      child: Align(
        alignment: Alignment.centerLeft,
        // ignore: sized_box_for_whitespace
        child: Container(
          width: 650,
          child: Card(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(70),
                bottomRight: Radius.circular(70),
              ),
            ),
            color: const Color(0xFF23223A),
            elevation: 6.0,
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
                      _buildStyledStepIndicator(1, _currentStep >= 1),
                      const SizedBox(width: 10),
                      _buildStyledStepIndicator(2, _currentStep >= 2),
                      const SizedBox(width: 10),
                      _buildStyledStepIndicator(3, _currentStep >= 3),
                      const SizedBox(width: 10),
                      _buildStyledStepIndicator(4, _currentStep >= 4),
                      const SizedBox(width: 10),
                      _buildStyledStepIndicator(5, _currentStep >= 5),
                       const SizedBox(width: 10),
                      _buildStyledStepIndicator(6, _currentStep >= 6),
                    ],
                  ),
                  const SizedBox(height: 40),
                  if (_currentStep == 1) Registration1(onRegisterComplete: _goToNextStep,)
                  else if (_currentStep == 2) Registration2(ps: parkingSpot, onRegisterComplete: _goToNextStep,)
                  else if (_currentStep == 3) Registration3(ps: parkingSpot, onRegisterComplete: _goToNextStep,)
                  else if (_currentStep == 4) Registration4(ps: parkingSpot, onRegisterComplete: _goToNextStep,)
                  else if (_currentStep == 5) Registration5(ps: parkingSpot, onRegisterComplete: _goToNextStep,)
                  else if (_currentStep == 6) Registration6(onRegisterComplete: () 
                  { Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const DashboardScreen(),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStyledStepIndicator(int step, bool isActive) {       //Change "This line" for nav
    return GestureDetector(
      // onTap: () => setState(() { _currentStep = step; }),      // This Line
      child: ClipPath(
        clipper: ArrowClipper(),
        child: Container(
          width: 85,
          height: 80,
          color: isActive ? const Color(0xFF58C6A9) : const Color(0xFF2B2B45),
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
        ),
      ),
    );
  }
}

class ParkingSpot {
  late String userId;
  late String name;
  late Map<String, String> operationHours;
  late double latitude;
  late double longitude;
  late int noZones;  
  late int noBasementLevels;
  late int noUpperLevels;
  late int noRows;
  late int noSlotsPerRow;
  late String price;

  
}

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

////////////////////////////////////////////////

class Registration1 extends StatefulWidget {
  final Function onRegisterComplete;

  const Registration1({super.key, required this.onRegisterComplete});

  @override
  // ignore: library_private_types_in_public_api
  _Registration1State createState() => _Registration1State();
}

class _Registration1State extends State<Registration1> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _accountHolderController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final FireBaseAuthServices _auth = FireBaseAuthServices();

  bool _isLoading = false;

  Future<void> registerUser() async {
    setState((){
      _isLoading = true;
    });

    final String password = _passwordController.text;
    final String accountHolder = _accountHolderController.text;
    final String email = _emailController.text;
    final String company = _companyController.text;

    final User? user = await _auth.signUpWithEmailAndPassword(email, password);

    if (user != null) {
      if(mounted) { // Check if the widget is still in the tree
        final firestore = FirebaseFirestore.instance;

        await firestore.collection('clients').doc(user.uid).set(
          {
            'accountHolder': accountHolder,
            'company': company,
            'email': email,
          }
        );

        if (mounted) { // Check if the widget is still in the tree before navigating
          widget.onRegisterComplete();
        }
      }
    } else {
      showToast(message: 'An Error Occured');
    }

    setState((){
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        _buildLabeledTextField('Account holder name *', 'Enter your name', _accountHolderController),
        const SizedBox(height: 15),
        _buildLabeledTextField('Company name *', 'Enter company name', _companyController),
        const SizedBox(height: 15),
        _buildLabeledTextField('Email *', 'Enter your email', _emailController),
        const SizedBox(height: 15),
        _buildLabeledTextField('Password *', 'Enter your password', _passwordController, obscureText: true),
        const SizedBox(height: 25),
        Center(
          child: SizedBox(
            width: 200,
            height: 40,
            child: ElevatedButton(
              onPressed: registerUser,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF58C6A9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: _isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.0,
                    ),
                  )
                : const Text(
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
                  text: 'Log in',
                  style: const TextStyle(
                    color: Color(0xFF58C6A9),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      // Navigate to login page
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const LoginPage(),
                        ),
                      );
                    },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabeledTextField(String label, String hintText, TextEditingController controller, {bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          obscureText: obscureText,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          cursorColor: const Color(0xFF58C6A9),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF58C6A9)),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
          ),
        ),
      ],
    );
  }
}
