import 'package:flutter/material.dart';

class StatsCards extends StatelessWidget {
  const StatsCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildIncomeCard(),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            children: [
              _buildStatsCard(
                title: "Today's Bookings",
                value: '302',
                iconUrl: 'https://cdn.builder.io/api/v1/image/assets/TEMP/3cb395552fdffb735d72a221b213b97a55c77df5869155584dffcd46c3b01263?placeholderIfAbsent=true&apiKey=109e5ef2921f4f19976eeca47438f346',
              ),
              const SizedBox(height: 18),
              _buildStatsCard(
                title: 'Total Parking Income',
                value: 'R 173,0000',
                iconUrl: 'https://cdn.builder.io/api/v1/image/assets/TEMP/bb10067f4d267608d9b3a8e3e39ab14a7114fe5c25c2bb334089dfd8022c6d2f?placeholderIfAbsent=true&apiKey=109e5ef2921f4f19976eeca47438f346',
              ),
              const SizedBox(height: 18),
              _buildStatsCard(
                title: "Today's Money",
                value: 'R 53,000',
                iconUrl: 'https://cdn.builder.io/api/v1/image/assets/TEMP/e51a57169833c585e6288db581c621e3b4f7b155d001d123cb19fabdbd61cf36?placeholderIfAbsent=true&apiKey=109e5ef2921f4f19976eeca47438f346',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIncomeCard() {
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Total Income',
                    style: TextStyle(
                      color: Color(0xFFE9EDF7),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'R25,215',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Image.network(
                'https://cdn.builder.io/api/v1/image/assets/TEMP/77a178fd5e51f686fe8dd5dd2aee64d6d4d3f1a1865ee6b1112db404d52dde0b?placeholderIfAbsent=true&apiKey=109e5ef2921f4f19976eeca47438f346',
                width: 176,
                fit: BoxFit.contain,
              ),
            ],
          ),
          const SizedBox(height: 34),
          const Text(
            'NEWEST',
            style: TextStyle(
              color: Color(0xFFA0AEC0),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 19),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'A36 Parking Booking',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Today, 16:36',
                    style: TextStyle(
                      color: Color(0xFFA0AEC0),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const Text(
                '+R40.50',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard({required String title, required String value, required String iconUrl}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F37),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFFA0AEC0),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Image.network(
            iconUrl,
            width: 45,
            height: 45,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}