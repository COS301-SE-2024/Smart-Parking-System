import 'package:flutter/material.dart';

class HelloWebPage extends StatelessWidget {
  const HelloWebPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hello, Web!'),
        centerTitle: true,
      ),
      body: Center(
        child: Text('Welcome to Flutter Web',
          style: Theme.of(context).textTheme.displaySmall,
        ),
      ),
    );
  }
}