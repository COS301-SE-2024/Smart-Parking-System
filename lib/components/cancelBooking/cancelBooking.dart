import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Parking System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            // Handle drawer opening
          },
        ),
        actions: <Widget>[
          CircleAvatar(
            radius: 20.0,
            backgroundImage: NetworkImage(
                'https://example.com/path_to_profile_image.jpg'),
          ),
          SizedBox(width: 10.0),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 40.0),
          Center(
            child: Column(
              children: <Widget>[
                Text(
                  'Bookings',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20.0),
                FloatingActionButton(
                  onPressed: () {
                    // Handle add booking action
                  },
                  child: Icon(Icons.add),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
