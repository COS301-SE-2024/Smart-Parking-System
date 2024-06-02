import 'package:flutter/material.dart';
import 'package:smart_parking_system/components/bookings/bookspace.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BookSpaceScreen()),
            );
          },
          child: Text('Book Space'),
        ),
      ),
    );
  }
}

