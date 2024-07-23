// select_row.dart
import 'package:flutter/material.dart';

class SelectRowPage extends StatelessWidget {
  final String bookedAddress;
  final double price;
  final String selectedZone;
  final String selectedLevel;

  const SelectRowPage({
    required this.bookedAddress,
    required this.price,
    required this.selectedZone,
    required this.selectedLevel,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Row')),
      body: Center(
        child: Text('Booked Address: $bookedAddress\nPrice: $price\nSelected Zone: $selectedZone\nSelected Level: $selectedLevel'),
      ),
    );
  }
}