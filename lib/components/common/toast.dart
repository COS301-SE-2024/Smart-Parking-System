import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast ({required String message}){
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.SNACKBAR,
    timeInSecForIosWeb: 1,
    backgroundColor: const Color(0xFF58C6A9),
    textColor: Colors.white,
    fontSize: 16.0
  );
}