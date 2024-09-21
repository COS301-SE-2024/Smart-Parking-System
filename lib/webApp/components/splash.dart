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
                          crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Center(
                              child: Image.asset(
                                'assets/logo1.png',
                                height: constraints.maxHeight * 0.25,
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
                            const SizedBox(height: 40), // Add more padding here to increase space above buttons
                            Padding(
                              padding: const EdgeInsets.only(left: 60, top: 50, bottom: 30), // Align buttons with text
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start, // Align buttons to the start
                                children: [
                                  SizedBox(
                                    width: constraints.maxWidth * 0.15,
                                    child: ElevatedButton(
                                      onPressed: () {},
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
                                      onPressed: () {},
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
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Divider(color: Colors.white, thickness: 0.5),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    'Download our app',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: constraints.maxWidth * 0.012,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Divider(color: Colors.white, thickness: 0.5),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Center(
                              child: Image.asset('assets/google-play.png', height: constraints.maxHeight * 0.06),
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
                        child: Image.asset('assets/parking.png', fit: BoxFit.contain),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
