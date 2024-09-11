import 'package:flutter/material.dart';

class AgriTechPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Agricultural Technology')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Explore the latest technologies in agriculture such as drones, precision farming, and automated machinery to enhance productivity.',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
