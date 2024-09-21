import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

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
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/backW.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.zero,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 600,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(70),
                              bottomRight: Radius.circular(70),
                            ),
                          ),
                          color: const Color(0xFF23223A),
                          elevation: 6.0,
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(30.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Image.asset(
                                    'assets/logo2.png',
                                    height: 70,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildStyledStepIndicator(1, false),
                                    const SizedBox(width: 10),
                                    _buildStyledStepIndicator(2, true),
                                    const SizedBox(width: 10),
                                    _buildStyledStepIndicator(3, false),
                                    const SizedBox(width: 10),
                                    _buildStyledStepIndicator(4, false),
                                    const SizedBox(width: 10),
                                    _buildStyledStepIndicator(5, false),
                                  ],
                                ),
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
                                        // Handle next step action
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
                                const SizedBox(height: 15),
                                Center(
                                  child: RichText(
                                    text: TextSpan(
                                      text: "Need to change details? ",
                                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                                      children: [
                                        TextSpan(
                                          text: 'Go back',
                                          style: const TextStyle(
                                            color: Color(0xFF58C6A9),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              // Navigate to the previous step
                                            },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Image.asset(
                    'assets/parking.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStyledStepIndicator(int step, bool isActive) {
    return ClipPath(
      clipper: ArrowClipper(),
      child: Container(
        width: 85,
        height: 80,
        color: isActive ? const Color(0xFF58C6A9) : const Color(0xFF2B2B45),
        child: Center(
          child: Text(
            step.toString(),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabeledTextField(String label, String hintText, {bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
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
          style: TextStyle(
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
                    style: TextStyle(
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
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          onPressed: () async {
                            await _selectTimeRange(entry.key);
                          },
                          icon: Icon(Icons.edit, color: Colors.white70),
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
              dialHandColor: Color(0xFF58C6A9),
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
          child: child!, // Return child directly
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
                dialHandColor: Color(0xFF58C6A9),
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
            child: child!, // Return child directly
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

class ArrowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, size.height * 0.25);
    path.lineTo(size.width * 0.9, size.height * 0.25);
    path.lineTo(size.width, size.height * 0.5);
    path.lineTo(size.width * 0.9, size.height * 0.75);
    path.lineTo(0, size.height * 0.75);
    path.lineTo(size.width * 0.1, size.height * 0.5);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}