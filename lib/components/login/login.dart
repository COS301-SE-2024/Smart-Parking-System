import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_parking_system/components/home/home.dart';
import 'dart:convert';

import 'package:smart_parking_system/components/login/verification.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _noController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool alreadyHaveOne = false;
  bool _isLoading = false;

Future<void> _login() async {
  setState(() {
    _isLoading = true;
  });

  final String email = _emailController.text;
  final String password = _passwordController.text;

  final response = await http.post(
    Uri.parse('http://192.168.3.20:3000/login'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'password': password,
    }),
  );

  setState(() {
    _isLoading = false;
  });

  if (mounted) { // Add this check
    if (response.statusCode == 200) {
      // If the server returns a successful response, show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful')),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const HomePage(),
        ),
      );
    } else {
      // If the server returns an error response, show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login failed')),
      );
    }
  }
}

  Future<void> _signup() async {
    setState(() {
      _isLoading = true;
    });
    final String email = _emailController.text;

    final response = await http.post(
      Uri.parse('http://192.168.3.20:3000/emailChecker'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
      }),
    );

    if(mounted){
    if (response.statusCode == 201){
        final String name = _nameController.text;
        final String surname = _surnameController.text;
        final String email = _emailController.text;
        final String phoneNumber = _noController.text;
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => VerificationPage(name: name, surname: surname, email: email, phoneNumber: phoneNumber,),
          ),
        );
    } else {
      // If the server returns an error response, show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email already has an account')),
      );
    }
    }
 
    setState(() {
      _isLoading = false;
    });
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
                const SizedBox(height: 20),
                if (alreadyHaveOne)
                  const Text(
                    'Enter your details',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 119, 119, 119),
                    ),
                  ),
                const SizedBox(height: 20),
                if (alreadyHaveOne)
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your Name';
                      }
                      return null;
                    },
                  ),
                if (alreadyHaveOne) 
                const SizedBox(height: 20),
                if (alreadyHaveOne)
                  TextFormField(
                    controller: _surnameController,
                    decoration: const InputDecoration(labelText: 'Surname'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your Surname';
                      }
                      return null;
                    },
                  ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                if (alreadyHaveOne) const SizedBox(height: 20),
                if (alreadyHaveOne)
                  TextFormField(
                    controller: _noController,
                    decoration: const InputDecoration(labelText: 'Phone Number'),
                    // obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your Phone Number';
                      }
                      return null;
                    },
                  ),
                if (!alreadyHaveOne) 
                const SizedBox(height: 20),
                if (!alreadyHaveOne)
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
                if (!alreadyHaveOne)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          alreadyHaveOne = !alreadyHaveOne;
                        });
                      },
                      child: const Text(
                        'Forgot Password',
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                const SizedBox(height: 35),
                if (alreadyHaveOne)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF613EEA),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0), // Slightly rounded corners
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width/ 2.5,
                        vertical: 18,
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _signup();
                      }
                    },
                    child: _isLoading
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : const Text('Next', style: TextStyle(
                                // fontWeight: FontWeight.bold,
                                fontSize: 18
                              ),),
                    
                  ),
                if (!alreadyHaveOne)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF613EEA),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0), // Slightly rounded corners
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width/ 2.5,
                        vertical: 18,
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await _login();
                      }
                    },
                    child: _isLoading
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : const Text('Login', style: TextStyle(
                                // fontWeight: FontWeight.bold,
                                fontSize: 18
                              ),),
                  ),
                const SizedBox(height: 35),
                if (alreadyHaveOne)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        alreadyHaveOne = !alreadyHaveOne;
                      });
                    },
                    child: const Text(
                      'Already have an account?\nLogin',
                      textAlign: TextAlign.center,
                    ),
                  ),
                if (!alreadyHaveOne)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        alreadyHaveOne = !alreadyHaveOne;
                      });
                    },
                    child: const Text(
                      'or Signup',
                      textAlign: TextAlign.center,
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
