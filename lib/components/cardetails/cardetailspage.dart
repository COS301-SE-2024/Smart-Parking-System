import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:smart_parking_system/components/settings/settings.dart';

class CarDetailsPage extends StatefulWidget {
  const CarDetailsPage({super.key});

  @override
  State<CarDetailsPage> createState() => _CarDetailsPageState();
}

class _CarDetailsPageState extends State<CarDetailsPage> {
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
        Navigator.of(context).pop();
        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(
        //     builder: (context) => const SettingsPage(),
        //   ),
        // );
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
      backgroundColor: const Color(0xFF2D2F41),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 1.0),
                    child: IconButton(
                      onPressed: () {
                        // Add your onPressed logic here
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => const SettingsPage(),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Vehicle Details',
                        style: TextStyle(
                          color: Colors.tealAccent,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Placeholder to keep the text centered
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Stack(
                children: [
                  // Profile Image
                  GestureDetector(
                    onTap: () {
                      // Add picture and show picture
                    },
                    child: Container(
                      width: 100, // Adjust the width as needed
                      height: 100, // Adjust the height as needed
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: const DecorationImage(
                          image: AssetImage('assets/car.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  // Edit Icon
                  const Positioned(
                    right: 0,
                    bottom: 70,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.edit,
                        size: 15,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                  children: [
                    ProfileField(
                      label: 'Vehicle Brand',
                      value: 'BMW',
                      controller: _makeController,
                    ),
                    ProfileField(
                      label: 'Vehicle Model',
                      value: 'M3',
                      controller: _modelController,
                    ),
                    ProfileField(
                      label: 'Color',
                      value: 'Grey White',
                      controller: _colorController,
                    ),
                    ProfileField(
                      label: 'License Number',
                      value: 'NFSMW',
                      controller: _licenseController,
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        // Handle save button
                        _register();
                        // showDialog(
                        //   context: context,
                        //   builder: (BuildContext context) {
                        //     return AlertDialog(
                        //       backgroundColor: const Color(0xFF2D2F41),
                              
                        //       title: const Text('Successfully Updated!', style: TextStyle(color: Colors.white)),
                              
                        //       actions: [
                        //         Center(
                        //           child: TextButton(
                        //             onPressed: () {
                        //               Navigator.of(context).pop();
                        //             },
                        //             child: const Text('OK', style: TextStyle(color: Color(0xFF58C6A9))),
                        //           ),
                        //         ),
                        //       ],
                        //     );
                        //   },
                        // );
                      },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF58C6A9),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 150,
                        vertical: 24,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),                  
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileField extends StatelessWidget {
  final String label;
  final String value;
  final TextEditingController controller;
  final bool obscureText;

  const ProfileField({
    super.key,
    required this.label,
    required this.value,
    required this.controller,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: TextFormField(
        // initialValue: value,
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(
          fontWeight: FontWeight.w600, // Make the input text bold
          fontSize: 16,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Color(0xFF757F8C), // Set the color here
            fontSize: 18,
          ),
          contentPadding: const EdgeInsets.only(top: 0),
        ),
      ),
    );
  }
}