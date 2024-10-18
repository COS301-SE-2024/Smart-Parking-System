import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_parking_system/components/common/common_functions.dart';
import 'package:smart_parking_system/components/login/card_registration.dart';
import 'package:smart_parking_system/components/common/toast.dart';
import 'package:smart_parking_system/components/firebase/firebase_auth_services.dart';
import 'package:smart_parking_system/components/login/login.dart';
import 'package:smart_parking_system/components/login/email_verification.dart';


class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _noController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final FireBaseAuthServices _auth = FireBaseAuthServices();

  bool _isLoading = false;
  bool _obscureText = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _usernameController.dispose();
    _noController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  _signUpWithGoogle () async {
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

            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setBool('isLoggedIn', true);
            await prefs.setInt('loginTimestamp', DateTime.now().millisecondsSinceEpoch);

            if(mounted) { // Check if the widget is still in the tree
              showToast(message: 'Successfully signed up');
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AddCardRegistrationPage(),
                ),
              );
            }
          } else {
            showToast(message: 'User with this email already exists');
          }
        }
      }
      
    } catch (e) {
      if (e is FirebaseAuthException) {
        showToast(message: 'Authentication error: ${e.message}');
      } else if (e is PlatformException) {
        showToast(message: 'Platform error: ${e.message}');
      } else {
        showToast(message: 'An unexpected error occurred: $e');
      }
    }
    setState((){
      _isLoading = false;
    });
  }
   
  Future<void> verification() async {
    setState((){
      _isLoading = true;
    });

    final String password = _passwordController.text;
    final String username = _usernameController.text;
    final String email = _emailController.text;
    final String surname = _noController.text;

    if(!isValidString(email, r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')){showToast(message: "Invalid email address"); setState((){_isLoading = false;}); return;}
    if(!isValidString(password, r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,}$')){showToast(message: "Invalid password:\n\nAt least 1 uppercase letter\nAt least 1 lowercase letter\nAt least 1 number\nAt least 1 special character (!@#\$%^&*)\nA minimum length of 8"); setState((){_isLoading = false;}); return;}
    if(!isValidString(surname, r'^[a-zA-Z]+$')){showToast(message: "Invalid surname"); setState((){_isLoading = false;}); return;}
    if(!isValidString(username, r'^[a-zA-Z]+$')){showToast(message: "Invalid name"); setState((){_isLoading = false;}); return;}

    try{
      final firestore = FirebaseFirestore.instance;
      final querySnapshot = await firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isEmpty) {
        final User? user = await _auth.signUpWithEmailAndPassword(email, password);

        if (user != null) {
          if(mounted) { // Check if the widget is still in the tree

            await firestore.collection('users').doc(user.uid).set(
              {
                'username': username,
                'email': email,
                'surname': surname,
                'balance': 0,
                'profileImageUrl': null,
                'notificationsEnabled': false,
              }
            );

            if (mounted) { // Check if the widget is still in the tree before navigating
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => VerificationPage(user: user, email: email),
                )
              );
            }
          }
        } else {
          showToast(message: 'An Error Occured');
        }
      } else {
        showToast(message: 'User with this email already exists');
      }
    } catch (e) {
      showToast(message: 'Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
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
          SingleChildScrollView(
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
            child: 
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
                ],
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
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(
                          color: Colors.grey.shade700, // Darker grey for label text
                          fontWeight: FontWeight.w500,
                          fontSize: 22,
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
                        labelText: 'Surname',
                        labelStyle: TextStyle(
                          color: Colors.grey.shade700, // Darker grey for label text
                          fontWeight: FontWeight.w500,
                          fontSize: 22,
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
                          fontSize: 22,
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
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                          fontSize: 22,
                        ),
                        floatingLabelStyle: TextStyle(
                          color: Colors.grey.shade700,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFD9D9D9),
                        contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                            color: Color(0xFFD9D9D9),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                            color: Color(0xFFD9D9D9),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                            color: Color(0xFFD9D9D9),
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
                        // Add helper text for password hint
                        helperText: 'Password must be a minimum length of 8,\nAt least 1 uppercase, lowercase letter,\nAt least 1 number and special character (!@#%^&*)',
                        helperStyle: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.grey.shade800,
                      ),
                      obscureText: _obscureText,  // Use the state variable here
                    ),
  
                    const SizedBox(height: 30),
                    // Signup Button
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
                        GestureDetector(
                          key: const Key('google'),
                          onTap: () {
                            _signUpWithGoogle();
                            // Add functionality to signup with Google
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Image.asset(
                              'assets/G_Logo.png',
                              height: 100, // Adjust the height as needed
                              width: 100,  // Adjust the width as needed
                            ),
                          ),
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
          ),
        ],
      ),
    );
  }
}