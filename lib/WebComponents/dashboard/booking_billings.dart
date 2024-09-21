import 'package:flutter/material.dart';

class BookingBillings extends StatelessWidget {
  const BookingBillings({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F37),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Booking Billings',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Row(
                children: [
                  SizedBox(width: 8),
                  Text(
                    '23 - 30 March 2024',
                    style: TextStyle(
                      color: Color(0xFFA0AEC0),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildBillingItem(
            'A36 Parking Booking Refund',
            '27 March 2024, at 12:35 PM',
            '-R40',
          ),
          _buildBillingItem(
            'A36 Parking Booking',
            '27 March 2024, at 12:30 PM',
            '+R40',
          ),
          _buildBillingItem(
            'C32 Parking Booking',
            '26 March 2024, at 05:00 AM',
            'Pending',
          ),
          _buildBillingItem(
            'B52 Parking Booking',
            '27 March 2024, at 12:30 PM',
            '+R40',
          ),
        ],
      ),
    );
  }

  Widget _buildBillingItem(String title, String date, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    date,
                    style: const TextStyle(
                      color: Color(0xFFA0AEC0),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text(
            amount,
            style: TextStyle(
              color: amount.startsWith('+') ? const Color(0xFF01B574) : Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}