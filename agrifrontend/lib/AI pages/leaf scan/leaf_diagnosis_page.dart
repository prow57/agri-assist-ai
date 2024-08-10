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
  String? _result;
  bool _isLoading = false;
  String _errorMessage = '';

  // Method to pick image from gallery
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

  // Method to analyze the image by sending it to the server
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
        setState(() {
          _result = json.decode(response.body)['description'] ??
              'No description available';
          _isLoading = false;
        });
      } else {
        setState(() {
          _result = "Failed to get description: ${response.statusCode}";
          _isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      setState(() {
        _result = 'Error analyzing image: $e\n$stackTrace';
        _isLoading = false;
      });
    }
  }

  // Method to capture an image using the camera
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

  // Method to reset the image selection
  void _resetImage() {
    setState(() {
      _image = null;
      _result = null;
      _errorMessage = '';
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Capture a photo of the leaf",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.image, color: Colors.green),
                  iconSize: 50,
                  onPressed: _isLoading ? null : _pickImage,
                ),
                const SizedBox(width: 30),
                IconButton(
                  icon: const Icon(Icons.camera_alt, color: Colors.green),
                  iconSize: 50,
                  onPressed: _isLoading ? null : _captureImage,
                ),
                const SizedBox(width: 30),
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.green),
                  iconSize: 50,
                  onPressed: _isLoading ? null : _resetImage,
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Take a clear, in-focus photo. Ensure the leaf is centered\nand no part is cut off.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            if (_image != null) ...[
              Image.file(_image!, height: 200),
              const SizedBox(height: 20),
            ],
            _isLoading
                ? const CircularProgressIndicator()
                : _result == null
                    ? const Text("Awaiting analysis result...")
                    : Text(
                        "Analysis Result: $_result",
                        style: const TextStyle(fontSize: 18),
                      ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(fontSize: 14.0, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      if (_image != null) {
                        _analyzeImage(_image!);
                      } else {
                        setState(() {
                          _errorMessage =
                              'Please select or capture an image first.';
                        });
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                "Submit",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
