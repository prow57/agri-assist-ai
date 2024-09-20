// import library
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
  Map<String, dynamic>? _result;
  bool _isLoading = false;
  String _errorMessage = '';
  int _selectedIndex = 0;
  bool _isPremiumUser = true;
  bool _isHealthAnalysis = false;

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
        _result = data['data'];
        _isHealthAnalysis = endpoint.contains('health-analysis');
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
      const SettingsPage(),
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
                  _isHealthAnalysis = false;
                  _analyzeImage(_image!,
                      'https://agriback-plum.vercel.app/api/vision/identify');
                }),
            TextButton(
              child: const Text("Analyze Health"),
              onPressed: () {
                Navigator.of(context).pop();
                _isHealthAnalysis = true;
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Leaf Diagnosis"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.of(context).pop(),
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
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              _buildImageSection(),
              const SizedBox(height: 20),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_result != null)
                _isHealthAnalysis
                    ? _buildHealthResultDisplay()
                    : _buildIdentificationResultDisplay()
              else if (_errorMessage.isNotEmpty)
                _buildErrorDisplay(),
              const SizedBox(height: 20),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.memory),
            label: 'Personalised AI',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        selectedItemColor: Colors.green[800],
        unselectedItemColor: Colors.green[300],
        showUnselectedLabels: true, // Ensure labels are always shown
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

  Widget _buildIdentificationResultDisplay() {
    var suggestions = _result?['result']['classification']['suggestions'] ?? [];
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.eco, color: Colors.green, size: 30),
                SizedBox(width: 10),
                Text(
                  'Identification Results',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text('Message: ${_result?['message'] ?? 'No message'}'),
            const SizedBox(height: 10),
            for (var suggestion in suggestions)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Plant Name: ${suggestion['name'] ?? 'Unknown'}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Probability: ${(suggestion['probability'] * 100).toStringAsFixed(2)}%',
                    style: TextStyle(
                      color: suggestion['probability'] > 0.5
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text('Similar Images:'),
                  for (var image in suggestion['similar_images'])
                    GestureDetector(
                      onTap: () {
                        _showImageDialog(image['url']);
                      },
                      child: Text(
                        image['url'] ?? 'No image available',
                        style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  const Divider(thickness: 1, color: Colors.grey),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthResultDisplay() {
    var diseases = _result?['result']['disease']['suggestions'] ?? [];
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.health_and_safety, color: Colors.red, size: 30),
                SizedBox(width: 10),
                Text(
                  'Health Analysis Results',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text('Message: ${_result?['message'] ?? 'No message'}'),
            const SizedBox(height: 10),
            Text(
              'Is Plant: ${_result?['result']['is_plant']['binary'] ? 'Yes' : 'No'}',
              style: TextStyle(
                color: _result?['result']['is_plant']['binary']
                    ? Colors.green
                    : Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Is Healthy: ${_result?['result']['is_healthy']['binary'] ? 'Yes' : 'No'}',
              style: TextStyle(
                color: _result?['result']['is_healthy']['binary']
                    ? Colors.green
                    : Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Health Probability: ${(_result?['result']['is_healthy']['probability'] * 100).toStringAsFixed(2)}%',
              style: TextStyle(
                color: _result?['result']['is_healthy']['binary']
                    ? Colors.green
                    : Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            const Text('Diseases Detected:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            for (var disease in diseases)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Disease Name: ${disease['name'] ?? 'Unknown'}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Probability: ${(disease['probability'] * 100).toStringAsFixed(2)}%',
                    style: TextStyle(
                      color: disease['probability'] > 0.5
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text('Similar Images:'),
                  for (var image in disease['similar_images'])
                    GestureDetector(
                      onTap: () {
                        _showImageDialog(image['url']);
                      },
                      child: Text(
                        image['url'] ?? 'No image available',
                        style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  const Divider(thickness: 1, color: Colors.grey),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void _showImageDialog(String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: double.maxFinite,
            child: Image.network(imageUrl, fit: BoxFit.cover),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Close"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildErrorDisplay() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Error:',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
        ),
        const SizedBox(height: 10),
        Text(_errorMessage,
            style: const TextStyle(fontSize: 16, color: Colors.red)),
      ],
    );
  }
}
