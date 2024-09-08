import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_parking_system/components/common/toast.dart';

Future<void> addParkingToFirestore({
  required String parkingName,
  required String pricePerHour,
  required double posLatitude,
  required double posLongitude,
  required Map<String, Map<String, dynamic>> parkingStructure,
}) async {
  final firestore = FirebaseFirestore.instance;

  try {
    // Check if parking name already exists
    final existingParkingQuery = await firestore
        .collection('parkings')
        .where('name', isEqualTo: parkingName)
        .limit(1)
        .get();

    if (existingParkingQuery.docs.isNotEmpty) {
      showToast(message: 'Parking with this name already exists.');
      return;
    }

    int totalSlots = 0;

    // Add parking document
    final parkingDocRef = firestore.collection('parkings').doc();

    // Add zones sub-collection
    for (var zoneEntry in parkingStructure.entries) {
      final zoneId = zoneEntry.key;
      final zoneData = zoneEntry.value;

      final zoneDocRef = parkingDocRef.collection('zones').doc(zoneId);

      // Add levels sub-collection
      int totalSlotsInZone = 0;
      for (var levelEntry in zoneData.entries) {
        final levelId = levelEntry.key;
        final levelData = levelEntry.value;

        if (levelData is Map<String, dynamic>) {

          final levelDocRef = zoneDocRef.collection('levels').doc(levelId);

          // Add rows sub-collection
          int totalSlotsInLevel = 0;
          for (var rowEntry in levelData.entries) {
            final rowId = rowEntry.key;
            final rowData = rowEntry.value;

            if (rowData is Map<String, dynamic>) {
              final totalSlotsInRow = (rowData['slots'] as int?) ?? 0;
              totalSlots += totalSlotsInRow;
              totalSlotsInLevel += totalSlotsInRow;
              totalSlotsInZone += totalSlotsInRow;

              final rowDocRef = levelDocRef.collection('rows').doc(rowId);

              await rowDocRef.set({
                'slots': "$totalSlotsInRow/$totalSlotsInRow",
              });
            }
          }

          await levelDocRef.set({
            'slots': "$totalSlotsInLevel/$totalSlotsInLevel",
          });
        }
      }

      await zoneDocRef.set({
        'slots': "$totalSlotsInZone/$totalSlotsInZone",
        'x': zoneData['x'],
        'y': zoneData['y'],
      });
    }

    await parkingDocRef.set({
      'latitude': posLatitude,
      'longitude': posLongitude,
      'name': parkingName,
      'price': pricePerHour,
      'slots_available': "$totalSlots/$totalSlots", // Total slots available
    });
    showToast(message: 'Success: Parking area added successfully!');
  } catch (e) {
    showToast(message: 'ERROR: $e');
  }
}

//How To Call :

  // addParkingToFirestore(
  //   parkingName: 'Hemingways Mall',
  //   pricePerHour: '15',
  //   posLatitude: -32.97051605731753,
  //   posLongitude: 27.901948782757295,
  //   parkingStructure: {
  //                       'A': {
  //                         'x' : 100,
  //                         'y' : 50,
  //                         'L2': {
  //                           'A': {'slots': 15},
  //                           'B': {'slots': 15},
  //                           'C': {'slots': 15},
  //                           'D': {'slots': 15},
  //                         },
  //                         'L1': {
  //                           'A': {'slots': 15},
  //                           'B': {'slots': 15},
  //                           'C': {'slots': 15},
  //                           'D': {'slots': 15},
  //                         },
  //                         'Ground': {
  //                           'A': {'slots': 15},
  //                           'B': {'slots': 15},
  //                           'C': {'slots': 15},
  //                           'D': {'slots': 15},
  //                         },
  //                         'B1': {
  //                           'A': {'slots': 15},
  //                           'B': {'slots': 15},
  //                           'C': {'slots': 15},
  //                           'D': {'slots': 15},
  //                         },
  //                         'B2': {
  //                           'A': {'slots': 15},
  //                           'B': {'slots': 15},
  //                           'C': {'slots': 15},
  //                           'D': {'slots': 15},
  //                         },
  //                       },
  //                       'B': {
  //                         'x': 200,
  //                         'y': 100,
  //                         'L2': {
  //                           'A': {'slots': 20},
  //                           'B': {'slots': 20},
  //                           'C': {'slots': 20},
  //                           'D': {'slots': 20},
  //                         },
  //                         'L1': {
  //                           'A': {'slots': 20},
  //                           'B': {'slots': 20},
  //                           'C': {'slots': 20},
  //                           'D': {'slots': 20},
  //                         },
  //                         'Ground': {
  //                           'A': {'slots': 20},
  //                           'B': {'slots': 20},
  //                           'C': {'slots': 20},
  //                           'D': {'slots': 20},
  //                         },
  //                         'B1': {
  //                           'A': {'slots': 20},
  //                           'B': {'slots': 20},
  //                           'C': {'slots': 20},
  //                           'D': {'slots': 20},
  //                         },
  //                         'B2': {
  //                           'A': {'slots': 20},
  //                           'B': {'slots': 20},
  //                           'C': {'slots': 20},
  //                           'D': {'slots': 20},
  //                         },
  //                       },
  //                     },
  // );

