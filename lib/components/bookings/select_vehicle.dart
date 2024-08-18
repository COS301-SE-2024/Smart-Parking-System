import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_parking_system/components/payment/confirmation_payment.dart';
// import 'package:smart_parking_system/components/sidebar.dart';

class ChooseVehiclePage extends StatefulWidget {
  final String bookedAddress;
  final double price;
  final String selectedZone;
  final String selectedLevel;
  final String? selectedRow;
  final String selectedTime;
  final DateTime selectedDate;
  final double selectedDuration;
  final bool selectedDisabled;

  const ChooseVehiclePage({
    required this.bookedAddress,
    required this.selectedZone,
    required this.selectedLevel,
    required this.selectedRow,
    required this.selectedTime,
    required this.selectedDate,
    required this.selectedDuration,
    required this.price,
    required this.selectedDisabled,
    super.key
  });

  @override
  State<ChooseVehiclePage> createState() => _ViewVehiclePageState();
}


class _ViewVehiclePageState extends State<ChooseVehiclePage> {
  late List<Map<String, dynamic>> cars = [];
  String? selectedCarVehicleId;
  String? logo;
  bool isLoading = false;


  void selectCar(String vehicleId, String vehicleLogo) {
    setState(() {
      selectedCarVehicleId = vehicleId;
      logo = vehicleLogo;
    });
  }

  Future<void> fetchUserVehicles() async {
    setState(() {
      isLoading = true;
    });
    try {
      String currentUserId = FirebaseAuth.instance.currentUser!.uid;
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('vehicles')
          .where('userId', isEqualTo: currentUserId)
          .get();
      List<Map<String, dynamic>> fetchedCars = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Add the imageDirector based on the vehicleBrand
        String imageDirector;
        switch (data['vehicleBrand']?.toLowerCase()) {
          case 'vw':
            imageDirector = 'assets/VW_Logo.png';
            break;
          case 'audi':
            imageDirector = 'assets/Audi_Logo.png';
            break;
          case 'porsche':
            imageDirector = 'assets/Porsche_Logo.png';
            break;
          default:
            imageDirector = 'assets/default_logo.png'; // You might want to have a default logo
        }

        // Add the imageDirector to the data map
        data['imageDirector'] = imageDirector;
        data['vehicleId'] = doc.id;

        return data;
      }).toList();

      setState(() {
        cars = fetchedCars;
        selectedCarVehicleId = cars.isNotEmpty ? cars[0]['vehicleId'] : null;
        logo = cars.isNotEmpty ? cars[0]['imageDirector'] : null;
        isLoading = false;
      });
    } catch (e) {
      // print('Error fetching vehicles: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserVehicles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF35344A),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                color: const Color(0xFF35344A),
                child: Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 1.0),
                          child: IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Select Vehicle',
                              style: TextStyle(
                                color: Colors.tealAccent,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 130, horizontal: 20),
                      child: Column(
                        children: [
                          // Center(
                          //   child: IconButton(
                          //     icon: const Icon(Icons.add_circle_outline, color: Colors.white, size: 90),
                          //     onPressed: () {
                          //       // Add new vehicle logic here
                          //     },
                          //   ),
                          // ),
                          const SizedBox(height: 20,),

                          for (var car in cars)
                            Padding(padding: const EdgeInsets.symmetric(vertical: 10),
                              child:   CarCard(
                                carName: car['vehicleBrand'],
                                carType: car['vehicleModel'],
                                imagePath: car['imageDirector'],
                                isSelected: selectedCarVehicleId == car['vehicleId'],
                                onSelect: () => selectCar(car['vehicleId']!, car['imageDirector']!),
                              ),
                            )

                        ],
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: Column(
                          children: [
                            const SizedBox(height: 40,),
                            ElevatedButton(
                              onPressed: () {
                                if(!isLoading){
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => ConfirmPaymentPage(bookedAddress: widget.bookedAddress, selectedZone: widget.selectedZone, selectedLevel: widget.selectedLevel, selectedRow: widget.selectedRow, selectedTime: widget.selectedTime, selectedDate: widget.selectedDate, selectedDuration:  widget.selectedDuration, price: widget.price, selectedDisabled: widget.selectedDisabled, vehicleId: selectedCarVehicleId.toString(), vehicleLogo: logo.toString()),
                                    ),
                                  );
                                  // Change to Something:
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isLoading ? const Color.fromARGB(255, 85, 85, 85) :const Color(0xFF58C6A9),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 100,
                                  vertical: 24,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.0,
                                ),
                              )
                                  : const Text(
                                'Continue',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20,),
                            !isLoading && cars.isEmpty
                                ? const Text(
                                'Sorry, you have no Vehicles.'
                            )
                                : const Text(''),
                            isLoading
                                ? const Text(
                              'Loading...',
                              style: TextStyle(
                                  color: Colors.white
                              ),
                            )
                                : const Text(''),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // drawer: const SideMenu(),
    );
  }
}

class CustomRoundedCornerShape extends ShapeBorder {
  final double radius;
  final double innerRadius;

  const CustomRoundedCornerShape({this.radius = 50.0, this.innerRadius = 89.0});

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return getOuterPath(rect, textDirection: textDirection);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final Path path = Path();

    // Top left corner
    path.moveTo(rect.left + radius, rect.top);

    // Top right corner
    path.lineTo(rect.right - radius, rect.top);
    path.arcToPoint(Offset(rect.right, rect.top + radius), radius: Radius.circular(radius));

    // Bottom right corner (inward curve)
    path.lineTo(rect.right, rect.bottom - innerRadius);
    path.arcToPoint(Offset(rect.right - innerRadius, rect.bottom), radius: Radius.circular(innerRadius), clockwise: false);

    // Bottom left corner
    path.lineTo(rect.left + radius, rect.bottom);
    path.arcToPoint(Offset(rect.left, rect.bottom - radius), radius: Radius.circular(radius));

    // Back to top left
    path.lineTo(rect.left, rect.top + radius);
    path.arcToPoint(Offset(rect.left + radius, rect.top), radius: Radius.circular(radius));

    path.close();
    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => CustomRoundedCornerShape(radius: radius * t, innerRadius: innerRadius * t);
}

class CarCard extends StatelessWidget {
  final String? carName;
  final String? carType;
  final String? imagePath;
  final bool isSelected;
  final VoidCallback onSelect;

  const CarCard({
    super.key,
    required this.carName,
    required this.carType,
    required this.imagePath,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 500,
        // decoration: BoxDecoration(
        //   color: const Color(0xFF23223a),
        //   borderRadius: BorderRadius.circular(60),
        // ),
        decoration: const ShapeDecoration(
          color:Color(0xFF23223a),
          shape: CustomRoundedCornerShape(), // Adjust radius as needed
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                  child: Row(
                    children: [
                      const SizedBox(width: 30),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              carName!,
                              style: const TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            Text(
                              carType!,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                imagePath!,
                                // width: 120,
                                height: 80,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(width: 40,)
                            ],
                          ),
                          const SizedBox(height: 15),
                          GestureDetector(
                            onTap: onSelect,
                            child: Icon(
                              Icons.check_circle,
                              color: isSelected ? Colors.tealAccent : Colors.grey,
                              size: 65,
                            ),
                          ),
                        ],
                      ),

                      // const SizedBox(width: 20),

                    ],
                  ),
                ),

                // const SizedBox(height: 5),

              ]
          ),
        ),
      ),
    );
  }
}