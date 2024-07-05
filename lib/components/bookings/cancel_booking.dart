import 'package:flutter/material.dart';
// import 'package:smart_parking_system/components/bookings/make_booking.dart';

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
  const CancelBookingPage({super.key});

  @override
  State<CancelBookingPage> createState() => _CancelBookingPageState();
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
          title: const Text('Confirm Cancellation'),
          content: const Text('Are you sure you want to cancel this booking?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                _cancelBooking(index);
              },
              child: const Text('Yes'),
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
          icon: const Icon(Icons.menu),
          onPressed: () {
            // Handle drawer opening
          },
        ),
        actions: const <Widget>[
          CircleAvatar(
            radius: 20.0,
            backgroundImage: AssetImage('assets/profile.png')
            ),
          SizedBox(width: 10.0),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 40.0), // 添加一些顶部间距
          Center(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Container(
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
          ),
          ),
          const SizedBox(height: 20.0),
          ...bookings.asMap().entries.map((entry) {
            int index = entry.key;
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
              child: const BookingCard(),
            );
          }),
          const SizedBox(height: 20.0),
          FloatingActionButton(
            onPressed: () {
              // Handle add booking action
              // Navigator.of(context).pushReplacement(
              //     MaterialPageRoute(
              //       builder: (context) => const BookingPage(),
              //     ),
              //   );
              Navigator.of(context).pop();
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  const BookingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: IntrinsicHeight(
      child: Row(
      children: <Widget>[
      const Expanded(
      flex: 2,
      child: Padding(
        padding: EdgeInsets.all(16.0),
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
                SizedBox(
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
            decoration: const BoxDecoration(
              color: Color(0xFF4C4981),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              ),
            ),
            padding: const EdgeInsets.all(16.0),
            child: const Center(
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
                    'Zone B\nLevel 1\nRow 2',
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

  const BookingDetailsDialog({super.key, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Sandton Mall',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10.0),
        const Row(
          children: <Widget>[
            Icon(Icons.calendar_today),
            SizedBox(width: 10.0),
            Text('25th June 2024'),
          ],
        ),
        const SizedBox(height: 10.0),
        const Row(
          children: <Widget>[
            Icon(Icons.access_time),
            SizedBox(width: 10.0),
            Text('2 Hours'),
          ],
        ),
        const SizedBox(height: 10.0),
        const Row(
          children: <Widget>[
            Icon(Icons.directions_car),
            SizedBox(width: 10.0),
            Text('Zone B Level 1 Row 2'),
          ],
        ),
        const SizedBox(height: 10.0),
        const Row(
          children: <Widget>[
            Icon(Icons.edit),
            SizedBox(width: 10.0),
            Text('Booking reference: 2KJ234'),
          ],
        ),
        const SizedBox(height: 10.0),
        const Row(
          children: <Widget>[
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 10.0),
            Text('Paid'),
          ],
        ),
        const SizedBox(height: 10.0),
        Row(
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                onPressed: onCancel,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4C4981),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Cancel booking'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
