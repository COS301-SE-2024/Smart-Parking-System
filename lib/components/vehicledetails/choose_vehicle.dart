import 'package:flutter/material.dart';

import 'package:smart_parking_system/components/sidebar.dart';

class ChooseVehiclePage extends StatefulWidget {
  const ChooseVehiclePage({super.key});

  @override
  State<ChooseVehiclePage> createState() => _ViewVehiclePageState();
}


class _ViewVehiclePageState extends State<ChooseVehiclePage> {
  String? selectedCarLicense;

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

  void selectCar(String license) {
    setState(() {
      selectedCarLicense = license;
    });
  }

  @override
  void initState() {
    super.initState();
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
                  Builder(
                    builder: (BuildContext context) {
                      return IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white, size: 30.0),
                        onPressed: () {
                          Scaffold.of(context).openDrawer(); // Open the drawer
                        },
                      );
                    },
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'My Vehicles',
                      style: TextStyle(
                        color: Colors.tealAccent,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
                              lisenseNumber: car['lisenseNumber'],
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


class CarCard extends StatelessWidget {
  final String? carName;
  final String? carType;
  final String? lisenseNumber;
  final String? imagePath;
  final bool isSelected;
  final VoidCallback onSelect;

  const CarCard({
    super.key,
    required this.carName,
    required this.carType,
    required this.imagePath,
    required this.lisenseNumber,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 500,
        decoration: BoxDecoration(
          color: const Color(0xFF23223a),
          borderRadius: BorderRadius.circular(60),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
          child: Row(
            children: [
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
                    const SizedBox(height: 5),
                    Text(
                      lisenseNumber!,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Image.asset(
                imagePath!,
                width: 120,
                height: 80,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 20),
              GestureDetector(
                onTap: onSelect,
                child: Icon(
                  Icons.check_circle,
                  color: isSelected ? Colors.tealAccent : Colors.grey,
                  size: 30,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}