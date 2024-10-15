import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_parking_system/components/common/toast.dart';

Future<void> addParkingToFirestore({
  required String userId,
  required String parkingName,
  required Map<String, String> operationHours,
  required double posLatitude,
  required double posLongitude,
  required int noZones,
  required int noBasementLevels,
  required int noUpperLevels,
  required int noRows,
  required int noSlotsPerRow,
  required String pricePerHour,
  // required Map<String, Map<String, dynamic>> parkingStructure,
}) async {
  final firestore = FirebaseFirestore.instance;
  final List<String> alphabet = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'];
  // final random = Random();

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
    for (int zoneIndex = 0; zoneIndex < noZones; zoneIndex++) {
      final zoneId = alphabet[zoneIndex];
      final zoneDocRef = parkingDocRef.collection('zones').doc(zoneId);

      // Add levels sub-collection
      int totalSlotsInZone = 0;
      for (int levelIndex = 0; levelIndex < noUpperLevels; levelIndex++) {
        var levelId = '';
        if (levelIndex == 0) {levelId = 'Ground';}
        else {levelId = 'L$levelIndex';}
        final levelDocRef = zoneDocRef.collection('levels').doc(levelId);

        // Add rows sub-collection
        int totalSlotsInLevel = 0;
        for (int rowIndex = 0; rowIndex < noRows; rowIndex++) {
          final rowId = alphabet[rowIndex];
          final totalSlotsInRow = noSlotsPerRow;
          totalSlotsInLevel += totalSlotsInRow;
          totalSlotsInZone += totalSlotsInRow;
          totalSlots += totalSlotsInRow;

          final rowDocRef = levelDocRef.collection('rows').doc(rowId);

          await rowDocRef.set({
            'slots': "$totalSlotsInRow/$totalSlotsInRow",
          });
        }

        await levelDocRef.set({
          'slots': "$totalSlotsInLevel/$totalSlotsInLevel",
        });
      }
      for (int levelIndex = 0; levelIndex < noBasementLevels; levelIndex++) {
        final levelId = 'B${levelIndex+1}';
        final levelDocRef = zoneDocRef.collection('levels').doc(levelId);

        // Add rows sub-collection
        int totalSlotsInLevel = 0;
        for (int rowIndex = 0; rowIndex < noRows; rowIndex++) {
          final rowId = alphabet[rowIndex];
          final totalSlotsInRow = noSlotsPerRow;
          totalSlotsInLevel += totalSlotsInRow;
          totalSlotsInZone += totalSlotsInRow;
          totalSlots += totalSlotsInRow;

          final rowDocRef = levelDocRef.collection('rows').doc(rowId);

          await rowDocRef.set({
            'slots': "$totalSlotsInRow/$totalSlotsInRow",
          });
        }

        await levelDocRef.set({
          'slots': "$totalSlotsInLevel/$totalSlotsInLevel",
        });
      }

      // - - - - - HERE - - - - -
      try {
        //Get first marker
        QuerySnapshot markerQuery = await firestore
          .collection('markers')
          .where('location_name', isEqualTo: parkingName)
          .limit(1)
          .get();
          
        if (markerQuery.docs.isNotEmpty) {
          //Get doc ref
          QueryDocumentSnapshot markerDoc = markerQuery.docs.first;

          //Set data
          await zoneDocRef.set({
            'slots': "$totalSlotsInZone/$totalSlotsInZone",
            'x': markerDoc.get('latitude') as double,
            'y': markerDoc.get('longitude') as double,
          });

          //Delete doc
          await markerDoc.reference.delete();
        }
        // - - - - - HERE - - - - -
      } catch (e) {
        showToast(message: "Error retrieving markers: $e");
      }
    }

    // Add parking details
    await parkingDocRef.set({
      'userId': userId,
      'name': parkingName,
      'operationHours': operationHours,
      'latitude': posLatitude,
      'longitude': posLongitude,
      'price': pricePerHour,
      'slots_available': "$totalSlots/$totalSlots", // Total slots available
    });

    showToast(message: 'Success: Parking area added successfully!');
  } catch (e) {
    showToast(message: 'ERROR: $e');
  }
}