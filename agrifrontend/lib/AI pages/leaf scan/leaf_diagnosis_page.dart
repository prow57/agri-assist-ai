import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:agrifrontend/AI%20pages/AI%20chat/AI_chat_page.dart';
import 'package:agrifrontend/AI%20pages/leaf%20scan/leaf_diagnosis_page.dart';
import 'package:agrifrontend/AI%20pages/personal%20advice/all_courses.dart';
import 'package:agrifrontend/AI%20pages/personal%20advice/personalized_advice_page.dart';
import 'package:agrifrontend/home/settings_page.dart';

class LeafAnalysisScreen extends StatefulWidget {
  const LeafAnalysisScreen({super.key});

  @override
  _LeafAnalysisScreenState createState() => _LeafAnalysisScreenState();
}

class _LeafAnalysisScreenState extends State<LeafAnalysisScreen> {
  File? _image;
  final ImagePicker picker = ImagePicker();
  Map<String, dynamic>? _result;
  bool _isLoading = false;
  String _errorMessage = '';
  int _selectedIndex = 0;

  Future<void> _pickImage() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          _result = null;
          _errorMessage = '';
          _isLoading = true;
        });
        await _analyzeImage(_image!);
      } else {
        setState(() {
          _errorMessage = 'No image selected';
        });
      }
    } catch (e, stackTrace) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error picking image: $e\n$stackTrace';
      });
    }
  }

  Future<void> _analyzeImage(File image) async {
    try {
      final bytes = await image.readAsBytes();
      final base64Image = base64Encode(bytes);

      final response = await http.post(
        Uri.parse('http://37.187.29.19:6932/analyze-leaf/'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"image": base64Image}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _result = data;
          _isLoading = false;
        });
      } else {
        setState(() {
          _result = null;
          _isLoading = false;
          _errorMessage = "Failed to get analysis: ${response.statusCode}";
        });
      }
    } catch (e, stackTrace) {
      setState(() {
        _result = null;
        _isLoading = false;
        _errorMessage = 'Error analyzing image: $e\n$stackTrace';
      });
    }
  }

  Future<void> _captureImage() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          _result = null;
          _errorMessage = '';
          _isLoading = true;
        });
        await _analyzeImage(_image!);
      } else {
        setState(() {
          _errorMessage = 'No image captured';
        });
      }
    } catch (e, stackTrace) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error capturing image: $e\n$stackTrace';
      });
    }
  }

  void _resetImage() {
    setState(() {
      _image = null;
      _result = null;
      _errorMessage = '';
    });
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;

      if (index == 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const AllCoursesPage(),
          ),
        );
      } else if (index == 1) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const PersonalizedAdvicePage(),
          ),
        );
      } else if (index == 2) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ChatPage(),
          ),
        );
      } else if (index == 3) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SettingsPage(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Leaf Diagnosis"),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "Capture or Select a Leaf Image",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              _buildImageSection(),
              const SizedBox(height: 20),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_result != null)
                _buildResultDisplay()
              else if (_errorMessage.isNotEmpty)
                _buildErrorDisplay(),
              const SizedBox(height: 20),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        selectedItemColor: Colors.green[800],
        unselectedItemColor: Colors.green[300],
        showUnselectedLabels: false,
        selectedLabelStyle:
            const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildImageSection() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(color: Colors.green, width: 2),
          ),
          height: 200,
          child: _image != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(_image!, fit: BoxFit.cover))
              : const Center(
                  child: Text(
                    'No image selected',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.image, color: Colors.green),
              iconSize: 50,
              onPressed: _isLoading ? null : _pickImage,
            ),
            const SizedBox(width: 20),
            IconButton(
              icon: const Icon(Icons.camera_alt, color: Colors.green),
              iconSize: 50,
              onPressed: _isLoading ? null : _captureImage,
            ),
            const SizedBox(width: 20),
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.green),
              iconSize: 50,
              onPressed: _isLoading ? null : _resetImage,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _isLoading
          ? null
          : () {
              if (_image != null) {
                _analyzeImage(_image!);
              } else {
                setState(() {
                  _errorMessage = 'Please select or capture an image first.';
                });
              }
            },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: const Text(
        "Submit",
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }

  Widget _buildResultDisplay() {
    final leafAnalysis = _result?['leaf_analysis'];
    final diseaseResearch = _result?['disease_research'];
    final guidanceGeneration = _result?['guidance_generation'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (leafAnalysis != null)
          _buildResultCard("Leaf Analysis", [
            _buildResultRow("Crop Type", leafAnalysis['crop_type']),
            _buildResultRow("Disease", leafAnalysis['disease_name']),
            _buildResultRow("Description", leafAnalysis['description']),
            _buildResultRow("Risk Level", leafAnalysis['level_of_risk']),
            _buildResultRow(
                "Infection Percentage", "${leafAnalysis['percentage'] ?? 0}%"),
            _buildResultRow(
                "Estimated Size", leafAnalysis['estimated_size']),
            _buildResultRow("Stage", leafAnalysis['stage']),
            const SizedBox(height: 10),
            const Text(
              "Symptoms:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...?leafAnalysis['symptoms']?.map<Widget>((symptom) =>
                Text("- $symptom")).toList(),
          ]),
        if (diseaseResearch != null)
          _buildResultCard("Disease Research", [
            const Text("Relevant Websites:"),
            ...?diseaseResearch['relevant_websites']?.map<Widget>(
                (website) => Text(website)).toList(),
            const Text("General Information:"),
            ...?diseaseResearch['general_information']?.map<Widget>(
                (info) => Text(info)).toList(),
            const Text("Recommended Treatments:"),
            ...?diseaseResearch['recommended_treatments']?.map<Widget>(
                (treatment) => Text("- $treatment")).toList(),
          ]),
        if (guidanceGeneration != null)
          _buildResultCard("Guidance Generation", [
            const Text("Treatment Steps:"),
            ...?guidanceGeneration['treatment_steps']?.map<Widget>(
                (step) => Text("- $step")).toList(),
            const Text("Ingredients:"),
            ...?guidanceGeneration['ingredients']?.map<Widget>(
                (ingredient) => Text("- $ingredient")).toList(),
          ]),
      ],
    );
  }

  Widget _buildResultCard(String title, List<Widget> content) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 10),
            ...content,
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            value ?? 'N/A',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorDisplay() {
    return Center(
      child: Text(
        _errorMessage,
        style: const TextStyle(fontSize: 14.0, color: Colors.red),
        textAlign: TextAlign.center,
      ),
    );
  }
}
