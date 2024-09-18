import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_parking_system/components/settings/settings.dart';
import 'package:smart_parking_system/components/home/sidebar.dart';
import 'package:smart_parking_system/components/vehicledetails/add_vehicle.dart';
import 'package:smart_parking_system/components/vehicledetails/edit_vehicle.dart';

class ViewVehiclePage extends StatefulWidget {
  const ViewVehiclePage({super.key});

  @override
  State<ViewVehiclePage> createState() => _ViewVehiclePageState();
}


class _ViewVehiclePageState extends State<ViewVehiclePage> {
  late List<Map<String, dynamic>> cars = [];
  bool isLoading = false;

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
                  Padding(
                    padding: const EdgeInsets.only(left: 1.0),
                    child: IconButton(
                      onPressed: () {
                        // Add your onPressed logic here
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const SettingsPage(),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
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
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const AddVehiclePage(),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20,),
                        // if(cars.isEmpty)
                        // const Text(
                        //   'You have no Vehicles',
                        //   style: TextStyle(
                        //     color: Colors.white,
                        //   )
                        // ),
                        for (var car in cars)
                          Padding(padding: const EdgeInsets.symmetric(vertical: 10),
                            child:   CarCard(
                              carName: car['vehicleBrand'],
                              carType: car['vehicleModel'],
                              carColor: car['vehicleColor'],
                              lisenseNumber: car['licenseNumber'], 
                              imagePath: car['imageDirector'],
                              vehicleId: car['vehicleId'],
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
  final String? carColor;
  final String? lisenseNumber;
  final String? imagePath;
  final String vehicleId;

  const CarCard({
    super.key,
    required this.carName,
    required this.carType,
    required this.imagePath,
    required this.carColor,
    required this.vehicleId,
    required this.lisenseNumber,
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
                        const SizedBox(height: 10,),
                        Text(
                          carColor!,
                          style: const TextStyle(color: Color.fromARGB(255, 218, 218, 218)),
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
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => EditVehiclePage(brand: carName!, model: carType!, color: carColor!, license: lisenseNumber!, vehicleId: vehicleId ),
                        ),
                      );
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