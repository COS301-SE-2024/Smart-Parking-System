import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontSize: 40,
            fontWeight: FontWeight.w700,
          ),
        ),
        Row(
          children: [
            Image.network(
              'https://cdn.builder.io/api/v1/image/assets/TEMP/53f40adde10f33178f0187c779a02cdedbabf943dd3b28bddaad895417316a8e?placeholderIfAbsent=true&apiKey=109e5ef2921f4f19976eeca47438f346',
              width: 19,
              height: 16,
            ),
            const SizedBox(width: 8),
            const Text(
              '23 - 30 March 2024',
              style: TextStyle(
                color: Color(0xFFA0AEC0),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}