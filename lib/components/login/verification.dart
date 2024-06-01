import 'package:flutter/material.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:smart_parking_system/components/login/signup.dart';

class VerificationPage extends StatefulWidget {
  final String name;
  final String surname;
  final String email;
  final String phoneNumber;

  VerificationPage({
    required this.name,
    required this.surname,
    required this.email,
    required this.phoneNumber,
  });

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _codeControllers = List.generate(4, (_) => TextEditingController());
  late String _verificationCode;

  @override
  void initState() {
    super.initState();
    _verificationCode = _generateVerificationCode();
    _sendVerificationEmail();
  }

  String _generateVerificationCode() {
    final Random _random = Random();
    const int length = 4;
    return String.fromCharCodes(
      List.generate(length, (index) => _random.nextInt(10) + 48), // Generates digits (0-9)
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

    if (response.statusCode != 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send verification code')),
      );
    }
  }

  void _verifyCode() {
    if (_formKey.currentState!.validate()) {
      String enteredCode = _codeControllers.map((controller) => controller.text).join();
      if (enteredCode == _verificationCode) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => SignupPage(name: widget.name, surname: widget.surname, email: widget.email, phoneNumber: widget.phoneNumber),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verified!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid verification code')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  SingleChildScrollView(
        child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 50),
              Image.asset('assets/logo.png', height: 150), // Ensure you have the logo image in your assets folder
              SizedBox(height: 30),
              Container(
                width: 300, // Specify the desired width
                child: Text(
                  'Interactively expedite revolutionary ROI after bricks-and-clicks alignments.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  return Container(
                    width: 50,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    child: TextFormField(
                      controller: _codeControllers[index],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        counterText: '', // Removes the character counter
                      ),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return '';
                        }
                        return null;
                      },
                    ),

                  );
                }),
              ),
              SizedBox(height: 30),
              Text(
                'Automatically displayed OTP',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  ),
              ),
              SizedBox(height: 30),
              Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 230, 230, 230),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    'Waiting for\nthe OTP',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color.fromARGB(255, 97, 97, 97), fontSize: 15),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Didn't receive OTP?",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                    ),
                  TextButton(
                    onPressed: _sendVerificationEmail,
                    child: Text('Resend'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF613EEA),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onPressed: _verifyCode,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 130.0,
                    vertical: 15,
                  ),
                  child: Text('Verify'),
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
