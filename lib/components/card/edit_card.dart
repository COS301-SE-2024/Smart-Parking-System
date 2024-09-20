import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:smart_parking_system/components/common/custom_widgets.dart';
import 'package:smart_parking_system/components/common/toast.dart';

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
          showToast(message: "Saved updated Card Information!");
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
      body: SingleChildScrollView(
        child: Center(
        child: SizedBox(
          width: 550,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(Icons.chevron_left, color: Colors.white, size: 35),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    const Center(
                      child: Text(
                        'Edit Card',
                        style: TextStyle(
                          color: Color(0xFF58C6A9),
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40.0),
                Center(
                  child: ShaderMask(
                    shaderCallback: (bounds) {
                      return const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Colors.transparent, Colors.white, Colors.white, Colors.transparent],
                        stops: [0.0, 0.1, 0.9, 1.0],
                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.dstIn,
                    child: Image.asset('assets/main_add_card.png'),
                  ),
                ),
                const SizedBox(height: 10.0),
                TextField(
                  controller: _cardNumberController,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.transparent,
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
                const SizedBox(height: 10.0),
                TextField(
                  controller: _bankController,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.transparent,
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
                const SizedBox(height: 10.0),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.transparent,
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
                const SizedBox(height: 10.0),
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
                const SizedBox(height: 60.0),
                nextButton(
                  displayText: 'Save', 
                  action: _saveCardDetails,
                ),
              ],
            ),
          ),
        ),
      ),
      )
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
