import 'package:flutter/material.dart';

class Community extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Text(
          'Welcome to Agriassist-AI',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
