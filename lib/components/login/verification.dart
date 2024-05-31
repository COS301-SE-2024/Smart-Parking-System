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
  final TextEditingController _codeController = TextEditingController();
  late String _verificationCode;

  @override
  void initState() {
    super.initState();
    _verificationCode = _generateVerificationCode();
    _sendVerificationEmail();
  }

  String _generateVerificationCode() {
    final Random _random = Random();
    const int length = 5;
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
      if (_codeController.text == _verificationCode) {
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
      appBar: AppBar(
        title: Text('Email Verification'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'A verification code has been sent to ${widget.email}. Please enter the code below to verify your account.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _codeController,
                decoration: InputDecoration(labelText: 'Verification Code'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the verification code';
                  }
                  return null;
                },
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
    );
  }
}
