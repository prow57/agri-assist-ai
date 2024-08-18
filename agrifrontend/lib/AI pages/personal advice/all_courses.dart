import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AllCoursesPage extends StatefulWidget {
  const AllCoursesPage({super.key});

  @override
  _AllCoursesPageState createState() => _AllCoursesPageState();
}

class _AllCoursesPageState extends State<AllCoursesPage> {
  List<dynamic> _courses = [];
  List<String> _appliedCourses = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    const url =
        'https://agriback-plum.vercel.app/api/courses/generate-full-course/:id';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'history': [],
        }),
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

  void _applyForCourse(String title) {
    setState(() {
      _appliedCourses.add(title);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Courses'),
        backgroundColor: Colors.green,
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
                          return _buildCourseCard(
                            context,
                            _courses[index]['title'] ?? 'No title available',
                            _courses[index]['imagePath'],
                          );
                        },
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Applied Courses:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    _appliedCourses.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text('No courses applied yet.'),
                          )
                        : Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16.0),
                              itemCount: _appliedCourses.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(_appliedCourses[index]),
                                );
                              },
                            ),
                          ),
                  ],
                ),
    );
  }

  Widget _buildCourseCard(
      BuildContext context, String title, String? imagePath) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: imagePath != null
            ? Image.network(
                imagePath,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, size: 50);
                },
              )
            : const Icon(Icons.image_not_supported, size: 50),
        title: Text(title),
        subtitle: const Text('Start Lesson'),
        trailing: ElevatedButton(
          onPressed: () => _applyForCourse(title),
          child: const Text('Apply'),
        ),
        onTap: () {
          // Handle course selection
        },
      ),
    );
  }
}
