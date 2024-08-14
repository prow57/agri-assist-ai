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

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    const url = 'http://37.187.29.19:6932/course-generation/';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'history': [], // Updated to always send an empty list
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _courses = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load courses');
      }
    } catch (e) {
      // Handle error
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Courses'),
      ),
      body: _courses.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _courses.length,
              itemBuilder: (context, index) {
                return _buildCourseCard(
                  context,
                  _courses[index]['title'],
                  _courses[index]['imagePath'],
                );
              },
            ),
    );
  }

  Widget _buildCourseCard(
      BuildContext context, String title, String imagePath) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading:
            Image.network(imagePath, width: 50, height: 50, fit: BoxFit.cover),
        title: Text(title),
        subtitle: const Text('Start Lesson'),
        onTap: () {
        },
      ),
    );
  }
}
