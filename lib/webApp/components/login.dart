import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart'; // Import the gestures package for TapGestureRecognizer

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1D1E33), // Background color from the screenshot
      body: Center(
        child: Row(
          children: [
            // Left section with the login form
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Logo
                    Center(
                      child: Image.asset(
                        'assets/logo1.png', // Replace with your app's logo
                        height: 100,
                      ),
                    ),
                    const SizedBox(height: 30),
                    // "Welcome back" text
                    const Text(
                      'Welcome back',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Please enter your details',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white54,
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Email field
                    const Text(
                      'Email',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter your email',
                        filled: true,
                        fillColor: Colors.white10,
                        hintStyle: const TextStyle(color: Colors.white54),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    // Password field
                    const Text(
                      'Password',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter your password',
                        filled: true,
                        fillColor: Colors.white10,
                        hintStyle: const TextStyle(color: Colors.white54),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 30),
                    // Log in button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle login action
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00C98F), // Green login button
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Log in',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Sign up with Google text
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(color: Colors.white54, thickness: 1),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            'Or Sign up with',
                            style: TextStyle(color: Colors.white54),
                          ),
                        ),
                        const Expanded(
                          child: Divider(color: Colors.white54, thickness: 1),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Google sign in button
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          // Handle Google sign-in
                        },
                        child: Image.asset(
                          'assets/google-logo.png', // Replace with your Google logo asset
                          height: 50,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Register link
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: "Don't have an account? ",
                          style: const TextStyle(color: Colors.white54),
                          children: [
                            TextSpan(
                              text: 'Register here',
                              style: const TextStyle(
                                color: Colors.tealAccent,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // Handle navigation to registration page
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
            // Right section with the image of the parking building
            Expanded(
              flex: 1,
              child: Image.asset(
                'assets/parking.png', // Replace with your building image
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() => runApp(const MaterialApp(home: LoginPage()));
