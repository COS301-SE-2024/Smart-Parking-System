import 'package:flutter/material.dart';
import 'package:smart_parking_system/components/bookings/make_booking.dart';
import 'package:smart_parking_system/components/sidebar.dart';
import 'package:smart_parking_system/components/payment/payment_options.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool _isModalVisible = false;
  int _selectedIndex = 0;
  

  @override
  void initState() {
    super.initState();
  }

  void _showParkingInfo() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20.0),
          decoration: const BoxDecoration(
            color: Color(0xFF35344A),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'R20 /Hr',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Sandton City Park A',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(
                  color: Color.fromARGB(255, 199, 199, 199), // Color of the lines
                  thickness: 1, // Thickness of the lines
              ),
              
              const SizedBox(height: 10),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Spaces Available :',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '5 slots',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Distance to Venue : ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '3 mins drive',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => const BookingPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF58C6A9),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: const Text(
                    'View Parking',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );

      },
    );
  }

  @override
   Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.only(top: 20.0),
          child: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu, color: Colors.black, size: 30.0),
                onPressed: () {
                  Scaffold.of(context).openDrawer(); // Open the drawer
                },
              );
            },
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/map.webp'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 80.0,
            left: 20.0,
            right: 20.0,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: const Color(0xFF35344A),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(

                    child: TextField(  
                      onTap: () {
                        setState(() {
                          _isModalVisible = true;
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: 'Where are you going?',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),

                
                
                Visibility(
                  visible: _isModalVisible,
                  child: Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFF35344A),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.location_on, color: Colors.white),
                          title: const Text('',
                              style: TextStyle(color: Colors.white, fontSize: 16)),
                          trailing: IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () {
                              setState(() {
                                _isModalVisible = false;
                              });
                            },
                          ),
                        ),
                        const Divider(color: Colors.white),
                        ListTile(
                          leading: const Icon(Icons.circle, color: Colors.white, size: 12),
                          title: const Text(
                            'Sandton City, Johannesburg, South Africa',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          onTap: () {
                            setState(() {
                                _isModalVisible = false;
                                _showParkingInfo();
                              });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),                
        ],
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

              } else if(_selectedIndex == 3){
              
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

void main() {
  runApp(const MaterialApp(
    home: MainPage(),
  ));
}