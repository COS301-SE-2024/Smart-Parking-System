import 'package:flutter/material.dart';

class BookingBillings extends StatelessWidget {
  const BookingBillings({Key? key}) : super(key: key);

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Booking Billings',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Row(
                children: [
                  Image.network(
                    'https://cdn.builder.io/api/v1/image/assets/TEMP/53f40adde10f33178f0187c779a02cdedbabf943dd3b28bddaad895417316a8e?placeholderIfAbsent=true&apiKey=109e5ef2921f4f19976eeca47438f346',
                    width: 19,
                    height: 16,
                  ),
                  const SizedBox(width: 8),
                  const Text(
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
            'https://cdn.builder.io/api/v1/image/assets/TEMP/a7972ed14f5880557037f856e3114085e751c7092766b63606dd83295361fbcd?placeholderIfAbsent=true&apiKey=109e5ef2921f4f19976eeca47438f346',
          ),
          _buildBillingItem(
            'A36 Parking Booking',
            '27 March 2024, at 12:30 PM',
            '+R40',
            'https://cdn.builder.io/api/v1/image/assets/TEMP/e46fc4611ded0b5622f9c7c6b13fa84542341134fea82e571dfc1f5887904dbe?placeholderIfAbsent=true&apiKey=109e5ef2921f4f19976eeca47438f346',
          ),
          _buildBillingItem(
            'C32 Parking Booking',
            '26 March 2024, at 05:00 AM',
            'Pending',
            'https://cdn.builder.io/api/v1/image/assets/TEMP/beb264ba687df869e0c380c83ea92c24d6ace8f8f36ee25492278e4bfed2c850?placeholderIfAbsent=true&apiKey=109e5ef2921f4f19976eeca47438f346',
          ),
          _buildBillingItem(
            'B52 Parking Booking',
            '27 March 2024, at 12:30 PM',
            '+R40',
            'https://cdn.builder.io/api/v1/image/assets/TEMP/54f17568422f3316a78dc79cc62bd50da95c1cc79c272686ac3015bf245f6f8e?placeholderIfAbsent=true&apiKey=109e5ef2921f4f19976eeca47438f346',
          ),
        ],
      ),
    );
  }

  Widget _buildBillingItem(String title, String date, String amount, String iconUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.network(
                iconUrl,
                width: 45,
                height: 45,
                fit: BoxFit.contain,
              ),
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