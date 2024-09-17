import 'package:agrifrontend/AI%20pages/personal%20advice/all_courses.dart';
import 'package:agrifrontend/AI%20pages/personal%20advice/full_course.dart';
import 'package:agrifrontend/AI%20pages/personal%20advice/practice_detail.dart';
import 'package:agrifrontend/AI%20pages/personal%20advice/crop_animal_info.dart';
import 'package:agrifrontend/home/home_page.dart';
import 'package:agrifrontend/home/settings_page.dart';
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
  int _selectedIndex = 2;
  bool isPremiumUser = false;

  final List<String> _imagePaths = [
    '../../assets/pic1.jpg',
    '../../assets/pic2.jpg',
    '../../assets/pic3.jpg',
    '../../assets/pic4.jpg',
    '../../assets/pic5.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _fetchCourses();
    _checkSubscriptionStatus();
  }

  Future<void> _checkSubscriptionStatus() async {
    // Placeholder implementation - replace with actual logic
    setState(() {
      isPremiumUser = false; // Default to non-premium user
    });
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

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else if (index == 1) {
        _handlePremiumFeature(() {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AllCoursesPage()),
          );
        });
      } else if (index == 2) {
        // Already on Personalized Advice page
      } else if (index == 3) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SettingsPage()),
        );
      }
    });
  }

  void _handlePremiumFeature(VoidCallback onSuccess) {
    if (isPremiumUser) {
      onSuccess();
    } else {
      _showUpgradePrompt();
    }
  }

  void _showUpgradePrompt() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Upgrade to Premium'),
        content: const Text(
          'This feature is only available for premium users. Upgrade to access more features.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _upgradeToPremium();
            },
            child: const Text('Go Premium'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _upgradeToPremium() {
    setState(() {
      isPremiumUser = true; // Upgrade user to premium
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Agriculture Assistant',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20.0),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment
                    .stretch, // Ensure buttons stretch to fill available height
                children: [
                  _buildFeatureButton(
                    context,
                    'AI Advice',
                    'Get AI advice',
                    Icons.lightbulb,
                    true, // AI Advice is always accessible
                  ),
                  const SizedBox(width: 20.0),
                  _buildFeatureButton(
                    context,
                    'Explore Farming',
                    '',
                    Icons.search,
                    false, // Require premium access
                  ),
                  const SizedBox(width: 20.0),
                  _buildFeatureButton(
                    context,
                    'Animal & Crop Info',
                    '',
                    Icons.agriculture,
                    true, // Require premium access
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30.0),
            const Text(
              'Recommended for you',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30.0),
            Expanded(
              child: _courses.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _courses.length,
                      itemBuilder: (context, index) {
                        // Get image path based on the index
                        final imagePath =
                            _imagePaths[index % _imagePaths.length];

                        return _buildCourseCard(
                          context,
                          _courses[index]['id'],
                          _courses[index]['title'],
                          _courses[index]['description'],
                          'Start Lesson',
                          imagePath, // Pass the correct image path
                        );
                      },
                    ),
            ),
            const SizedBox(height: 20.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _handlePremiumFeature(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AllCoursesPage()),
                    );
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 15.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text(
                  'View all courses',
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
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
            label: 'AI',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        selectedItemColor: Colors.green[800],
        unselectedItemColor: Colors.green[300],
        showUnselectedLabels: false,
        selectedLabelStyle:
            const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildFeatureButton(BuildContext context, String title,
      String subtitle, IconData icon, bool accessible) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (!accessible) {
            _handlePremiumFeature(() {
              if (title == 'Explore Farming') {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FarmingPracticesPage()));
              }
            });
          } else if (title == 'AI Advice') {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AiAdvice()));
          } else if (title == 'Animal & Crop Info') {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CropAnimalInfo()));
          }
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8.0,
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(icon, size: 40, color: Colors.green.shade700),
              const SizedBox(height: 8),
              Text(
                title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCourseCard(BuildContext context, String courseId, String title,
      String description, String buttonText, String imagePath) {
    return Container(
      width: 180,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: AssetImage(imagePath), // Load image from assets
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [
              Colors.black.withOpacity(0.7),
              Colors.black.withOpacity(0.2),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
              maxLines: 10, // Limit to 2 lines
              softWrap: true, // Allow text to wrap
              overflow:
                  TextOverflow.ellipsis, // Show ellipsis if text overflows
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _handlePremiumFeature(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CourseDetailPage(courseId: courseId)),
                    );
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: Text(
                  buttonText,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
