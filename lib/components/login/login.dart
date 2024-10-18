import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_parking_system/components/common/common_functions.dart';
import 'package:smart_parking_system/components/common/toast.dart';
import 'package:smart_parking_system/components/firebase/firebase_auth_services.dart';
import 'package:smart_parking_system/components/login/signup.dart';
import 'package:smart_parking_system/components/home/main_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscureText = true;

  final FireBaseAuthServices _auth = FireBaseAuthServices();

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }
   
  Future<void> _signIn() async {
    setState((){
      _isLoading = true;
    });
    
    final String password = _passwordController.text;
    final String email = _emailController.text;

    if(!isValidString(email, r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')){showToast(message: "Invalid email address"); return;}

    final User? user = await _auth.signInWithEmailAndPassword(email, password);

    if (user != null) {

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setInt('loginTimestamp', DateTime.now().millisecondsSinceEpoch);
      
      if(mounted) { // Check if the widget is still in the tree
        showToast(message: 'Successfully signed in');
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const MainPage(),
          ),
          (Route<dynamic> route) => false,
        );
      }
    }

    setState((){
      _isLoading = false;
    });
  }
    

  _signInWithGoogle () async {
    setState((){
      _isLoading = true;
    });
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential authResult = await _auth.signInWithCredential(credential);
        final User? user = authResult.user;

        if (user != null) {
          final firestore = FirebaseFirestore.instance;
          final String? username = googleSignInAccount.displayName;
          final String email = googleSignInAccount.email;

          final querySnapshot = await firestore
              .collection('users')
              .where('email', isEqualTo: email)
              .get();

          if (querySnapshot.docs.isEmpty) {
            await firestore.collection('users').doc(user.uid).set(
              {
                'username': username,
                'email': email,
                'surname': null,
                'balance': 0,
                'profileImageUrl': null,
                'notificationsEnabled': false,
              }
            );
          }
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setBool('isLoggedIn', true);
            await prefs.setInt('loginTimestamp', DateTime.now().millisecondsSinceEpoch);

            if(mounted) { // Check if the widget is still in the tree
              showToast(message: 'Google sign in successful');
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const MainPage(),
                ),
              );
            }
        }
      }
      
    } catch (e) {
        showToast(message: 'Some error occurred: $e');
    }
    setState((){
      _isLoading = false;
    });
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
          SingleChildScrollView(
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
            child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              // Logo above the white container
              Image.asset(
                'assets/logo_small.png',
                height: 200, // Adjust the height as needed
                width: 200,  // Adjust the width as needed
              ),
              const SizedBox(height: 20), // Space between logo and container
              // Container for login form
              Container(
                height: MediaQuery.of(context).size.height,
                width: 500,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25), 
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                     // Space before the Login text
                    const Text(
                      'Log in',
                      style: TextStyle(
                        fontSize: 43,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF58C6A9),
                      ),
                    ),
                    const SizedBox(height: 50), // Space between the Login text and text boxes
                    // Email Text Field
                    TextField(
                      controller: _emailController,
                      key: const Key('Email'),
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
                    const SizedBox(height: 25),
                    // Password Text Field
                    TextField(
                      controller: _passwordController,
                      key: const Key('Password'),
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
                        // Add suffix icon for visibility toggle
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey.shade700,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.grey.shade800, // Dark grey input text color
                      ),
                      obscureText: _obscureText,
                    ),
                    const SizedBox(height: 30),
                    // Login Button
                    ElevatedButton(
                      onPressed: () {
                       _signIn();
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
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.0,
                              ),
                            )
                          : const Text(
                        'Log in',
                        style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w400),
                      ),
                    ),
                    const SizedBox(height: 40), // Space between login button and Login with section
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
                            'Or Login with',
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
                        GestureDetector(
                          onTap: _signInWithGoogle,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Image.asset(
                              'assets/G_Logo.png',
                              height: 100, // Adjust the height as needed
                              width: 100,  // Adjust the width as needed
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 5), // Space between login button and Login with section
                    InkWell(
                      onTap: () {
                        // Navigate to SignupPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignupPage()),
                        );
                      },
                      child: const Text(
                        "Don't have an account? Sign up",
                        style: TextStyle(fontSize: 20, color: Color(0xFF58C6A9), fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
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