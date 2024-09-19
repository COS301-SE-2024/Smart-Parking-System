import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_parking_system/components/login/card_registration.dart';
import 'package:smart_parking_system/components/common/toast.dart';

class VerificationPage extends StatefulWidget {
  final String email;
  final User user;

  const VerificationPage({
    super.key,
    required this.user,
    required this.email,
  });

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {

  @override
  void initState() {
    super.initState();
    // _sendVerificationEmail();
    verification();
  }

  Future<void> verification() async {

    await widget.user.sendEmailVerification();
    showToast(message: 'A verification email has been sent to ${widget.email}');

    // Wait for the email to be verified
    bool emailVerified = false;
    while (!emailVerified) {
      await Future.delayed(const Duration(seconds: 3));
      await widget.user.reload();
      final User? currentUser = FirebaseAuth.instance.currentUser;
      emailVerified = currentUser?.emailVerified ?? false;
    }

    if (emailVerified) {
      if (mounted) { // Check if the widget is still in the tree
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const AddCardRegistrationPage()
          ),
        );
      }
    } else {
      showToast(message: 'Email not verified');
    }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SvgPicture.asset(
            'assets/Background - Small.svg',
            fit: BoxFit.fill,
            width: double.infinity,
            height: double.infinity,
          ),
          Center(
            child: SingleChildScrollView(
              child: SizedBox(
                width: 550,
                child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Email Verification',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'We sent you an email to verify your email.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Center(
                        child: SizedBox( 
                          width: 300,
                          child: ElevatedButton(
                            onPressed: () {
                              
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                // horizontal: 15,
                                vertical: 20,
                              ),
                              backgroundColor: const Color.fromARGB(255, 66, 87, 81),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                              Text(
                                'Verifying',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 20),
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.0,
                                  ),
                                ),
                            ],)
                          ),
                        ),
                        
                      ),
                      const SizedBox(height: 30,),
                      Center(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Wait 30 seconds, then:',
                                style: TextStyle(
                                  color: Colors.white
                                )
                              ),
                              TextButton(
                                onPressed: verification, 
                                child: const Text(
                                  'Resend Email',
                                  style: TextStyle(
                                    color: Color(0xFF58C6A9),
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ), 
                            ],
                          ),
                      ),
                    ],
                  ),
                ),
              ),
              ),
              
            ),
          
        ],
      ),
    );
  }
}
