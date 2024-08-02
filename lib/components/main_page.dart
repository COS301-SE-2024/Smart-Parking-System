import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:smart_parking_system/components/bookings/select_zone.dart';
import 'package:smart_parking_system/components/parking/parking_history.dart';
import 'package:smart_parking_system/components/settings/settings.dart';
import 'package:smart_parking_system/components/sidebar.dart';
import 'package:smart_parking_system/components/payment/payment_options.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool _isModalVisible = false;
  int _selectedIndex = 0;
  LocationData? locationData;
  final Completer<GoogleMapController> _controller = Completer();

  final TextEditingController _destinationController = TextEditingController();


  final double pricePerHour = 10;
  final String parkingLocation = 'Sandton City Centre';
  final String spacesAvailable = '5 slots';
  final String distanceToVenue = '3 mins drive';

  @override
  void initState() {
    super.initState();
    requestLocation();
  }

  void requestLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();
    setState(() {}); // Notify the framework that the internal state of this object has changed.

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(locationData!.latitude!, locationData!.longitude!),
          zoom: 15.0,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _destinationController.dispose();
    super.dispose();
  }

  void _showParkingInfo() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20.0),
          decoration: const BoxDecoration(
            color: Color(0xFF35344A),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'R${pricePerHour.toInt()} /Hr',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    parkingLocation,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(
                color: Color.fromARGB(255, 199, 199, 199), // Color of the lines
                thickness: 1, // Thickness of the lines
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Spaces Available :',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    spacesAvailable,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Distance to Venue :',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    distanceToVenue,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => ZoneSelectPage(bookedAddress: parkingLocation, price: pricePerHour),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF58C6A9),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: const Text(
                    'View Parking',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.only(top: 20.0),
          child: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu, color: Colors.black, size: 30.0),
                onPressed: () {
                  Scaffold.of(context).openDrawer(); // Open the drawer
                },
              );
            },
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(-26.270760, 28.112268), // Default location
              zoom: 10,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              if (locationData != null) {
                controller.animateCamera(CameraUpdate.newLatLngZoom(
                  LatLng(locationData!.latitude!, locationData!.longitude!), 15.0,
                ));
              }
            },
            myLocationEnabled: true,
          ),
          Positioned(
            top: 80.0,
            left: 20.0,
            right: 20.0,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: const Color(0xFF35344A),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                    child: TextField(
                      controller: _destinationController, // Added the controller
                      onTap: () {
                        setState(() {
                          _isModalVisible = true;
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: 'Where are you going?',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Visibility(
                  visible: _isModalVisible,
                  child: Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFF35344A),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.location_on, color: Colors.white),
                          title: const Text('',
                              style: TextStyle(color: Colors.white, fontSize: 16)),
                          trailing: IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () {
                              setState(() {
                                _isModalVisible = false;
                              });
                            },
                          ),
                        ),
                        const Divider(color: Colors.white),
                        ListTile(
                          leading: const Icon(Icons.circle, color: Colors.white, size: 12),
                          title: const Text(
                            'Sandton City, Johannesburg, South Africa',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          onTap: () {
                            setState(() {
                              _isModalVisible = false;
                              _showParkingInfo();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: const Color(0xFF35344A),
        ),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.6),
                spreadRadius: 1,
                blurRadius: 8,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: const Color(0xFF35344A), // To ensure the Container color is visible
            currentIndex: _selectedIndex,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined, size: 30),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.wallet, size: 30),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history, size: 30),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined, size: 30),
                label: '',
              ),
            ],
            onTap: (index) {
              setState(() {
                _selectedIndex = index;

                if (_selectedIndex == 0) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const MainPage(),
                    ),
                  );
                } else if (_selectedIndex == 1) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const PaymentMethodPage(),
                    ),
                  );
                } else if (_selectedIndex == 2) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const ParkingHistoryPage(),
                    ),
                  );
                } else if (_selectedIndex == 3) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ),
                  );
                }
              });
            },
            selectedItemColor: const Color(0xFF58C6A9),
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: false,
            showSelectedLabels: false,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF58C6A9),
        shape: const CircleBorder(),
        child: const Icon(
          Icons.near_me,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      drawer: const SideMenu(),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: MainPage(),
  ));
}
