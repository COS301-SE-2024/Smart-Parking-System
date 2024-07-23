import 'package:flutter/material.dart';

import 'package:smart_parking_system/components/sidebar.dart';

class ChooseVehiclePage extends StatefulWidget {
  const ChooseVehiclePage({super.key});

  @override
  State<ChooseVehiclePage> createState() => _ViewVehiclePageState();
}


class _ViewVehiclePageState extends State<ChooseVehiclePage> {
  

  final List<Map<String, String>> cars = [
    {
      'carName': 'Audi R8',
      'carType': 'Black',
      'lisenseNumber': 'BW26CZGP',
      'imagePath':'assets/VWTiguan.png'
    },
    {
      'carName': 'VW Tiguan',
      'carType': 'Black',
      'lisenseNumber': 'OP34CZGP',
      'imagePath':'assets/VWTiguan.png'
    },
    {
      'carName': 'VW Citi Golf',
      'carType': 'Blue',
      'lisenseNumber': 'TXGASGP',
      'imagePath':'assets/VWTiguan.png'
    }
  ];
  String? selectedCarLicense;
   

  void selectCar(String license) {
    setState(() {
      selectedCarLicense = license;
    });
  }

  @override
  void initState() {
    super.initState();
    selectedCarLicense = cars.isNotEmpty ? cars[0]['lisenseNumber'] : null;
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
                            // Navigator.of(context).pushReplacement(
                            //   MaterialPageRoute(
                            //     builder: (_) => const SettingsPage(),
                            //   ),
                            // );
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
                    padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
                    child: Column(
                      children: [
                        Center(
                          child: IconButton(
                            icon: const Icon(Icons.add_circle_outline, color: Colors.white, size: 90),
                            onPressed: () {
                              // Add new vehicle logic here
                            },
                          ),
                        ),
                        const SizedBox(height: 20,),
                        for (var car in cars)
                          Padding(padding: const EdgeInsets.symmetric(vertical: 10),
                            child:   CarCard(
                              carName: car['carName'],
                              carType: car['carType'],
                              imagePath: car['imagePath'],
                              isSelected: selectedCarLicense == car['lisenseNumber'],
                              onSelect: () => selectCar(car['lisenseNumber']!),
                            ),
                          )
                          
                      ],
                    ),
                  ),
                  
                ],
              ),
            ),
          ],
        ),
        ),   
      ),
      drawer: const SideMenu(),
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
                              width: 120,
                              height: 80,
                              fit: BoxFit.cover,
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