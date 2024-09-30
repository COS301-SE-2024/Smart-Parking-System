import 'package:flutter/material.dart';

void main() {
  runApp(MyTestWebApp());
}

class MyTestWebApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Web App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Test Web App'),
        ),
        body: Center(
          child: TestButton(),
        ),
      ),
    );
  }
}

class TestButton extends StatefulWidget {
  @override
  _TestButtonState createState() => _TestButtonState();
}

class _TestButtonState extends State<TestButton> {
  String buttonText = "Click me!";

  void _updateText() {
    setState(() {
      buttonText = "Clicked!";
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _updateText,
      child: Text(buttonText),
    );
  }
}
