import 'package:agrifrontend/AI%20pages/personal%20advice/all_courses.dart';
import 'package:agrifrontend/AI%20pages/personal%20advice/practice_detail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'ai_advice.dart';
import 'farming_practices.dart';

class PersonalizedAdvicePage extends StatefulWidget {
  const PersonalizedAdvicePage({super.key});

  @override
  _PersonalizedAdvicePageState createState() => _PersonalizedAdvicePageState();
}

class _PersonalizedAdvicePageState extends State<PersonalizedAdvicePage> {
  List<dynamic> _courses = [];

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    const url = 'https://agriback-plum.vercel.app/api/courses/random-topics';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          _courses = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load courses');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Agriculture Assistant',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white), // Set back arrow color to white
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
              height: 250,
              child: _courses.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _courses.length,
                      itemBuilder: (context, index) {
                        return _buildCourseCard(
                          context,
                          _courses[index]['id'], // Pass the id
                          _courses[index]['title'],
                          'Start Lesson',
                          _courses[index]['imagePath'] ?? 'https://via.placeholder.com/150',
                        );
                      },
                    ),
            ),
            const SizedBox(height: 10.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AllCoursesPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text(
                  'View all courses',
                  style: TextStyle(color: Colors.white),
                ),
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
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
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
          } else if (title == 'Explore Farming') {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const FarmingPracticesPage()), 
            );
          } else {
            // Define actions for other buttons
          }
        },
        child: Container(
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(icon, size: 40, color: Colors.green),
              const SizedBox(height: 8),
              Text(title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCourseCard(
      BuildContext context, String courseId, String title, String buttonText, String imagePath) {
    return Container(
      width: 150,
      height: 250,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              Colors.black.withOpacity(0.8),
              Colors.black.withOpacity(0.3),
            ],
            begin: Alignment.topCenter, // Start gradient from top
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CourseDetailPage(
                      courseId: courseId, // Pass the id
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: Text(
                buttonText,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
