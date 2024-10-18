import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_parking_system/webApp/components/login.dart';
import 'package:smart_parking_system/webApp/components/registration1.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ParkMe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.urbanistTextTheme(
          Theme.of(context).textTheme,
        ).apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => const LoginPage(),
        '/registration': (context) => const RegistrationPage(),
      },
    );
  }
}

// ignore: use_key_in_widget_constructors
class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/backW.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center, // Centering the Column
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Centered logo
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20), // Added space below the logo
                            child: Center(
                              child: Image.asset(
                                'assets/logo1.png',
                                height: constraints.maxHeight * 0.25,
                              ),
                            ),
                          ),
                          // Centered text
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20), // Adjust padding as necessary
                            child: Center(
                              child: Text(
                                'Never waste time\nsearching for\nparking again!',
                                textAlign: TextAlign.center, // Center the text
                                style: TextStyle(
                                  fontSize: constraints.maxWidth * 0.06,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  height: 1.0,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          // Centered buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: constraints.maxWidth * 0.15,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/login');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF58C6A9),
                                    padding: const EdgeInsets.symmetric(vertical: 15),
                                  ),
                                  child: Text(
                                    'Log in',
                                    style: TextStyle(
                                      fontSize: constraints.maxWidth * 0.015,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              SizedBox(
                                width: constraints.maxWidth * 0.15,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/registration');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueGrey,
                                    padding: const EdgeInsets.symmetric(vertical: 15),
                                  ),
                                  child: Text(
                                    'Client Register',
                                    style: TextStyle(
                                      fontSize: constraints.maxWidth * 0.015,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 80),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/line.png',
                                width: 200,
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                          Center(
                            child: Text(
                              '© 2024 DaVinci Code. All rights reserved.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: constraints.maxWidth * 0.01,
                                fontWeight: FontWeight.w900,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Image.asset(
                        'assets/parking.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
