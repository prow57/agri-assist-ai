import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class HistoryFullCourse extends StatefulWidget {
  final String courseId;

  const HistoryFullCourse({required this.courseId, super.key});

  @override
  _HistoryFullCourseState createState() => _HistoryFullCourseState();
}

class _HistoryFullCourseState extends State<HistoryFullCourse> {
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
    final url = 'https://agriback-plum.vercel.app/api/courses/get-explore/${widget.courseId}';

    try {
      final response = await http.get(Uri.parse(url), headers: {
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
        title: const Text('Course Details', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _scrollToTop,
        backgroundColor: Colors.green,
        child: const Icon(Icons.arrow_upward, color: Colors.white),
      ),
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

  return ExpansionTile(
    title: const Text(
      'Table of Contents',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    children: tocItems.map((tocItem) {
      return ListTile(
        title: Text(tocItem['title'] as String),
        onTap: () => _scrollToSection(tocItem['key'] as GlobalKey),
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
        _buildSectionContent('Content', content['sections'], _contentKey),
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
              key: sectionKey,
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
                              child: MarkdownBody(
                                data: item is Map ? item['content'] ?? '' : item.toString(),
                                onTapLink: (text, href, title) {
                                  if (href != null) {
                                    launchUrl(Uri.parse(href));
                                  }
                                },
                                styleSheet: MarkdownStyleSheet(
                                  p: const TextStyle(fontSize: 16, color: Colors.black54),
                                ),
                              ),
                            );
                          }).toList(),
                        )
                      : MarkdownBody(
                          data: sectionContent.toString(),
                          onTapLink: (text, href, title) {
                            if (href != null) {
                              launchUrl(Uri.parse(href));
                            }
                          },
                          styleSheet: MarkdownStyleSheet(
                            p: const TextStyle(fontSize: 16, color: Colors.black54),
                          ),
                        ),
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }

  Widget _buildSectionContent(String sectionTitle, dynamic sectionContent, GlobalKey sectionKey) {
  return sectionContent != null
      ? Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: ExpansionTile(
            key: sectionKey,
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
                          String itemTitle = item is Map ? item['title'] ?? '' : '';
                          String itemContent = item is Map ? item['content'] ?? '' : item.toString();
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (itemTitle.isNotEmpty)
                                  MarkdownBody(
                                    data: itemTitle,
                                    styleSheet: MarkdownStyleSheet(
                                      h2: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                                    ),
                                  ),
                                if (itemContent.isNotEmpty)
                                  MarkdownBody(
                                    data: itemContent,
                                    styleSheet: MarkdownStyleSheet(
                                      p: const TextStyle(fontSize: 16, color: Colors.black54),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }).toList(),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (sectionContent is Map && sectionContent['title'] != null)
                            MarkdownBody(
                              data: sectionContent['title'],
                              styleSheet: MarkdownStyleSheet(
                                h2: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                              ),
                            ),
                          if (sectionContent is Map && sectionContent['content'] != null)
                            MarkdownBody(
                              data: sectionContent['content'],
                              styleSheet: MarkdownStyleSheet(
                                p: const TextStyle(fontSize: 16, color: Colors.black54),
                              ),
                            ),
                        ],
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
    final RegExp urlRegex = RegExp(r'((https?|ftp)://[^\s/$.?#].[^\s]*)');
    final matches = urlRegex.allMatches(text);

    if (matches.isEmpty) {
      return Text(
        text,
        style: const TextStyle(fontSize: 16, color: Colors.black54),
      );
    }

    final List<TextSpan> textSpans = [];
    int lastMatchEnd = 0;

    for (final match in matches) {
      if (match.start > lastMatchEnd) {
        textSpans.add(TextSpan(text: text.substring(lastMatchEnd, match.start)));
      }

      final url = match.group(0);
      if (url != null) {
        textSpans.add(TextSpan(
          text: url,
          style: const TextStyle(color: Colors.blue),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              launchUrl(Uri.parse(url));
            },
        ));
      }

      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < text.length) {
      textSpans.add(TextSpan(text: text.substring(lastMatchEnd)));
    }

    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 16, color: Colors.black54),
        children: textSpans,
      ),
    );
  }
}
