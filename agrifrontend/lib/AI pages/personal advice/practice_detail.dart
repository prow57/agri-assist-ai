// practice_detail_page.dart
import 'package:flutter/material.dart';

class PracticeDetailPage extends StatelessWidget {
  final String practiceName;
  final String practiceDescription;

  const PracticeDetailPage({
    super.key,
    required this.practiceName,
    required this.practiceDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(practiceName),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              practiceName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              practiceDescription,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
