import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF23223A),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 112.5,
            backgroundImage: NetworkImage('https://cdn.builder.io/api/v1/image/assets/TEMP/82dc3a69dcf46cd825727ce87572e42325f569c3cbe3680d98e1c0c5f86bcc51?placeholderIfAbsent=true&apiKey=109e5ef2921f4f19976eeca47438f346'),
          ),
          SizedBox(height: 69),
          Text(
            'Sandton City Parking',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              fontFamily: 'Roboto',
            ),
          ),
          SizedBox(height: 34),
          Text(
            'Sandton City, 83 Rivonia Rd, Sandhurst, Sandton, 2196',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
              fontFamily: 'Roboto',
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 33),
          Image.network(
            'https://cdn.builder.io/api/v1/image/assets/TEMP/4f37c4fa9d2d8ca66025bb6d74a05cd6661b7a819b8c280e187d504da7555079?placeholderIfAbsent=true&apiKey=109e5ef2921f4f19976eeca47438f346',
            width: double.infinity,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 47),
          Text(
            'James Smith',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              fontFamily: 'Roboto',
            ),
          ),
          SizedBox(height: 21),
          Text(
            'sandtonParking@gmail.com',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              fontFamily: 'Roboto',
            ),
          ),
          SizedBox(height: 53),
          Image.network(
            'https://cdn.builder.io/api/v1/image/assets/TEMP/ba6f4da98288183439928ddb1ca24a505d93c7ace04c037cb20a0fde510014a1?placeholderIfAbsent=true&apiKey=109e5ef2921f4f19976eeca47438f346',
            width: double.infinity,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 357),
          Text(
            'Next billing:\n\n1 October 2024',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              fontFamily: 'Roboto',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}