import 'package:flutter/material.dart';
import 'package:smart_parking_system/WebComponents/profilePage/sidebar.dart';
import 'package:smart_parking_system/WebComponents/profilePage/profile_card.dart';
import 'package:smart_parking_system/WebComponents/profilePage/parking_details.dart';
import 'package:smart_parking_system/WebComponents/profilePage/parking_rate.dart';
import 'package:smart_parking_system/WebComponents/profilePage/help_section.dart';

class ParkingLayoutScreen extends StatelessWidget {
  const ParkingLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color(0xFF35344A),
      body: Row(
        children: [
          const Expanded(
            flex: 12,
            child: Sidebar(),
          ),
          Expanded(
            flex: 80,
            child: SingleChildScrollView(
              // Enable vertical scrolling
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                  // Ensure minimum height
                ),
                child: const IntrinsicHeight(
                  // Correct sizing for vertical direction
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Start of the modified code
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ProfileCard on the left
                            Expanded(
                              flex: 2,
                              child: ProfileCard(),
                            ),
                            SizedBox(width: 20),
                            // Column containing ParkingRate and ParkingDetails on the right
                            Expanded(
                              flex: 3,
                              child: Column(
                                children: [
                                  ParkingRate(),
                                  SizedBox(height: 20),
                                  ParkingDetails(),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // End of the modified code
                        SizedBox(height: 20),
                        // HelpSection at the bottom, expanded to fill remaining space
                        Expanded(
                          child: HelpSection(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
