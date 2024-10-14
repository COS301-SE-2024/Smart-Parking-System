import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookingDetails extends StatelessWidget {
  const BookingDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final bookingsCollection = FirebaseFirestore.instance.collection('bookings');

    return Card(
      color: const Color(0xFF1A1F37),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            const Text(
              'Booking Details',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // Fetch bookings from Firestore
            StreamBuilder<QuerySnapshot>(
              stream: bookingsCollection
                  .where('userId', isEqualTo: currentUser?.uid)
                  .orderBy('notificationTime', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Text(
                      "Your customer booking details will be displayed here",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }

                final bookings = snapshot.data!.docs;

                if (bookings.isEmpty) {
                  return const Center(
                    child: Text(
                      'No bookings found.',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                // Build booking items
                return Column(
                  children: bookings.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final zone = data['zone'] ?? '';
                    final row = data['row'] ?? '';
                    final title = '$zone$row Parking Booking';

                    final date = data['date'] ?? ''; // e.g., "2024-11-14"
                    final time = data['time'] ?? ''; // e.g., "12:00"
                    final dateTimeString = '$date, at $time';

                    return _buildBookingItem(context, doc.id, title, dateTimeString, data);
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingItem(BuildContext context, String bookingId, String title, String date, Map<String, dynamic> data) {
    return Card(
      color: const Color(0xFF2D3447),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Color(0xFF58C6A9),
          child: Icon(Icons.event_note, color: Colors.white),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          date,
          style: const TextStyle(
            color: Color(0xFFA0AEC0),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        trailing: ElevatedButton(
          onPressed: () {
            _showEditDialog(context, bookingId, data);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF58C6A9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          child: const Text(
            'Edit',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, String bookingId, Map<String, dynamic> data) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController dateController = TextEditingController(text: data['date'] ?? '');
    final TextEditingController timeController = TextEditingController(text: data['time'] ?? '');
    final TextEditingController durationController = TextEditingController(text: data['duration']?.toString() ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1F37),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'Edit Booking',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  // Date Field
                  TextFormField(
                    controller: dateController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Date',
                      labelStyle: TextStyle(color: Color(0xFFA0AEC0)),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFA0AEC0)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF58C6A9)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a date';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  // Time Field
                  TextFormField(
                    controller: timeController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Time',
                      labelStyle: TextStyle(color: Color(0xFFA0AEC0)),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFA0AEC0)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF58C6A9)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a time';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  // Duration Field
                  TextFormField(
                    controller: durationController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Duration (hours)',
                      labelStyle: TextStyle(color: Color(0xFFA0AEC0)),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFA0AEC0)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF58C6A9)),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter duration';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Color(0xFF58C6A9))),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  // Capture the NavigatorState before the await call
                  var navigator = Navigator.of(context);
                  // Update the booking in Firestore
                  await FirebaseFirestore.instance
                      .collection('bookings')
                      .doc(bookingId)
                      .update({
                    'date': dateController.text,
                    'time': timeController.text,
                    'duration': int.parse(durationController.text),
                  });
                  navigator.pop(); // Close the dialog after saving
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF58C6A9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Save Changes',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
