import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_parking_system/components/bookings/make_booking.dart';
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_parking_system/components/login/successmark.dart';

class CarRegistration extends StatefulWidget {
  const CarRegistration({super.key});

  @override
  State<CarRegistration> createState() => _CarRegistrationState();
}

class _CarRegistrationState extends State<CarRegistration> {
  final TextEditingController _makeController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _licenseController = TextEditingController();

  Future<void> _register() async {
    final String make = _makeController.text;
    final String model = _modelController.text;
    final String color = _colorController.text;
    final String license = _licenseController.text;

    final response = await http.post(
      Uri.parse('http://192.168.11.121:3000/registerVehicle'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'make': make,
        'model': model,
        'color': color,
        'license_number': license,
      }),
    );

    if (mounted) {
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vehicle registered successfully')),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const SuccessionPage(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vehicle registration failed')),
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
            fit: BoxFit.fill,
          ),
          // Foreground elements
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              // Logo above the white container
              Image.asset(
                'assets/Vehicle_temp.png',
                height: 200, // Adjust the height as needed
                width: 200,  // Adjust the width as needed
              ),
              const SizedBox(height: 20), // Space between logo and container
              // Container for login form
              Container(
                height: MediaQuery.of(context).size.height * 0.62,
                width: 500,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(height: 30),  // Space before the "Add Your Vehicle" text
                    const Text(
                      'Add Your Vehicle',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF58C6A9),
                      ),
                    ),
                    const SizedBox(height: 25), // Space between the "Add Vehicle" text and text boxes
                    TextField(
                      controller: _makeController,
                      decoration: InputDecoration(
                        labelText: 'Vehicle Brand',
                        labelStyle: TextStyle(
                          color: Colors.grey.shade700, // Darker grey for label text
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                        floatingLabelStyle: TextStyle(
                          color: Colors.grey.shade700, // Color for floating label when focused
                        ),
                        filled: true,
                        fillColor: const Color(0xFFD9D9D9), // Light grey background color
                        contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                            color: Color(0xFFD9D9D9), // Border color
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                            color: Color(0xFFD9D9D9), // Border color when enabled
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                            color: Color(0xFFD9D9D9), // Border color when focused
                          ),
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.grey.shade800, // Dark grey input text color
                      ),
                    ),
                    const SizedBox(height: 20,),
                    TextField(
                      controller: _modelController,
                      decoration: InputDecoration(
                        labelText: 'Vehicle Model',
                        labelStyle: TextStyle(
                          color: Colors.grey.shade700, // Darker grey for label text
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                        floatingLabelStyle: TextStyle(
                          color: Colors.grey.shade700, // Color for floating label when focused
                        ),
                        filled: true,
                        fillColor: const Color(0xFFD9D9D9), // Light grey background color
                        contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                            color: Color(0xFFD9D9D9), // Border color
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                            color: Color(0xFFD9D9D9), // Border color when enabled
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                            color: Color(0xFFD9D9D9), // Border color when focused
                          ),
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.grey.shade800, // Dark grey input text color
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _colorController,
                      decoration: InputDecoration(
                        labelText: 'Colour',
                        labelStyle: TextStyle(
                          color: Colors.grey.shade700, // Darker grey for label text
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                        floatingLabelStyle: TextStyle(
                          color: Colors.grey.shade700, // Color for floating label when focused
                        ),
                        filled: true,
                        fillColor: const Color(0xFFD9D9D9), // Light grey background color
                        contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                            color: Color(0xFFD9D9D9), // Border color
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                            color: Color(0xFFD9D9D9), // Border color when enabled
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                            color: Color(0xFFD9D9D9), // Border color when focused
                          ),
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.grey.shade800, // Dark grey input text color
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _licenseController,
                      decoration: InputDecoration(
                        labelText: 'License Number',
                        labelStyle: TextStyle(
                          color: Colors.grey.shade700, // Darker grey for label text
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                        floatingLabelStyle: TextStyle(
                          color: Colors.grey.shade700, // Color for floating label when focused
                        ),
                        filled: true,
                        fillColor: const Color(0xFFD9D9D9), // Light grey background color
                        contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                            color: Color(0xFFD9D9D9), // Border color
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                            color: Color(0xFFD9D9D9), // Border color when enabled
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                            color: Color(0xFFD9D9D9), // Border color when focused
                          ),
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.grey.shade800, // Dark grey input text color
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Add Vehicle Button
                    ElevatedButton(
                      onPressed: () {
                        // Validate Vehicle details
                        bool bValid = true;

                        // Handle add Vehicle action
                        if (bValid) {
                          _register();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 100,
                          vertical: 20,
                        ),
                        backgroundColor: const Color(0xFF58C6A9),
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w400),
                      ),
                    ),
                    const SizedBox(height: 10), // Space between login button and Login with section
                    Row(
                      children: <Widget>[
                        const Expanded(
                          child: Divider(
                            color: Color.fromARGB(255, 199, 199, 199), // Color of the lines
                            thickness: 1, // Thickness of the lines
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const SuccessionPage(),
                                ),
                              );
                            },
                            child: const Text(
                            'Skip for now',
                            style:  TextStyle(fontSize: 13, color: Color(0xFF58C6A9)),
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Divider(
                            color: Color.fromARGB(255, 199, 199, 199), // Color of the lines
                            thickness: 1, // Thickness of the lines
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
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
