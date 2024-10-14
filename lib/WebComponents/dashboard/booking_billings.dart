import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookingBillings extends StatelessWidget {
  const BookingBillings({super.key});

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
            // Header row
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Booking Billings',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Use a StreamBuilder to fetch bookings from Firestore
            StreamBuilder<QuerySnapshot>(
              stream: bookingsCollection
                  .where('userId', isEqualTo: currentUser?.uid)
                  .orderBy('notificationTime', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Text(
                      "Your booking billings details will be displayed here",
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

                // Build a list of billing items
                return Column(
                  children: bookings.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final zone = data['zone'] ?? '';
                    final row = data['row'] ?? '';
                    final title = '$zone$row Parking Booking';

                    final date = data['date'] ?? ''; // e.g., "2024-11-14"
                    final time = data['time'] ?? ''; // e.g., "12:00"
                    final dateTimeString = '$date, at $time';

                    final price = data['price'] ?? 0; // e.g., 10
                    String amount = '+R$price';

                    // Determine the amount based on booking status
                    final disabled = data['disabled'] ?? false;
                    final sent = data['sent'] ?? false;

                    if (disabled) {
                      // Booking was canceled/refunded
                      amount = '-R$price';
                    } else if (!sent) {
                      // Booking is pending
                      amount = 'Pending';
                    }

                    return _buildBillingItem(context, title, dateTimeString, amount);
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillingItem(BuildContext context, String title, String date, String amount) {
    Color amountColor;
    IconData iconData;

    if (amount.startsWith('+')) {
      amountColor = const Color(0xFF01B574); // Positive amount color
      iconData = Icons.arrow_upward; // Icon for positive transactions
    } else if (amount.startsWith('-')) {
      amountColor = Colors.red; // Negative amount color
      iconData = Icons.arrow_downward; // Icon for negative transactions
    } else {
      amountColor = Colors.yellow; // Pending amount color
      iconData = Icons.hourglass_empty; // Icon for pending transactions
    }

    return Card(
      color: const Color(0xFF2D3447),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF58C6A9),
          child: Icon(iconData, color: Colors.white),
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
        trailing: Text(
          amount,
          style: TextStyle(
            color: amountColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
