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
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: BookingDetailsDialog(),
                        );
                      },
                    );
                  },
                  child: BookingCard(),
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

class BookingCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
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
                    SizedBox(height: 10.0),
                    Text(
                      '25th June 2024',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      children: <Widget>[
                        Text(
                          '14:35',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        SizedBox(width: 20.0),
                        Container(
                          height: 40.0,
                          child: VerticalDivider(
                            width: 1.0,
                            thickness: 1.0,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: 20.0),
                        Text(
                          '16:55',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1, // 右边部分占据1/3
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF4C4981), // 使用指定的紫色
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  ),
                ),
                padding: EdgeInsets.all(16.0),
                child: Center( // 使用Center确保内容居中
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.directions_car,
                        color: Colors.white,
                        size: 40.0, // 放大图标
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        'Level 1\nRow 2',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0, // 放大文字
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




class BookingDetailsDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Sandton Mall',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.0),
        Row(
          children: <Widget>[
            Icon(Icons.calendar_today),
            SizedBox(width: 10.0),
            Text('25th June 2024'),
          ],
        ),
        SizedBox(height: 10.0),
        Row(
          children: <Widget>[
            Icon(Icons.access_time),
            SizedBox(width: 10.0),
            Text('2 Hours'),
          ],
        ),
        SizedBox(height: 10.0),
        Row(
          children: <Widget>[
            Icon(Icons.directions_car),
            SizedBox(width: 10.0),
            Text('Level 1 Row 2'),
          ],
        ),
        SizedBox(height: 10.0),
        Row(
          children: <Widget>[
            Icon(Icons.edit),
            SizedBox(width: 10.0),
            Text('Booking reference: 2KJ234'),
          ],
        ),
        SizedBox(height: 10.0),
        Row(
          children: <Widget>[
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 10.0),
            Text('Paid'),
          ],
        ),
        SizedBox(height: 20.0),
        Row(
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Handle change booking action
                },
                child: Text('Change booking'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4C4981),
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.0),
        Row(
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Handle cancel booking action
                },
                child: Text('Cancel booking'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4C4981),
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
