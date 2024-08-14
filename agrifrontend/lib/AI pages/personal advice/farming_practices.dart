import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FarmingPracticesPage extends StatefulWidget {
  const FarmingPracticesPage({super.key});

  @override
  _FarmingPracticesPageState createState() => _FarmingPracticesPageState();
}

class _FarmingPracticesPageState extends State<FarmingPracticesPage> {
  List<Map<String, String>> _farmingPractices = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFarmingPractices();
  }

  Future<void> _fetchFarmingPractices() async {
    const url = 'https://api.openai.com/v1/completions';
    const apiKey =
        'sk-ZxonIMxLFUcVXhY0ZhhU8jUKqPUsxMOlAWNBcRUyBqT3BlbkFJZOom0hmSkhrSXRy6dxzrf7MOru-3X72p6HgeiChq0A'; // Replace with your OpenAI API key

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: json.encode({
          'model': 'text-davinci-003', // or 'gpt-4' if available
          'prompt': 'Generate a list of farming practices with descriptions.',
          'max_tokens': 200,
          'n': 1,
          'stop': null,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        final generatedText = decodedResponse['choices'][0]['text'] as String;
        _parseFarmingPractices(generatedText);
      } else {
        throw Exception('Failed to load farming practices');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error: $e');
    }
  }

  void _parseFarmingPractices(String text) {
    final List<Map<String, String>> practices = [];

    // Assuming the text is in a bullet-point format
    final lines = text.split('\n');
    for (var line in lines) {
      if (line.trim().isNotEmpty) {
        final parts = line.split(':');
        if (parts.length == 2) {
          practices.add({
            'name': parts[0].trim(),
            'description': parts[1].trim(),
          });
        }
      }
    }

    setState(() {
      _farmingPractices = practices;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farming Practices'),
        backgroundColor: Colors.green,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _farmingPractices.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text(_farmingPractices[index]['name']!),
                    subtitle: Text(_farmingPractices[index]['description']!),
                    onTap: () {
                      // Navigate to PracticeDetailPage or perform other actions
                    },
                  ),
                );
              },
            ),
    );
  }
}
