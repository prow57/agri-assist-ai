import 'package:flutter/material.dart';

class HarvestingTipsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Harvesting Tips')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Harvest crops efficiently by monitoring maturity, using the right tools, and storing the harvest properly to maximize yield.',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
