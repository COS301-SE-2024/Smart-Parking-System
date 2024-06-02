import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Two Buttons Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF613EEA),
                foregroundColor: Colors.white,   // Text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              onPressed: () {
                // Do nothing
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 50.0,
                  vertical: 15,
                ),
                child: Text('Button 1'),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF613EEA),
                foregroundColor: Colors.white,   // Text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              onPressed: () {
                // Do nothing
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 50.0,
                  vertical: 15,
                ),
                child: Text('Button 2'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

