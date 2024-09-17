import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart'; // Import the markdown package
import 'package:http/http.dart' as http;
import 'dart:convert';

class HarvestingTipsPage extends StatefulWidget {
  const HarvestingTipsPage({super.key});

  @override
  _HarvestingTipsPageState createState() => _HarvestingTipsPageState();
}

class _HarvestingTipsPageState extends State<HarvestingTipsPage> {
  Map<String, dynamic> content = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchContent();
  }

  Future<void> _fetchContent() async {
    final response = await http.get(Uri.parse('https://agriback-plum.vercel.app/api/community/harvesting-tips'));
    if (response.statusCode == 200) {
      setState(() {
        content = jsonDecode(response.body);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
        content['error'] = 'Failed to load content';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Harvesting Tips For Malawi Farmers')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (content.containsKey('title'))
                      Text(
                        content['title'],
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    const SizedBox(height: 10),
                    if (content.containsKey('introduction'))
                      MarkdownBody(
                        data: content['introduction'],  // Render introduction as markdown
                        styleSheet: MarkdownStyleSheet(
                          p: const TextStyle(color: Colors.black, fontSize: 16), // Set text to black
                        ),
                      ),
                    const SizedBox(height: 20),
                    if (content.containsKey('sections'))
                      ...content['sections'].map<Widget>((section) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              section['heading'],
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green[700]),
                            ),
                            const SizedBox(height: 10),
                            MarkdownBody(
                              data: section['content'],  // Render section content as markdown
                              styleSheet: MarkdownStyleSheet(
                                p: const TextStyle(color: Colors.black, fontSize: 16), // Set text to black
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        );
                      }).toList(),
                    if (content.containsKey('conclusion'))
                      MarkdownBody(
                        data: content['conclusion'],  // Render conclusion as markdown
                        styleSheet: MarkdownStyleSheet(
                          p: const TextStyle(color: Colors.black, fontSize: 16), // Set text to black
                        ),
                      ),
                    if (content.containsKey('error'))
                      Center(
                        child: Text(
                          content['error'],
                          style: const TextStyle(color: Colors.red, fontSize: 18),
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}
