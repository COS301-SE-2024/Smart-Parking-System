import 'package:flutter/material.dart';

import 'package:smart_parking_system/components/sidebar.dart';

class ViewVehiclePage extends StatefulWidget {
  const ViewVehiclePage({super.key});

  @override
  State<ViewVehiclePage> createState() => _ViewVehiclePageState();
}


class _ViewVehiclePageState extends State<ViewVehiclePage> {
  final List<Map<String, String>> cars = [
    {
      'carName': 'Audi R8',
      'carType': 'Black',
      'lisenseNumber': 'BW26CZGP',
      'imagePath':'assets/Audi_Logo.png'
    },
    {
      'carName': 'VW Tiguan',
      'carType': 'Black',
      'lisenseNumber': 'OP34CZGP',
      'imagePath':'assets/VW_Logo.png'
    },
    {
      'carName': 'VW Citi Golf',
      'carType': 'Blue',
      'lisenseNumber': 'TXGASGP',
      'imagePath':'assets/VW_Logo.png'
    }
  ];


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
                              // lisenseNumber: car['lisenseNumber'],
                              imagePath: car['imagePath'],
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
  // final String? lisenseNumber;
  final String? imagePath;

  const CarCard({
    super.key,
    required this.carName,
    required this.carType,
    required this.imagePath,
    // required this.lisenseNumber,
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
          child: Column(
            children: [
              Row(
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
                        // const SizedBox(height: 5,),
                        // Text(
                        //   lisenseNumber!,
                        //   style: const TextStyle(color: Colors.grey),
                        // ),
                      ],
                    ),
                  ),
                  Image.asset(
                    imagePath!,
                    // width: 120,
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: 100, // Adjust this value to make the button wider
                  height: 40,
                  child: OutlinedButton(
                    onPressed: () {
                      // Edit button logic here
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      side: const BorderSide(color: Colors.white, width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'edit',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
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