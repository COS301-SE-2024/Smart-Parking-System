import 'package:flutter/material.dart';


class BookSpaceScreen extends StatefulWidget {
  @override
  _BookSpaceScreenState createState() => _BookSpaceScreenState();
}

class _BookSpaceScreenState extends State<BookSpaceScreen> {
  double _estimatedDuration = 2;
  TimeOfDay? _checkInTime = TimeOfDay(hour: 0, minute: 0);
  bool _isDisabledParking = false;
  bool _isCarWashing = false;

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _checkInTime ?? TimeOfDay(hour: 0, minute: 0),
    );
    if (picked != null && picked != _checkInTime) {
      setState(() {
        _checkInTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        actions: [
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
            SizedBox(height: 16),
            Text(
              'Space 2C',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
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
            SizedBox(height: 16),
            Text(
              'Check-in Time:',
              style: TextStyle(fontSize: 16),
            ),
            Row(
              children: [
                Text(
                  '${_checkInTime?.format(context) ?? 'Select time'}',
                  style: TextStyle(fontSize: 16),
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _selectTime(context),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Specifications',
              style: TextStyle(fontSize: 16),
            ),
            SwitchListTile(
              title: Text('Disabled Parking'),
              value: _isDisabledParking,
              onChanged: (value) {
                setState(() {
                  _isDisabledParking = value;
                });
              },
            ),
            SwitchListTile(
              title: Text('Request Car Washing (R100)'),
              value: _isCarWashing,
              onChanged: (value) {
                setState(() {
                  _isCarWashing = value;
                });
              },
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
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
