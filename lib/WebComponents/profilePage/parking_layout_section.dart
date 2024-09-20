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
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          Expanded(
            flex: 32,
            child: Sidebar(),
          ),
          Expanded(
            flex: 68,
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileCard(),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ParkingDetails(),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: ParkingRate(),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  HelpSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}