import 'package:agrifrontend/AI%20pages/personal%20advice/full_course.dart';
import 'package:agrifrontend/home/home_page.dart';
import 'package:agrifrontend/home/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'personalized_advice_page.dart'; // Import the personalized advice page

class AllCoursesPage extends StatefulWidget {
  const AllCoursesPage({super.key});

  @override
  _AllCoursesPageState createState() => _AllCoursesPageState();
}

class _AllCoursesPageState extends State<AllCoursesPage> {
  List<dynamic> _courses = [];
  bool _isLoading = true;
  String _errorMessage = '';
  int _selectedIndex = 1; // Set the index for the Courses tab to be active

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    const url = 'https://agriback-plum.vercel.app/api/courses/courses';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _courses = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load courses: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return; // Ignore tap if already on the selected tab

    setState(() {
      _selectedIndex = index;

      if (index == 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      } else if (index == 1) {
        // Already on AllCoursesPage
      } else if (index == 2) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const PersonalizedAdvicePage(),
          ),
        );
      } else if (index == 3) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SettingsPage(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Courses', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: _courses.length,
                        itemBuilder: (context, index) {
                          final course = _courses[index];
                          return _buildCourseCard(
                            context,
                            course['title'] ?? 'No title available',
                            course['imagePath'],
                            course['id'], // Assuming 'id' is the identifier for the course
                          );
                        },
                      ),
                    ),
                  ],
                ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Set the current index
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
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
      ),
    );
  }

  Widget _buildCourseCard(
    BuildContext context,
    String title,
    String? imagePath,
    String courseId, // Add the courseId parameter
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4.0,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: imagePath != null
            ? Image.network(
                imagePath,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, size: 80);
                },
              )
            : const Icon(Icons.image_not_supported, size: 80),
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FullCourse(courseId: courseId),
            ),
          );
        },
      ),
    );
  }
}
