import 'package:flutter/material.dart';

class SoilManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Soil Management')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Best practices for maintaining soil health and fertility include crop rotation, '
            'organic fertilizers, and proper tillage.',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
