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
          _responseContent = 'Failed to load course: ${response.statusCode}';
          _isLoading = false;
          _isError = true;
        });
      }
    } catch (e) {
      setState(() {
        _responseContent = 'Error: $e';
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
        backgroundColor: Colors.green,
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
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Course Description',
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category',
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _fetchCourse,
                child: const Text('Fetch Course'),
              ),
              const SizedBox(height: 32.0),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _isError
                      ? Text(
                          _responseContent,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                          ),
                        )
                      : Text(
                          _responseContent,
                          style: const TextStyle(
                            fontFamily: 'Courier',
                            fontSize: 14,
                            letterSpacing: 1.2,
                          ),
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
