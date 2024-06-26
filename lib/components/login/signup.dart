import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_parking_system/components/login/login.dart';
import 'package:smart_parking_system/components/login/verification.dart';


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
   
  Future<void> verification() async {
    final String password = _passwordController.text;
    final String name = _nameController.text;
    final String email = _emailController.text;
    final String phoneNumber = _noController.text;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => VerificationPage(fullname: name, email: email, phoneNumber: phoneNumber, password: password,),
      ),
    );
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
              Stack(
                children: [
                  // Profile Image
                  GestureDetector(
                    onTap: () {
                      // Add picture and show picture
                    },
                    child: const CircleAvatar(
                      radius: 70,
                      backgroundColor: Color(0xFFD9D9D9),
                      child: Icon(
                        Icons.person,
                        size: 70,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  // Edit Icon
                  const Positioned(
                    right: 0,
                    bottom: 100,
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
                     // Space before the Login text
                    const Text(
                      'Sign up',
                      style: TextStyle(
                        fontSize: 43,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF58C6A9),
                      ),
                    ),
                    const SizedBox(height: 8), // Space between the Login text and text boxes
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
                      obscureText: true,
                    ),
                    const SizedBox(height: 30),
                    // Login Button
                    ElevatedButton(
                      onPressed: () {
                        verification();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 100,
                          vertical: 12,
                        ),
                        backgroundColor: const Color(0xFF58C6A9),
                      ),
                      child: const Text(
                        'Signup',
                        style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w400),
                      ),
                    ),
                    const SizedBox(height: 10), // Space between login button and Login with section
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
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/F_Logo.png',
                          height: 50, // Adjust the height as needed
                          width: 50,  // Adjust the width as needed
                        ),
                        GestureDetector(
                          onTap: () {
                            // Add functionality to signup with Google
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Image.asset(
                              'assets/G_Logo.png',
                              height: 50, // Adjust the height as needed
                              width: 50,  // Adjust the width as needed
                            ),
                          ),
                        ),
                        Image.asset(
                          'assets/A_Logo.png',
                          height: 50, // Adjust the height as needed
                          width: 50,  // Adjust the width as needed
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    InkWell(
                      onTap: () {
                        // Navigate to SignupPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                        );
                      },
                      child: const Text(
                        "Have an account? Login",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF58C6A9)),
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