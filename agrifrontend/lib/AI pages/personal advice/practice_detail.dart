import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class CourseDetailPage extends StatefulWidget {
  final String courseId;

  const CourseDetailPage({required this.courseId, super.key});

  @override
  _CourseDetailPageState createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  Map<String, dynamic>? courseData;
  bool _isLoading = true;
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

  void _scrollToSection(GlobalKey sectionKey) {
    final context = sectionKey.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(context,
          duration: const Duration(seconds: 1), curve: Curves.easeInOut);
    } else {
      print('Context is null for section key: $sectionKey');
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
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
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
                      _buildCollapsibleSections(),
                    ],
                  ),
                )
              : Center(child: Text('No course data available.')),
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
    final content = courseData!['content'] as Map<String, dynamic>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSection('Objectives', content['objectives'], _objectivesKey),
        _buildSection('Introduction', content['introduction'], _introductionKey),
        _buildSection('Content', content['sections'], _contentKey),
        _buildSection('Guided Practice', content['guided_practice'], _guidedPracticeKey),
        _buildSection('Conclusion', content['conclusion'], _conclusionKey),
        _buildReference('References', content['references'], _referencesKey),
        _buildSection('Practical Lessons', content['practical_lessons'], _practicalLessonsKey),
        _buildSection('Assessment', content['assessment'], _assessmentKey),
      ],
    );
  }

  Widget _buildSection(String sectionTitle, dynamic sectionContent, GlobalKey sectionKey) {
    return sectionContent != null
        ? Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: ExpansionTile(
              key: sectionKey,  // Attach the GlobalKey here
              title: Text(
                sectionTitle,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: sectionContent is List
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: sectionContent.map<Widget>((item) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(
                                item is Map ? item['content'] ?? '' : item.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                              ),
                            );
                          }).toList(),
                        )
                      : Text(
                          sectionContent.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }

Widget _buildReference(String sectionTitle, dynamic sectionContent, GlobalKey sectionKey) {
  return sectionContent != null
      ? Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: ExpansionTile(
            key: sectionKey, // Attach the GlobalKey here
            title: Text(
              sectionTitle,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: sectionContent is List
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: sectionContent.map<Widget>((item) {
                          final content = item is Map ? item['link'] : item.toString();
                          return content != null && content.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                  child: _buildRichTextWithLinks(content),
                                )
                              : const SizedBox.shrink();
                        }).toList(),
                      )
                    : _buildRichTextWithLinks(sectionContent.toString()),
              ),
            ],
          ),
        )
      : const SizedBox.shrink();
}

Widget _buildRichTextWithLinks(String text) {
  final linkRegex = RegExp(r'(https?://[^\s]+)');
  final matches = linkRegex.allMatches(text);

  if (matches.isEmpty) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16, color: Colors.black54),
    );
  }

  final List<TextSpan> spans = [];
  int currentIndex = 0;

  for (final match in matches) {
    final linkText = match.group(0)!;
    if (match.start > currentIndex) {
      spans.add(TextSpan(
        text: text.substring(currentIndex, match.start),
        style: const TextStyle(fontSize: 16, color: Colors.black54),
      ));
    }
    spans.add(TextSpan(
      text: linkText,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.blue,
        decoration: TextDecoration.underline,
      ),
      recognizer: TapGestureRecognizer()..onTap = () => _launchURL(linkText),
    ));
    currentIndex = match.end;
  }

  if (currentIndex < text.length) {
    spans.add(TextSpan(
      text: text.substring(currentIndex),
      style: const TextStyle(fontSize: 16, color: Colors.black54),
    ));
  }

  return RichText(
    text: TextSpan(children: spans),
  );
}

void _launchURL(String url) async {
  final Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'Could not launch $url';
  }
}


}
