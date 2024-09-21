import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart'; // For TapGestureRecognizer

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Color emailUnderlineColor = Colors.white;
  Color passwordUnderlineColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/backW.png', // Ensure this asset exists
              fit: BoxFit.cover,
            ),
          ),
          // Content
          Center(
            child: Row(
              children: [
                // Left section with the rounded card login form
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.zero, // Remove space on the left
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 600, // Set a fixed width for the card
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(70),
                              bottomRight: Radius.circular(70),
                            ),
                          ),
                          color: const Color(0xFF23223A), // Dark color for the card
                          elevation: 6.0,
                          child: Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Logo
                                Center(
                                  child: Image.asset(
                                    'assets/logo2.png', // Replace with your logo
                                    height: 90, // Increased logo size
                                  ),
                                ),
                                const SizedBox(height: 40),
                                // "Welcome back" text
                                const Text(
                                  'Welcome back',
                                  style: TextStyle(
                                    fontSize: 45, // Increased font size
                                    fontWeight: FontWeight.w900, // Thicker font weight
                                    color: Colors.white, // White text color
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'Please enter your details',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white70, // Slightly lighter text color
                                  ),
                                ),
                                const SizedBox(height: 30),
                                // Email field
                                const Text(
                                  'Email',
                                  style: TextStyle(
                                    color: Colors.white, // White text color
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                MouseRegion(
                                  onEnter: (_) => setState(() {
                                    emailUnderlineColor = const Color(0xFF58C6A9); // Hover color
                                  }),
                                  onExit: (_) => setState(() {
                                    emailUnderlineColor = Colors.white; // Default color
                                  }),
                                  child: TextField(
                                    style: TextStyle(color: Colors.white), // White text color when typing
                                    cursorColor: Color(0xFF58C6A9), // Green cursor color
                                    decoration: InputDecoration(
                                      hintText: 'Enter your email',
                                      hintStyle: const TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: emailUnderlineColor),
                                      ),
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(color: Color(0xFF58C6A9)), // Green color when focused
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                // Password field
                                const Text(
                                  'Password',
                                  style: TextStyle(
                                    color: Colors.white, // White text color
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                MouseRegion(
                                  onEnter: (_) => setState(() {
                                    passwordUnderlineColor = const Color(0xFF58C6A9); // Hover color
                                  }),
                                  onExit: (_) => setState(() {
                                    passwordUnderlineColor = Colors.white; // Default color
                                  }),
                                  child: TextField(
                                    style: TextStyle(color: Colors.white), // White text color when typing
                                    cursorColor: Color(0xFF58C6A9), // Green cursor color
                                    decoration: InputDecoration(
                                      hintText: 'Enter your password',
                                      hintStyle: const TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: passwordUnderlineColor),
                                      ),
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(color: Color(0xFF58C6A9)), // Green color when focused
                                      ),
                                    ),
                                    obscureText: true, // Hide password input
                                  ),
                                ),
                                const SizedBox(height: 30),
                                // Log in button
                                Center(
                                  child: SizedBox(
                                    width: 200, // Button width
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // Handle login action
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF58C6A9), // Button color
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                      ),
                                      child: const Text(
                                        'Log in',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white, // White text color
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                // "Or Sign up with" text centered
                                Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 50, // Set the desired width for the left divider
                                        child: Divider(color: Colors.white70),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16),
                                        child: Text(
                                          'Or Sign up with',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 60, // Set the desired width for the right divider
                                        child: Divider(color: Colors.white70),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                // Google Sign In icon button (slightly bigger)
                                Center(
                                  child: IconButton(
                                    icon: Image.asset(
                                      'assets/google-icon.png',
                                      height: 40, // Increased size
                                      width: 40, // Increased size
                                    ),
                                    onPressed: () {
                                      // Handle Google Sign-in
                                    },
                                    iconSize: 60, // Increased touch target size
                                    padding: EdgeInsets.all(15), // Increased padding around the icon
                                  ),
                                ),
                                const SizedBox(height: 20),
                                // Register link
                                Center(
                                  child: RichText(
                                    text: TextSpan(
                                      text: "Don't have an account? ",
                                      style: const TextStyle(color: Colors.white70),
                                      children: [
                                        TextSpan(
                                          text: 'Register here',
                                          style: const TextStyle(
                                            color: Color(0xFF58C6A9), // Link color
                                            fontWeight: FontWeight.bold,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              // Navigate to registration page
                                            },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Right section with the image of the parking building
                Expanded(
                  flex: 1,
                  child: Image.asset(
                    'assets/parking.png', // Replace with your image
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
