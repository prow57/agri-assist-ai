import 'package:flutter/material.dart';

class PestControlPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pest Control')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Effective methods for controlling pests include using biological pest control, chemical treatments, '
            'and integrated pest management techniques.',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
