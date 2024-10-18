//General
import 'dart:async';
import 'package:flutter/material.dart';
//Maps
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:location/location.dart' as loc;
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
//Pages
import 'package:smart_parking_system/components/bookings/select_zone.dart';
import 'package:smart_parking_system/components/parking/parking_history.dart';
import 'package:smart_parking_system/components/settings/settings.dart';
import 'package:smart_parking_system/components/home/sidebar.dart';
import 'package:smart_parking_system/components/payment/payment_options.dart';
//Firebase
// import 'package:smart_parking_system/components/firebase/firebase_common_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_parking_system/components/common/toast.dart';
import 'package:smart_parking_system/components/common/common_functions.dart';



// Add the import for your loading screen
import 'package:smart_parking_system/components/home/loading_screen.dart';


class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class Parking {
  final String name;
  final String price;
  final String slots;
  final String slotsAvailable;
  final double latitude;
  final double longitude;

  Parking(
    this.name,
    this.price,
    this.slots,
    this.slotsAvailable,
    this.latitude,
    this.longitude,
  );
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  LocationData? locationData;
  final Completer<GoogleMapController> _controller = Completer();
  bool _locationPermissionGranted = false;
  final Set<Marker> _markers = {};
  final TextEditingController _destinationController = TextEditingController();
  PermissionStatus _permissionGranted = PermissionStatus.granted;

  bool _isLoading = true; // New variable to manage loading state




  late Parking parking;
  // Parking parking = Parking('', '', '', '', 0);                                         //Change to this if main page gives error

  @override
  void initState() {
    super.initState();
    requestLocation();
    _addCarMarker();
  }

