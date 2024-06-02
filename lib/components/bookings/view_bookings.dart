import 'package:flutter/material.dart';
import 'package:smart_parking_system/components/bookings/make_booking.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});
  

  @override
  State<BookingScreen> createState() => _BookingScreen();
}

class _BookingScreen extends State<BookingScreen> {

   @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage('https://example.com/user-profile.jpg'), // Replace with actual image URL
            ),
          ),
        ],
      ),
      drawer: const Drawer(
        // Add your drawer items here
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal:  16.0, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'Bookings',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            const BookingCard(),
            const Spacer(),
            FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const BookingPage(),
                  ),
                );
              },
              child:  const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  const BookingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Padding(
            padding:  EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sandton Mall',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '25th June 2024',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  '14:35 - 16:55',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 50.0,vertical: 40),
            decoration: BoxDecoration(
              color: const Color(0xFF4C4981),
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.directions_car,
                  color: Colors.white,
                ),
                SizedBox(height: 8.0),
                Text(
                  'Zone B',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Level 1',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Row 2',
                  style: TextStyle(
                    color: Colors.white,
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