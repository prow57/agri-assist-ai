import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart'; // Import the markdown package
import 'package:http/http.dart' as http;
import 'dart:convert';

class AgriTechPage extends StatefulWidget {
  @override
  _AgriTechPageState createState() => _AgriTechPageState();
}

class _AgriTechPageState extends State<AgriTechPage> {
  Map<String, dynamic> content = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchContent();
  }

  Future<void> _fetchContent() async {
    final response = await http.get(Uri.parse('https://agriback-plum.vercel.app/api/community/agri-tech'));
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
      appBar: AppBar(title: Text('Agricultural Technology')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (content.containsKey('title'))
                      Text(
                        content['title'],
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    SizedBox(height: 10),
                    if (content.containsKey('introduction'))
                      MarkdownBody(
                        data: content['introduction'],  // Render introduction as markdown
                        styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
                      ),
                    SizedBox(height: 20),
                    if (content.containsKey('sections'))
                      ...content['sections'].map<Widget>((section) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              section['heading'],
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green[700]),
                            ),
                            SizedBox(height: 10),
                            MarkdownBody(
                              data: section['content'],  // Render section content as markdown
                              styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
                            ),
                            SizedBox(height: 20),
                          ],
                        );
                      }).toList(),
                    if (content.containsKey('conclusion'))
                      MarkdownBody(
                        data: content['conclusion'],  // Render conclusion as markdown
                        styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
                      ),
                    if (content.containsKey('error'))
                      Center(
                        child: Text(
                          content['error'],
                          style: TextStyle(color: Colors.red, fontSize: 18),
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}
