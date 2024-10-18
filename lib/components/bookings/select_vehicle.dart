import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_parking_system/components/bookings/select_add_vehicle.dart';
import 'package:smart_parking_system/components/common/custom_widgets.dart';
import 'package:smart_parking_system/components/payment/confirm_payment.dart';
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
  bool hasCars = false;
  bool _isFetching = true;

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
        selectedCarVehicleId = cars.isNotEmpty ? cars[0]['vehicleId'] : null;
        logo = cars.isNotEmpty ? cars[0]['imageDirector'] : null;
        isLoading = false;
        if(cars.isEmpty){
          hasCars = false;
        } else {
          hasCars = true;
        }
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
                    Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 1.0),
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
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
                  // Center(
                  //   child: Padding(
                  //     padding: const EdgeInsets.symmetric(vertical: 50),
                  //     child: IconButton(
                  //     icon: const Icon(Icons.add_circle_outline, color: Colors.white, size: 90),
                  //     onPressed: () {
                  //       // Add new vehicle logic here
                  //       Navigator.of(context).push(
                  //         MaterialPageRoute(
                  //           builder: (_) => const SelectAddVehicle(),
                  //         ),
                  //       );
                  //     },
                  //   ),
                  //   ),
                    
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
                    child: Column(
                      children: [
                        Center(
                          child: IconButton(
                            icon: const Icon(Icons.add_circle_outline, color: Colors.white, size: 90),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const SelectAddVehicle(),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20,),
                        
                        for (var car in cars)
                          Padding(padding: const EdgeInsets.symmetric(vertical: 10),
                            child:   CarCard(
                              carName: car['vehicleBrand'],
                              carType: car['vehicleModel'],
                              imagePath: car['imageDirector'],
                              licensePlate: car['licenseNumber'],
                              isSelected: selectedCarVehicleId == car['vehicleId'],
                              onSelect: () => selectCar(car['vehicleId']!, car['imageDirector']!),
                            ),
                          ),
                        
                        
                          
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
      // drawer: const SideMenu(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        child: ElevatedButton(
            onPressed: (!isLoading && hasCars) 
              ? () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ConfirmPaymentPage(
                        bookedAddress: widget.bookedAddress,
                        selectedZone: widget.selectedZone,
                        selectedLevel: widget.selectedLevel,
                        selectedRow: widget.selectedRow,
                        selectedTime: widget.selectedTime,
                        selectedDate: widget.selectedDate,
                        selectedDuration: widget.selectedDuration,
                        price: widget.price,
                        selectedDisabled: widget.selectedDisabled,
                        vehicleId: selectedCarVehicleId.toString(),
                        vehicleLogo: logo.toString(),
                      ),
                    ),
                  );
                }
              : null,  // This disables the button when hasCars is false or isLoading is true
            style: ElevatedButton.styleFrom(
              backgroundColor: isLoading && !hasCars
                    ? const Color.fromARGB(255, 85, 85, 85) 
                    : const Color(0xFF58C6A9),
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
              : !hasCars ?
                const Text(
                  'You dont have any Vehicles',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
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
      ),
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
  final String? licensePlate;
  final bool isSelected;
  final VoidCallback onSelect;

  const CarCard({
    super.key,
    required this.carName,
    required this.carType,
    required this.licensePlate,
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
                          const SizedBox(height: 2),
                          Text(
                            licensePlate!,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
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