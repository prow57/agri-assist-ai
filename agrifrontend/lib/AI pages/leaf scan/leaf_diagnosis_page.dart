import 'package:agrifrontend/AI%20pages/personal%20advice/all_courses.dart';
import 'package:agrifrontend/AI%20pages/personal%20advice/personalized_advice_page.dart';
import 'package:agrifrontend/home/home_page.dart';
import 'package:agrifrontend/home/settings_page.dart';
import 'package:flutter/material.dart';
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
  Map<String, dynamic>? _deepAnalysisResult; // To hold the deep analysis data
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
    _showSnackBar(message.contains('Timeout')
        ? 'Network issue. Please try again later.'
        : 'Error occurred.');
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
      const HomePage(), // Placeholder widgets for demo purposes
      const AllCoursesPage(),
      const PersonalizedAdvicePage(),
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
              },
            ),
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

  // Method for deep health analysis
  Future<void> _performDeepAnalysis() async {
    if (_image == null) return;

    try {
      setState(() => _isLoading = true);

      // Post the image to the deep analysis endpoint
      final response = await _postBase64Image(
          _image!, 'http://37.187.29.19:6932/analyze-leaf/');
      if (response.statusCode == 200) {
        setState(() {
          _deepAnalysisResult = json.decode(response.body)['leaf_analysis'];
          _isLoading = false;
        });
      } else {
        _showError("Failed to get deep analysis: ${response.statusCode}");
      }
    } catch (e, stackTrace) {
      _handleError('Error performing deep analysis: $e', stackTrace);
    }
  }

  // Building the health result card, now with a button for deep analysis
  Widget _buildHealthResultDisplay() {
    var disease = _result?['result']['disease']['suggestions']?.first;
    if (disease == null) return const SizedBox.shrink(); // Return if no result

    return Column(
      children: [
        Card(
          elevation: 5,
          margin: const EdgeInsets.symmetric(vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                      'Health Analysis Result',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text('Message: ${_result?['message'] ?? 'No message'}'),
                const SizedBox(height: 10),
                Text(
                    'Is Plant: ${_result?['result']['is_plant']['binary'] ? 'Yes' : 'No'}'),
                Text(
                    'Is Healthy: ${_result?['result']['is_healthy']['binary'] ? 'Yes' : 'No'}'),
                Text(
                    'Health Probability: ${(_result?['result']['is_healthy']['probability'] * 100).toStringAsFixed(2)}%'),
                const SizedBox(height: 10),
                const Text('Disease Detected:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Disease Name: ${disease['name'] ?? 'Unknown'}'),
                Text(
                    'Probability: ${(disease['probability'] * 100).toStringAsFixed(2)}%'),
                const SizedBox(height: 5),
                const Text('Similar Image:'),
                if (disease['similar_images']?.first['url'] != null)
                  Image.network(disease['similar_images'].first['url'],
                      height: 100, width: 100, fit: BoxFit.cover),
              ],
            ),
          ),
        ),
        ElevatedButton(
          onPressed:
              _performDeepAnalysis,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green), // Perform the deep analysis when pressed
          child: const Text("Get More Details", style: TextStyle(color: Colors.white),),
        ),
        if (_deepAnalysisResult != null) _buildDeepAnalysisCard(),
      ],
    );
  }

  // Function to build the deep analysis card
  Widget _buildDeepAnalysisCard() {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Deep Health Analysis',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const Divider(),
            _buildAnalysisRow('Crop Type', _deepAnalysisResult?['crop_type']),
            _buildAnalysisRow(
                'Disease Name', _deepAnalysisResult?['disease_name']),
            _buildAnalysisRow(
                'Risk Level', _deepAnalysisResult?['level_of_risk']),
            _buildAnalysisRow('Stage', _deepAnalysisResult?['stage']),
            const SizedBox(height: 10),
            const Text('Symptoms:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
                (_deepAnalysisResult?['symptoms'] as List<dynamic>).join(", ")),
            const SizedBox(height: 10),
            const Text('Image Feedback:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            _buildAnalysisRow(
                'Focus', _deepAnalysisResult?['image_feedback']['focus']),
            _buildAnalysisRow(
                'Distance', _deepAnalysisResult?['image_feedback']['distance']),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value ?? 'Unknown')),
        ],
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
        const SizedBox(height: 10),
        const Text(
          "Take a clear, focused photo. Ensure the leaf is centered and fully visible, with no parts cut off.",
          style: TextStyle(
            color: Colors.black54,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
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

  Widget _buildIdentificationResultDisplay() {
    var suggestion = _result?['result']['classification']['suggestions']?.first;
    if (suggestion == null)
      return const SizedBox.shrink(); // Return if no result

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
                  'Identification Result',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Tooltip(
              message: 'This is the overall message from the results',
              child: Text('Message: ${_result?['message'] ?? 'No message'}'),
            ),
            const SizedBox(height: 10),
            Tooltip(
              message: 'Name of the plant identified by the model',
              child: Text(
                'Plant Name: ${suggestion['name'] ?? 'Unknown'}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Tooltip(
              message:
                  'The probability score indicates the confidence of the model',
              child: Text(
                'Probability: ${(suggestion['probability'] * 100).toStringAsFixed(2)}%',
                style: TextStyle(
                  color: suggestion['probability'] > 0.5
                      ? Colors.green
                      : Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 5),
            const Text('Similar Image:'),
            if (suggestion['similar_images']?.first['url'] != null)
              GestureDetector(
                onTap: () {
                  _showImageDialog(suggestion['similar_images'].first['url']);
                },
                child: Image.network(
                  suggestion['similar_images'].first['url'],
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
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
                const Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 10),
                      Text('Analyzing the image, please wait...'),
                    ],
                  ),
                )
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
}
