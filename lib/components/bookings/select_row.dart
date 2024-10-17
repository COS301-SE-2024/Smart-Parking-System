import 'package:flutter/material.dart';
import 'package:smart_parking_system/components/bookings/confirm_booking.dart';
//Firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_parking_system/components/common/custom_widgets.dart';
import 'package:smart_parking_system/components/common/toast.dart';
import 'package:smart_parking_system/components/common/common_functions.dart';

class SelectRowPage extends StatefulWidget {
  final String bookedAddress;
  final double price;
  final String selectedZone;
  final String selectedLevel;
  final bool futureBooking;

  const SelectRowPage({
    required this.bookedAddress,
    required this.price,
    required this.selectedZone,
    required this.selectedLevel,
    required this.futureBooking,
    super.key,
  });

  @override
  SelectRowPageState createState() => SelectRowPageState();
}

class RowSpace {
  final String row;
  final int slots;

  RowSpace(this.row, this.slots);
}

class SelectRowPageState extends State<SelectRowPage> {
  String? selectedRow;
  int totalSlots = 0;
  late bool futureBooking;
  bool _isFetching = true;

  List<RowSpace> rows = [
    // Add more rows here
  ];

    // Get details on load
  Future<void> getDetails() async {
    setState(() {
      _isFetching = true;
    });
    try {
      // Get a reference to the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Query the 'parkings' collection for a document with matching name
      QuerySnapshot querySnapshot = await firestore
          .collection('parkings')
          .where('name', isEqualTo: widget.bookedAddress)
          .get();

      // Check if a matching document was found
      if (querySnapshot.docs.isNotEmpty) {
        // Get the document snapshot
        DocumentSnapshot parkingDocumentSnapshot = querySnapshot.docs[0];

        // Get the subcollection 'zones'
        CollectionReference zonesCollection = parkingDocumentSnapshot.reference.collection('zones');

        // Query the 'zones' subcollection for a document with matching id
        DocumentSnapshot zoneDocumentSnapshot = await zonesCollection.doc(widget.selectedZone).get();

        // Check if a matching document was found
        if (zoneDocumentSnapshot.exists) {
          // Get the subcollection 'levels'
          CollectionReference levelsCollection = zoneDocumentSnapshot.reference.collection('levels');

          // Query the 'levels' subcollection for a document with matching id
          DocumentSnapshot levelDocumentSnapshot = await levelsCollection.doc(widget.selectedLevel).get();

          // Check if a matching document was found
          if (levelDocumentSnapshot.exists) {
            // Get the subcollection 'rows'
            CollectionReference rowsCollection = levelDocumentSnapshot.reference.collection('rows');

            // Query the 'rows' subcollection for all documents
            QuerySnapshot rowsQuerySnapshot = await rowsCollection.get();

            // Check if there are any documents
            if (rowsQuerySnapshot.docs.isNotEmpty) {
              // Loop through each document
              for (var rowDocument in rowsQuerySnapshot.docs) {
                // Retrieve the fields
                String rowId = rowDocument.id;
                String slots = rowDocument.get('slots') as String;

                // Calculate total price
                int availableSlots = extractSlotsAvailable(slots);

                // Add to rows list
                rows.add(RowSpace(
                  rowId,
                  availableSlots,
                ));
              }

              // Sort the rows list
              rows.sort((a, b) {
                int comparison = a.row.compareTo(b.row);
                if (comparison != 0) {
                  return comparison;
                } else {
                  return a.row.compareTo(b.row);
                }
              });
            } else {
              // No rows found
              showToast(message: 'No rows found for level: ${widget.selectedLevel}');
            }
          } else {
            // No level found
            showToast(message: 'No level found: ${widget.selectedLevel}');
          }
        } else {
          // No zone found
          showToast(message: 'No zone found: ${widget.selectedZone}');
        }
      } else {
        // No parking found
        showToast(message: 'No parking found: ${widget.bookedAddress}');
      }

      // Calculate total slots
      totalSlots = rows.fold(0, (tot, row) => tot + row.slots);
    } catch (e) {
      // Handle any errors
      showToast(message: 'Error retrieving row details: $e');
    }

    setState(() {
      _isFetching = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getDetails();
    futureBooking = widget.futureBooking;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D2F41),
      body: _isFetching ? loadingWidget()
      : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                        Icons.arrow_back_ios_new_rounded, color: Colors.white,
                        size: 30.0),
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                  const Expanded(
                    child: Text(
                      'Parking Row',
                      style: TextStyle(color: Color(0xFF58C6A9),
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 48), // To balance the back button
                ],
              ),
              const SizedBox(height: 40),
              const Center(
                child: Text(
                  'Choose your parking',
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
              const Center(
                child: Text(
                  'Row',
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
              const SizedBox(height: 13),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15, horizontal: 80),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.white.withOpacity(0.2), width: 2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    '$totalSlots spaces available',
                    style: const TextStyle(color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: rows.expand((rows) => [
                  _buildRowButton(rows),
                ]).toList(),
              ),
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: 160,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedRow != null ? const Color(0xFF58C6A9) : const Color(0xFF5B5B5B),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    onPressed: selectedRow != null
                        ? () {
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     builder: (_) => const ChooseVehiclePage(),
                      //   ),
                      // );
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ConfirmBookingPage(
                            bookedAddress: widget.bookedAddress,
                            price: widget.price,
                            selectedZone: widget.selectedZone,
                            selectedLevel: widget.selectedLevel,
                            selectedRow: selectedRow,
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRowButton(RowSpace rows) {
    String row = rows.row;

    bool isDisabled = rows.slots == 0;
    bool isSelected = selectedRow == row;
    Color buttonColor = isDisabled ? const Color(0xFFC0C0C0) : (isSelected ? const Color(0xFF58C6A9) : const Color(0xFF39C16B));

    return Center(
      child: Column(
        children: [ 
          const SizedBox(height: 13),
          SizedBox(
            width: 300,
            height: 1,
            child: CustomPaint(
              painter: DottedLinePainter(),
            ),
          ),
          const SizedBox(height: 13),
          Container(
            width: 290,
            height: 110,
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: isDisabled 
                ? () {
                  setState(() {
                    selectedRow = row;
                    futureBooking = true;
                    showToast(message: 'This must be a future booking');
                  });
                } 
                : () {
                  setState(() {
                    selectedRow = row;
                    futureBooking = false;
                  });
                },
              child: Stack(
                children: [
                  if (isSelected)
                    Center(
                      child: Text(
                        'Row $row Selected',
                        style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    )
                  else ...[
                    Positioned(
                      left: 2,
                      top: 8,
                      child: Text(
                        'Row $row',
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.normal),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Positioned(
                      right: 2,
                      top: 8,
                      child: Text(
                        '${rows.slots} Slots Available',
                        style: const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      left: 2,
                      child: Row(
                        children: List.generate(6, (index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Image.asset(
                            'assets/smallCar.png',
                            width: 30,
                            height: 50,
                          ),
                        )),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ]
      ),
    );
  }
}

class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    var max = size.width;
    var dashWidth = 5;
    var dashSpace = 5;
    double startX = 0;

    while (startX < max) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}