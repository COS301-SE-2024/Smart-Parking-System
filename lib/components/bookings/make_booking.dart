import 'package:flutter/material.dart';
import 'package:smart_parking_system/components/bookings/bookspace.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  String _selectedRow = '';
  String _selectedLevel = '';
  String _selectedZone = '';
  // String _selectedZone = '';
  bool hasLevel = false;
  bool hasZone = false;
  int numberOfLevels = 5;
  int numberOfZones = 7;
  int numberOfRows = 11;
  
  
  // bool _agreeToReserve = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // Handle the menu button press
          },
        ),
        actions: const [
          CircleAvatar(
            backgroundImage: AssetImage('assets/profile.png'),
            radius: 20,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 30),
            Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Sandton City',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text('R10/hr'),
                  ],
                ),
              )
            ),
            const SizedBox(height: 20),
            const Text('Choose the available space', style: TextStyle(color: Colors.grey, fontSize: 18)),
            const SizedBox(height: 10),
            //Here is Level checker!
            
            
            // if(hasZone)
            // const SizedBox(height: 10),
            if(!hasZone)
            const Text("Zones:", style: TextStyle(fontSize: 18)),
            if(!hasZone)
            SingleChildScrollView(
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ListView.builder(
                  itemCount: numberOfLevels,
                  itemBuilder: (context, index) {
                    int zone = index + 1;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Column(
                        children: [
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              if((zone + index) <= numberOfZones)
                              
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedZone = 'Zone ${String.fromCharCode(65 + index + index)}';
                                    });
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 150,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: _selectedZone == 'Zone ${String.fromCharCode(65 + index + index)}'
                                      ? const Color(0xFF4C4981)
                                          : Colors.white,
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      'Zone ${String.fromCharCode(65 + index + index)}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: _selectedZone == 'Zone ${String.fromCharCode(65 + index + index)}'
                                        ? Colors.white
                                          : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              
                              const SizedBox(width: 20),
                              if((zone + index + 1) <= numberOfZones)
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedZone = 'Zone ${String.fromCharCode(65 + index + index + 1)}';
                                    });
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 200,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: _selectedZone == 'Zone ${String.fromCharCode(65 + index + index + 1)}'
                                      ? const Color(0xFF4C4981)
                                          : Colors.white,
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      'Zone ${String.fromCharCode(65 + index + index + 1)}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: _selectedZone == 'Zone ${String.fromCharCode(65 + index + index + 1)}'
                                        ? Colors.white
                                          : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                )
              ),
            ),
            

            if(hasLevel)
            Text(_selectedZone, style: const TextStyle(fontSize: 18),),
            if(hasLevel)
            const Text("Levels:", style: TextStyle(fontSize: 18)),
            if(hasLevel)
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ListView.builder(
                itemCount: numberOfLevels,
                itemBuilder: (context, index) {
                  int level = index + 1;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Column(
                      children: [
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            if((level + index) <= numberOfLevels)
                            
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _selectedLevel = 'Level ${level + index}';
                                  });
                                },
                                child: Container(
                                  height: 40,
                                  width: 150,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: _selectedLevel == 'Level ${level + index}'
                                    ? const Color(0xFF4C4981)
                                        : Colors.white,
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    'Level ${level + index}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _selectedLevel == 'Level ${level + index}'
                                      ? Colors.white
                                        : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            
                            const SizedBox(width: 20),
                            if((level + index + 1) <= numberOfLevels)
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _selectedLevel = 'Level ${level + index + 1}';
                                  });
                                },
                                child: Container(
                                  height: 40,
                                  width: 200,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: _selectedLevel == 'Level ${level + index + 1}'
                                    ? const Color(0xFF4C4981)
                                        : Colors.white,
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    'Level ${level + index + 1}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _selectedLevel == 'Level ${level + index + 1}'
                                      ? Colors.white
                                        : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              )
            ),

            if (hasZone && !hasLevel)
            Text(_selectedZone, style: const TextStyle(fontSize: 18),),
            if (hasZone && !hasLevel)
             Text(_selectedLevel, style: const TextStyle(fontSize: 18)),
            //  if (!hasZone && hasLevel)
            // const SizedBox(height: 10),
            if (hasZone && !hasLevel)
            const Text('Row:', style: TextStyle(fontSize: 18),),
            if (hasZone && !hasLevel)
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ListView.builder(
                itemCount: 12,
                itemBuilder: (context, index) {
                  int row = index + 1;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            if((row + index) <= numberOfRows)
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    _selectedRow = 'Row ${row + index}';
                                  });
                                },
                                child: Container(
                                  height: 40,
                                  width: 140,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: _selectedRow == 'Row ${row + index}'
                                    ? const Color(0xFF4C4981)
                                        : Colors.white,
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    'Row ${row + index}  10 Available',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _selectedRow == 'Row ${row + index}'
                                      ? Colors.white
                                        : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            
                            if((row + index) <= numberOfRows)
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child:  Icon(
                                    Icons.directions_car,
                                    size: 25,
                                  ),
                            ),
                            if((row + index + 1) <= numberOfRows)
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _selectedRow = 'Row ${row + index + 1}';
                                  });
                                },
                                child: Container(
                                  height: 40,
                                  width: 200,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: _selectedRow == 'Row ${row + index + 1}'
                                    ? const Color(0xFF4C4981)
                                        : Colors.white,
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    'Row ${row + index + 1}   10 Available',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _selectedRow == 'Row ${row + index + 1}'
                                      ? Colors.white
                                        : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              )
            ),




            const SizedBox(height: 40),
            // Row(
            //   children: [
            //     Text(
            //       'Reserve for another time',
            //       style: TextStyle(),
            //     ),
            //     Switch(
            //       value: _agreeToReserve,
            //       onChanged: (value) {
            //         setState(() {
            //           _agreeToReserve = value;
            //         });
            //       },
            //         ),
            //       ],
            // ),
            // const SizedBox(height: 20),
            if(hasLevel)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4C4981),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed:  _selectedLevel.isEmpty? null :() {
                // Handle the continue button press
                setState(() {
                  hasLevel = false;
                  hasZone = true;
                });
              },
              child: Text('Choose $_selectedLevel', style: const TextStyle(color: Colors.white, fontSize: 18),),
            ),
            if(!hasZone)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4C4981),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _selectedZone.isEmpty? null : () {
                // Handle the continue button press
                setState(() {
                  hasLevel = true;
                  hasZone = true;
                });
              },
              child: Text('Choose $_selectedZone', style: const TextStyle(color: Colors.white, fontSize: 18),),
            ),
            if (hasZone && !hasLevel)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4C4981),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                
              ),
              onPressed: _selectedRow.isEmpty? null : () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const BookSpaceScreen(),
                  ),
                );
                
              },
              child: Text('Choose $_selectedRow', style: const TextStyle(color: Colors.white, fontSize: 18),),
            ),
              
            
          ],
        ),
      ),
    );
  }
}