import 'package:flutter/material.dart';
import 'package:smart_parking_system/components/bookings/select_level.dart';
//Firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_parking_system/components/common/custom_widgets.dart';
import 'package:smart_parking_system/components/common/toast.dart';
import 'package:smart_parking_system/components/common/common_functions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ZoneSelectPage extends StatefulWidget {
  final double price;
  final String bookedAddress;
  final String distanceAndDurationString;
  const ZoneSelectPage({
    required this.bookedAddress,
    required this.price,
    required this.distanceAndDurationString,
    super.key
  });

  @override
  State<ZoneSelectPage> createState() => _ZoneSelectPageState();
}

class Zone {
  final String zone;
  final int slots;
  final int timeDistance;
  final double x;
  final double y;

  Zone(this.zone, this.slots, this.timeDistance, this.x, this.y);
}

class _ZoneSelectPageState extends State<ZoneSelectPage> {
  String? selectedZone;
  int totalSlots = 0;
  List<Zone> zones = [];
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};
  final Set<Marker> _markersZones = {};
  LatLng? initialPosition;
  MarkerId? initialMarkerId;
  BitmapDescriptor? carIcon;
  BitmapDescriptor? zoneIcon;
  bool futureBooking = false;
  bool _isFetching = true;

  Future<void> loadCustomMarker() async {
    setState(() {
      _isFetching = true;
    });
    carIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(100, 100)),
      'assets/Purple_ParkMe.png',
    );
    zoneIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(40, 40)),
      'assets/zone.png',
    );
    setState(() {
      _isFetching = false;
    });
  }

   String getZoneLetter(int index) {
    return String.fromCharCode('A'.codeUnitAt(0) + index);
  }

   Future<void> getDetails() async {
    setState(() {
      _isFetching = true;
    });
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot = await firestore
          .collection('parkings')
          .where('name', isEqualTo: widget.bookedAddress)
          .get();

      DocumentSnapshot documentSnapshot = querySnapshot.docs[0];
      
      if (documentSnapshot.exists) {
        double latitude = documentSnapshot.get('latitude');
        double longitude = documentSnapshot.get('longitude');
        initialPosition = LatLng(latitude, longitude);
        
        CollectionReference zonesCollection = documentSnapshot.reference.collection('zones');
        QuerySnapshot zonesQuerySnapshot = await zonesCollection.get();
        if (zonesQuerySnapshot.docs.isNotEmpty) {
          for (var zoneDocument in zonesQuerySnapshot.docs) {
            String zone = zoneDocument.id;
            String slots = zoneDocument.get('slots') as String;
            double lat = zoneDocument.get('x') as double;
            double long = zoneDocument.get('y') as double;

            int availableSlots = extractSlotsAvailable(slots);

            Zone newZone = Zone(
              zone,
              availableSlots,
              5,
              lat,
              long,
            );

            zones.add(newZone);

            _markersZones.add(
              Marker(
                markerId: MarkerId("zone_$zone"),
                position: LatLng(lat, long),
                icon: zoneIcon ?? BitmapDescriptor.defaultMarker,
                infoWindow: InfoWindow(
                  title: 'Zone $zone',
                  snippet: '$availableSlots slots available',
                ),
                onTap: () {
                  selectZone(zone);
                },
              ),
            );
          }

          zones.sort((a, b) => a.zone.compareTo(b.zone));
        } else {
          showToast(message: 'No zones found for parking: ${widget.bookedAddress}');
        }
      } else {
        showToast(message: 'No parkings found called: ${widget.bookedAddress}');
      }
      totalSlots = zones.fold(0, (tot, zone) => tot + zone.slots);
    } catch (e) {
      showToast(message: 'Error retrieving zone details: $e');
    }

    setState(() {
      _markers.clear();
      if (initialPosition != null) {
        initialMarkerId = const MarkerId('initialPosition');
        _markers.add(
          Marker(
            markerId: initialMarkerId!,
            position: initialPosition!,
            icon: carIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            infoWindow: InfoWindow(
              title: widget.bookedAddress,
            ),
          ),
        );
      }
      _markers.addAll(_markersZones);
    });
    setState(() {
      _isFetching = false;
    });
  }


  void selectZone(String zone) {
    // showToast(message: zone);
    setState(() {
      selectedZone = zone;
    });
  }

  @override
  void initState() {
    super.initState();
    loadCustomMarker().then((_) {
      getDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D2F41),
      body: _isFetching ? loadingWidget()
      : Container(
        color: const Color(0xFF2D2F41),
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Container(
            color: const Color(0xFF2D2F41),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 15),
                  color: const Color(0xFF2D2F41),
                  child: Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 30.0),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                      ),
                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Parking Zones',
                          style: TextStyle(
                            color: Colors.tealAccent,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Text(
                  'Choose Your Parking\nZone',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.white),
                  ),
                  child: Text(
                    '$totalSlots spaces available',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage('assets/zone.png'),
                      width: 40,
                      height: 40,
                    ),
                    SizedBox(width: 8),
                    Text(
                      '  Click on a icon which\ndenotes a parking zone',
                      style: TextStyle(
                        color: Colors.tealAccent,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 400,
                  child: initialPosition == null
                      ? const Center(child: CircularProgressIndicator())
                      : GoogleMap(
                          onMapCreated: (GoogleMapController controller) {
                            mapController = controller;
                            if (initialMarkerId != null) {
                              Future.delayed(const Duration(milliseconds: 500), () {
                                mapController.showMarkerInfoWindow(initialMarkerId!);
                              });
                            }
                          },
                          initialCameraPosition: CameraPosition(
                            target: initialPosition!,
                            zoom: 17.0,
                          ),
                          markers: _markers,
                        ),
                ),
                if (selectedZone != null) ...[
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF34354A),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Zone $selectedZone',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Spaces Available: ${zones.firstWhere((z) => z.zone == selectedZone).slots} slots',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Distance to Zone: ${widget.distanceAndDurationString}', // Display the string here
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    width: 160,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedZone != null ? const Color(0xFF58C6A9) : const Color(0xFF5B5B5B),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      onPressed: selectedZone != null
                          ? () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => LevelSelectPage(
                                    bookedAddress: widget.bookedAddress,
                                    price: widget.price,
                                    selectedZone: selectedZone!,
                                    futureBooking: futureBooking,
                                  ),
                                ),
                              );
                            }
                          : null,
                      child: const Text('Continue', style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

//   Widget _buildZoneButton(Zone zones) {
//     return Positioned(
//       left: zones.x,
//       top: zones.y,
//       child: GestureDetector(
//         onTap: () {
//           selectZone(zones.zone);
//           if(zones.slots == 0) {
//             futureBooking = true;
//             showToast(message: 'This must be a future booking');
//           } else { 
//             futureBooking = false;
//           }
//         },
//         child: Container(
//           width: 40,
//           height: 40,
//           decoration: BoxDecoration(
//             color: selectedZone == zones.zone ? const Color(0xFF58C6A9) : Colors.green,
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: const Center(
//             child: Icon(Icons.local_parking, color: Colors.white),
//           ),
//         ),
//       ),
//     );
//   }
}
