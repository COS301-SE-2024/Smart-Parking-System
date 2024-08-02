import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  double creditAmount = 60.00; // Changed to double for calculation
  List<Map<String, String>> cards = [];

  @override
  void initState() {
    super.initState();
    _fetchCards();
  }

  Future<void> _fetchCards() async {
    String userId = "lhfXz2ynvue4ZOQJ5XQ9QT6oghu1"; // 替换为实际的用户 ID

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('cards')
          .where('userId', isEqualTo: userId)
          .get();

      final List<Map<String, String>> fetchedCards = [];
      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        fetchedCards.add({
          'id': doc.id,
          'bank': 'Unknown Bank', // You can add logic to fetch the bank name if needed
          // ignore: prefer_interpolation_to_compose_strings
          'number': '**** **** **** ' + (data['cardNumber']?.substring(data['cardNumber'].length - 4) ?? '0000'),
          'cvv': data['cvv'] ?? '',
          'name': data['holderName'] ?? '',
          'expiry': data['expiry'] ?? '',
          'image': 'assets/mastercard.png' // 默认图片，您可以根据实际情况进行修改
        });
      }

      setState(() {
        cards = fetchedCards;
      });
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching cards: $e');
      // 这里可以添加更多错误处理逻辑
    }
  }

  Future<void> _showTopUpDialog() async {
    double? topUpAmount;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF35344A),
          title: const Text('Top Up', style: TextStyle(color: Colors.white)),
          content: TextField(
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Enter amount',
              hintStyle: TextStyle(color: Colors.grey),
            ),
            onChanged: (value) {
              topUpAmount = double.tryParse(value);
            },
          ),
          actions: [
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.tealAccent)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Top Up', style: TextStyle(color: Colors.tealAccent)),
              onPressed: () {
                if (topUpAmount != null && topUpAmount! > 0) {
                  setState(() {
                    creditAmount += topUpAmount!;
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showEditCardDialog(String cardId) async {
    String? newCardNumber;
    String? newCvv;
    String? newName;
    String? newExpiry;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF35344A),
          title: const Text('Edit Card', style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Enter new card number',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                onChanged: (value) {
                  newCardNumber = value;
                },
              ),
              const SizedBox(height: 10),
              TextField(
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Enter new CVV',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                onChanged: (value) {
                  newCvv = value;
                },
              ),
              const SizedBox(height: 10),
              TextField(
                keyboardType: TextInputType.text,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Enter new name',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                onChanged: (value) {
                  newName = value;
                },
              ),
              const SizedBox(height: 10),
              TextField(
                keyboardType: TextInputType.text,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Enter new expiry (MM/YY)',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                onChanged: (value) {
                  newExpiry = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.tealAccent)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save', style: TextStyle(color: Colors.tealAccent)),
              onPressed: () async {
                if (newCardNumber != null && newCardNumber!.isNotEmpty) {
                  Map<String, String> updatedData = {
                    'cardNumber': newCardNumber!,
                    if (newCvv != null && newCvv!.isNotEmpty) 'cvv': newCvv!,
                    if (newName != null && newName!.isNotEmpty) 'holderName': newName!,
                    if (newExpiry != null && newExpiry!.isNotEmpty) 'expiry': newExpiry!,
                  };

                  await FirebaseFirestore.instance
                      .collection('cards')
                      .doc(cardId)
                      .update(updatedData);

                  await _fetchCards();
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

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
                    Row(
                      children: [
                        const Icon(Icons.account_balance_wallet, color: Colors.white),
                        const SizedBox(width: 20),
                        Text(
                          'ZAR ${creditAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF58C6A9),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ElevatedButton(
                        onPressed: _showTopUpDialog,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black, backgroundColor: Colors.tealAccent,
                        ),
                        child: const Text('Top Up'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
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
                    for (var card in cards)
                      Column(
                        children: [
                          Card(
                            elevation: 0, // Set elevation to 0
                            color: Colors.transparent, // Set color to transparent
                            child: ListTile(
                              leading: SizedBox(
                                width: 50, // Set the desired width of the image
                                child: Image.asset(card['image']!),
                              ),
                              title: Text(
                                '${card['bank']}\n${card['number']}\n${card['name']}\n${card['expiry']}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                              trailing: TextButton(
                                onPressed: () {
                                  _showEditCardDialog(card['id']!);
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
                        ],
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
                            const Icon(
                              Icons.add,
                              color: Color(0xFF58C6A9),
                            ),
                            const SizedBox(width: 10),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const AddCardPage(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Add New Card',
                                style: TextStyle(color: Color(0xFF58C6A9)),
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
          canvasColor: const Color(0xFF35344A),
        ),
        child: Container(
          decoration: BoxDecoration(
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

                if (_selectedIndex == 0) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const MainPage(),
                    ),
                  );
                } else if (_selectedIndex == 1) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const PaymentMethodPage(),
                    ),
                  );
                } else if (_selectedIndex == 2) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ParkingHistoryPage(),
                    ),
                  );
                } else if (_selectedIndex == 3) {
                  Navigator.of(context).push(
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
