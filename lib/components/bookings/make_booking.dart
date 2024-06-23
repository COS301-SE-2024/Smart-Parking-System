import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:smart_parking_system/components/bookings/confirm_booking.dart';
import 'package:smart_parking_system/components/bookings/select_level.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final Map<String, int> availableSlots = {
    '' : 0,
    'A': 2,
    'B': 0,
    'C': 0,
  };

  String? selectedRow;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF35344A),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.symmetric(vertical:0, horizontal: 15),
                  color: const Color(0xFF35344A),
                  child: Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 30.0),
                        onPressed: () {
                           // Open the drawer
                           Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const LevelSelectPage(),
                            ),
                          );
                        },
                      ),
                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Parking Slot',
                          style: TextStyle(
                            color: Color(0xFF58C6A9),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // const Center(
                //   child:  Padding(
                //     padding: EdgeInsets.symmetric(horizontal: 15.0),
                //     child: Text(
                //       '2 Slots Available For Zone A Level 1',
                //       style: TextStyle(
                //         color: Colors.tealAccent,
                //         fontSize: 16,
                //         fontWeight: FontWeight.bold,
                //       ),
                //     ),
                //   ),
                // ),
                
                // const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: availableSlots.keys.length,
                    itemBuilder: (context, index) {
                      String row = availableSlots.keys.elementAt(index);
                      int slots = availableSlots[row]!;
                      return GestureDetector(
                        onTap: slots > 0
                            ? () {
                                setState(() {
                                  selectedRow = row;
                                });
                              }
                            : null,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0.0),
                          child: Column(
                            
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Visibility(
                              visible: index == 0,
                              child: RichText(
                                text: const TextSpan(
                                  style: TextStyle(color: Colors.white),
                                  children: [
                                    TextSpan(
                                      text: '| ',
                                      style: TextStyle(
                                        color: Color(0xFF58C6A9),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 28,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Main Entrance',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold, 
                                        fontSize: 28,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' |',
                                      style: TextStyle(
                                        color: Color(0xFF58C6A9),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 28,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Visibility(
                              visible: index == 0,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 85),
                                child: Divider(
                                  color: Color(0xFF58C6A9),
                                  thickness: 3,
                                ),
                              ),
                            ),
                            SizedBox(height: index == 0 ? 40 : 0),
                            Visibility(
                              visible: index != 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    row,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 50,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    'Parking\nRow',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w200,
                                    ),
                                  ),
                                ],
                              ),
                            ),              
                            Visibility(
                              visible: index != 0,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 0),
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: selectedRow == row
                                        ? Colors.green
                                        : slots > 0
                                            ? const Color(0xFF58C6A9)
                                            : const Color.fromARGB(255, 170, 55, 47),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '$slots slots Available',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      selectedRow == row
                                        ? const Text('  | Selected',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          
                                        ) 
                                        : const SizedBox(),
                                    ],
                                  ),
                                ),
                              ),
                            ),  
                              const SizedBox(height: 15),
                              // const Divider(
                              //   color: Color.fromARGB(255, 199, 199, 199), // Color of the lines

                              //   thickness: 1, // Thickness of the lines
                              // ),
                            Visibility(
                              visible: index != 0,
                              child: Dash(
                                direction: Axis.horizontal,
                                length: MediaQuery.of(context).size.width - 52,
                                dashLength: 10,
                                dashColor: const Color.fromARGB(255, 199, 199, 199),
                                dashThickness: 1,
                              ),
                            ),
                              
                              
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Change pages
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => const ConfirmBookingPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedRow != null ? const Color(0xFF58C6A9): const Color(0xFF35344A),
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Text(
                      'Book Slot',
                      style: TextStyle(
                        color: selectedRow == null ? const Color(0xFF35344A) : Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
            // Positioned(
            //   top: 250,
            //   bottom: 0,
            //   right: 20,
            //   child: Dash(
            //     direction: Axis.vertical,
            //     length: MediaQuery.of(context).size.height,
            //     dashLength: 10,
            //     dashColor: const Color.fromARGB(255, 199, 199, 199),
            //     dashThickness: 1,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
