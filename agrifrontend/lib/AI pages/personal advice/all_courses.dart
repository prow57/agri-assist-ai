import 'package:flutter/material.dart';

class AllCoursesPage extends StatelessWidget {
  const AllCoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Courses'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildCourseCard(
            context,
            'Crops',
            'assets/crops.jpg',
          ),
          _buildCourseCard(
            context,
            'Pests',
            'assets/pests.jpg',
          ),
          _buildCourseCard(
            context,
            'Weeds',
            'assets/weeds.jpg',
          ),
        ],
      ),
    );
  }

  Widget _buildCourseCard(
      BuildContext context, String title, String imagePath) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading:
            Image.asset(imagePath, width: 50, height: 50, fit: BoxFit.cover),
        title: Text(title),
        subtitle: const Text('Start Lesson'),
        onTap: () {
          // Handle course item tap
        },
      ),
    );
  }

  Widget _buildCourseListItem(String title, String author, String imagePath) {
    return Card(
      child: ListTile(
        leading:
            Image.asset(imagePath, width: 50, height: 50, fit: BoxFit.cover),
        title: Text(title),
        subtitle: Text('By $author'),
        onTap: () {
          // Handle course item tap
        },
      ),
    );
  }
}
