import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_parking_system/components/card/add_card_registration.dart';
import 'package:smart_parking_system/components/login/successmark.dart';

class VerificationPage extends StatefulWidget {
  final String fullname;
  final String password;
  final String email;
  final String phoneNumber;

  const VerificationPage({super.key, 
    required this.fullname,
    required this.email,
    required this.phoneNumber,
    required this.password,
  });

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _codeControllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  late String _verificationCode;
  bool _isLoading = false;
  late String _verificationId;

  @override
  void initState() {
    super.initState();
    _verificationCode = _generateVerificationCode();
    _sendVerificationEmail();
  }

  String _generateVerificationCode() {
    final Random random = Random();
    const int length = 4;
    return String.fromCharCodes(
      List.generate(length, (index) => random.nextInt(10) + 48), // Generates digits (0-9)
    );
  }

Future<void> _sendVerificationEmail() async {
  FirebaseAuth auth = FirebaseAuth.instance;

  try {
    await auth.verifyPhoneNumber(
      phoneNumber: widget.phoneNumber,     
      verificationCompleted: (PhoneAuthCredential credential) {
        // This callback won't be used for manual entry of OTP
        setState(() {
          _isLoading = false;
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verification failed')),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId; // Save verification ID
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationId = verificationId; // Save verification ID
        });
      },
      timeout: const Duration(seconds: 110),
    );
  } catch (e) {
    print('Error during phone number verification: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Error during phone number verification')),
    );
  }
}

  

  void _verifyCode() {
    setState(() {
      _isLoading = true;
    });

    String enteredCode = _codeControllers.map((controller) => controller.text).join();
    
    // Create PhoneAuthCredential object
    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: _verificationId, smsCode: enteredCode);

    // Check if a user is currently authenticated
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not authenticated')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // Link the PhoneAuthCredential to the current user's account
    currentUser.linkWithCredential(credential).then((authResult) {
      // Handle linking success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfully linked phone number!')),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const AddCardRegistrationPage(),
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }).catchError((error) {
      // Handle linking failure
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to link phone number')),
      );
      setState(() {
        _isLoading = false;
      });
    });
  }


   @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SvgPicture.asset(
            'assets/Background - Small.svg', // Ensure you have the SVG background image in your assets folder
            fit: BoxFit.fill,
            width: double.infinity,
            height: double.infinity,
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'OTP Verification',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Enter the verification code we just sent on your email address. $_verificationCode',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(6, (index) {
                          return SizedBox(
                            width: 80,
                            child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            child: TextFormField(
                              controller: _codeControllers[index],
                              focusNode: _focusNodes[index],
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(vertical: 22),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(color: Colors.green, width: 2.0),
                                ),
                                counterText: '', // Removes the character counter
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              maxLength: 1,
                              onChanged: (value) {
                                if (value.length == 1 && index < 5) {
                                  FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                                } else if (value.length == 1 && index == 5) {
                                  _focusNodes[index].unfocus();
                                }
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return '';
                                }
                                return null;
                              },
                            ),
                          ),
                          );
                        }),
                      ),
                     
                      
                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: () {
                          _verifyCode();
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 150,
                            vertical: 18,
                          ),
                          backgroundColor: const Color(0xFF58C6A9),
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
                              'Verify',
                              style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w300),
                            ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            "Didn't receive OTP?",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          TextButton(
                            onPressed: _sendVerificationEmail,
                            child: const Text('Resend', style: TextStyle(color:Color(0xFF58C6A9))),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}