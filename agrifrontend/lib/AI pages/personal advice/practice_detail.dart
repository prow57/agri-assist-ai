import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CourseDetailPage extends StatefulWidget {
  final String courseId;

  const CourseDetailPage({required this.courseId, super.key});

  @override
  _CourseDetailPageState createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  String _courseDescription = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCourseDetail();
  }

  Future<void> _fetchCourseDetail() async {
    final url =
        'https://agriback-plum.vercel.app/api/courses/topics/${widget.courseId}';

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        setState(() {
          _courseDescription = decodedResponse['description'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _courseDescription =
              'Failed to load course description: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _courseDescription = 'Error: $e';
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Details'),
        backgroundColor: Colors.green,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(_courseDescription),
            ),
    );
  }
}
