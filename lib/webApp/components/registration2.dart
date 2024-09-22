import 'package:flutter/material.dart';

import 'package:smart_parking_system/webapp/components/registration3.dart';
import 'package:smart_parking_system/webapp/components/registration4.dart';
import 'package:smart_parking_system/webapp/components/registration5.dart';

class Registration2 extends StatefulWidget {
  const Registration2({Key? key}) : super(key: key);

  @override
  _Registration2State createState() => _Registration2State();
}

class _Registration2State extends State<Registration2> {
  Map<String, String> operationalHours = {
    'Monday': '--',
    'Tuesday': '--',
    'Wednesday': '--',
    'Thursday': '--',
    'Friday': '--',
    'Saturday': '--',
    'Sunday': '--',
  };

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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Registration3()),
                  );
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
        contentPadding: EdgeInsets.symmetric(vertical: 8),
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
            timePickerTheme: TimePickerThemeData(
              dialHandColor: const Color(0xFF58C6A9),
              hourMinuteColor: Colors.white,
              hourMinuteTextColor: Colors.black,
              dialTextColor: Colors.black,
              backgroundColor: Colors.white,
            ),
            colorScheme: ColorScheme.light(
              primary: const Color(0xFF58C6A9),
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (startTime != null) {
      TimeOfDay? endTime = await showTimePicker(
        context: context,
        initialTime: startTime,
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              timePickerTheme: TimePickerThemeData(
                dialHandColor: const Color(0xFF58C6A9),
                hourMinuteColor: Colors.white,
                hourMinuteTextColor: Colors.black,
                dialTextColor: Colors.black,
                backgroundColor: Colors.white,
              ),
              colorScheme: ColorScheme.light(
                primary: const Color(0xFF58C6A9),
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
//column