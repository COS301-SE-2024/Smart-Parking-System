import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_parking_system/components/common/common_functions.dart';
import 'package:smart_parking_system/components/common/custom_widgets.dart';
import 'package:smart_parking_system/components/common/toast.dart';
import 'package:smart_parking_system/components/settings/settings.dart';
import 'package:smart_parking_system/components/vehicledetails/view_vehicle.dart';

class AddVehiclePage extends StatefulWidget {
  const AddVehiclePage({super.key});

  @override
  State<AddVehiclePage> createState() => _CarDetailsPageState();
}

class _CarDetailsPageState extends State<AddVehiclePage> {
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _licenseController = TextEditingController();

  Future<void> _addVehicleDetails() async {
    final String brand = _brandController.text; 
    final String model = _modelController.text;
    final String color = _colorController.text;
    final String license = _licenseController.text;

    if(!isValidString(brand, r'^[a-zA-Z/\s]+$')){showToast(message: "Invalid Brand"); return;}
    if(!isValidString(model, r'^[a-zA-Z0-9/\s]+$')){showToast(message: "Invalid Model"); return;}
    if(!isValidString(color, r'^[a-zA-Z/\s]+$')){showToast(message: "Invalid Color"); return;}
    if(!isValidString(license, r'^[a-zA-Z0-9/\s]+$')){showToast(message: "Invalid License"); return;}

    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await FirebaseFirestore.instance.collection('vehicles').add({
          'userId': user.uid, // Add the userId field
          'vehicleBrand': brand,
          'vehicleModel': model,
          'vehicleColor': color,
          'licenseNumber': license,
        });
      }
    } catch (e) {
      showToast(message: 'Error: $e');
    }

    if (mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const ViewVehiclePage(),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D2F41),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
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
                  const Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Car Info',
                        style: TextStyle(
                          color: Colors.tealAccent,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Placeholder to keep the text centered
                ],
              ),
            ),
            const SizedBox(height: 30,),
            Container(
              width: 200, // Adjust the size as needed
              height: 200, // Make sure width and height are equal for a perfect circle
              decoration: const BoxDecoration(
                color: Color(0xFF25253d), // The color you specified
                shape: BoxShape.circle, // This makes the container perfectly round
              ),
              child: Center(
                child: Image.network(
                  'https://firebasestorage.googleapis.com/v0/b/parkme-c2508.appspot.com/o/vehiclelogo%2Fracecarsketch.png?alt=media&token=193239fc-ba59-429b-8868-4175f8b0ff96', // Make sure this path is correct
                  width: 200, // Adjust the image size as needed
                  height: 200,
                  fit: BoxFit.contain, // This will ensure the image fits within the circle
                ),
              ),
            ),
            //FInish your code here!
            Container(
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height,
              width: 500,
              decoration: const BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  ProfileField(
                    label: 'Vehicle Brand',
                    value: '',
                    controller: _brandController,
                  ),
                  ProfileField(
                    label: 'Vehicle Model',
                    value: '',
                    controller: _modelController,
                  ),
                  ProfileField(
                    label: 'Color',
                    value: '',
                    controller: _colorController,
                  ),
                  ProfileField(
                    label: 'License Number',
                    value: '',
                    controller: _licenseController,
                  ),
                  const SizedBox(height: 30,),
                  nextButton(
                    displayText: 'Add Vehicle', 
                    action: () {
                      _addVehicleDetails();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileField extends StatelessWidget {
  final String label;
  final String value;
  final TextEditingController controller;
  final bool obscureText;

  const ProfileField({
    super.key,
    required this.label,
    required this.value,
    required this.controller,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: TextFormField(
        // initialValue: value,
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(
          fontWeight: FontWeight.w600, // Make the input text bold
          fontSize: 16,
          color: Colors.white
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Color(0xFF757F8C), // Set the color here
            fontSize: 18,
          ),
          contentPadding: const EdgeInsets.only(top: 0),
        ),
      ),
    );
  }
}