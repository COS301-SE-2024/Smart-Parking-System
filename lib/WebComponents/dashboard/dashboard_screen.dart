import 'package:flutter/material.dart';
import 'package:smart_parking_system/WebComponents/dashboard/sidebar.dart';
import 'package:smart_parking_system/WebComponents/dashboard/header.dart';
import 'package:smart_parking_system/WebComponents/dashboard/stats_cards.dart';
import 'package:smart_parking_system/WebComponents/dashboard/booking_billings.dart';
import 'package:smart_parking_system/WebComponents/dashboard/invoices.dart';
import 'package:smart_parking_system/WebComponents/dashboard/booking_details.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF35344A),
      body: Row(
        children: [
          // Sidebar
          Sidebar(),
          // Main Content
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(48.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Header(),
                    SizedBox(height: 20),
                    // Stats Cards
                    StatsCards(),
                    SizedBox(height: 46),
                    // Booking Billings
                    BookingBillings(),
                    SizedBox(height: 45),
                    // Invoices
                    Invoices(),
                    SizedBox(height: 45),
                    // Booking Details
                    BookingDetails(),
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
