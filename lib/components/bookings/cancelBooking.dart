import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Smart Parking System',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: CancelBookingPage(),
//     );
//   }
// }

class CancelBookingPage extends StatefulWidget {
  @override
  _CancelBookingPageState createState() => _CancelBookingPageState();
}

class _CancelBookingPageState extends State<CancelBookingPage> {
  List<String> bookings = ['Sandton Mall']; // 示例数据

  void _cancelBooking(int index) {
    setState(() {
      bookings.removeAt(index);
    });
  }

  void _showCancelConfirmationDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Cancellation'),
          content: Text('Are you sure you want to cancel this booking?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _cancelBooking(index);
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

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
                'https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2'),
          ),
          SizedBox(width: 10.0),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 40.0), // 添加一些顶部间距
          Center(
            child: Container(
              width: 200.0, // 调整宽度
              decoration: BoxDecoration(
                color: Colors.white, // 背景颜色
                borderRadius: BorderRadius.circular(20.0), // 圆角
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                'Bookings',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: 20.0),
          ...bookings.asMap().entries.map((entry) {
            int index = entry.key;
            String booking = entry.value;
            return GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: BookingDetailsDialog(
                        onCancel: () => _showCancelConfirmationDialog(index),
                      ),
                    );
                  },
                );
              },
              child: BookingCard(),
            );
          }).toList(),
          SizedBox(height: 20.0),
          FloatingActionButton(
            onPressed: () {
              // Handle add booking action
            },
            child: Icon(Icons.add),
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
                  'Start: 14:35',
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
                  'End: 16:55',
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
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFF4C4981),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              ),
            ),
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.directions_car,
                    color: Colors.white,
                    size: 40.0,
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Level 1\nRow 2',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
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
  final VoidCallback onCancel;

  BookingDetailsDialog({required this.onCancel});

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
        SizedBox(height: 10.0),
        Row(
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                onPressed: onCancel,
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
