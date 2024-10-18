import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_parking_system/components/common/custom_widgets.dart';

class OfferPage extends StatefulWidget {
  const OfferPage({super.key});

  @override
  State<OfferPage> createState() => _OfferPageState();
}

class _OfferPageState extends State<OfferPage> {
  final Set<int> _appliedCouponIndices = {};
  List<Map<String, dynamic>> coupons = [];
  bool _isFetching = true;

  @override
  void initState() {
    super.initState();
    fetchCoupons();
  }

  Future<void> fetchCoupons() async {
    setState(() {
      _isFetching = true;
    });
    final user = FirebaseAuth.instance.currentUser; // Get the current user
    if (user != null) {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('coupons')
          .where('userId', isEqualTo: user.uid) // Filter by userId
          .get();
      final List<Map<String, dynamic>> fetchedCoupons = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'amountOff': doc['amount'],
          'description': 'Get R${doc['amount']} off your next booking',
          'applied': doc['applied'],
          'userId': doc['userId'],
        };
      }).toList();

      setState(() {
        coupons = fetchedCoupons;
      });
    }
    setState(() {
      _isFetching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(53, 52, 74, 1),
      body: _isFetching ? loadingWidget()
      : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 80),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 30),
                ),
                const Text(
                  'Offers',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF58C6A9),
                  ),
                ),
                const SizedBox(width: 48), // Adjust the width as needed
              ],
            ),
            const SizedBox(height: 50),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Center( 
                child: Text(
                  'Available Coupons',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF58C6A9),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            if(coupons.isEmpty) const Center( child: Text('No Coupons', style: TextStyle(color: Colors.grey, fontSize: 16),),),
            Expanded(
              child: ListView.builder(
                itemCount: coupons.length,
                itemBuilder: (context, index) {
                  final coupon = coupons[index];
                  final isApplied = coupon['applied'];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF35344A),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 1),
                            child: Icon(
                              Icons.local_activity,
                              color: Color(0xFF58C6A9),
                              size: 40,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ZAR R${coupon['amountOff'].toString()} OFF',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  coupon['description'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: isApplied
                                        ? null
                                        : () {
                                            // Handle apply action
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  backgroundColor: const Color(0xFF35344A), // Change dialog background color
                                                  title: const Text(
                                                    'Confirm',
                                                    style: TextStyle(color: Colors.white), // Change title text color
                                                  ),
                                                  content: Text(
                                                    'This coupon will apply R${coupon['amountOff'].toString()} OFF to your next booking.',
                                                    style: const TextStyle(color: Colors.white), // Change content text color
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: const Text(
                                                        'Cancel',
                                                        style: TextStyle(color: Color(0xFF58C6A9)), // Change button text color
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context).pop(true); // Close the dialog
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: const Text(
                                                        'Confirm',
                                                        style: TextStyle(color: Color(0xFF58C6A9)), // Change button text color
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context).pop(true); // Close the confirmation dialog
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext context) {
                                                            return AlertDialog(
                                                              backgroundColor: const Color(0xFF35344A), // Change dialog background color
                                                              title: const Text(
                                                                'Success!',
                                                                style: TextStyle(color: Colors.white), // Change title text color
                                                              ),
                                                              content: const Text(
                                                                'Coupon Applied Successfully.',
                                                                style: TextStyle(color: Colors.white), // Change content text color
                                                              ),
                                                              actions: <Widget>[
                                                                Center(
                                                                  child: TextButton(
                                                                    child: const Text(
                                                                      'OK',
                                                                      style: TextStyle(color: Color(0xFF58C6A9)), // Change button text color
                                                                    ),
                                                                    onPressed: () {
                                                                      Navigator.of(context).pop(true); // Close the success dialog
                                                                      setState(() {
                                                                        _appliedCouponIndices.add(index);
                                                                        coupons[index]['applied'] = true;
                                                                      });
                                                                      // Update Firestore
                                                                      FirebaseFirestore.instance.collection('coupons').doc(coupon['id']).update({
                                                                        'applied': true,
                                                                      });
                                                                    },
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                      style: ButtonStyle(
                                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(40.0),
                                          ),
                                        ),
                                        padding: WidgetStateProperty.all<EdgeInsets>(
                                          const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 0,
                                          ),
                                        ),
                                        backgroundColor: WidgetStateProperty.resolveWith<Color>(
                                          (Set<WidgetState> states) {
                                            if (states.contains(WidgetState.disabled)) {
                                              return const Color(0xFF58C6A9); // Light blue when disabled
                                            }
                                            return const Color(0xFF58C6A9); // Light blue when enabled
                                          },
                                        ),
                                      ),
                                      child: Text(
                                        isApplied ? 'Coupon Applied!' : 'Apply',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: isApplied ? Colors.white : Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    if (isApplied)
                                      ElevatedButton(
                                        onPressed: () {
                                          // Handle cancel action
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                backgroundColor: const Color(0xFF35344A), // Change dialog background color
                                                title: const Text(
                                                  'Confirm',
                                                  style: TextStyle(color: Colors.white), // Change title text color
                                                ),
                                                content: Text(
                                                  'Cancelling this coupon will no longer apply R${coupon['amountOff']} OFF to your next booking.',
                                                  style: const TextStyle(color: Colors.white), // Change content text color
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: const Text(
                                                      'Cancel',
                                                      style: TextStyle(color: Color(0xFF58C6A9)), // Change button text color
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context).pop(true); // Close the dialog
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: const Text(
                                                      'Confirm',
                                                      style: TextStyle(color: Color(0xFF58C6A9)), // Change button text color
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context).pop(true); // Close the confirmation dialog
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return AlertDialog(
                                                            backgroundColor: const Color(0xFF35344A), // Change dialog background color
                                                            title: const Text(
                                                              'Success!',
                                                              style: TextStyle(color: Colors.white), // Change title text color
                                                            ),
                                                            content: const Text(
                                                              'Coupon Cancelled Successfully.',
                                                              style: TextStyle(color: Colors.white), // Change content text color
                                                            ),
                                                            actions: <Widget>[
                                                              Center(
                                                                child: TextButton(
                                                                  child: const Text(
                                                                    'OK',
                                                                    style: TextStyle(color: Color(0xFF58C6A9)), // Change button text color
                                                                  ),
                                                                  onPressed: () {
                                                                    Navigator.of(context).pop(true); // Close the success dialog
                                                                    setState(() {
                                                                      _appliedCouponIndices.remove(index);
                                                                      coupons[index]['applied'] = false;
                                                                    });
                                                                    // Update Firestore
                                                                    FirebaseFirestore.instance.collection('coupons').doc(coupon['id']).update({
                                                                      'applied': false,
                                                                    });
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(40.0),
                                            side: const BorderSide(color: Colors.white),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 0,
                                          ),
                                          backgroundColor: const Color(0xFF35344A),
                                        ),
                                        child: const Text(
                                          'Cancel',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF2A4037),
                borderRadius: BorderRadius.circular(80),
              ),
              padding: const EdgeInsets.all(25),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Invite your friend to get the coupon',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            // Handle invite action
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 0,
                            ),
                            backgroundColor: const Color(0xFF58C6A9),
                          ),
                          child: const Text(
                            'Start Invite',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.local_activity,
                    color: Color(0xFF58C6A9),
                    size: 40,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}