import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:smart_parking_system/components/home/home.dart';


class SignupPage extends StatefulWidget {
  final String name;
  final String surname;
  final String email;
  final String phoneNumber;

  const SignupPage({super.key, 
    required this.name,
    required this.surname,
    required this.email,
    required this.phoneNumber,
  });

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmationController = TextEditingController();
  bool _isLoading = false;

   Future<void> _signup() async {
    setState(() {
      _isLoading = true;
    });

    final String password = _passwordController.text;
    final String confirationPassword = _confirmationController.text;
    if(mounted){
      if(password != confirationPassword){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('The Passwords are not the same')),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }
    }

    final response = await http.post(
      Uri.parse('http://192.168.3.20:3000/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': widget.name,
        'surname': widget.surname,
        'email': widget.email,
        'phoneNumber': widget.phoneNumber,
        'password': password,
      }),
    );

    setState(() {
      _isLoading = false;
    });
    if(mounted){
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signup successful')),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomePage(),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 100),
                Image.asset(
                  'assets/logo.png',
                  height: 150, // Set the height to make it small
                ),
                const SizedBox(height: 80),
                  const Text(
                    'Enter your Password',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 119, 119, 119),
                    ),
                  ),
                const SizedBox(height: 20),
                TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your Password';
                      }
                      return null;
                    },
                ),
                const SizedBox(height: 20),
                TextFormField(
                    controller: _confirmationController,
                    decoration: const InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your Password';
                      }
                      return null;
                    },
                ),
                
                const SizedBox(height: 35),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4C4981),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0), // Slightly rounded corners
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width/ 3.3,
                        vertical: 18,
                      ),
                    ),
                  
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await _signup();
                      }
                    },
                    child:  _isLoading
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : const Text(
                              'Create Account',
                              style: TextStyle(
                                // fontWeight: FontWeight.bold,
                                fontSize: 18
                              ),
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
