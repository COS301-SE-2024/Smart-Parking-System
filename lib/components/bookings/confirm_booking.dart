import 'package:flutter/material.dart';
import 'package:smart_parking_system/components/bookings/make_booking.dart';
import 'package:smart_parking_system/components/payment/confirmation_payment.dart';

class ConfirmBookingPage extends StatefulWidget {
  const ConfirmBookingPage({super.key});

  @override
  State<ConfirmBookingPage> createState() => _ConfirmBookingState();
}

class _ConfirmBookingState extends State<ConfirmBookingPage> {
  double _currentSliderValue = 1;
  final double _currentPrice = 10;
  bool _disabledParking = false;
  bool _carWashing = false;
  String _checkInTime = "12:00 am";

  // use the variable to replace the text
  final String appBarTitle = 'Confirm Booking';
  final String parkingSlot = 'Parking Slot A1';
  final String estimateDuration = 'Estimate Duration';
  final String checkInTimeText = 'Check-in Time:';
  final String disabledParkingText = 'Disabled Parking';
  final String requestCarWashingText = 'Request Car Washing (R100)';
  final String bookSpaceButtonText = 'Book Space';

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 0, minute: 0),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            timePickerTheme: const TimePickerThemeData(
              dialHandColor: Color(0xFF58C6A9), // Change this to your desired color
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _checkInTime = picked.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF35344A),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 80),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => const BookingPage(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  Text(
                    appBarTitle,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF58C6A9),
                    ),
                  ),
                  const SizedBox(width: 48), // Adjust the width as needed
                ],
              ),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  parkingSlot,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF58C6A9),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: 380,
                decoration: BoxDecoration(
                  color: const Color(0xFF35344A),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Box showing the final price
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${_currentSliderValue.round()} hours - R${(_currentPrice.toInt() * _currentSliderValue.round()).toInt()}',
                        style: const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      estimateDuration,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    Slider(
                      value: _currentSliderValue,
                      min: 1,
                      max: 24,
                      divisions: 23,
                      activeColor: const Color(0xFF58C6A9),
                      inactiveColor: Colors.white.withOpacity(0.5),
                      label: '${_currentSliderValue.toInt()} hour(s) - R${_currentSliderValue.toInt() * _currentPrice.toInt()}',
                      onChanged: (double value) {
                        setState(() {
                          _currentSliderValue = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () => _selectTime(context),
                      child: Row(
                        children: [
                          Text(
                            checkInTimeText,
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _checkInTime,
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Divider line
                    const Divider(color: Colors.white, thickness: 1),

                    // Disabled Parking option
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.accessible,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              disabledParkingText,
                              style: const TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                        Switch(
                          value: _disabledParking,
                          onChanged: (bool value) {
                            setState(() {
                              _disabledParking = value;
                            });
                          },
                          activeColor: const Color(0xFF58C6A9),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Request Car Washing option
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.directions_car,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              requestCarWashingText,
                              style: const TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                        Switch(
                          value: _carWashing,
                          onChanged: (bool value) {
                            setState(() {
                              _carWashing = value;
                            });
                          },
                          activeColor: const Color(0xFF58C6A9),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => const ConfirmPaymentPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 120,
                    vertical: 18,
                  ),
                  backgroundColor: const Color(0xFF58C6A9),
                ),
                child: Text(
                  bookSpaceButtonText,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
