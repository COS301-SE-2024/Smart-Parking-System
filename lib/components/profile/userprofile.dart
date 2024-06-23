import 'package:flutter/material.dart';
import 'package:smart_parking_system/components/main_page.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF2D2F41),
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
                              builder: (_) => const MainPage(),
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
                        'User Profile',
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
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[200],
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.all(20),
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
                      label: 'Full name',
                      value: 'John Doe',
                    ),
                    const ProfileField(
                      label: 'Email address',
                      value: 'JohnDoe@gmail.com',
                    ),
                    const ProfileField(
                      label: 'Phone number',
                      value: '+27 63 123 4567',
                    ),
                    const ProfileField(
                      label: 'Password',
                      value: '09033421159',
                      obscureText: true,
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        // Handle save button
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:  const Color(0xFF58C6A9),
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
