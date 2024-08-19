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
  Map<String, dynamic>? courseData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCourseDetail();
  }

  Future<void> _fetchCourseDetail() async {
    final url = 'https://agriback-plum.vercel.app/api/courses/generate-full-course/${widget.courseId}';

    try {
      final response = await http.post(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        setState(() {
          courseData = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          courseData = {
            'title': 'Error',
            'description': 'Failed to load course description: ${response.statusCode}'
          };
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        courseData = {
          'title': 'Error',
          'description': 'Error: $e'
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Details', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : courseData != null
              ? SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        courseData!['title'] ?? 'No Title',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        courseData!['category'] ?? 'No Category',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        courseData!['description'] ?? 'No Description',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                       const SizedBox(height: 20),
                      Text(
                        courseData!['content'] ?? 'No Content',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // _buildSection('Objectives', courseData!['content']),
                      // _buildSection('Introduction', courseData!['content']),
                      // _buildSection('Content', courseData!['content']),
                      // _buildSection('Guided Practice', courseData!['content']),
                      // _buildSection('Conclusion', courseData!['content']),
                      // _buildSection('References', courseData!['content']),
                      // _buildSection('Practical Lesson', courseData!['content']),
                      // _buildSection('Assessment', courseData!['content']),
                    ],
                  ),
                )
              : Center(child: Text('No course data available.')),
    );
  }

  Widget _buildSection(String sectionTitle, String? content) {
    final sectionContent = _extractSectionContent(sectionTitle, content);

    return sectionContent.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sectionTitle,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  sectionContent,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }

  String _extractSectionContent(String sectionTitle, String? content) {
    if (content == null) return '';

    final startIndex = content.indexOf('**$sectionTitle:**');
    if (startIndex == -1) return '';

    final endIndex = content.indexOf('**', startIndex + sectionTitle.length + 3);
    final sectionContent = endIndex == -1
        ? content.substring(startIndex + sectionTitle.length + 3).trim()
        : content.substring(startIndex + sectionTitle.length + 3, endIndex).trim();

    return sectionContent;
  }
}
