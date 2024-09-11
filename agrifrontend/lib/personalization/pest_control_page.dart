

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PestControlPage extends StatefulWidget {
  @override
  _SoilManagementPageState createState() => _SoilManagementPageState();
}

class _PestControlPageState extends State<SoilManagementPage> {
  Map<String, dynamic> content = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchContent();
  }

  Future<void> _fetchContent() async {
    final response = await http.get(Uri.parse('https://agriback-plum.vercel.app/api/community/soil-management'));
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
      appBar: AppBar(title: Text('Soil Management')),
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
                      Text(
                        content['introduction'],
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
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
                            Text(
                              section['content'],
                              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                            ),
                            SizedBox(height: 20),
                          ],
                        );
                      }).toList(),
                    if (content.containsKey('conclusion'))
                      Text(
                        content['conclusion'],
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}
