import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/backW.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minHeight: constraints.maxHeight),
                          child: IntrinsicHeight(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Reduced the top space
                                Image.asset('assets/logo1.png', height: constraints.maxHeight * 0.25),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.only(left: 40),
                                  child: Text(
                                    'Never waste time\nsearching for\nparking again!',
                                    style: TextStyle(
                                      fontSize: constraints.maxWidth * 0.05,
                                      fontWeight: FontWeight.bold, // Increased thickness
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 40), // Space between text and buttons
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Reduced button width
                                    SizedBox(
                                      width: constraints.maxWidth * 0.15, // Adjusted width
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.teal,
                                          padding: const EdgeInsets.symmetric(vertical: 15),
                                        ),
                                        child: Text(
                                          'Log in',
                                          style: TextStyle(
                                            fontSize: constraints.maxWidth * 0.015,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    SizedBox(
                                      width: constraints.maxWidth * 0.15, // Adjusted width
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blueGrey,
                                          padding: const EdgeInsets.symmetric(vertical: 15),
                                        ),
                                        child: Text(
                                          'Client Register',
                                          style: TextStyle(
                                            fontSize: constraints.maxWidth * 0.015,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 40),
                                Row(
                                  children: [
                                    // Reduced width of white lines
                                    Expanded(
                                      flex: 1, // Adjusted flex
                                      child: Divider(color: Colors.white, thickness: 0.5),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: Text(
                                        'Download our app',
                                        style: TextStyle(color: Colors.white, fontSize: constraints.maxWidth * 0.012, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1, // Adjusted flex
                                      child: Divider(color: Colors.white, thickness: 0.5),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Image.asset('assets/google-play.png', height: constraints.maxHeight * 0.06),
                                const SizedBox(height: 20),
                                Text(
                                  '© 2024 DaVinci Code. All rights reserved.\nPrivacy policy | Contact us',
                                  style: TextStyle(color: Colors.white, fontSize: constraints.maxWidth * 0.01, fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Image.asset('assets/parking.png', fit: BoxFit.contain),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
