import 'package:flutter/material.dart';
import 'package:smart_parking_system/WebComponents/dashboard/sidebar.dart';
import 'package:smart_parking_system/WebComponents/dashboard/header.dart';
import 'package:smart_parking_system/WebComponents/dashboard/stats_cards.dart';
import 'package:smart_parking_system/WebComponents/dashboard/booking_billings.dart';
import 'package:smart_parking_system/WebComponents/dashboard/invoices.dart';
import 'package:smart_parking_system/WebComponents/dashboard/booking_details.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF35344A),
      body: Row(
        children: [
          const Sidebar(),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(48.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Header(),
                    const SizedBox(height: 20),
                    const StatsCards(),
                    const SizedBox(height: 46),
                    const BookingBillings(),
                    const SizedBox(height: 45),
                    const Invoices(),
                    const SizedBox(height: 45),
                    const BookingDetails(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}