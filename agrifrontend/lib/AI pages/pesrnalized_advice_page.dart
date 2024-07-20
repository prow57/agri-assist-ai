import 'package:flutter/material.dart';
import 'ai_advice.dart';

class PersonalizedAdvicePage extends StatelessWidget {
  const PersonalizedAdvicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FarmBase'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Define your action here
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Get the most out of your farm. Get started with the menu below.',
              style: TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 20.0),
            ListTile(
              leading: const Icon(Icons.lightbulb, color: Colors.orange),
              title: const Text('AI Advice'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AiAdvice()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.search, color: Colors.orange),
              title: const Text('Explore Farming'),
              onTap: () {
                // Define your action here
              },
            ),
            ListTile(
              leading: const Icon(Icons.video_library, color: Colors.orange),
              title: const Text('Recommended Courses'),
              onTap: () {
                // Define your action here
              },
            ),
            ListTile(
              leading: const Icon(Icons.book, color: Colors.orange),
              title: const Text('Lessons'),
              onTap: () {
                // Define your action here
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud),
            label: 'Weather',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Market',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note),
            label: 'Notes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
