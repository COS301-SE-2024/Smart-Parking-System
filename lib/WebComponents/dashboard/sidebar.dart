import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: const Color(0xFF1A1F37),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Image.network(
              'https://cdn.builder.io/api/v1/image/assets/TEMP/19f28bdda1b8eddb4510581c4a28f215f5cb05e9913f7351144e92620ab76d00?placeholderIfAbsent=true&apiKey=109e5ef2921f4f19976eeca47438f346',
              width: 197,
              fit: BoxFit.contain,
            ),
          ),
          Image.network(
            'https://cdn.builder.io/api/v1/image/assets/TEMP/0c0767ed110113d31ba793b3f79ee5dbfcf8cdca4ea01ccf1c437fc1a3abab6b?placeholderIfAbsent=true&apiKey=109e5ef2921f4f19976eeca47438f346',
            width: double.infinity,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 34),
          _buildMenuItem('Dashboard', 'https://cdn.builder.io/api/v1/image/assets/TEMP/89449ae15f2084058eb80aca52c1aa06c1192b07fea95c0a50f695a5ca8a64b7?placeholderIfAbsent=true&apiKey=109e5ef2921f4f19976eeca47438f346', isSelected: true),
          _buildMenuItem('Parking Fees', null),
          _buildMenuItem('Invoices', null),
          _buildMenuItem('Booking Details', null),
          const SizedBox(height: 27),
          const Padding(
            padding: EdgeInsets.only(left: 29.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'ACCOUNT PAGES',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 27),
          _buildMenuItem('Profile', 'https://cdn.builder.io/api/v1/image/assets/TEMP/4bae99e06fc3c1bcfac582c9d802660da95637fca64251c1f76e17e61c09db52?placeholderIfAbsent=true&apiKey=109e5ef2921f4f19976eeca47438f346'),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String title, String? iconUrl, {bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          if (iconUrl != null)
            Image.network(
              iconUrl,
              width: 30,
              height: 30,
              fit: BoxFit.contain,
            ),
          const SizedBox(width: 15),
          Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.8),
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}