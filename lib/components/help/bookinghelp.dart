import 'package:flutter/material.dart';

class Bookinghelp extends StatelessWidget {
  const Bookinghelp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          backgroundColor: const Color(0xFF2D2F41),
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(true),
                      ),
                      const Text(
                        'Booking questions',
                        style: TextStyle(
                          color: Color(0xFF5CEAD8),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 48), // To balance the layout
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        color: const Color(0xFF2D2F41),
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _buildQuestionBlock(
              context,
              'How do I make a booking',
              [
                'assets/help1.png',
                'assets/help2.png',
                'assets/help3.png',
                'assets/help4.png',
                'assets/help5.png',
                'assets/help6.png',
                'assets/help7.png',
                'assets/help8.png',

              ],
              [
                '1   Navigate to home page',
                '2   Enter a location',
                '3   Pick a parking zone',
                '4   Pick a parking floor',
                '5   Pick a row',
                '6   Confirm booking',
                '7   Confirm car',
                '8   Confirm payment method',
              ],
            ),
            _buildQuestionBlock(
              context,
              'How do I check my booking',
              [],
              [
                'You can view your current and past bookings by navigating to the booking history page',
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionBlock(BuildContext context, String title, List<String> imagePaths, List<String> instructions) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF404051),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ExpansionTile(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.help_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                overflow: TextOverflow.visible, 
              ),
            ),
          ],
        ),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Conditionally display the image section if there are images
              if (imagePaths.isNotEmpty) ...[
                SizedBox(
                  height: 250, 
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: imagePaths.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 140, 
                          ),
                          child: Image.asset(
                            imagePaths[index],
                            fit: BoxFit.contain, 
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: instructions
                      .map((instruction) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              instruction,
                              style: const TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
