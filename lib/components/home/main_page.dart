import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:location/location.dart' as loc;
import 'package:smart_parking_system/components/bookings/select_zone.dart';
import 'package:smart_parking_system/components/parking/parking_history.dart';
import 'package:smart_parking_system/components/settings/settings.dart';
import 'package:smart_parking_system/components/home/sidebar.dart';
import 'package:smart_parking_system/components/payment/payment_options.dart';
//Firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_parking_system/components/common/toast.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class Parking {
  final String location;
  final String name;
  final String price;
  final String slots;

  Parking(this.location, this.name, this.price, this.slots);
}

class _MainPageState extends State<MainPage> {
  bool _isModalVisible = false;
  int _selectedIndex = 0;
  LocationData? locationData;
  final Completer<GoogleMapController> _controller = Completer();
  bool _locationPermissionGranted = false;
  final Set<Marker> _markers = {};

  final TextEditingController _destinationController = TextEditingController();

  Parking parking = Parking('', '', '', '');
  final String distanceToVenue = '3 mins drive';                            ///Adjust with maps implementation
    // Get details on load
  Future<void> getDetails() async {
    try {
      // Get a reference to the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Query the 'bookings' collection for a document with matching userId
      QuerySnapshot querySnapshot = await firestore
          .collection('parkings')
          .limit(1)
          .get();
      // Check if a matching document was found
      if (querySnapshot.docs.isNotEmpty) {
        // // Loop through each document
        var document = querySnapshot.docs.first;

        // Retrieve the fields
        String location = document.get('location') as String;
        String name = document.get('name') as String;
        String price = document.get('price') as String;
        String slots = document.get('slots_available') as String;

        // Add to reservedspots list
        parking = Parking(
          location,
          name,
          price,
          slots,
        );
        spacesAvailable = extractSlotsAvailable(parking.slots);
      } else {
        // No matching document found
        showToast(message: 'No parkings found');
      }
    } catch (e) {
      // Handle any errors
      showToast(message: 'Error retrieving parkings details: $e');
    }

    setState((){}); // This will trigger a rebuild with the new values
  }


  @override
  void initState() {
    super.initState();
    getDetails();
    requestLocation();
    _addCarMarker();
  }

