import 'package:flutter/material.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
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
  final List<TextEditingController> _codeControllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());
  late String _verificationCode;
  bool _isLoading = false;

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
    final response = await http.post(
      Uri.parse('http://192.168.3.20:3000/verification'), // Replace with your server URL
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': widget.email,
        'code': _verificationCode,
      }),
    );
    if(mounted){
      if (response.statusCode != 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to send verification code')),
        );
      }
    }
  }

  void _verifyCode() {
    setState(() {
      _isLoading = true;
    });
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const SuccessionPage(),
      ),
    );
    if(mounted){
      if (_formKey.currentState!.validate()) {
        String enteredCode = _codeControllers.map((controller) => controller.text).join();
        if (enteredCode == _verificationCode) {
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Verified!')),
          );
          _signup();
        } else {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid verification code')),
          );
        }
      }
    }
  }

  Future<void> _signup() async {
    setState(() {
      _isLoading = true;
    });

    final String password = widget.password;
    final String name = widget.fullname;
    final String email = widget.email;
    final String phoneNumber = widget.phoneNumber;
    
    final response = await http.post(
      Uri.parse('http://192.168.3.20:3000/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'email': email,
        'phoneNumber': phoneNumber,
        'password': password,
      }),
    );

    setState(() {
      _isLoading = false;
    });
    if(mounted){
      if (response.statusCode == 201) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const SuccessionPage(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signup failed')),
        );
      }
    }
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
                        children: List.generate(4, (index) {
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
                                if (value.length == 1 && index < 3) {
                                  FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                                } else if (value.length == 1 && index == 3) {
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