import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_parking_system/components/common/toast.dart';

import 'package:smart_parking_system/webApp/components/registration3.dart';


class Registration2 extends StatefulWidget {
  final Function onRegisterComplete;

  const Registration2({super.key, required this.onRegisterComplete});

  @override
  // ignore: library_private_types_in_public_api
  _Registration2State createState() => _Registration2State();
}

class _Registration2State extends State<Registration2> {
  final TextEditingController _locationController = TextEditingController();
  Map<String, String> operationalHours = {
    'Monday': '--',
    'Tuesday': '--',
    'Wednesday': '--',
    'Thursday': '--',
    'Friday': '--',
    'Saturday': '--',
    'Sunday': '--',
  };


  Future<void> _clientRegisterParkingDetails() async {
    final String location = _locationController.text;
    try {
      User? user = FirebaseAuth.instance.currentUser;
      
      if (user != null) {
        // Query for existing document
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('client_parking_details')
            .where('userId', isEqualTo: user.uid)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // Document exists, update it
          await querySnapshot.docs.first.reference.update({
            'location': location,
            'operationHours': operationalHours,
          });
          showToast(message: 'Parking Detail updated Successfully!');
        } else {
          // Document doesn't exist, add new one
          await FirebaseFirestore.instance.collection('client_parking_details').add({
            'userId': user.uid,
            'location': location,
            'operationHours': operationalHours,
            'pricingPerHour': null,
          });
          showToast(message: 'Parking Detail added Successfully!');
        }

        // ignore: use_build_context_synchronously
        widget.onRegisterComplete();
      } else {
        showToast(message: 'User not logged in');
      }
    } catch (e) {
      showToast(message: 'Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          _buildLabeledTextField('Parking location *', 'Enter the parking address'),
          const SizedBox(height: 15),
          _buildOperationalHoursField('Operational hours *'),
          const SizedBox(height: 25),
          Center(
            child: SizedBox(
              width: 200,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  _clientRegisterParkingDetails();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF58C6A9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabeledTextField(String label, String hintText, {bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        _buildTextField(hintText, obscureText: obscureText),
      ],
    );
  }

  Widget _buildTextField(String hintText, {bool obscureText = false}) {
    return TextField(
      controller: _locationController,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      cursorColor: const Color(0xFF58C6A9),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF58C6A9)),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
      ),
    );
  }

  Widget _buildOperationalHoursField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Column(
          children: operationalHours.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    entry.key,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          entry.value,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          onPressed: () async {
                            await _selectTimeRange(entry.key);
                          },
                          icon: const Icon(Icons.edit, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Future<void> _selectTimeRange(String day) async {
    TimeOfDay? startTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            timePickerTheme: const TimePickerThemeData(
              dialHandColor: Color(0xFF58C6A9),
              hourMinuteColor: Colors.white,
              hourMinuteTextColor: Colors.black,
              dialTextColor: Colors.black,
              backgroundColor: Colors.white,
            ),
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF58C6A9),
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (startTime != null) {
      TimeOfDay? endTime = await showTimePicker(
        // ignore: use_build_context_synchronously
        context: context,
        initialTime: startTime,
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              timePickerTheme: const TimePickerThemeData(
                dialHandColor: Color(0xFF58C6A9),
                hourMinuteColor: Colors.white,
                hourMinuteTextColor: Colors.black,
                dialTextColor: Colors.black,
                backgroundColor: Colors.white,
              ),
              colorScheme: const ColorScheme.light(
                primary: Color(0xFF58C6A9),
                onSurface: Colors.black,
              ),
            ),
            child: child!,
          );
        },
      );

      if (endTime != null) {
        setState(() {
          operationalHours[day] = '${startTime.format(context)} - ${endTime.format(context)}';
        });
      }
    }
  }
}
