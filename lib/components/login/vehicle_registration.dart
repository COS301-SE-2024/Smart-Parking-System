import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_parking_system/components/common/toast.dart';
import 'package:smart_parking_system/components/login/registration_successful.dart';

class CarRegistration extends StatefulWidget {
  const CarRegistration({super.key});

  @override
  State<CarRegistration> createState() => _CarRegistrationState();
}

class _CarRegistrationState extends State<CarRegistration> {
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _licenseController = TextEditingController();
  bool isLoading = false;

  Future<void> validateVehicleDetails() async {
    // Validate Vehicle details
    await _register();   
    // showToast(message: 'Please fill in all fields');
  }
    

  Future<void> _register() async {
    final String brand = _brandController.text;
    final String model = _modelController.text;
    final String color = _colorController.text;
    final String license = _licenseController.text;
    setState((){
      isLoading = true;
    });
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

        showToast(message: 'Vehicle Added Successfully!');
        // ignore: use_build_context_synchronously
        setState((){
          isLoading = false;
        });
        if(mounted) { // Check if the widget is still in the tree
             Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const SuccessionPage(),
            ),
          );
        }
       
      }
    } catch (e) {
      setState((){
        isLoading = false;
      });
      showToast(message: 'Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF35344A),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: 550,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40.0), // Space from the top
                  const Center(
                    child: Text(
                      'Add Your Vehicle',
                      style: TextStyle(
                        color: Color(0xFF58C6A9),
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                
                  const SizedBox(height: 60.0),
                  TextField(
                    controller: _brandController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.transparent,
                      labelText: 'Vehicle Brand',
                      labelStyle: TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 10.0),
                  TextField(
                    controller: _modelController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.transparent,
                      labelText: 'Vehicle Model',
                      labelStyle: TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  TextField(
                    controller: _colorController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.transparent,
                      labelText: 'Color',
                      labelStyle: TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 10.0),
                  TextField(
                    controller: _licenseController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.transparent,
                      labelText: 'License Number',
                      labelStyle: TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 60.0),
                  // nextButtonWithSkip(
                  //   displayText: 'Continue',
                  //   action: validateVehicleDetails,
                  //   nextPage: const CarRegistration(),
                  //   context: context
                  // ),
                  ElevatedButton(
                      onPressed: () {
                        validateVehicleDetails();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 100,
                          vertical: 12,
                        ),
                        backgroundColor: const Color(0xFF58C6A9),
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
                        style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w400),
                      ),
                    ),
                  const SizedBox(height: 20.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => const SuccessionPage(),
                        ),
                      );
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Divider(
                            color: Color.fromARGB(255, 199, 199, 199),
                            thickness: 1,
                            endIndent: 10,
                          ),
                        ),
                        Text(
                          'Skip for now',
                          style: TextStyle(
                            color: Color(0xFF58C6A9),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Color.fromARGB(255, 199, 199, 199),
                            thickness: 1,
                            indent: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
