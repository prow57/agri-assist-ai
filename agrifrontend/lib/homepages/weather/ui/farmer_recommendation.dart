import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_markdown/flutter_markdown.dart'; // Import flutter_markdown

class FarmerRecommendationsPage extends StatefulWidget {
  final String city;

  const FarmerRecommendationsPage({
    super.key,
    required this.city,
  });

  @override
  _FarmerRecommendationsPageState createState() => _FarmerRecommendationsPageState();
}

class _FarmerRecommendationsPageState extends State<FarmerRecommendationsPage> {
  String recommendation = 'Fetching recommendations...';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRecommendations();
  }

  Future<void> fetchRecommendations() async {
    final url = Uri.parse('https://agriback-plum.vercel.app/api/recommend/weather');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'location': widget.city}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          recommendation = data['recommendations'] ?? 'No recommendations available';
          isLoading = false;
        });
      } else {
        setState(() {
          recommendation = 'Failed to load recommendations';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        recommendation = 'Error: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recommendations for ${widget.city}'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Markdown(
                      data: recommendation, // Render the recommendation as Markdown
                      styleSheet: MarkdownStyleSheet(
                        p: const TextStyle(fontSize: 18), 
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
