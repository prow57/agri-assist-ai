import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class FarmingPracticesPage extends StatefulWidget {
  const FarmingPracticesPage({super.key});

  @override
  _FarmingPracticesPageState createState() => _FarmingPracticesPageState();
}

class _FarmingPracticesPageState extends State<FarmingPracticesPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  Map<String, dynamic>? _courseData;
  bool _isLoading = false;
  bool _isError = false;
  final ScrollController _scrollController = ScrollController();

  // Define the GlobalKeys for each section
  final GlobalKey _objectivesKey = GlobalKey();
  final GlobalKey _introductionKey = GlobalKey();
  final GlobalKey _contentKey = GlobalKey();
  final GlobalKey _guidedPracticeKey = GlobalKey();
  final GlobalKey _conclusionKey = GlobalKey();
  final GlobalKey _referencesKey = GlobalKey();
  final GlobalKey _practicalLessonsKey = GlobalKey();
  final GlobalKey _assessmentKey = GlobalKey();

  Future<void> _fetchCourse() async {
    setState(() {
      _isLoading = true;
      _isError = false;
    });

    const url =
        'https://agriback-plum.vercel.app/api/courses/generate-full-course';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'title': _titleController.text,
          'description': _descriptionController.text,
          'category': _categoryController.text,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _courseData = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        setState(() {
          _courseData = {
            'title': 'Error',
            'description':
                'Failed to load course: ${response.statusCode}. Please try again later.'
          };
          _isLoading = false;
          _isError = true;
        });
      }
    } catch (e) {
      setState(() {
        _courseData = {
          'title': 'Error',
          'description':
              'Network error: Unable to fetch course. Please check your internet connection or try again later.'
        };
        _isLoading = false;
        _isError = true;
      });
      print('Error: $e');
    }
  }

  void _scrollToSection(GlobalKey sectionKey) {
    final context = sectionKey.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(context,
          duration: const Duration(seconds: 1), curve: Curves.easeInOut);
    } else {
      print('Context is null for section key: $sectionKey');
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0.0,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farming Practices'),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white, // Set the color of the title and icon to white
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Course Title',
                  prefixIcon: Icon(Icons.title),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Course Description',
                  prefixIcon: Icon(Icons.description),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  prefixIcon: Icon(Icons.category),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _fetchCourse,
                  icon: const Icon(Icons.download),
                  label: const Text('Fetch Course', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                ),
              ),
              const SizedBox(height: 32.0),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _isError || _courseData == null
                      ? Card(
                          color: Colors.red.shade100,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              _courseData?['description'] ?? 'Fill all fields abouve',
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        )
                      : _buildCourseContent(),
            ],
          ),
        ),
      ),
      floatingActionButton: _courseData != null && !_isLoading
          ? FloatingActionButton(
              onPressed: _scrollToTop,
              backgroundColor: Colors.green,
              child: const Icon(Icons.arrow_upward, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildCourseContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Table of Contents
        Text(
          'Table of Contents',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        _buildTableOfContents(),
        const SizedBox(height: 20),

        // Course Content
        Text(
          _courseData!['title'] ?? 'No Title',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          _courseData!['category'] ?? 'No Category',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          _courseData!['description'] ?? 'No Description',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 20),
        _buildCollapsibleSections(),
      ],
    );
  }

  Widget _buildTableOfContents() {
    final tocItems = [
      {'title': 'Objectives', 'key': _objectivesKey},
      {'title': 'Introduction', 'key': _introductionKey},
      {'title': 'Content', 'key': _contentKey},
      {'title': 'Guided Practice', 'key': _guidedPracticeKey},
      {'title': 'Conclusion', 'key': _conclusionKey},
      {'title': 'References', 'key': _referencesKey},
      {'title': 'Practical Lessons', 'key': _practicalLessonsKey},
      {'title': 'Assessment', 'key': _assessmentKey},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: tocItems.map((tocItem) {
        return GestureDetector(
          onTap: () => _scrollToSection(tocItem['key'] as GlobalKey),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              tocItem['title'] as String,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCollapsibleSections() {
    final content = _courseData!['content'] as Map<String, dynamic>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildExpansionTile('Objectives', content['objectives'], _objectivesKey),
        _buildExpansionTile('Introduction', content['introduction'], _introductionKey),
        _buildExpansionTile('Content', content['sections'], _contentKey),
        _buildExpansionTile('Guided Practice', content['guided_practice'], _guidedPracticeKey),
        _buildExpansionTile('Conclusion', content['conclusion'], _conclusionKey),
        _buildExpansionTile('References', content['references'], _referencesKey),
        _buildExpansionTile('Practical Lessons', content['practical_lessons'], _practicalLessonsKey),
        _buildExpansionTile('Assessment', content['assessment'], _assessmentKey),
      ],
    );
  }

  Widget _buildExpansionTile(String title, dynamic sectionContent, GlobalKey sectionKey) {
    return sectionContent != null && sectionContent.isNotEmpty
        ? ExpansionTile(
            key: sectionKey,
            title: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: [
              const SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  children: _buildTextSpans(sectionContent),
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 10),
            ],
          )
        : const SizedBox.shrink();
  }

  List<TextSpan> _buildTextSpans(dynamic content) {
    if (content is List) {
      return content.map<TextSpan>((item) {
        return TextSpan(
          text: '$item\n',
          style: const TextStyle(fontSize: 16, height: 1.5),
        );
      }).toList();
    } else if (content is String) {
      return [
        TextSpan(
          text: '$content\n',
          style: const TextStyle(fontSize: 16, height: 1.5),
        ),
      ];
    }
    return [];
  }
}
