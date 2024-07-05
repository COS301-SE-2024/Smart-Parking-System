import 'package:flutter/material.dart';
import 'package:smart_parking_system/components/settings/settings.dart';

class CarDetailsPage extends StatelessWidget {
  const CarDetailsPage({super.key});

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
                  const ProfileField(
                    label: 'Vehicle Brand',
                    value: 'BMW',
                  ),
                  const ProfileField(
                    label: 'Vehicle Model',
                    value: 'M3',
                  ),
                  const ProfileField(
                    label: 'Color',
                    value: 'Grey White',
                  ),
                  const ProfileField(
                    label: 'License Number',
                    value: 'NFSMW',
                  ),
                  const SizedBox(height: 60.0),
                  ElevatedButton(
                    onPressed: () {
                      // Handle save button
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: const Color(0xFF2D2F41),
                            title: const Text(
                              'Successfully Updated!',
                              style: TextStyle(color: Colors.white),
                            ),
                            actions: [
                              Center(
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'OK',
                                    style: TextStyle(color: Color(0xFF58C6A9)),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
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
  final bool obscureText;

  const ProfileField({
    super.key,
    required this.label,
    required this.value,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: TextFormField(
        initialValue: value,
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