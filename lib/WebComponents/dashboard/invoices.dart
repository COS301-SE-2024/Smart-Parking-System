import 'package:flutter/material.dart';

class Invoices extends StatelessWidget {
  const Invoices({super.key});

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
                'Invoices',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF58C6A9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
                child: const Text(
                  'VIEW ALL',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const SizedBox(height: 20),
          _buildInvoiceItem('March, 01, 2024', '#MS-415646', 'R 30'),
          _buildInvoiceItem('February, 10, 2024', '#RV-126749', 'R 20'),
        ],
      ),
    );
  }

  Widget _buildInvoiceItem(String date, String invoiceNumber, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                date,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                invoiceNumber,
                style: const TextStyle(
                  color: Color(0xFFA0AEC0),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                amount,
                style: const TextStyle(
                  color: Color(0xFFA0AEC0),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 10),
              const Row(
                children: [
                  SizedBox(width: 4),
                  Text(
                    'OPEN PDF',
                    style: TextStyle(
                      color: Color(0xFFA0AEC0),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}