import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StatsCards extends StatefulWidget {
  const StatsCards({super.key});

  @override
  State<StatsCards> createState() => _StatsCardsState();
}

class _StatsCardsState extends State<StatsCards> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = true;
  bool isLatestBooking = false;
  late CollectionReference bookingsCollection;
  num totalIncome = 0;
  num todaysIncome = 0;
  num totalBookings = 0;
  num todaysBookings = 0;
  late DocumentSnapshot latestBooking;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    try {
      //get current user
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception("No user logged in");
      }
      // Query the parkings collection
      final parkingQuery = await _firestore.collection('parkings')
          .where('userId', isEqualTo: currentUser.uid)
          .limit(1)
          .get();
      //No parking for user
      if (parkingQuery.docs.isEmpty) {
        throw Exception("No parking spot found for this user");
      }
      //Get address name
      final address = parkingQuery.docs.first.get('name') as String?;
      //Empty address name
      if (address == null) {
        throw Exception("Parking spot name not found");
      }
      // Query the bookings collection
      QuerySnapshot bookingsQuery = await _firestore
          .collection('bookings')
          .where('address', isEqualTo: address)
          .get();
      // Query the bookings collection
      QuerySnapshot pastBookingsQuery = await _firestore
          .collection('past_bookings')
          .where('address', isEqualTo: address)
          .get();

      // Getting Total Income and Latest DateTime
      num tempTotalIncome = 0;
      num tempTodaysIncome = 0;
      num tempTotalBookings = 0;
      num tempTodaysBookings = 0;
      DateTime? latestDate;
      DocumentSnapshot? tempLatestBooking;
      bool tempIsLatestBooking = false;
      DateTime today = DateTime.now();
      for (var booking in bookingsQuery.docs) {
        final data = booking.data() as Map<String, dynamic>;

        // Calculate total income
        tempTotalIncome += data['price'] ?? 0;
        tempTotalBookings++;

        // Calculate latest booking and todays bookings
        if (data['date'] != null && data['time'] != null) {
          // Parse date and time
          DateTime bookingDateTime = DateTime.parse('${data['date']} ${data['time']}');
          // Update latestDate if the current dateTime is later
          if (latestDate == null || bookingDateTime.isAfter(latestDate)) {
            latestDate = bookingDateTime;
            tempLatestBooking = booking;
            tempIsLatestBooking = true;
          }

          // Parse date
          DateTime bookingDate = DateTime.parse(data['date']);
          // Update latestDate if the current dateTime is later
          if (bookingDate.year == today.year && bookingDate.month == today.month && bookingDate.day == today.day) {
            tempTodaysIncome += data['price'] ?? 0;
            tempTodaysBookings++;
          }
        }
      }
      for (var booking in pastBookingsQuery.docs) {
        final data = booking.data() as Map<String, dynamic>;

        // Calculate total income
        tempTotalIncome += data['price'] ?? 0;
        tempTotalBookings++;

        // Calculate todays bookings
        if (data['date'] != null && data['time'] != null) {
          // Parse date
          DateTime bookingDate = DateTime.parse(data['date']);
          // Update latestDate if the current dateTime is later
          if (bookingDate.year == today.year && bookingDate.month == today.month && bookingDate.day == today.day) {
            tempTodaysIncome += data['price'] ?? 0;
            tempTodaysBookings++;
          }
        }
      }

      setState(() {
        totalIncome = tempTotalIncome;
        latestBooking = tempLatestBooking!;
        isLatestBooking = tempIsLatestBooking;
        totalBookings = tempTotalBookings;
        todaysBookings = tempTodaysBookings;
        todaysIncome = tempTodaysIncome;
      });
    } catch (e) {
      if(kDebugMode){
        print("Error: $e");
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) { //Done
    return Row(
      children: [
        Expanded(child: _buildIncomeCard(context)),
        const SizedBox(width: 20),
        Expanded(child: _buildStatsColumn(context)),
      ],
    );
  }

  Widget _buildIncomeCard(BuildContext context) { //Done
    return Card(
      color: const Color(0xFF1A1F37),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isLoading ?  const Center(child: CircularProgressIndicator()) :
                _buildCardHeader(context, 'Total Income', 'R $totalIncome'),
            const SizedBox(height: 24),
            Text(
              'LATEST BOOKING',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: const Color(0xFFA0AEC0),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            isLoading ?  const Center(child: CircularProgressIndicator()) :
              isLatestBooking
                ? _buildLatestBookingInfo(context)
                : const Text(
                    'No bookings yet',
                    style: TextStyle(color: Colors.white),
                  ),
          ],
        ),
      ),
    );
  }
  Widget _buildCardHeader(BuildContext context, String title, String value) { //Done
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFFE9EDF7),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const Icon(Icons.trending_up, color: Colors.greenAccent, size: 32),
      ],
    );
  }
  Widget _buildLatestBookingInfo(BuildContext context) { //Done
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.bookmark, color: Colors.white),
      title: Text(
        'Zone ${latestBooking['zone']} Parking Booking',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        'Today, ${latestBooking['time']}',
        style: const TextStyle(
          color: Color(0xFFA0AEC0),
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: Text(
        '+R ${latestBooking['price']}',
        style: const TextStyle(
          color: Colors.greenAccent,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStatsColumn(BuildContext context) {
    return Column(
      children: [
        _buildStatsCard(
          context,
          title: 'Total All-Time Bookings',
          value: totalBookings.toString(),
          icon: Icons.local_parking,
        ),
        const SizedBox(height: 18),
        _buildStatsCard(
          context,
          title: "Today's Bookings",
          value: todaysBookings.toString(),
          icon: Icons.event_available,
        ),
        const SizedBox(height: 18),
        _buildStatsCard(
          context,
          title: "Today's Earnings",
          value: 'R $todaysIncome',
          icon: Icons.attach_money,
        ),
      ],
    );
  }
  Widget _buildStatsCard(BuildContext context, //Done
      {required String title, required String value, required IconData icon}) {
    return Card(
      color: const Color(0xFF1A1F37),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 3,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFE9EDF7),
          child: Icon(icon, color: const Color(0xFF1A1F37)),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFFA0AEC0),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
      ),
    );
  }
}
