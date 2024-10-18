import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_parking_system/components/common/toast.dart';
import 'package:smart_parking_system/webApp/components/registration1.dart';

class Registration3 extends StatefulWidget {
  final Function onRegisterComplete;
  final ParkingSpot ps;

  const Registration3({super.key, required this.ps, required this.onRegisterComplete});

  @override
  // ignore: library_private_types_in_public_api
  _Registration3State createState() => _Registration3State();
}

class _Registration3State extends State<Registration3> {
  bool _isLoading = false;
  final Set<Marker> _markers = {};
  final Map<MarkerId, String> _markerIdsToFirestoreIds = {};
  late GoogleMapController mapController;
  late LatLng _center;
  late BitmapDescriptor _parkingIcon;
  late String locationName; // Replace with actual user ID
  int numZones = 0;

  @override
  void initState() {
    super.initState();
    locationName = widget.ps.name; // Initialize userId here
    _center = LatLng(widget.ps.latitude, widget.ps.longitude);
    _setCustomMarkerIcon();
    _addInitialMarker();
  }

  void _setCustomMarkerIcon() async {
    _parkingIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/zone.png', // Ensure you have this asset in your project
    );
  }

  void _addInitialMarker() {
    setState(() {
      _markers.add(Marker(
        markerId: const MarkerId('initial_marker'),
        position: _center,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ));
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _addMarker(LatLng position) async {
    final markerId = MarkerId(position.toString());
    setState(() {
      _markers.add(Marker(
        markerId: markerId,
        position: position,
        icon: _parkingIcon,
        onTap: () => _removeMarker(markerId),
      ));
    });

    // Store marker in Firestore
    DocumentReference docRef = await FirebaseFirestore.instance.collection('markers').add({
      'longitude': double.parse(position.longitude.toStringAsFixed(20)),
      'latitude': double.parse(position.latitude.toStringAsFixed(20)),
      'location_name': locationName,
    });

    // Store the Firestore document ID
    _markerIdsToFirestoreIds[markerId] = docRef.id;
    numZones++;
  }

  void _removeMarker(MarkerId markerId) async {
    setState(() {
      _markers.removeWhere((marker) => marker.markerId == markerId);
    });

    // Remove marker from Firestore
    if (_markerIdsToFirestoreIds.containsKey(markerId)) {
      String firestoreId = _markerIdsToFirestoreIds[markerId]!;
      await FirebaseFirestore.instance.collection('markers').doc(firestoreId).delete();
      _markerIdsToFirestoreIds.remove(markerId);
      numZones--;
    }
  }

  Future<void> _saveParkingDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (_markers.isEmpty) {
        showToast(message: 'Please add at least one parking zone marker.');
        return;
      }

      // Here you would typically save the markers to your ParkingSpot object
      // For example:
      // widget.ps.markers = _markers.map((marker) => marker.position).toList();

      // Call onRegisterComplete to move to the next step
      widget.ps.noZones = numZones;
      widget.onRegisterComplete();
    } catch (e) {
      showToast(message: 'Failed to save parking details: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          const Text(
            'Pin the parking zones below *',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          const Text(
            'Tap on the map to place parking zone markers at your parking location',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: SizedBox(
                height: 400,
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _center,
                    zoom: 17.0,
                  ),
                  markers: _markers,
                  onTap: _addMarker,
                ),
              ),
            ),
          ),

          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.local_parking, color: Colors.green, size: 30),
              SizedBox(width: 10),
              Text(
                'Denotes a Parking Zone',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),

          const SizedBox(height: 15),
          Center(
            child: SizedBox(
              width: 200,
              height: 40,
              child: ElevatedButton(
                onPressed: _saveParkingDetails,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF58C6A9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.0,
                        ),
                      )
                    : const Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}