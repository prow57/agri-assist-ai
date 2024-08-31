import 'package:agrifrontend/AI%20pages/AI%20chat/AI_chat_page.dart';
import 'package:agrifrontend/AI%20pages/personal%20advice/all_courses.dart';
import 'package:agrifrontend/AI%20pages/personal%20advice/personalized_advice_page.dart';
import 'package:agrifrontend/home/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class LeafAnalysisScreen extends StatefulWidget {
  const LeafAnalysisScreen({super.key});

  @override
  _LeafAnalysisScreenState createState() => _LeafAnalysisScreenState();
}

class _LeafAnalysisScreenState extends State<LeafAnalysisScreen> {
  File? _image;
  final ImagePicker picker = ImagePicker();
  Map<String, dynamic>? _result; // Stores the result as a Map
  bool _isLoading = false;
  String _errorMessage = '';
  int _selectedIndex = 0;
  bool _isPremiumUser = false;

  Future<void> _handleImage(ImageSource source) async {
    try {
      final pickedFile = await picker.pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          _result = null;
          _errorMessage = '';
        });
        if (_isPremiumUser) {
          _showAnalysisChoiceDialog();
        } else {
          await _analyzeImage(
              _image!, 'http://37.187.29.19:6932/analyze-leaf/');
        }
      } else {
        _showError('No image selected');
      }
    } catch (e, stackTrace) {
      _handleError('Error picking image: $e', stackTrace);
    }
  }

  Future<void> _analyzeImage(File image, String endpoint) async {
    try {
      setState(() => _isLoading = true);

      http.Response response;

      if (_isPremiumUser && _isPremiumEndpoint(endpoint)) {
        response = await _uploadImage(image, endpoint);
      } else {
        response = await _postBase64Image(image, endpoint);
      }

      _handleResponse(response, endpoint);
    } catch (e, stackTrace) {
      _handleError('Error analyzing image: $e', stackTrace);
    }
  }

  Future<http.Response> _uploadImage(File image, String endpoint) async {
    final request = http.MultipartRequest('POST', Uri.parse(endpoint));
    request.files.add(await http.MultipartFile.fromPath('image', image.path));
    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }

  Future<http.Response> _postBase64Image(File image, String endpoint) async {
    final bytes = await image.readAsBytes();
    final base64Image = base64Encode(bytes);

    return await http.post(
      Uri.parse(endpoint),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"image": base64Image}),
    );
  }

  void _handleResponse(http.Response response, String endpoint) {
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;

      setState(() {
        _result = data;
        _isLoading = false;
      });
      _showSnackBar('Analysis completed successfully.');
      if (!_isPremiumUser) _showUpgradePrompt();
    } else {
      _showError("Failed to get analysis: ${response.statusCode}");
    }
  }

  void _handleError(String message, StackTrace stackTrace) {
    setState(() {
      _result = null;
      _isLoading = false;
      _errorMessage = message;
    });
    _showSnackBar('Error occurred.');
  }

  bool _isPremiumEndpoint(String endpoint) {
    return endpoint.contains('identify') ||
        endpoint.contains('health-analysis');
  }

  void _showError(String message) {
    setState(() => _errorMessage = message);
    _showSnackBar(message);
  }

  void _showUpgradePrompt() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Upgrade to Premium'),
        content: const Text(
          'Upgrade to premium to access more detailed analysis features and exclusive content.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Go Premium'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
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

    setState(() => _selectedIndex = index);

    final pages = [
      const AllCoursesPage(),
      const PersonalizedAdvicePage(),
      const ChatPage(),
      SettingsPage(),
    ];

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => pages[index]),
    );
  }

  void _showAnalysisChoiceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Choose Analysis Type"),
          content: const Text(
              "Would you like to identify the plant or analyze its health?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Identify Plant"),
              onPressed: () {
                Navigator.of(context).pop();
                _analyzeImage(_image!,
                    'https://agriback-plum.vercel.app/api/vision/identify');
              },
            ),
            TextButton(
              child: const Text("Analyze Health"),
              onPressed: () {
                Navigator.of(context).pop();
                _analyzeImage(_image!,
                    'https://agriback-plum.vercel.app/api/vision/health-analysis');
              },
            ),
          ],
        );
      },
    );
  }

  void _togglePremiumStatus() {
    setState(() => _isPremiumUser = true);
    _showSnackBar('You are now a premium user!');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Leaf Diagnosis"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.star, color: Colors.yellow),
            onPressed: _togglePremiumStatus,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "Capture or Select a Leaf Image",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              _buildImageSection(),
              const SizedBox(height: 20),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_result != null)
                _isPremiumUser
                    ? _buildPremiumResultDisplay()
                    : _buildResultDisplay()
              else if (_errorMessage.isNotEmpty)
                _buildErrorDisplay(),
              const SizedBox(height: 20),
              _buildActionButtons(),
              if (_isPremiumUser) ...[
                const SizedBox(height: 20),
                _buildSubmitButton(),
              ],
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
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(2, 4),
              ),
            ],
            border: Border.all(color: Colors.green, width: 2),
          ),
          height: 250,
          width: double.infinity,
          child: _image != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    _image!,
                    fit: BoxFit.cover,
                  ),
                )
              : const Icon(
                  Icons.image,
                  color: Colors.grey,
                  size: 100,
                ),
        ),
        if (_image != null)
          TextButton.icon(
            icon: const Icon(Icons.clear, color: Colors.red),
            label: const Text(
              'Clear Image',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: _resetImage,
          ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: () => _handleImage(ImageSource.camera),
          icon: const Icon(Icons.camera, color: Colors.white),
          label: const Text(
            'Camera',
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => _handleImage(ImageSource.gallery),
          icon: const Icon(Icons.photo, color: Colors.white),
          label: const Text(
            'Gallery',
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
          ),
        ),
      ],
    );
  }

Widget _buildResultDisplay() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Analysis Results:',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 10),
      _result != null
          ? MarkdownBody(
              data: _result?['result'] ?? 'No results available',
              styleSheet: MarkdownStyleSheet(
                p: TextStyle(fontSize: 16),
                h1: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                h2: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                // Add more style customization if needed
              ),
            )
          : const Text(
              'No results available',
              style: TextStyle(fontSize: 16),
            ),
    ],
  );
}


  Widget _buildPremiumResultDisplay() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Premium Analysis Results:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(_result.toString(), style: const TextStyle(fontSize: 16)),
        // Example: Adding an additional chart or detailed info here for premium users
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () {
            // Navigate to additional insights or advice page
          },
          icon: const Icon(Icons.insights),
          label: const Text('View Additional Insights'),
        ),
      ],
    );
  }

  Widget _buildErrorDisplay() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
        ),
        const SizedBox(height: 10),
        Text(_errorMessage,
            style: const TextStyle(fontSize: 16, color: Colors.red)),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton.icon(
      onPressed: () {
        // Submit for expert analysis or further action
      },
      icon: const Icon(Icons.send, color: Colors.white),
      label: const Text(
        'Submit for Expert Analysis',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
