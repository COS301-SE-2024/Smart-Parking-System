import 'package:flutter/material.dart';

class BookingDetails extends StatelessWidget {
  const BookingDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
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
                'Booking Details',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Row(
                children: [
                  Image.network(
                    'https://cdn.builder.io/api/v1/image/assets/TEMP/7389423a944638f9046db02ab5e05380b10b2c60af4eba44c6740112be6f9dd8?placeholderIfAbsent=true&apiKey=109e5ef2921f4f19976eeca47438f346',
                    width: 15,
                    height: 14,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 6),
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
          _buildBookingItem(
            'A36 Parking Booking Refund',
            '27 March 2024, at 12:35 PM',
            'https://cdn.builder.io/api/v1/image/assets/TEMP/4d65e5092253e78637bf8f086dcdf5817a55ec241987fd1e90d15e8e1a88eab2?placeholderIfAbsent=true&apiKey=109e5ef2921f4f19976eeca47438f346',
          ),
          _buildBookingItem(
            'A36 Parking Booking',
            '27 March 2024, at 12:30 PM',
            'https://cdn.builder.io/api/v1/image/assets/TEMP/6aee38d759a0060f1c5eba7455af752264ebcb25a7296a12c3b560b08777b985?placeholderIfAbsent=true&apiKey=109e5ef2921f4f19976eeca47438f346',
          ),
          const SizedBox(height: 20),
          const Text(
            'YESTERDAY',
            style: TextStyle(
              color: Color(0xFFA0AEC0),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          _buildBookingItem(
            'B52 Parking Booking',
            '27 March 2024, at 12:30 PM',
            'https://cdn.builder.io/api/v1/image/assets/TEMP/b7d78d07cbc7e6c20e231c7debe52b440fa921db1bb30f4cef5dd72d35dcf0ac?placeholderIfAbsent=true&apiKey=109e5ef2921f4f19976eeca47438f346',
          ),
          _buildBookingItem(
            'C32 Parking Booking',
            '26 March 2024, at 05:00 AM',
            'https://cdn.builder.io/api/v1/image/assets/TEMP/b4635b3376ef76d93d831e43a26545542a10b70ec2f193e3ce70bf12af07b314?placeholderIfAbsent=true&apiKey=109e5ef2921f4f19976eeca47438f346',
          ),
        ],
      ),
    );
  }

  Widget _buildBookingItem(String title, String date, String iconUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.network(
                iconUrl,
                width: 35,
                height: 35,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 14),
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
          ElevatedButton(
            onPressed: () {},
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
        ],
      ),
    );
  }
}