import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FarmingPracticesPage extends StatefulWidget {
  const FarmingPracticesPage({super.key});

  @override
  _FarmingPracticesPageState createState() => _FarmingPracticesPageState();
}

class _FarmingPracticesPageState extends State<FarmingPracticesPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  String _responseContent = '';
  bool _isLoading = false;
  bool _isError = false;

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
          _responseContent = response.body;
          _isLoading = false;
        });
      } else {
        setState(() {
          _responseContent =
              'Failed to load course: ${response.statusCode}. Please try again later.';
          _isLoading = false;
          _isError = true;
        });
      }
    } catch (e) {
      setState(() {
        _responseContent = 'Network error: Unable to fetch course. Please check your internet connection or try again later.';
        _isLoading = false;
        _isError = true;
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farming Practices'),
        backgroundColor: Colors.green[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
                  : _isError
                      ? Card(
                          color: Colors.red.shade100,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              _responseContent,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        )
                      : Card(
                          color: Colors.green.shade50,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              _responseContent,
                              style: const TextStyle(
                                fontFamily: 'Courier',
                                fontSize: 14,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
