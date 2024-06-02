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
                'https://example.com/path_to_profile_image.jpg'), // 替换为你的头像图片URL
          ),
          SizedBox(width: 10.0),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 40.0), // 添加一些顶部间距
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
                BookingCard(),
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

class BookingCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Sandton Mall',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text('25th June 2024'),
                  SizedBox(height: 5.0),
                  Row(
                    children: <Widget>[
                      Text('Start: 14:35'),
                      VerticalDivider(
                        width: 20.0,
                        thickness: 1.0,
                        color: Colors.black,
                      ),
                      Text('End: 16:55'),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.blue,
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.directions_car,
                    color: Colors.white,
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    'Level 1\nRow 2',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
