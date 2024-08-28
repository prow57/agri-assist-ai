import 'package:flutter/material.dart';

class CommunityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to the Agriculture Community',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Here you can find various resources and information to help you in your farming journey.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 30),

            // Example of Information Section
            Expanded(
              child: ListView(
                children: [
                  _buildInfoCard(
                    'Irrigation Techniques',
                    'Learn about modern irrigation techniques to optimize water usage.',
                    Icons.water,
                  ),
                  _buildInfoCard(
                    'Soil Management',
                    'Best practices for maintaining soil health and fertility.',
                    Icons.eco,
                  ),
                  _buildInfoCard(
                    'Pest Control',
                    'Effective methods for controlling pests and protecting your crops.',
                    Icons.bug_report,
                  ),
                  _buildInfoCard(
                    'Harvesting Tips',
                    'Guidelines for harvesting crops efficiently and at the right time.',
                    Icons.agriculture,
                  ),
                  _buildInfoCard(
                    'Agricultural Technology',
                    'Explore the latest technologies in agriculture.',
                    Icons.computer,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String description, IconData icon) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.green, size: 40),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
