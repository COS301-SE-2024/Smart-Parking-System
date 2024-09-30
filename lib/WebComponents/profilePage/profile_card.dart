import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileCard extends StatefulWidget {
  const ProfileCard({super.key});

  @override
  // _ProfileCardState createState() => _ProfileCardState();
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  String fullName = '';
  String email = '';
  String address = 'Loading...'; // Initial placeholder text

  @override
  void initState() {
    super.initState();
    _loadClientData();
  }

  Future<void> _loadClientData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    var document = FirebaseFirestore.instance.collection('clients').doc(currentUser!.uid);
    var snapshot = await document.get();
    if (snapshot.exists) {
      setState(() {
        fullName = snapshot.data()?['accountHolder'] ?? 'N/A';
        email = snapshot.data()?['email'] ?? 'N/A';
        address = snapshot.data()?['company'] ?? 'N/A';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F37),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 112.5,
            backgroundImage: AssetImage('assets/logo1.png'),
          ),
          const SizedBox(height: 69),
          Text(
            address,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              fontFamily: 'Roboto',
            ),
          ),
          const SizedBox(height: 34),
          const SizedBox(height: 33),
          Text(
            fullName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              fontFamily: 'Roboto',
            ),
          ),
          const SizedBox(height: 71),
          Text(
            email,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              fontFamily: 'Roboto',
            ),
          ),
          const SizedBox(height: 73),
        ],
      ),
    );
  }
}
