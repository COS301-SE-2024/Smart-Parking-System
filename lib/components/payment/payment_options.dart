import 'package:flutter/material.dart';
import 'package:smart_parking_system/components/card/add_card.dart';
import 'package:smart_parking_system/components/main_page.dart';
import 'package:smart_parking_system/components/parking/parking_history.dart';
import 'package:smart_parking_system/components/settings/settings.dart';
import 'package:smart_parking_system/components/sidebar.dart';

class PaymentMethodPage extends StatefulWidget {
  const PaymentMethodPage({super.key});

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF35344A),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 15),
              color: const Color(0xFF35344A),
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
                      'Payment Options',
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
            const SizedBox(height: 10),
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
            const SizedBox(height: 40),
            // ListTile(
            //   leading: const Icon(Icons.local_activity, color: Color(0xFF58C6A9)), 
            //   title: const Text('Offers', style: TextStyle(color: Colors.white)),
            //   trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
            //   onTap: () {
            //     Navigator.of(context).pushReplacement(
            //       MaterialPageRoute(
            //         builder: (context) => const OfferPage(),
            //       ),
            //     );
            //   },
            // ),
            // const SizedBox(height: 20),
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
                        'FNB Bank\n**** **** **** 8395',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      trailing: TextButton(
                        onPressed: () {
                          // Add your onPressed logic here for editing the card
                        },
                        child: const Text(
                          'Edit Card',
                          style: TextStyle(
                            color: Color(0xFF58C6A9),
                          ),
                        ),
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
                        'Capitec Bank\n**** **** **** 6246',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      trailing: TextButton(
                        onPressed: () {
                          // Add your onPressed logic here for editing the card
                          
                        },
                        child: const Text(
                          'Edit Card',
                          style: TextStyle(
                            color: Color(0xFF58C6A9),
                          ),
                        ),
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
                      child: Row(
                        children: [
                          const Icon(Icons.add,
                            color: Color(0xFF58C6A9),
                          ),
                          const SizedBox(width: 10),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => const AddCardPage(),
                                ),
                              );
                            },
                            child: const Text(
                            'Add New Card',
                            style: TextStyle(
                              color: Color(0xFF58C6A9)
                            ),
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
          selectedItemColor: const Color(0xFF58C6A9),
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
}

class CustomCenterDockedFABLocation extends FloatingActionButtonLocation {
  final double offset;

  CustomCenterDockedFABLocation(this.offset);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    // Position the FAB slightly higher than centerDocked
    final double fabX = (scaffoldGeometry.scaffoldSize.width / 2) -
        (scaffoldGeometry.floatingActionButtonSize.width / 2);
    final double fabY = scaffoldGeometry.scaffoldSize.height -
        scaffoldGeometry.bottomSheetSize.height -
        scaffoldGeometry.snackBarSize.height -
        (scaffoldGeometry.floatingActionButtonSize.height / 2) - 
        offset;
    return Offset(fabX, fabY);
  }
}