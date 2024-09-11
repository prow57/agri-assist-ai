import 'package:flutter/material.dart';

class IrrigationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Irrigation Techniques')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Learn about modern irrigation techniques to optimize water usage. '
            'Here are some effective irrigation methods: drip irrigation, sprinkler systems, and more.',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
