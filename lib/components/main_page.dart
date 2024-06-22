// import 'package:flutter/material.dart';
// import 'package:smart_parking_system/components/sidebar.dart'; 
// class MainPage extends StatefulWidget {
//   MainPage({Key? key}) : super(key: key);

//   @override
//   State<MainPage> createState() => _MainPageState();
// }

// class _MainPageState extends State<MainPage> {
//   late FocusNode _focusNode;
//   bool _isModalVisible = false;

//   @override
//   void initState() {
//     super.initState();
//     _focusNode = FocusNode();
//     _focusNode.addListener(() {
//       setState(() {
//         _isModalVisible = _focusNode.hasFocus;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _focusNode.dispose();
//     super.dispose();
//   }

//   void _showParkingInfo(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       builder: (context) {
//         return GestureDetector(
//           onTap: () {}, // Consume tap events to prevent dismissing the modal
//           child: ClipRRect(
//             borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
//             child: Stack(
//               children: [
//                 Positioned(
//                   bottom: MediaQuery.of(context).viewInsets.bottom + 170,
//                   left: 20,
//                   right: 20,
//                   child: Container(
//                     decoration: const BoxDecoration(
//                       color: Color(0xFF35344A),
//                       borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
//                     ),
//                     padding: const EdgeInsets.all(16.0),
//                     child: const Column(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Row(
//                           children: [
//                             Text(
//                               'R20',
//                               style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
//                             ),
//                             SizedBox(width: 5),
//                             Text(
//                               '/Hr',
//                               style: TextStyle(color: Colors.white, fontSize: 18),
//                             ),
//                             Spacer(),
//                             Text(
//                               'Sandton City Park A',
//                               style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 10),
//                         Divider(color: Colors.white54),
//                         SizedBox(height: 10),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: <Widget>[
//                             Text(
//                               'Spaces Available:',
//                               style: TextStyle(color: Colors.white, fontSize: 16),
//                             ),
//                             Text(
//                               '5 slots',
//                               style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 5),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: <Widget>[
//                             Text(
//                               'Distance to Venue:',
//                               style: TextStyle(color: Colors.white, fontSize: 16),
//                             ),
//                             Text(
//                               '3 mins drive',
//                               style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   bottom: MediaQuery.of(context).viewInsets.bottom + 100,
//                   left: 0,
//                   right: 0,
//                   child: Center(
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF58C6A9),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(30.0),
//                         ),
//                         padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//                       ),
//                       child: const Text('View Car Park', style: TextStyle(fontSize: 16, color: Colors.white)),
//                       onPressed: () {
//                         Navigator.pop(context); // Close the bottom sheet
//                       },
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: Container(
//           margin: const EdgeInsets.only(top: 20.0),
//           child: Builder(
//             builder: (BuildContext context) {
//               return IconButton(
//                 icon: const Icon(Icons.menu, color: Colors.black, size: 30.0),
//                 onPressed: () {
//                   Scaffold.of(context).openDrawer(); // Open the drawer
//                 },
//               );
//             },
//           ),
//         ),
//       ),
//       body: Stack(
//         children: <Widget>[
//           Container(
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('../assets/map.webp'),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           Positioned(
//             top: 80.0,
//             left: 20.0,
//             right: 20.0,
//             child: Column(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                   height: 50.0,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF35344A),
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   child: Center(
//                     child: TextField(
//                       focusNode: _focusNode,
//                       decoration: const InputDecoration(
//                         hintText: 'Where are you going?',
//                         border: InputBorder.none,
//                         hintStyle: TextStyle(color: Colors.white),
//                       ),
//                       style: const TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ),
//                 Visibility(
//                   visible: _isModalVisible,
//                   child: Container(
//                     margin: const EdgeInsets.only(top: 5.0),
//                     padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFF35344A),
//                       borderRadius: BorderRadius.circular(10.0),
//                     ),
//                     child: Column(
//                       children: [
//                         ListTile(
//                           leading: const Icon(Icons.location_on, color: Colors.white),
//                           title: const Text(
//                             '',
//                             style: TextStyle(color: Colors.white, fontSize: 16),
//                           ),
//                           trailing: IconButton(
//                             icon: const Icon(Icons.close, color: Colors.white),
//                             onPressed: () {
//                               setState(() {
//                                 _isModalVisible = false;
//                                 _focusNode.unfocus();
//                               });
//                             },
//                           ),
//                         ),
//                         const Divider(color: Colors.white),
//                         GestureDetector(
//                           onTap: () {
//                             _showParkingInfo(context); // Ensure 'context' here is correct
//                           },
//                           child: ListTile(
//                             leading: const Icon(Icons.circle, color: Colors.white, size: 12),
//                             title: const Text(
//                               'Sandton City, Johannesburg, South Africa',
//                               style: TextStyle(color: Colors.white, fontSize: 14),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Positioned(
//             left: 0,
//             right: 0,
//             bottom: 0,
//             child: Container(
//               height: 54,
//               decoration: BoxDecoration(
//                 image: const DecorationImage(
//                   image: AssetImage('../assets/navabr.png'),
//                   fit: BoxFit.cover,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.06),
//                     spreadRadius: 0,
//                     blurRadius: 14,
//                     offset: const Offset(0, -4),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: <Widget>[
//                   Container(
//                     width: 50,
//                     height: 50,
//                     decoration: const BoxDecoration(
//                       shape: BoxShape.circle,
//                       image: DecorationImage(
//                         image: AssetImage('../assets/home.png'),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                   Container(
//                     width: 50,
//                     height: 50,
//                     decoration: const BoxDecoration(
//                       shape: BoxShape.circle,
//                       image: DecorationImage(
//                         image: AssetImage('../assets/wallet.png'),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 60),
//                   Container(
//                     width: 50,
//                     height: 50,
//                     decoration: const BoxDecoration(
//                       shape: BoxShape.circle,
//                       image: DecorationImage(
//                         image: AssetImage('../assets/history.png'),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                   Container(
//                     width: 50,
//                     height: 50,
//                     decoration: const BoxDecoration(
//                       shape: BoxShape.circle,
//                       image: DecorationImage(
//                         image: AssetImage('../assets/settings.png'),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: 40,
//             left: MediaQuery.of(context).size.width / 2 - 28,
//             child: GestureDetector(
//               onTap: () {},
//               child: Container(
//                 width: 56,
//                 height: 56,
//                 decoration: const BoxDecoration(
//                   shape: BoxShape.circle,
//                   image: DecorationImage(
//                     image: AssetImage('../assets/map.png'),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       drawer: SideMenu(), // Add your drawer here
//     );
//   }
// }

// void main() {
//   runApp(MaterialApp(
//     home: MainPage(),
//   ));
// }
import 'package:flutter/material.dart';
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
                    Navigator.pop(context);
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
                          trailing: IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () {
                              setState(() {
                                _isModalVisible = false;
                              });
                            },
                          ),
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