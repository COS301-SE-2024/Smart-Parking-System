import 'package:flutter/material.dart';
import 'package:smart_parking_system/components/main_page.dart';

void main() {
  runApp(const SupportApp());
}

class SupportApp extends StatelessWidget {
  const SupportApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SupportPage(),
    );
  }
}

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF2D2F41),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           Container(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 15),
              color: const Color(0xFF2D2F41),
              child: Stack(
                children: [
                  Builder(
                    builder: (BuildContext context) {
                      return IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 30.0),
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const MainPage(),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Support',
                      style: TextStyle(
                        color: Colors.tealAccent,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Text(
              'How can we help you?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter your keyword',
                filled: true,
                fillColor: const Color(0xFF404051),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: _buildCategoryCard(
                      imagePath: 'assets/getting_started.png',
                      label1: 'Questions about',
                      label2: 'Getting Started',
                      color: const Color(0xFF0D6EFD),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: _buildCategoryCard(
                      imagePath: 'assets/how_to_invest.png',
                      label1: 'Questions about',
                      label2: 'How to Invest',
                      color: const Color(0xFF28A745),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: _buildCategoryCard(
                      imagePath: 'assets/payment.png',
                      label1: 'Questions about',
                      label2: 'Payments',
                      color: const Color(0xFFDC3545),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionCard(
                    question: 'How to create a account?',
                    answer: 'Open the app to get started and follow the steps, blablablablablablablsdasdasdasdasdasdasdas.',
                    isExpanded: true,
                  ),
                  _buildQuestionCard(
                    question: 'How to add a payment method by this app?',
                    answer: 'To add a payment method, go to settings and follow the instructions.',
                  ),
                  _buildQuestionCard(
                    question: 'What Time Does The Stock Market Open?',
                    answer: 'The stock market opens at 9:30 AM EST.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard({required String imagePath, required String label1, required String label2, required Color color}) {
    return Container(
      width: 150,
      height: 110,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              imagePath,
              width: 40, // Adjust the size of the icon
              height: 40,
              alignment: Alignment.centerLeft,
            ),
            Text(
              label1,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
              textAlign: TextAlign.left,
            ),
            Text(
              label2,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard({required String question, required String answer, bool isExpanded = false}) {
    return Card(
      color: const Color(0xFF404051),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(color: Colors.white),
        ),
        initiallyExpanded: isExpanded,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              answer,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