  void displayPrediction(Prediction? p) async {
    if (p != null) {
      GoogleMapsPlaces places = GoogleMapsPlaces(apiKey: dotenv.env['PLACES_API_KEY']!);
      PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);
      final lat = detail.result.geometry!.location.lat;
      final lng = detail.result.geometry!.location.lng;

      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 15.0));

      setState(() {
        _destinationController.text = p.description!;
        _markers.add(
          Marker(
            markerId: MarkerId(p.placeId!),
            position: LatLng(lat, lng),
            infoWindow: InfoWindow(
              title: p.description!,
            ),
          ),
        );
      });
    }
  }

  Future<void> _addCarMarker() async {
    final BitmapDescriptor carIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(100, 100)),
      'assets/Purple_ParkMe.png',
    );

    final List<Marker> markers = [
      Marker(
        markerId: const MarkerId('car_marker_1'),
        position: const LatLng(-26.108528752672193, 28.05280562667932), // Specific location
        icon: carIcon,
        infoWindow: const InfoWindow(
          title: 'Sandton City',
          snippet: 'ParkMe Available', // Additional information
        ),
        onTap: () async {
          final GoogleMapController controller = await _controller.future;
          controller.animateCamera(
            CameraUpdate.newCameraPosition(
              const CameraPosition(
                target: LatLng(-26.108528752672193, 28.05280562667932),
                zoom: 17.0,
              ),
            ),
          );

          await Future.delayed(const Duration(seconds: 3));
          _showParkingInfo();
        },
      ),

      Marker(
        markerId: const MarkerId('car_marker_2'),
        position: const LatLng(-25.782702280688465, 28.274768587059818), // Specific location
        icon: carIcon,
        infoWindow: const InfoWindow(
          title: 'Menlyn Park Shopping Centre',
          snippet: 'ParkMe Available', // Additional information
        ),
        onTap: () async {
          final GoogleMapController controller = await _controller.future;
          controller.animateCamera(
            CameraUpdate.newCameraPosition(
              const CameraPosition(
                target: LatLng(-25.782702280688465, 28.274768587059818),
                zoom: 17.0,
              ),
            ),
          );
        },
      ),

      Marker(
        markerId: const MarkerId('car_marker_3'),
        position: const LatLng(-33.90776949320457, 18.420081870975576), // Specific location
        icon: carIcon,
        infoWindow: const InfoWindow(
          title: 'V&A Waterfront',
          snippet: 'ParkMe Available', // Additional information
        ),
        onTap: () async {
          final GoogleMapController controller = await _controller.future;
          controller.animateCamera(
            CameraUpdate.newCameraPosition(
              const CameraPosition(
                target: LatLng(-33.90776949320457, 18.420081870975576),
                zoom: 17.0,
              ),
            ),
          );
        },
      ),

      Marker(
        markerId: const MarkerId('car_marker_4'),
        position: const LatLng(-32.97051605731753, 27.901948782757295), // Specific location
        icon: carIcon,
        infoWindow: const InfoWindow(
          title: 'Hemingways Mall',
          snippet: 'ParkMe Available', // Additional information
        ),
        onTap: () async {
          final GoogleMapController controller = await _controller.future;
          controller.animateCamera(
            CameraUpdate.newCameraPosition(
              const CameraPosition(
                target: LatLng(-32.97051605731753, 27.901948782757295),
                zoom: 17.0,
              ),
            ),
          );
        },
      ),

      Marker(
        markerId: const MarkerId('car_marker_5'),
        position: const LatLng(-29.114696757582518, 26.21065532493569), // Specific location
        icon: carIcon,
        infoWindow: const InfoWindow(
          title: 'Loch Logan Waterfront',
          snippet: 'ParkMe Available', // Additional information
        ),
        onTap: () async {
          final GoogleMapController controller = await _controller.future;
          controller.animateCamera(
            CameraUpdate.newCameraPosition(
              const CameraPosition(
                target: LatLng(-29.114696757582518, 26.21065532493569),
                zoom: 17.0,
              ),
            ),
          );
        },
      ),
    ];

    setState(() {
      _markers.addAll(markers);

    });

  }

  void requestLocation() async {
    loc.Location location = loc.Location();

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
    _locationPermissionGranted = true;
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

  static String extractSlotsAvailable(String slots) {
    // Use a regular expression to match the first number
    RegExp regex = RegExp(r'^\d+');
    Match? match = regex.firstMatch(slots);
    
    if (match != null) {
      String number = match.group(0)!;
      return "$number slots";
    }
    
    // Return a default value if no match is found
    return "0 slots";
  }

  // final double pricePerHour = 10;
  // final String parkingLocation = 'Sandton City Centre';
  // final String spacesAvailable = '5 slots';
  String spacesAvailable = "";

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
                    'R${parking.price} /Hr',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    parking.name,
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
                        builder: (_) => ZoneSelectPage(bookedAddress: parking.name, price: double.parse(parking.price)),
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
              target: LatLng(-30.983819953976862, 23.84867659935075), // Default location
              zoom: 6,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              if (locationData != null) {
                controller.animateCamera(CameraUpdate.newLatLngZoom(
                  LatLng(locationData!.latitude!, locationData!.longitude!), 15.0,
                ));
              }
            },
            myLocationEnabled: _locationPermissionGranted,
            markers: _markers,
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
                    child: GestureDetector(
                      onTap: () async {
                        Prediction? p = await PlacesAutocomplete.show(
                          context: context,
                          apiKey: dotenv.env['PLACES_API_KEY']!,
                          mode: Mode.overlay, // Mode.fullscreen
                          language: "en",
                          components: [const Component(Component.country, "za")],
                        );
                        displayPrediction(p);
                      },
                      child: AbsorbPointer(
                        child: TextField(
                          controller: _destinationController,
                          decoration: const InputDecoration(
                            hintText: 'Where are you going?',
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.white),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
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
                          title:  Text(
                            parking.location,
                            style: const TextStyle(color: Colors.white, fontSize: 14),
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

void main() async {
  runApp(const MaterialApp(
    home: MainPage(),
  ));
}