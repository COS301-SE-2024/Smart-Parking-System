import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_parking_system/components/bookings/make_booking.dart';
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_parking_system/components/login/login.dart';
import 'package:smart_parking_system/components/login/car_registration.dart';


class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _noController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
   
   
  Future<void> _signup() async {
    setState(() {
      _isLoading = true;
    });

    final String password = _passwordController.text;
    final String name = _nameController.text;
    final String email = _emailController.text;
    final String phoneNumber = _noController.text;

    final response = await http.post(
      Uri.parse('http://192.168.11.121:3000/signup'),
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signup successful')),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const BookingPage(),
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
        fit: StackFit.expand,
        children: <Widget>[
          // Background image
          SvgPicture.asset(
            'assets/Background - Small.svg',
            fit: BoxFit.cover,
          ),
          // Foreground elements
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              // Logo above the white container
              Image.asset(
                'assets/logo_small.jpg',
                height: 200, // Adjust the height as needed
                width: 200,  // Adjust the width as needed
                
              ),
              SizedBox(height: 20), // Space between logo and container
              // Container for login form
              Container(
                height: MediaQuery.of(context).size.height * 0.62,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.elliptical(100, 40),
                    topRight: Radius.elliptical(100, 40),
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                     // Space before the Login text
                    Text(
                      'Sign up',
                      style: TextStyle(
                        fontSize: 43,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF58C6A9),
                      ),
                    ),
                    SizedBox(height: 8), // Space between the Login text and text boxes
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(
                          color: Colors.grey.shade700, // Darker grey for label text
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                        floatingLabelStyle: TextStyle(
                          color: Colors.grey.shade700, // Color for floating label when focused
                        ),
                        filled: true,
                        fillColor: Color(0xFFD9D9D9), // Light grey background color
                        contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(
                            color: Color(0xFFD9D9D9), // Border color
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(
                            color: Color(0xFFD9D9D9), // Border color when enabled
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(
                            color: Color(0xFFD9D9D9), // Border color when focused
                          ),
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.grey.shade800, // Dark grey input text color
                      ),
                    ),
                    SizedBox(height: 20,),
                    TextField(
                      controller: _noController,
                      decoration: InputDecoration(
                        labelText: 'Phone',
                        labelStyle: TextStyle(
                          color: Colors.grey.shade700, // Darker grey for label text
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                        floatingLabelStyle: TextStyle(
                          color: Colors.grey.shade700, // Color for floating label when focused
                        ),
                        filled: true,
                        fillColor: Color(0xFFD9D9D9), // Light grey background color
                        contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(
                            color: Color(0xFFD9D9D9), // Border color
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(
                            color: Color(0xFFD9D9D9), // Border color when enabled
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(
                            color: Color(0xFFD9D9D9), // Border color when focused
                          ),
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.grey.shade800, // Dark grey input text color
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          color: Colors.grey.shade700, // Darker grey for label text
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                        floatingLabelStyle: TextStyle(
                          color: Colors.grey.shade700, // Color for floating label when focused
                        ),
                        filled: true,
                        fillColor: Color(0xFFD9D9D9), // Light grey background color
                        contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(
                            color: Color(0xFFD9D9D9), // Border color
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(
                            color: Color(0xFFD9D9D9), // Border color when enabled
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(
                            color: Color(0xFFD9D9D9), // Border color when focused
                          ),
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.grey.shade800, // Dark grey input text color
                      ),
                    ),
                    SizedBox(height: 20),
                    // Password Text Field
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(
                          color: Colors.grey.shade700, // Darker grey for label text
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                        floatingLabelStyle: TextStyle(
                          color: Colors.grey.shade700, // Color for floating label when focused
                        ),
                        filled: true,
                        fillColor: Color(0xFFD9D9D9), // Light grey background color
                        contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(
                            color: Color(0xFFD9D9D9), // Border color
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(
                            color: Color(0xFFD9D9D9), // Border color when enabled
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(
                            color: Color(0xFFD9D9D9), // Border color when focused
                          ),
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.grey.shade800, // Dark grey input text color
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 30),
                    // Login Button
                    ElevatedButton(
                      onPressed: () {
                        // Handle login action

                        // Navigate to SignupPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CarRegistration()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 100,
                          vertical: 12,
                        ),
                        backgroundColor: Color(0xFF58C6A9),
                      ),
                      child: Text(
                        'Signup',
                        style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(height: 10), // Space between login button and Login with section
                    const Row(
                      children: <Widget>[
                        Expanded(
                          child: Divider(
                            color: Color.fromARGB(255, 199, 199, 199), // Color of the lines
                            thickness: 1, // Thickness of the lines
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'Or Sign up with',
                            style: TextStyle(fontSize: 13, color: Color(0xFF58C6A9)),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Color.fromARGB(255, 199, 199, 199), // Color of the lines
                            thickness: 1, // Thickness of the lines
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text('Google Logo, Github Logo'),
                    SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        // Navigate to SignupPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: Text(
                        "Have an account? Login",
                        style: TextStyle(fontSize: 13, color: Color(0xFF58C6A9)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
