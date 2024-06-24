import 'package:flutter/material.dart';
import 'package:smart_parking_system/components/main_page.dart';
import 'package:smart_parking_system/components/parking/parking_history.dart';
import 'package:smart_parking_system/components/payment/payment_options.dart';
import 'package:smart_parking_system/components/settings/settings.dart';
import 'package:smart_parking_system/components/sidebar.dart';


class SupportApp extends StatefulWidget {
  const SupportApp({super.key});

  @override
  State<SupportApp> createState() => _SupportAppState();
}

class _SupportAppState extends State<SupportApp> {
  int _selectedIndex = 1;

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
                        icon: const Icon(Icons.menu, color: Colors.white, size: 30.0),
                        onPressed: () {
                          Scaffold.of(context).openDrawer(); // Open the drawer
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
                      label2: 'Booking',
                      color: const Color(0xFF0D6EFD),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: _buildCategoryCard(
                      imagePath: 'assets/how_to_invest.png',
                      label1: 'Questions about',
                      label2: 'Payment',
                      color: const Color(0xFF28A745),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: _buildCategoryCard(
                      imagePath: 'assets/payment.png',
                      label1: 'Questions about',
                      label2: 'Account',
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
                    question: 'How to add card payment?',
                    answer: 'Navigate to the payment option page by clicking on the "wallet" icon and enter your card details',
                    isExpanded: true,
                  ),
                  _buildQuestionCard(
                    question: 'How do I edit card information?',
                    answer: 'On the payment options page, click on the edit card button and enter your new card details',
                  ),
                  _buildQuestionCard(
                    question: 'How do I see my previous parking sessions',
                    answer: 'Navigate to the parking history page by clicking on the "time" icon and view your previous parking sessions',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: const Color(0xFF35344A),),
        child: Container(
        decoration: BoxDecoration(
          // color: const Color(0xFF2C2C54),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed, 
          backgroundColor: const Color(0xFF35344A), // To ensure the Container color is visible
          currentIndex: _selectedIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, size: 30),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.wallet, size: 30),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history, size: 30),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined, size: 30),
              label: '',
            ),
          ],
          onTap: (index) {
            setState(() {
              _selectedIndex = index;

              if(_selectedIndex == 0){
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const MainPage(),
                  ),
                );
              } else if(_selectedIndex == 1){
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const PaymentMethodPage(),
                  ),
                );
              } else if(_selectedIndex == 2){
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const ParkingHistoryPage(),
                  ),
                );
              } else if(_selectedIndex == 3){
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const SettingsPage(),
                  ),
                );
              }
            });
          },
          selectedItemColor: Colors.grey,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: false,
          showSelectedLabels: false,
        ),
      ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF58C6A9),
        shape: const CircleBorder(),
        child: const Icon(
          Icons.near_me,
          color: Colors.white,
        ), 
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      drawer: const SideMenu(),
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
