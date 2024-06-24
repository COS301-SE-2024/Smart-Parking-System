import 'package:flutter/material.dart';
import 'package:smart_parking_system/components/payment/confirmation_payment.dart';

class OfferPage extends StatefulWidget {
  const OfferPage({super.key});

  @override
  State<OfferPage> createState() => _OfferPageState();
}

class _OfferPageState extends State<OfferPage> {
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
              const SizedBox(height: 80),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => const ConfirmPaymentPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const Text(
                    'Offers',
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
                          'Blablablablabalbalabalblabala\nBlablablablabalbalabalblabalaBla\nblablablabalbalabalblabala',
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
        
        
      ),
    );
  }
}
