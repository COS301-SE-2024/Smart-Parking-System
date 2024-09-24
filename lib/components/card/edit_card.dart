import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:smart_parking_system/components/common/common_functions.dart';
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


    final String cardNumber = _cardNumberController.text.replaceAll(RegExp(r'\s+'), '');
    final String holderName = _nameController.text;
    final String expiry = _expiryController.text;
    final String cvv = _cvvController.text;
    final String bank = _bankController.text;
    if(!isValidString(cardNumber, r'^(?:4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14}|3[47][0-9]{13}|3(?:0[0-5]|[68][0-9])[0-9]{11}|6(?:011|5[0-9]{2})[0-9]{12}|(?:2131|1800|35\d{3})\d{11})$')){showToast(message: "Invalid Card Number, Remove any spaces"); return;}
    if(!isValidString(holderName, r'^[a-zA-Z/\s]+$')){showToast(message: "Invalid Holder Name"); return;}
    if(!isValidString(expiry, r'^\d{2}/\d{2}$')){showToast(message: "Invalid Expiry, format: 00/00"); return;}
    if(!isValidString(cvv, r'^\d{3}$')){showToast(message: "Invalid CVV, format 000"); return;}
    if(!isValidString(bank, r'^[a-zA-Z]+$')){showToast(message: "Invalid Bank Name"); return;}
    Map<String, String> cardPatterns = {
      'visa': r'^4[0-9]{12}(?:[0-9]{3})?$',
      'mastercard': r'^5[1-5][0-9]{14}$',
      'american express': r'^3[47][0-9]{13}$',
      'diners club': r'^3(?:0[0-5]|[68][0-9])[0-9]{11}$',
      'discover': r'^6(?:011|5[0-9]{2})[0-9]{12}$',
      'jcb': r'^(?:2131|1800|35\d{3})\d{11}$'
    };
    String cardType = '';
    for (var entry in cardPatterns.entries) {
      if (RegExp(entry.value).hasMatch(cardNumber)) {
        cardType = entry.key;
      }
    }

    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('cards').doc(widget.cardId).update({
          'cardNumber': cardNumber,
          'cvv': cvv,
          'holderName': holderName,
          'expiry': expiry,
          'bank': bank,
          'cardType': cardType
        });

        if (mounted) {
          showToast(message: "Saved updated Card Information!");
          Navigator.of(context).pop();
        }
      } catch (e) {
        showToast(message: 'Failed to edit card details: $e');
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
