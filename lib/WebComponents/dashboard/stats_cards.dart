import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StatsCards extends StatelessWidget {
  const StatsCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildIncomeCard(context)),
        const SizedBox(width: 20),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('bookings')
                .where('date', isEqualTo: DateTime.now().toString().substring(0, 10))
                .snapshots(),
            builder: (context, snapshot) {
              return _buildStatsColumn(context, snapshot);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildIncomeCard(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('bookings').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return _buildLoadingCard(context);

        var totalIncome = snapshot.data!.docs.fold<int>(
          0,
              (docSum, doc) => docSum + (doc['price'] as int),
        );
        var latestBooking = snapshot.data!.docs.last;

        return Card(
          color: const Color(0xFF1A1F37),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                _buildLatestBookingInfo(context, latestBooking),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatsColumn(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    if (!snapshot.hasData) return _buildLoadingColumn(context);

    var totalBookings = snapshot.data!.docs.length;
    var totalIncome = snapshot.data!.docs.fold<int>(
      0,
          (docSum, doc) => docSum + (doc['price'] as int),
    );
    var todaysMoney = totalIncome; // Assuming totalIncome is today's income

    return Column(
      children: [
        _buildStatsCard(
          context,
          title: "Today's Bookings",
          value: totalBookings.toString(),
          icon: Icons.event_available,
        ),
        const SizedBox(height: 18),
        _buildStatsCard(
          context,
          title: 'Total Parking Income',
          value: 'R $totalIncome',
          icon: Icons.local_parking,
        ),
        const SizedBox(height: 18),
        _buildStatsCard(
          context,
          title: "Today's Earnings",
          value: 'R $todaysMoney',
          icon: Icons.attach_money,
        ),
      ],
    );
  }

  Widget _buildStatsCard(BuildContext context,
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
        subtitle: Text(
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

  Widget _buildCardHeader(BuildContext context, String title, String value) {
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

  Widget _buildLatestBookingInfo(BuildContext context, DocumentSnapshot latestBooking) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.bookmark, color: Colors.white),
      title: Text(
        '${latestBooking['zone']} Parking Booking',
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

  Widget _buildLoadingCard(BuildContext context) {
    return Card(
      color: const Color(0xFF1A1F37),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 5,
      child: const Center(
        heightFactor: 10,
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildLoadingColumn(BuildContext context) {
    return Column(
      children: [
        _buildLoadingCard(context),
        const SizedBox(height: 18),
        _buildLoadingCard(context),
        const SizedBox(height: 18),
        _buildLoadingCard(context),
      ],
    );
  }
}