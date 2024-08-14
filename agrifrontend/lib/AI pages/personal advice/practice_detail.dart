// practice_detail_page.dart
import 'package:flutter/material.dart';
import 'all_courses.dart'; // Import the AllCoursesPage or specific course page

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
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _applyForCourse(context, practiceName);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32, vertical: 12),
                ),
                child: const Text(
                  'Apply for Course',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _applyForCourse(BuildContext context, String practiceName) {
    // Here you can define the logic for applying to a course related to this practice
    // For now, it navigates to the AllCoursesPage. 
    // You could modify this to go to a specific course page if available.

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AllCoursesPage(), // Or a specific course page
      ),
    );
  }
}
