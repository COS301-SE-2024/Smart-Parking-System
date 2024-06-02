import 'package:flutter/material.dart';
import 'package:smart_parking_system/components/bookings/view_bookings.dart';


class BookSpaceScreen extends StatefulWidget {
  const BookSpaceScreen({super.key});

  @override
  State<BookSpaceScreen> createState() => _BookSpaceScreenState();
}

class _BookSpaceScreenState extends State<BookSpaceScreen> {
  double _estimatedDuration = 2;
  TimeOfDay? _checkInTime = const TimeOfDay(hour: 0, minute: 0);
  bool _isDisabledParking = false;
  bool _isCarWashing = false;

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _checkInTime ?? const TimeOfDay(hour: 0, minute: 0),
    );
    if (picked != null && picked != _checkInTime) {
      setState(() {
        _checkInTime = picked;
      });
    }
  }

  void _showBookingConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 60,
              ),
              const SizedBox(height: 10),
              const Text(
                'Space Successfully Booked',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const BookingScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 30),

                ),
                child: const Text(
                  'View Booking Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              )

            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        actions: const [
          CircleAvatar(
            backgroundImage: NetworkImage('https://example.com/profile_image.png'),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Sandton City',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text('R10/hr'),
                  ],
                ),
              )
            ),
            const SizedBox(height: 16),
            const Text(
              'Space 2C',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Estimate Duration',
              style: TextStyle(fontSize: 16),
            ),
            Slider(
              value: _estimatedDuration,
              min: 1,
              max: 24,
              divisions: 23,
              label: '${_estimatedDuration.round()} hours - R${(_estimatedDuration * 10).round()}',
              onChanged: (value) {
                setState(() {
                  _estimatedDuration = value;
                });
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Check-in Time:',
              style: TextStyle(fontSize: 16),
            ),
            Row(
              children: [
                Text(
                  _checkInTime?.format(context) ?? 'Select time',
                  style: const TextStyle(fontSize: 16),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _selectTime(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Specifications',
              style: TextStyle(fontSize: 16),
            ),
            SwitchListTile(
              title: const Text('Disabled Parking'),
              value: _isDisabledParking,
              onChanged: (value) {
                setState(() {
                  _isDisabledParking = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Request Car Washing (R100)'),
              value: _isCarWashing,
              onChanged: (value) {
                setState(() {
                  _isCarWashing = value;
                });
              },
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                _showBookingConfirmation(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Book Space',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
