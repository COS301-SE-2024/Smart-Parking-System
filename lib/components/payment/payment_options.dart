import 'package:flutter/material.dart';
import 'package:smart_parking_system/components/payment/offers.dart';

class PaymentMethodPage extends StatefulWidget {
  const PaymentMethodPage({super.key});

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  int _selectedCard = 1;
  // int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF35344A),
      body: Padding(
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
                    // Add your onPressed logic here
                  },
                  icon: const Icon(Icons.menu,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const Text(
                  'Payment Method',
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
              child: Text(
                'Credit',
                style: TextStyle(
                  fontSize: 28, 
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF58C6A9),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF35344A),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Row(
                    children: [
                      Icon(Icons.account_balance_wallet, color: Colors.white),
                      SizedBox(width: 20),
                      Text('ZAR 60.00', 
                        style: TextStyle(
                          fontSize: 25, 
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF58C6A9),  
                        )
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GestureDetector(
                      onTap: () {
                        // Insert here what Top Up does
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.add,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(width: 10),
                          Text('Top Up',
                            style: TextStyle(
                              color: Colors.white
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.local_activity, color: Color(0xFF58C6A9)), 
              title: const Text('Offers', style: TextStyle(color: Colors.white)),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const OfferPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'Credits & Debit Cards',
                style: TextStyle(
                  fontSize: 28, 
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF58C6A9),
                ),
              ),
            ),
            
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF35344A),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Card(
                    elevation: 0, // Set elevation to 0
                    color: Colors.transparent, // Set color to transparent
                    child: ListTile(
                      leading: SizedBox(
                        width: 50, // Set the desired width of the image
                        child: Image.asset('assets/mastercard.png'),
                      ),
                      title: const Text(
                        'FNB Bank **** **** **** 8395',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      trailing: Radio(
                        value: 1,
                        groupValue: _selectedCard,
                        onChanged: (value) {
                          setState(() {
                            _selectedCard = value as int;
                          });
                        },
                        activeColor: const Color(0xFF58C6A9), // Set the color here
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 0, // Set elevation to 0
                    color: Colors.transparent, // Set color to transparent
                    child: ListTile(
                      leading: SizedBox(
                        width: 50, // Set the desired width of the image
                        child: Image.asset('assets/visa.png'),
                      ),
                      title: const Text(
                        'Capitec Bank **** **** **** 6246',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      trailing: Radio(
                        value: 2,
                        groupValue: _selectedCard,
                        onChanged: (value) {
                          setState(() {
                            _selectedCard = value as int;
                          });
                        },
                        activeColor: const Color(0xFF58C6A9), // Set the color here
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GestureDetector(
                      onTap: () {
                        // Insert here what Top Up does
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.add,
                            color: Color(0xFF58C6A9),
                          ),
                          SizedBox(width: 10),
                          Text('Add New Card',
                            style: TextStyle(
                              color: Color(0xFF58C6A9)
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      // bottomNavigationBar: Container(
      //   decoration: BoxDecoration(
      //     color: const Color(0xFF2C2C54),
      //     boxShadow: [
      //       BoxShadow(
      //         color: Colors.black.withOpacity(0.6),
      //         spreadRadius: 1,
      //         blurRadius: 8,
      //         offset: const Offset(0, -3),
      //       ),
      //     ],
      //   ),
      //   child: BottomNavigationBar(
      //     backgroundColor: const Color(0xFF2C2C54), // To ensure the Container color is visible
      //     currentIndex: _selectedIndex,
      //     items: const [
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.home, size: 30),
      //         label: '',
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.account_balance_wallet, size: 30),
      //         label: '',
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.history, size: 30),
      //         label: '',
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.settings, size: 30),
      //         label: '',
      //       ),
      //     ],
      //     onTap: (index) {
      //       setState(() {
      //         _selectedIndex = index;
      //       });
      //     },
      //     selectedItemColor: const Color(0xFF58C6A9),
      //     unselectedItemColor: Colors.grey,
      //     showUnselectedLabels: false,
      //     showSelectedLabels: false,
      //   ),
      // ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   backgroundColor: const Color(0xFF58C6A9),
      //   shape: const CircleBorder(),
      //   child: const Icon(
      //     Icons.send,
      //     color: Colors.white,
      //   ), 
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
