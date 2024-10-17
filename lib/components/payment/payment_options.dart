import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_parking_system/components/common/common_functions.dart';
import 'package:smart_parking_system/components/common/custom_widgets.dart';
import 'package:smart_parking_system/components/common/toast.dart';
import 'package:smart_parking_system/components/payment/add_card.dart';
import 'package:smart_parking_system/components/home/main_page.dart';
import 'package:smart_parking_system/components/parking/parking_history.dart';
import 'package:smart_parking_system/components/settings/settings.dart';
import 'package:smart_parking_system/components/card/edit_card.dart';
import 'package:smart_parking_system/components/home/sidebar.dart';

class PaymentMethodPage extends StatefulWidget {
  const PaymentMethodPage({super.key});

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  int _selectedIndex = 1;
  int creditAmount = 0; // Changed to default 0 and will fetch from database
  List<Map<String, String>> cards = [];
  bool _isFetching = true;

  @override
  void initState() {
    super.initState();
    _fetchCards();
    _fetchCreditAmount();
  }

  Future<void> _fetchCards() async {
    setState(() {
      _isFetching = true;
    });
    User? user = FirebaseAuth.instance.currentUser;

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('cards')
          .where('userId', isEqualTo: user?.uid)
          .get();

      final List<Map<String, String>> fetchedCards = [];
      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;

        String cardNumber = data['cardNumber'] ?? '';

        fetchedCards.add({
          'id': doc.id,
          'bank': data['bank'] ?? '',
          'number': '**** **** **** ${cardNumber.isNotEmpty ? cardNumber.substring(cardNumber.length - 4) : '0000'}',
          'cardNumber': data['cardNumber'] ?? '',
          'cvv': data['cvv'] ?? '',
          'name': data['holderName'] ?? '',
          'expiry': data['expiry'] ?? '',
          'image': 'assets/${data['cardType']}.png',
        });
      }

      setState(() {
        cards = fetchedCards;
      });
    } catch (e) {
      //print('Error fetching cards: $e');
    }
    setState(() {
      _isFetching = false;
    });
  }


  Future<void> _fetchCreditAmount() async {
    setState(() {
      _isFetching = true;
    });
    User? user = FirebaseAuth.instance.currentUser;

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .get();

      final data = userDoc.data() as Map<String, dynamic>;
      setState(() {
        creditAmount = data['balance']?.toInt() ?? 0;
      });
    } catch (e) {
      // 这里可以添加更多错误处理逻辑
    }
    setState(() {
      _isFetching = false;
    });
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
                Navigator.of(context).pop(true);
              },
            ),
            TextButton(
              child: const Text('Top Up', style: TextStyle(color: Colors.tealAccent)),
              onPressed: () async {
                if (isValidString(topUpAmount.toString(), r'^\d+(\.\d+)?$')) {
                  User? user = FirebaseAuth.instance.currentUser;
                  setState(() {
                    creditAmount += (topUpAmount ?? 0).toInt();
                  });

                  // Update credit amount in Firestore
                  try {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(user?.uid)
                        .update({'balance': creditAmount});
                  } catch (e) {
                    // 这里可以添加更多错误处理逻辑
                  }

                  if(context.mounted) {
                    Navigator.of(context).pop(true);
                  }
                } else {
                  showToast(message: "Invalid Amount : $topUpAmount");
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
      body: _isFetching ? loadingWidget()
      : Padding(
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
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF58C6A9),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
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
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => EditCardPage(
                                        cardId: card['id']!,
                                        cardNumber: card['number']!,
                                        cvv: card['cvv']!,
                                        name: card['name']!,
                                        expiry: card['expiry']!,
                                        bank: card['bank']!,
                                      ),
                                    ),
                                  );
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
      drawer: const SideMenu(),
    );
  }
}
