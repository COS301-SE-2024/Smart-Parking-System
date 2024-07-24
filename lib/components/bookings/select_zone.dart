// import 'package:flutter/material.dart';
// import 'package:smart_parking_system/components/bookings/select_level.dart';

// class ZoneSelectPage extends StatefulWidget {
//   final double price;
//   final String bookedAddress;
//   const ZoneSelectPage({required this.bookedAddress, required this.price, super.key});

//   @override
//   State<ZoneSelectPage> createState() => _ZoneSelectPageState();
// }

// class _ZoneSelectPageState extends State<ZoneSelectPage> {
//   String? selectedZone;
//   Map<String, dynamic> zoneDetails = {
//     'A': {'spaces': 200, 'distance': '3 mins drive'},
//     'B': {'spaces': 150, 'distance': '5 mins drive'},
//     // Add more zones as needed
//   };

//   void selectZone(String zone) {
//     setState(() {
//       selectedZone = zone;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF2D2F41),
//       body: Container(
//         color: const Color(0xFF2D2F41),
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Container(
//               padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 15),
//               color: const Color(0xFF2D2F41),
//               child: Stack(
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 30.0),
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                   ),
//                   const Align(
//                     alignment: Alignment.center,
//                     child: Text(
//                       'Parking Zones',
//                       style: TextStyle(
//                         color: Colors.tealAccent,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const Text(
//               'Choose Your Parking\nZone',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 28,
//                 fontWeight: FontWeight.bold,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 20),
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(25),
//                 border: Border.all(color: Colors.white),
//               ),
//               child: const Text(
//                 '500 spaces available',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   width: 40,
//                   height: 40,
//                   decoration: BoxDecoration(
//                     color: selectedZone == null ? Colors.green : Color(0xFF58C6A9),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: const Center(
//                     child: Icon(Icons.local_parking, color: Colors.white),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 const Text(
//                   'Denotes a Parking Zone',
//                   style: TextStyle(
//                     color: Colors.tealAccent,
//                     fontSize: 18,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             // Container(
//             //   padding: const EdgeInsets.all(8),
//             //   decoration: BoxDecoration(
//             //     color: Colors.white,
//             //     borderRadius: BorderRadius.circular(8),
//             //     boxShadow: [
//             //       BoxShadow(
//             //         color: Colors.grey.withOpacity(0.5),
//             //         spreadRadius: 5,
//             //         blurRadius: 7,
//             //         offset: const Offset(0, 3),
//             //       ),
//                 LayoutBuilder(
//                   builder: (BuildContext context, BoxConstraints constraints) {
//                     return Container(
//                       // Set the width and height according to the image dimensions or constraints
//                       width: constraints.maxWidth, // Example to use max width available
//                       height: constraints.maxHeight, // Adjust based on your image aspect ratio or desired size
//                       child: Image(
//                         image: AssetImage('path/to/your/image'),
//                         fit: BoxFit.cover, // Adjust the fit as needed
//                       ),
//                     );
//                   },
//                 );
//                 ],
//               ),
//               child: Column(
//                 children: [
//                   Stack(
//                     children: [
//                       Image.asset(
//                         'assets/s-map.png', // Update this with your image path
//                         height: 200,
//                         width: double.infinity,
//                         fit: BoxFit.contain,
//                       ),
//                       Positioned(
//                         left: 100,
//                         top: 50,
//                         child: GestureDetector(
//                           onTap: () {
//                             selectZone('A');
//                           },
//                           child: Container(
//                             width: 40,
//                             height: 40,
//                             decoration: BoxDecoration(
//                               color: selectedZone == 'A' ? Color(0xFF58C6A9) : Colors.green,
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: const Center(
//                               child: Icon(Icons.local_parking, color: Colors.white),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         left: 200,
//                         top: 100,
//                         child: GestureDetector(
//                           onTap: () {
//                             selectZone('B');
//                           },
//                           child: Container(
//                             width: 40,
//                             height: 40,
//                             decoration: BoxDecoration(
//                               color: selectedZone == 'B' ? Color(0xFF58C6A9) : Colors.green,
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: const Center(
//                               child: Icon(Icons.local_parking, color: Colors.white),
//                             ),
//                           ),
//                         ),
//                       ),
//                       // Add more Positioned widgets for other 'P' markers
//                     ],
//                   ),
//                   if (selectedZone != null && zoneDetails.containsKey(selectedZone)) ...[
//                     const SizedBox(height: 20),
//                     Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF34354A),
//                         borderRadius: BorderRadius.circular(8),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.white.withOpacity(0.5),
//                             spreadRadius: 5,
//                             blurRadius: 7,
//                             offset: const Offset(0, 3),
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Zone $selectedZone',
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 10),
//                           Text(
//                             'Spaces Available: ${zoneDetails[selectedZone!]['spaces']} slots',
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 18,
//                             ),
//                           ),
//                           const SizedBox(height: 10),
//                           Text(
//                             'Distance to Zone: ${zoneDetails[selectedZone!]['distance']}',
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 18,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//             const Spacer(),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.teal,
//                 padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               onPressed: selectedZone != null ? () {
//                 // Handle continue action
//               } : null,
//               child: const Text(
//                 'Continue',
//                 style: TextStyle(color: Colors.white, fontSize: 18),
//               ),
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class ZoneSelectPage extends StatefulWidget {
  final double price;
  final String bookedAddress;
  const ZoneSelectPage({required this.bookedAddress, required this.price, super.key});

  @override
  State<ZoneSelectPage> createState() => _ZoneSelectPageState();
}

class _ZoneSelectPageState extends State<ZoneSelectPage> {
  String? selectedZone;
  Map<String, dynamic> zoneDetails = {
    'A': {'spaces': 200, 'distance': '3 mins drive'},
    'B': {'spaces': 150, 'distance': '5 mins drive'},
    // Add more zones as needed
  };

  void selectZone(String zone) {
    setState(() {
      selectedZone = zone;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D2F41),
      body: Container(
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
                      Navigator.of(context).pop();
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
              child: const Text(
                '500 spaces available',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: selectedZone == null ? Colors.green : Color(0xFF58C6A9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Icon(Icons.local_parking, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Denotes a Parking Zone',
                  style: TextStyle(
                    color: Colors.tealAccent,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              width: 300, // Fixed width to ensure positions don't change with screen size
              height: 200, // Fixed height to ensure positions don't change with screen size
              child: Stack(
                children: [
                  Image.asset(
                    'assets/s-map.png', // Update this with your image path
                    height: 200,
                    width: 300,
                    fit: BoxFit.contain,
                  ),
                  Positioned(
                    left: 100,
                    top: 50,
                    child: GestureDetector(
                      onTap: () {
                        selectZone('A');
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: selectedZone == 'A' ? Color(0xFF58C6A9) : Colors.green,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Icon(Icons.local_parking, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 200,
                    top: 100,
                    child: GestureDetector(
                      onTap: () {
                        selectZone('B');
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: selectedZone == 'B' ? Color(0xFF58C6A9) : Colors.green,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Icon(Icons.local_parking, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  // Add more Positioned widgets for other 'P' markers
                ],
              ),
            ),
            if (selectedZone != null && zoneDetails.containsKey(selectedZone)) ...[
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
                      'Spaces Available: ${zoneDetails[selectedZone!]['spaces']} slots',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Distance to Zone: ${zoneDetails[selectedZone!]['distance']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: selectedZone != null ? () {
                // Handle continue action
              } : null,
              child: const Text(
                'Continue',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
