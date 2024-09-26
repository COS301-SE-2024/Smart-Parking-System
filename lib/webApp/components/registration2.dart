import 'package:flutter/material.dart';
import 'package:smart_parking_system/components/common/toast.dart';

import 'package:smart_parking_system/webApp/components/registration1.dart';


class Registration2 extends StatefulWidget {
  final Function onRegisterComplete;
  final ParkingSpot ps;

  const Registration2({super.key, required this.ps, required this.onRegisterComplete});

  @override
  // ignore: library_private_types_in_public_api
  _Registration2State createState() => _Registration2State();
}

class _Registration2State extends State<Registration2> {
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  Map<String, String> operationalHours = {
    'Monday': '--',
    'Tuesday': '--',
    'Wednesday': '--',
    'Thursday': '--',
    'Friday': '--',
    'Saturday': '--',
    'Sunday': '--',
  };
  bool _isLoading = false;

  Future<void> _clientRegisterParkingDetails() async {
    setState((){
      _isLoading = true;
    });

    try {
      final String location = _locationController.text;
      final double latitude = double.parse(_latitudeController.text);
      final double longitude = double.parse(_longitudeController.text);
      widget.ps.name = location;
      widget.ps.operationHours = operationalHours;
      widget.ps.latitude = latitude;
      widget.ps.longitude = longitude;

      widget.onRegisterComplete();
    } catch (e) {
      showToast(message: 'Error: $e');
    }

    setState((){
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          _buildLabeledTextField('Parking location name *', 'Enter the parking name', _locationController),
          const SizedBox(height: 15),
          _buildLabeledTextField('Parking latitude *', 'Enter the parking latitude', _latitudeController),
          const SizedBox(height: 15),
          _buildLabeledTextField('Parking longitude *', 'Enter the parking longitude', _longitudeController),
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
                child: _isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.0,
                    ),
                  )
                : const Text(
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

  Widget _buildLabeledTextField(String label, String hintText, TextEditingController controller, {bool obscureText = false}) {
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
        TextField(
          controller: controller,
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
        ),
      ],
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
