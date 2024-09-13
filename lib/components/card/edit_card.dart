import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class EditCardPage extends StatefulWidget {
  final String cardId;
  final String cardNumber; // 确保添加 cardNumber 参数
  final String cvv;
  final String name;
  final String expiry;
  final String bank;

  const EditCardPage({
    super.key,
    required this.cardId,
    required this.cardNumber, // 传递 cardNumber 参数
    required this.cvv,
    required this.name,
    required this.expiry,
    required this.bank,
  });

  @override
  EditCardPageState createState() => EditCardPageState();
}

class EditCardPageState extends State<EditCardPage> {
  late TextEditingController _cardNumberController;
  late TextEditingController _cvvController;
  late TextEditingController _nameController;
  late TextEditingController _expiryController;
  late TextEditingController _bankController;

  @override
  void initState() {
    super.initState();
    _cardNumberController = TextEditingController(text: widget.cardNumber); // 使用传递的参数初始化
    _cvvController = TextEditingController(text: widget.cvv);
    _nameController = TextEditingController(text: widget.name);
    _expiryController = TextEditingController(text: widget.expiry);
    _bankController = TextEditingController(text: widget.bank);
  }

  Future<void> _saveCardDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('cards').doc(widget.cardId).update({
          'cardNumber': _cardNumberController.text,
          'cvv': _cvvController.text,
          'holderName': _nameController.text,
          'expiry': _expiryController.text,
          'bank': _bankController.text,
        });

        if (mounted) {
          Navigator.of(context).pop(); // 返回上一页
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to save card details: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF35344A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF35344A),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 30),
          onPressed: () {
            Navigator.of(context).pop(); // 返回上一页
          },
        ),
        title: const Text(
          'Edit Card',
          style: TextStyle(color: Color(0xFF58C6A9), fontSize: 20.0),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20.0),
              Center(
                child: Image.asset('assets/main_add_card.png'),
              ),
              const SizedBox(height: 20.0),
              Center(
                child: SizedBox(
                  width: 500,
                  child: Column(
                    children: [
                      TextField(
                        controller: _cardNumberController,
                        decoration: const InputDecoration(
                          labelText: 'Card Number',
                          labelStyle: TextStyle(color: Colors.grey),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 20.0),
                      TextField(
                        controller: _bankController,
                        decoration: const InputDecoration(
                          labelText: 'Bank',
                          labelStyle: TextStyle(color: Colors.grey),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 20.0),
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Holder Name',
                          labelStyle: TextStyle(color: Colors.grey),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _expiryController,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.transparent,
                                labelText: 'MM/YY',
                                labelStyle: TextStyle(color: Colors.grey),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                counterStyle: TextStyle(color: Colors.grey),
                              ),
                              style: const TextStyle(color: Colors.white),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                _ExpiryDateInputFormatter(),
                              ],
                              maxLength: 5,
                            ),
                          ),
                          const SizedBox(width: 120.0),
                          Expanded(
                            child: TextField(
                              controller: _cvvController,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.transparent,
                                labelText: 'CVV',
                                labelStyle: TextStyle(color: Colors.grey),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                counterStyle: TextStyle(color: Colors.grey),
                              ),
                              style: const TextStyle(color: Colors.white),
                              keyboardType: TextInputType.number,
                              maxLength: 3,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40.0),
                      Center(
                        child: ElevatedButton(
                          onPressed: _saveCardDetails,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 100,
                              vertical: 15,
                            ),
                            backgroundColor: const Color.fromRGBO(88, 198, 169, 1),
                          ),
                          child: const Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                )
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}

class _ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 2 == 0 && nonZeroIndex != text.length) {
        buffer.write('/');
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}
