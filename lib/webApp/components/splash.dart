import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_parking_system/webapp/components/login.dart';
import 'package:smart_parking_system/webapp/components/registration1.dart';

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

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
        '/login': (context) => LoginPage(),
        '/registration': (context) => RegistrationPage()
      },
    );
  }
}

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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Moved logo to the left
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Center(
                              child: Image.asset(
                                'assets/logo1.png',
                                height: constraints.maxHeight * 0.25,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 60),
                            child: Text(
                              'Never waste time\nsearching for\nparking again!',
                              style: TextStyle(
                                fontSize: constraints.maxWidth * 0.06,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                height: 1.0,
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          Padding(
                            padding: const EdgeInsets.only(left: 60, top: 50, bottom: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: constraints.maxWidth * 0.15,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/login');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF58C6A9),
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
                          ),
                          const SizedBox(height: 40),
                          // Centered "Or Sign up with" section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/line.png',
                                width: 200,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  'Or Sign up with',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: constraints.maxWidth * 0.012,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                              Image.asset(
                                'assets/line.png',
                                width: 200,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: Image.asset(
                              'assets/google-play.png',
                              height: constraints.maxHeight * 0.06,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: Text(
                              '© 2024 DaVinci Code. All rights reserved.\nPrivacy policy | Contact us',
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
//column