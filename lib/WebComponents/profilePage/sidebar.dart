import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF1A1F37),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(27.0),
            child: Image.network(
              'https://cdn.builder.io/api/v1/image/assets/TEMP/19f28bdda1b8eddb4510581c4a28f215f5cb05e9913f7351144e92620ab76d00?placeholderIfAbsent=true&apiKey=109e5ef2921f4f19976eeca47438f346',
              width: 197,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 53),
          _buildMenuItem('Dashboard', 'https://cdn.builder.io/api/v1/image/assets/TEMP/b3fd3a550b50ebc19fe596a81e069291d7a8e367ea7cdd0f46dfd7eaa46c6449?placeholderIfAbsent=true&apiKey=109e5ef2921f4f19976eeca47438f346'),
          const SizedBox(height: 30),
          const Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Text(
              'ACCOUNT PAGES',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                fontFamily: 'Roboto',
              ),
            ),
          ),
          SizedBox(height: 27),
          _buildExpandedMenuItem('Profile', 'https://cdn.builder.io/api/v1/image/assets/TEMP/68718f444accf9babdd692e1aecd79c296ebb48ea6a17ead645cb546155c9077?placeholderIfAbsent=true&apiKey=109e5ef2921f4f19976eeca47438f346'),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String title, String iconUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Image.network(
            iconUrl,
            width: 30,
            height: 30,
            fit: BoxFit.contain,
          ),
          SizedBox(width: 15),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              fontFamily: 'Roboto',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedMenuItem(String title, String iconUrl) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F37),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.network(
                iconUrl,
                width: 30,
                height: 30,
                fit: BoxFit.contain,
              ),
              SizedBox(width: 15),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Roboto',
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          const Text(
            'Parking Layout',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              fontFamily: 'Roboto',
            ),
          ),
          SizedBox(height: 8),
          const Text(
            'Parking Rate',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              fontFamily: 'Roboto',
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Help',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              fontFamily: 'Roboto',
            ),
          ),
        ],
      ),
    );
  }
}