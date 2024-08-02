import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_parking_system/components/common/toast.dart';
import 'package:smart_parking_system/components/vehicledetails/view_vehicle.dart';

class EditVehiclePage extends StatefulWidget {
  final String brand;
  final String model;
  final String color;
  final String license;
  final String vehicleId;

  const EditVehiclePage({
    super.key,
    required this.brand,
    required this.model,
    required this.color,
    required this.license,
    required this.vehicleId,
  });

  @override
  State<EditVehiclePage> createState() => _CarDetailsPageState();
}

class _CarDetailsPageState extends State<EditVehiclePage> {
  late final TextEditingController _brandController;
  late final TextEditingController _modelController;
  late final TextEditingController _colorController;
  late final TextEditingController _licenseController;
  late String imageDirect;

  Future<void> _updateVehicleDetails() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await FirebaseFirestore.instance
            .collection('vehicles')
            .doc(widget.vehicleId)
            .update({
          'vehicleBrand': _brandController.text,
          'vehicleModel': _modelController.text,
          'vehicleColor': _colorController.text,
          'licenseNumber': _licenseController.text,
        });

        if (mounted){
            showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: const Color(0xFF2D2F41),
                title: const Text(
                  'Successfully Updated!',
                  style: TextStyle(color: Colors.white),
                ),
                actions: [
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'OK',
                        style: TextStyle(color: Color(0xFF58C6A9)),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        }
        
      }
    } catch (e) {
      showToast(message: 'Error: $e');
    }
  }



  @override
  void initState() {
    super.initState();
    _brandController = TextEditingController(text: widget.brand);
    _modelController = TextEditingController(text: widget.model);
    _colorController = TextEditingController(text: widget.color);
    _licenseController = TextEditingController(text: widget.license);

    switch (widget.brand.toLowerCase()) {
          case 'vw':
            imageDirect = 'assets/VW_logo.png';
            break;
          case 'audi':
            imageDirect = 'assets/Audi_logo.png';
            break;
          default:
            imageDirect = 'assets/default_logo.png'; // You might want to have a default logo
        }
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
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => const ViewVehiclePage(),
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
                child: Image.asset(
                  imageDirect, // Make sure this path is correct
                  width: 150, // Adjust the image size as needed
                  height: 150,
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
                      value: 'BMW',
                      controller: _brandController,
                    ),
                    ProfileField(
                      label: 'Vehicle Model',
                      value: 'M3',
                      controller: _modelController,
                    ),
                    ProfileField(
                      label: 'Color',
                      value: 'Grey White',
                      controller: _colorController,
                    ),
                    ProfileField(
                      label: 'License Number',
                      value: 'NFSMW',
                      controller: _licenseController,
                    ),
                    const SizedBox(height: 30,),
                    ElevatedButton(
                      onPressed: () {
                        // Handle save button
                        _updateVehicleDetails();
                        // showDialog(
                        //   context: context,
                        //   builder: (BuildContext context) {
                        //     return AlertDialog(
                        //       backgroundColor: const Color(0xFF2D2F41),
                              
                        //       title: const Text('Successfully Updated!', style: TextStyle(color: Colors.white)),
                              
                        //       actions: [
                        //         Center(
                        //           child: TextButton(
                        //             onPressed: () {
                        //               Navigator.of(context).pop();
                        //             },
                        //             child: const Text('OK', style: TextStyle(color: Color(0xFF58C6A9))),
                        //           ),
                        //         ),
                        //       ],
                        //     );
                        //   },
                        // );
                      },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF58C6A9),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 150,
                        vertical: 24,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
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