  void findNearestLoaction() async {
    try{
      Marker nearestMarker = _markers.first; //Use this to compare for the nearest marker;
      for (var marker in _markers){
        double distanceMarker = Geolocator.distanceBetween(
          locationData!.latitude!,
          locationData!.longitude!,
          marker.position.latitude,
          marker.position.longitude,
        );
        double distanceNearestMarker = Geolocator.distanceBetween(
          locationData!.latitude!,
          locationData!.longitude!,
          nearestMarker.position.latitude,
          nearestMarker.position.longitude,
        );
        if (distanceMarker < distanceNearestMarker){
          nearestMarker = marker;
        }
      }
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: nearestMarker.position,
            zoom: 19.0,
          ),
        ),
      );
    } catch (e) {
      showToast(message: 'Error retrieving closest parking: $e');
    }
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
      setState(() {
      _isLoading = true; // Set loading state to true
    });

    final BitmapDescriptor carIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(100, 100)),
      'assets/Purple_ParkMe.png',
    );

    List<Marker> markers = [];
    // Firebase Functions
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    // Query the 'parkings' collection for all documents
    QuerySnapshot querySnapshot = await firestore.collection('parkings').get();

    if (querySnapshot.docs.isNotEmpty) {
      // Loop through each document
      for (var document in querySnapshot.docs) {
        try {
          // Retrieve the fields
          String name = document.get('name') as String;

          // Check if the marker is for "EPI-USE Labs"
          if (name == 'EPI-USE Labs') {
            // Call the detectCars function with the appropriate YouTube URL
            detectCars('https://www.youtube.com/live/CH8GegCF9FI');
          }

          String price = document.get('price') as String;
          String slots = document.get('slots_available') as String;
          double latitude = 0.0;
          double longitude = 0.0;
          try {
            latitude = document.get('latitude') as double;
            longitude = document.get('longitude') as double;
          } catch (e) {
            try {
              latitude = document.get('latitude') as double;
              int temp = document.get('longitude') as int;
              longitude = double.parse(temp.toString());
            } catch (e) {
              try {
                int temp = document.get('latitude') as int;
                longitude = document.get('longitude') as double;
                latitude = double.parse(temp.toString());
              } catch (e) {
                try {
                  int temp1 = document.get('latitude') as int;
                  int temp2 = document.get('longitude') as int;
                  latitude = double.parse(temp1.toString());
                  longitude = double.parse(temp2.toString());
                } catch (e) {
                  showToast(message: "latitude/longitude error: $e");
                }
              }
            }
          }

          // Add to the parkingList
          markers.add(
            Marker(
              markerId: MarkerId(document.id),
              position: LatLng(latitude, longitude), // Specific location
              icon: carIcon,
              infoWindow: InfoWindow(
                title: name,
                snippet: '$slots slots Available', // Additional information
              ),
              onTap: () async {
                final GoogleMapController controller = await _controller.future;
                controller.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: LatLng(latitude, longitude),
                      zoom: 17.0,
                    ),
                  ),
                );

                await Future.delayed(const Duration(seconds: 0));
                parking = Parking(
                  name,
                  price,
                  slots,
                  '${extractSlotsAvailable(slots)} slots',
                  latitude,
                  longitude,
                );

                _showParkingInfo();
              },
            ),
          );
        } catch (e) {
          showToast(message: 'Firebase error $e');
        }
      }
    } else {
      // No matching documents found
      showToast(message: 'No parkings found');
    }

    setState(() {
      _markers.addAll(markers);
       _isLoading = false; 
    });

  }

  void requestLocation() async {
    loc.Location location = loc.Location();

    bool serviceEnabled;
    // PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      while(_permissionGranted != PermissionStatus.granted) {
        _permissionGranted = await location.requestPermission();
        setState(() {});
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

  Future<void> detectCars(String youtubeUrl) async {
    const url = 'https://detectcars-syx3usysxa-uc.a.run.app';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'youtube_url': youtubeUrl}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      int carCount = data['car_count'];

      // Fetch the parking location from Firestore
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot = await firestore.collection('parkings').where('name', isEqualTo: 'EPI-USE Labs').get();

      if (querySnapshot.docs.isNotEmpty) {
        // Update the slotsAvailable field for the location
        DocumentSnapshot document = querySnapshot.docs.first;
        int availableSlots = 5 - carCount;
        await firestore.collection('parkings').doc(document.id).update({
          'slots_available': '$availableSlots/5',
        });
      } else {
        showToast(message: 'Parking location not found');
      }
    } else {
      showToast(message: 'Error: ${response.body}');
    }
  }

  @override
  void dispose() {
    _destinationController.dispose();
    super.dispose();
  }

  void _showParkingInfo() async {
    double distanceInMeters = Geolocator.distanceBetween(
      locationData!.latitude!,
      locationData!.longitude!,
      parking.latitude,
      parking.longitude,
    );
    
    double distanceInKm = distanceInMeters / 1000;
    String distanceString = distanceInKm < 1 
      ? '${distanceInMeters.toStringAsFixed(0)} m' 
      : '${distanceInKm.toStringAsFixed(1)} km';

    String apiKey = dotenv.env['PLACES_API_KEY']!;
    String url = 'https://maps.googleapis.com/maps/api/distancematrix/json?units=metric'
        '&origins=${locationData!.latitude},${locationData!.longitude}'
        '&destinations=${parking.latitude},${parking.longitude}'
        '&key=$apiKey';

    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      String duration = data['rows'][0]['elements'][0]['duration']['text'];

      String distanceAndDurationString = '$duration ($distanceString)';

      if (!mounted) return;

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
                SingleChildScrollView(
                  child: Text(
                    parking.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                      'Cost per hour :',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'R${parking.price} /Hr',
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
                      'Spaces Available :',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      parking.slotsAvailable,
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
                      ),
                    ),
                    Text(
                      distanceAndDurationString,
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
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ZoneSelectPage(bookedAddress: parking.name, price: double.parse(parking.price), distanceAndDurationString: distanceAndDurationString,),
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
    } else {
      showToast(message: 'Failed to fetch duration');
    }
  }

  @override
  Widget build(BuildContext context) {
    return  _permissionGranted != PermissionStatus.granted 
    ? 
    Scaffold(
      body: Container(
        color: const Color(0xFF35344A), // Background color like the toast
        child: const Center(
          child: Text(
            "Location Permissions are Required",
            style: TextStyle(
              fontSize: 24, // Same font size as toast
              fontWeight: FontWeight.bold,
              color: Color(0xFF58C6A9), // Same text color as toast
            ),
            textAlign: TextAlign.center, // To make sure text is centered
          ),
        ),
      ),
    )
    :
    Scaffold(
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

          if (_isLoading) const LoadingScreen(), 
          if (!_isLoading)

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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
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
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(Icons.search, color: Colors.grey),
                          ),
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
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
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const MainPage(),
                    ),
                  );
                } else if (_selectedIndex == 1) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const PaymentMethodPage(),
                    ),
                  );
                } else if (_selectedIndex == 2) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ParkingHistoryPage(),
                    ),
                  );
                } else if (_selectedIndex == 3) {
                  Navigator.of(context).push(
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
        onPressed: findNearestLoaction,
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