import 'package:flutter/material.dart';
// import 'package:smart_parking_system/components/vehicledetails/choose_vehicle.dart';
import 'package:smart_parking_system/components/bookings/confirm_booking.dart';

class SelectRowPage extends StatefulWidget {
  final String bookedAddress;
  final double price;
  final String selectedZone;
  final String selectedLevel;

  const SelectRowPage({
    required this.bookedAddress,
    required this.price,
    required this.selectedZone,
    required this.selectedLevel,
    super.key,
  });

  @override
  SelectRowPageState createState() => SelectRowPageState();
}

class SelectRowPageState extends State<SelectRowPage> {
  String? selectedRow;

  @override
  Widget build(BuildContext context) {
    int totalSlots = 8;

    return Scaffold(
      backgroundColor: const Color(0xFF2D2F41),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                        Icons.arrow_back_ios_new_rounded, color: Colors.white,
                        size: 30.0),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Expanded(
                    child: Text(
                      'Parking Slot',
                      style: TextStyle(color: Color(0xFF58C6A9),
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 48), // To balance the back button
                ],
              ),
              const SizedBox(height: 40),
              const Center(
                child: Text(
                  'Choose your parking',
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
              const Center(
                child: Text(
                  'Row',
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
              const SizedBox(height: 13),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15, horizontal: 80),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.white.withOpacity(0.2), width: 2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    '$totalSlots spaces available',
                    style: const TextStyle(color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 13),
              Center(
                child: SizedBox(
                  width: 300, // 控制虚线的总体长度
                  height: 1,
                  child: CustomPaint(
                    painter: DottedLinePainter(),
                  ),
                ),
              ),
              const SizedBox(height: 13),
              _buildRowButton(context, 'A', '3 Slots Available'),
              const SizedBox(height: 13),
              Center(
                child: SizedBox(
                  width: 300,
                  height: 1,
                  child: CustomPaint(
                    painter: DottedLinePainter(),
                  ),
                ),
              ),
              const SizedBox(height: 13),
              _buildRowButton(context, 'B', '0 Slots Available'),
              const SizedBox(height: 13),
              Center(
                child: SizedBox(
                  width: 300,
                  height: 1,
                  child: CustomPaint(
                    painter: DottedLinePainter(),
                  ),
                ),
              ),
              const SizedBox(height: 13),
              _buildRowButton(context, 'C', '5 Slots Available'),
              const SizedBox(height: 13),
              Center(
                child: SizedBox(
                  width: 300,
                  height: 1,
                  child: CustomPaint(
                    painter: DottedLinePainter(),
                  ),
                ),
              ),
              const SizedBox(height: 13),
              _buildRowButton(context, 'D', '1 Slot Available'),
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: 160,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedRow != null ? const Color(0xFF58C6A9) : const Color(0xFF5B5B5B),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    onPressed: selectedRow != null
                        ? () {
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     builder: (_) => const ChooseVehiclePage(),
                      //   ),
                      // );
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ConfirmBookingPage(bookedAddress: widget.bookedAddress, price: widget.price, selectedZone: widget.selectedZone, selectedLevel: widget.selectedLevel, selectedRow: selectedRow,),
                        ),
                      );
                    }
                        : null,
                    child: const Text('Continue', style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRowButton(BuildContext context, String rowL, String slotInfo) {
    String rowLabel = 'Row $rowL';
    int slotsAvailable = int.parse(slotInfo.split(' ')[0]);

    bool isDisabled = slotsAvailable == 0;
    bool isSelected = selectedRow == rowL;
    Color buttonColor = isDisabled ? const Color(0xFFC0C0C0) : (isSelected ? const Color(0xFF58C6A9) : const Color(0xFF39C16B));
    String buttonText = isSelected ? '$rowLabel Selected' : rowLabel;

    return Center(
      child: Container(
        width: 290,
        height: 90,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onPressed: isDisabled ? null : () {
            setState(() {
              selectedRow = rowL;
            });
          },
          child: Stack(
            children: [
              if (isSelected)
                Center(
                  child: Text(
                    buttonText,
                    style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                )
              else ...[
                Positioned(
                  left: 2,
                  top: 8,
                  child: Text(
                    buttonText,
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.normal),
                    textAlign: TextAlign.left,
                  ),
                ),
                Positioned(
                  right: 2,
                  top: 8,
                  child: Text(
                    slotInfo,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 2,
                  child: Row(
                    children: List.generate(6, (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Image.asset(
                        'assets/smallCar.png',
                        width: 30,
                        height: 50,
                      ),
                    )),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    var max = size.width;
    var dashWidth = 5;
    var dashSpace = 5;
    double startX = 0;

    while (startX < max) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}