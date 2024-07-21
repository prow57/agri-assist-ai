import 'package:flutter/material.dart';
import 'ai_advice.dart';

class PersonalizedAdvicePage extends StatelessWidget {
  const PersonalizedAdvicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agriculture Assistant'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildFeatureButton(
                    context, 'AI Advice', 'Get AI advice', Icons.lightbulb),
                _buildFeatureButton(context, 'Explore Farming',
                    'Explore farming', Icons.search),
              ],
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Recommended for you',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            Container(
              height: 200.0, // Set a fixed height for the horizontal ListView
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCourseCard(
                    context,
                    'Crops',
                    'Start Lesson',
                    'assets/crops.jpg',
                  ),
                  _buildCourseCard(
                    context,
                    'Pests',
                    'Start Lesson',
                    'assets/pests.jpg',
                  ),
                  _buildCourseCard(
                    context,
                    'Weeds',
                    'Start Lesson',
                    'assets/weeds.jpg',
                  ),
                  _buildCourseCard(
                    context,
                    'Weeds',
                    'Start Lesson',
                    'assets/weeds.jpg',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Define your action here
                },
                child: const Text('View all courses'),
              ),
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
            icon: Icon(Icons.book),
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureButton(
      BuildContext context, String title, String subtitle, IconData icon) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (title == 'AI Advice') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AiAdvice()),
            );
          } else {
            // Define actions for other buttons
          }
        },
        child: Container(
          margin: EdgeInsets.all(4),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(icon, size: 40, color: Colors.orange),
              const SizedBox(height: 8),
              Text(title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(subtitle, style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCourseCard(
      BuildContext context, String title, String buttonText, String imagePath) {
    return Container(
      width: 150,
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              Colors.black.withOpacity(0.8),
              Colors.black.withOpacity(0.3)
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              title,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            ElevatedButton(
              onPressed: () {
                // Define your action here
              },
              child: Text(buttonText),
            ),
          ],
        ),
      ),
    );
  }
}
