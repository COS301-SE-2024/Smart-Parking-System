import 'package:flutter/material.dart';

class Paymentshelp extends StatelessWidget {
  const Paymentshelp({super.key});

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
                        'Payment questions',
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
              'How do I add a new card ',
              [],
              [
                '1   Open "Payment methods page via the side bar',
                '2   Click on "Add a new card"'
              ],
            ),
            _buildQuestionBlock(
              context,
              'How do I apply a coupon upon payment',
              [],
              [
                'When directed to the payments method page upon booking, click on "Offers" and then choose the relevant coupon to apply'
              ],
            ),
            _buildQuestionBlock(
              context,
              'How do I top up on credit',
              [],
              [
                '1   Open "Payment methods page via the side bar',
                '2   Click on "Top up"',
                '3   Enter the amount you wish to top up'
              ],
            ),
            // Add more question blocks as needed
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
                overflow: TextOverflow.visible, // Ensure text doesn't overflow horizontally
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
                  height: 250, // Adjust height as needed
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: imagePaths.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 140, // Adjust width as needed
                          ),
                          child: Image.asset(
                            imagePaths[index],
                            fit: BoxFit.contain, // Ensure images fit without being cut off
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
