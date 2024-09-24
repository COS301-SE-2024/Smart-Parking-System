import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:smart_parking_system/components/common/toast.dart';
import 'package:smart_parking_system/components/firebase/firebase_auth_services.dart';
import 'package:smart_parking_system/webApp/components/login.dart';

import 'package:smart_parking_system/webApp/components/registration2.dart';
import 'package:smart_parking_system/webApp/components/registration3.dart';
import 'package:smart_parking_system/webApp/components/registration4.dart';
import 'package:smart_parking_system/webApp/components/registration5.dart';

class RegistrationPage extends StatefulWidget {
  final int currentStep;

  const RegistrationPage({super.key, this.currentStep = 1});

  @override
  // ignore: library_private_types_in_public_api
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  late int _currentStep;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _accountHolderController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final FireBaseAuthServices _auth = FireBaseAuthServices();

  bool _isLoading = false;

  Future<void> registerUser() async {
    final String password = _passwordController.text;
    final String accountHolder = _accountHolderController.text;
    final String email = _emailController.text;
    final String company = _companyController.text;

    setState((){
      _isLoading = true;
    });

    final User? user = await _auth.signUpWithEmailAndPassword(email, password);

    setState((){
      _isLoading = false;
    });

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
          _goToNextStep();
        }
      }
    } else {
      // ignore: avoid_print
      showToast(message: 'An Error Occured');
    }
    
  }

  @override
  void initState() {
    super.initState();
    _currentStep = widget.currentStep;
  }

  void _goToNextStep() {
    if (_currentStep < 5) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _navigateToStep(int step) {
    setState(() {
      _currentStep = step;
    });
  }

  Widget _getCurrentRegistrationStep() {
    switch (_currentStep) {
      case 1:
        return _buildRegistrationStep1();
      case 2:
        return Registration2(onRegisterComplete: _goToNextStep,);
      case 3:
        return  Registration3(onRegisterComplete: _goToNextStep,);
      case 4:
        return  Registration4(onRegisterComplete: _goToNextStep,);
      case 5:
        return const Registration5();
      default:
        return _buildRegistrationStep1();
    }
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
          width: 600,
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
                    ],
                  ),
                  const SizedBox(height: 40),
                  _getCurrentRegistrationStep(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStyledStepIndicator(int step, bool isActive) {
    return GestureDetector(
      onTap: () => _navigateToStep(step),
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

  Widget _buildRegistrationStep1() {
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

  Widget _buildLabeledTextField(String label, String hintText, {bool obscureText = false}) {
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
        if (label == 'Company name *')
          _buildCompanyTextField(hintText, obscureText: obscureText)
        else if (label == 'Email *')
          _buildEmailTextField(hintText, obscureText: obscureText)
        else if (label == 'Account holder name *')
          _buildAHTextField(hintText, obscureText: obscureText)
        else if (label == 'Password *')
          _buildPasswordTextField(hintText, obscureText: obscureText),
      ],
    );
  }

  Widget _buildAHTextField(String hintText, {bool obscureText = false}) {
    return TextField(
      controller: _accountHolderController,
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
    );
  }

  Widget _buildPasswordTextField(String hintText, {bool obscureText = false}) {
    return TextField(
      controller: _passwordController,
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
    );
  }

  Widget _buildCompanyTextField(String hintText, {bool obscureText = false}) {
    return TextField(
      controller: _companyController,
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
    );
  }

  Widget _buildEmailTextField(String hintText, {bool obscureText = false}) {
    return TextField(
      controller: _emailController,
      obscureText: obscureText,
      keyboardType: TextInputType.emailAddress,
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
    );
  }
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
