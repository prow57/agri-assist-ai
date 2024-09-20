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
  final ImagePicker _picker = ImagePicker();
  Map<String, dynamic>? _result;
  String _errorMessage = '';
  bool _isLoading = false;
  bool _isHealthAnalysis = false;
  bool _isDeepAnalysisLoading = false;
  Map<String, dynamic>? _deepAnalysisResult;

  // Image Handling Logic
  Future<void> _handleImageSelection(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          _resetResults();
        });
        _showAnalysisChoiceDialog();
      } else {
        _showError('No image selected');
      }
    } catch (e, stackTrace) {
      _handleError('Error picking image: $e', stackTrace);
    }
  }

  // Analysis API call
  Future<void> _analyzeImage(File image, String endpoint) async {
    try {
      _setLoadingState(true);
      final response = await _uploadImage(image, endpoint);
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        setState(() {
          _result = data['data'];
          _isHealthAnalysis = endpoint.contains('health-analysis');
        });
        _showSnackBar('Analysis completed successfully.');
      } else {
        _showError('Failed to get analysis: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      _handleError('Error analyzing image: $e', stackTrace);
    } finally {
      _setLoadingState(false);
    }
  }

  Future<http.Response> _uploadImage(File image, String endpoint) async {
    final request = http.MultipartRequest('POST', Uri.parse(endpoint));
    request.files.add(await http.MultipartFile.fromPath('image', image.path));
    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }

  // Deep Health Analysis Logic
  Future<void> _performDeepHealthAnalysis() async {
    if (_image == null) return;
    try {
      _setDeepAnalysisLoadingState(true);
      final response = await _uploadImage(_image!, 'http://37.187.29.19:6932/analyze-leaf/');
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        setState(() {
          _deepAnalysisResult = data['leaf_analysis'];
        });
      } else {
        _showError('Failed to get deep health analysis: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      _handleError('Error performing deep health analysis: $e', stackTrace);
    } finally {
      _setDeepAnalysisLoadingState(false);
    }
  }

  // UI Feedback Handling
  void _showError(String message) {
    setState(() {
      _errorMessage = message;
    });
    _showSnackBar(message);
  }

  void _handleError(String message, StackTrace stackTrace) {
    _showError(message);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _resetResults() {
    _result = null;
    _deepAnalysisResult = null;
    _errorMessage = '';
  }

  // Loading State Management
  void _setLoadingState(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  void _setDeepAnalysisLoadingState(bool isLoading) {
    setState(() {
      _isDeepAnalysisLoading = isLoading;
    });
  }

  // Dialog to Choose Analysis Type
  void _showAnalysisChoiceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Choose Analysis Type", style: TextStyle(color: Colors.green)),
          content: const Text("Would you like to identify the plant or analyze its health?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Identify Plant", style: TextStyle(color: Colors.green)),
              onPressed: () {
                Navigator.of(context).pop();
                _isHealthAnalysis = false;
                _analyzeImage(_image!, 'https://agriback-plum.vercel.app/api/vision/identify');
              },
            ),
            TextButton(
              child: const Text("Analyze Health", style: TextStyle(color: Colors.green)),
              onPressed: () {
                Navigator.of(context).pop();
                _isHealthAnalysis = true;
                _analyzeImage(_image!, 'https://agriback-plum.vercel.app/api/vision/health-analysis');
              },
            ),
          ],
        );
      },
    );
  }

  // UI Widgets
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Leaf Diagnosis"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
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
            if (_isLoading) const Center(child: CircularProgressIndicator()) else if (_result != null) _buildResultDisplay(),
            if (_errorMessage.isNotEmpty) _buildErrorDisplay(),
            const SizedBox(height: 20),
            _buildActionButtons(),
            const SizedBox(height: 20),
            if (_isHealthAnalysis && _result != null) _buildDeepHealthAnalysisButton(),
            if (_deepAnalysisResult != null) _buildDeepAnalysisCard(),
          ],
        ),
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
          height: 250,
          width: double.infinity,
          child: _image != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(_image!, fit: BoxFit.cover),
                )
              : const Icon(Icons.image, color: Colors.grey, size: 100),
        ),
        if (_image != null)
          TextButton.icon(
            icon: const Icon(Icons.clear, color: Colors.red),
            label: const Text('Clear Image', style: TextStyle(color: Colors.red)),
            onPressed: _resetResults,
          ),
      ],
    );
  }

  Widget _buildResultDisplay() {
    if (_isHealthAnalysis) {
      return _buildHealthResultDisplay();
    } else {
      return _buildIdentificationResultDisplay();
    }
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
            const Text('Identification Results', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            for (var suggestion in suggestions)
              ListTile(
                title: Text(suggestion['plant_name'] ?? 'Unknown'),
                subtitle: Text('Probability: ${(suggestion['probability'] * 100).toStringAsFixed(2)}%'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthResultDisplay() {
    var healthStatus = _result?['health_status'] ?? {};
    var diseases = _result?['diseases'] ?? [];
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Health Analysis Results', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ListTile(
              title: Text('Plant Status: ${healthStatus['is_plant'] ? "Yes" : "No"}'),
              subtitle: Text('Health Probability: ${(healthStatus['healthy_probability'] * 100).toStringAsFixed(2)}%'),
            ),
            const SizedBox(height: 10),
            const Text('Diseases:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            for (var disease in diseases)
              ListTile(
                title: Text(disease['name'] ?? 'Unknown Disease'),
                subtitle: Text('Probability: ${(disease['probability'] * 100).toStringAsFixed(2)}%\nView similar images: ${disease['similar_images'][0]['url']}'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeepHealthAnalysisButton() {
    return ElevatedButton.icon(
      onPressed: _performDeepHealthAnalysis,
      icon: _isDeepAnalysisLoading ? const CircularProgressIndicator() : const Icon(Icons.medical_services_outlined, color: Colors.white),
      label: const Text('Do Deep Health Analysis', style: TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
    );
  }

  Widget _buildDeepAnalysisCard() {
    var deepAnalysis = _deepAnalysisResult ?? {};
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Deep Health Analysis Results', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ListTile(
              title: Text('Crop Type: ${deepAnalysis['crop_type']}'),
              subtitle: Text('Disease: ${deepAnalysis['disease_name'] ?? 'N/A'}\nRisk Level: ${deepAnalysis['level_of_risk'] ?? 'N/A'}'),
            ),
            const SizedBox(height: 10),
            const Text('Additional Details:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ListTile(
              title: Text('Stage: ${deepAnalysis['stage'] ?? 'N/A'}'),
              subtitle: Text('Estimated Size: ${deepAnalysis['estimated_size'] ?? 'N/A'}\nSymptoms: ${deepAnalysis['symptoms'] ?? 'N/A'}'),
            ),
            const SizedBox(height: 10),
            if (deepAnalysis['image_feedback'] != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Image Feedback:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ListTile(
                    title: Text('Focus: ${deepAnalysis['image_feedback']['focus']}'),
                    subtitle: Text('Distance: ${deepAnalysis['image_feedback']['distance']}'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorDisplay() {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text('Error: $_errorMessage', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: () => _handleImageSelection(ImageSource.camera),
          icon: const Icon(Icons.camera, color: Colors.white),
          label: const Text('Camera', style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        ),
        ElevatedButton.icon(
          onPressed: () => _handleImageSelection(ImageSource.gallery),
          icon: const Icon(Icons.photo, color: Colors.white),
          label: const Text('Gallery', style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        ),
      ],
    );
  }
}
