import 'package:flutter/material.dart';
import 'package:smart_parking_system/components/main_page.dart';
import 'package:smart_parking_system/components/parking/parking_history.dart';
import 'package:smart_parking_system/components/payment/payment_options.dart';
import 'package:smart_parking_system/components/settings/settings.dart';
import 'package:smart_parking_system/components/sidebar.dart';

class PromotionCode extends StatefulWidget {
  const PromotionCode({super.key});

  @override
  State<PromotionCode> createState() => _OfferPageState();
}

class _OfferPageState extends State<PromotionCode> {
  int _selectedIndex = 0;
  
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
                const Text(
                  'Promotion Codes',
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
                'The Available Coupon',
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
              child: Padding( 
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 1),
                    child: Icon(
                      Icons.local_activity,
                      color: Color(0xFF58C6A9),
                      size: 40,
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Text and Button Column
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ZAR 40 Off',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20
                        ),
                      ),
                      const SizedBox(height: 3),
                      const Text(
                        'Get R40 off your next booking',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w300
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 0,
                          ),
                          backgroundColor: const Color(0xFF58C6A9),
                        ),
                        child: const Text(
                          'Apply',
                          style: TextStyle(
                            fontSize: 15, 
                            color: Colors.white, 
                            fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF2A4037),
                borderRadius: BorderRadius.circular(80),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.white.withOpacity(0.2),
                //     spreadRadius: 1,
                //     blurRadius: 8,
                //     offset: const Offset(0, 3), // changes position of shadow
                //   ),
                // ],
              ),
              padding: const EdgeInsets.all(25),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Invite your friend to get the coupon',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 0,
                            ),
                            backgroundColor: const Color(0xFF58C6A9),
                          ),
                          child: const Text(
                            'Start Invite',
                            style: TextStyle(
                              fontSize: 15, 
                              color: Colors.white, 
                              fontWeight: FontWeight.w500
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.local_activity,
                    color: Color(0xFF58C6A9),
                    size: 40,
                  ),
                ],
              ),
            )

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
}
