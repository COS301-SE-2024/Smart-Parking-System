import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_parking_system/components/common/custom_widgets.dart';
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
  bool _isFetching = true;

  Future<void> fetchUserVehicles() async {
    setState(() {
      isLoading = true;
      _isFetching = true;
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
          case 'audi':
            imageDirector = 'https://firebasestorage.googleapis.com/v0/b/parkme-c2508.appspot.com/o/vehiclelogo%2FAudi_Logo.png?alt=media&token=ae374933-220d-46a9-b3bb-7d92334eb0a9';
            break;
          case 'bmw':
            imageDirector = 'https://firebasestorage.googleapis.com/v0/b/parkme-c2508.appspot.com/o/vehiclelogo%2FBMW_Logo.png?alt=media&token=26622a31-0ed6-44fd-9c05-b30ae5b34f2d';
            break;
          case 'chevrolet':
            imageDirector = 'https://firebasestorage.googleapis.com/v0/b/parkme-c2508.appspot.com/o/vehiclelogo%2FChevrolet_Logo.png?alt=media&token=00365703-146d-4daa-b839-c9cdf2f68b43';
            break;
          case 'ford':
            imageDirector = 'https://firebasestorage.googleapis.com/v0/b/parkme-c2508.appspot.com/o/vehiclelogo%2FFord_Logo.png?alt=media&token=2a544019-af34-4871-b4fa-db433f662f55';
            break;
          case 'haval':
            imageDirector = 'https://firebasestorage.googleapis.com/v0/b/parkme-c2508.appspot.com/o/vehiclelogo%2FHaval_Logo.png?alt=media&token=283a1adb-1407-4925-b8c6-cc290eb85ad8';
            break;
          case 'honda':
            imageDirector = 'https://firebasestorage.googleapis.com/v0/b/parkme-c2508.appspot.com/o/vehiclelogo%2FHonda_Logo.png?alt=media&token=bb6e1fdf-cad3-44b1-affd-20b0f85d7fb8';
            break;
          case 'hyundai':
            imageDirector = 'https://firebasestorage.googleapis.com/v0/b/parkme-c2508.appspot.com/o/vehiclelogo%2FHyundai_Logo.png?alt=media&token=30e724ae-52fa-475e-b424-0ed7f7f3323b';
            break;
          case 'isuzu':
            imageDirector = 'https://firebasestorage.googleapis.com/v0/b/parkme-c2508.appspot.com/o/vehiclelogo%2FIsuzu_Logo.png?alt=media&token=c7f7eff8-0f72-4e4f-9154-983661dd33d3';
            break;
          case 'kia':
            imageDirector = 'https://firebasestorage.googleapis.com/v0/b/parkme-c2508.appspot.com/o/vehiclelogo%2FKia_Logo.png?alt=media&token=7e6f4ead-4b43-498d-a9a2-8ceb62503da0';
            break;
          case 'mahindra':
            imageDirector = 'https://firebasestorage.googleapis.com/v0/b/parkme-c2508.appspot.com/o/vehiclelogo%2FMahindra_Logo.png?alt=media&token=5c930729-e4ac-43b6-8bc6-bf43d0daf194';
            break;
          case 'mazda':
            imageDirector = 'https://firebasestorage.googleapis.com/v0/b/parkme-c2508.appspot.com/o/vehiclelogo%2FMazda_Logo.png?alt=media&token=61b5dc0a-5956-4c7d-917a-4be462ce35fd';
            break;
          case 'mercedes':
            imageDirector = 'https://firebasestorage.googleapis.com/v0/b/parkme-c2508.appspot.com/o/vehiclelogo%2FMercedes_Benz_Logo.png?alt=media&token=a0970710-44df-451f-9273-23d9d586bf74';
            break;
          case 'mercedes-benz':
            imageDirector = 'https://firebasestorage.googleapis.com/v0/b/parkme-c2508.appspot.com/o/vehiclelogo%2FMercedes_Benz_Logo.png?alt=media&token=a0970710-44df-451f-9273-23d9d586bf74';
            break;
          case 'nissan':
            imageDirector = 'https://firebasestorage.googleapis.com/v0/b/parkme-c2508.appspot.com/o/vehiclelogo%2FNissan_Logo.png?alt=media&token=32347ed8-58e0-495b-a084-b35f6a89ec69';
            break;
          case 'opel':
            imageDirector = 'https://firebasestorage.googleapis.com/v0/b/parkme-c2508.appspot.com/o/vehiclelogo%2FOpel_Logo.png?alt=media&token=098ab2d9-eab6-478c-a19a-24099addcd69';
            break;
          case 'renault':
            imageDirector = 'https://firebasestorage.googleapis.com/v0/b/parkme-c2508.appspot.com/o/vehiclelogo%2FRenault_Logo.png?alt=media&token=2b3821b5-4ae3-4ca6-ad70-2c30efcb88f5';
            break;
          case 'suzuki':
            imageDirector = 'https://firebasestorage.googleapis.com/v0/b/parkme-c2508.appspot.com/o/vehiclelogo%2FSuzuki_Logo.png?alt=media&token=43e5167d-c51f-4345-9479-74ec04c57908';
            break;
          case 'toyota':
            imageDirector = 'https://firebasestorage.googleapis.com/v0/b/parkme-c2508.appspot.com/o/vehiclelogo%2FToyota_Logo.png?alt=media&token=e0c4d85e-4a41-4027-b9c2-db13b69f6ef8';
            break;
          case 'volvo':
            imageDirector = 'https://firebasestorage.googleapis.com/v0/b/parkme-c2508.appspot.com/o/vehiclelogo%2FVolvo_Logo.png?alt=media&token=6eb02bdb-2102-47d6-bedc-e28bc0993282';
            break;
          case 'vw':
            imageDirector = 'https://firebasestorage.googleapis.com/v0/b/parkme-c2508.appspot.com/o/vehiclelogo%2FVW_Logo.png?alt=media&token=f3dcb770-eafe-44d4-ba83-12dcffd93094';
            break;
          default:
            imageDirector = 'https://firebasestorage.googleapis.com/v0/b/parkme-c2508.appspot.com/o/vehiclelogo%2Fdefault_logo.png?alt=media&token=735c5077-5c11-498c-9d24-5481ba932e99'; // You might want to have a default logo
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
    setState(() {
      _isFetching = false;
    });
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
      body: _isFetching ? loadingWidget()
      : Padding(
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
                  imagePath != null ?
                    Image.network(
                      imagePath!,
                      // width: 120,
                      height: 80,
                      fit: BoxFit.contain,
                    ) :
                    Image.asset(
                      'assets/default_logo.png',
                      // width: 150,
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
                          builder: (_) => EditVehiclePage(brand: carName!, model: carType!, color: carColor!, license: lisenseNumber!, vehicleId: vehicleId, image: imagePath! ),
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