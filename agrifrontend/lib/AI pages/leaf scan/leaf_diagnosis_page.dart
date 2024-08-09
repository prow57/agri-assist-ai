import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LeafDiagnosisPage extends StatefulWidget {
  const LeafDiagnosisPage({super.key});

  @override
  _LeafDiagnosisPageState createState() => _LeafDiagnosisPageState();
}

class _LeafDiagnosisPageState extends State<LeafDiagnosisPage> {
  String _description = '';
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          _isLoading = true;
          _description = '';
          _errorMessage = '';
        });
        final description = await _uploadImage(image);
        setState(() {
          _description = description;
          _isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error picking image: $e\n$stackTrace';
      });
    }
  }

  Future<String> _uploadImage(XFile image) async {
    try {
      final uri = Uri.parse('http://37.187.29.19:6932/analyze-leaf/');
      final bytes = await image.readAsBytes();
      final base64Image = base64Encode(bytes);
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'image': base64Image}),
      );
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse['description'] ?? 'No description available';
      } else {
        return 'Failed to get description: ${response.statusCode}';
      }
    } catch (e, stackTrace) {
      return 'Error uploading image: $e\n$stackTrace';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Leaf Diagnosis',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20.0),
              const Text(
                'Capture a photo of the leaf',
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.photo,
                        size: 50.0, color: Colors.green),
                    onPressed: () {
                      _pickImage(ImageSource.gallery);
                    },
                  ),
                  const SizedBox(width: 30.0),
                  IconButton(
                    icon: const Icon(Icons.camera_alt,
                        size: 50.0, color: Colors.green),
                    onPressed: () {
                      _pickImage(ImageSource.camera);
                    },
                  ),
                  const SizedBox(width: 30.0),
                  IconButton(
                    icon: const Icon(Icons.refresh,
                        size: 50.0, color: Colors.green),
                    onPressed: () {
                      setState(() {
                        _description = '';
                        _errorMessage = '';
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Take a clear, in-focus photo. Ensure the leaf is centered and no part is cut off.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0, color: Colors.black54),
                ),
              ),
              const SizedBox(height: 20.0),
              _isLoading
                  ? const CircularProgressIndicator()
                  : Column(
                      children: [
                        Text(
                          _description,
                          style: const TextStyle(
                              fontSize: 18.0, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                        if (_errorMessage.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              _errorMessage,
                              style: const TextStyle(
                                  fontSize: 14.0, color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                          ),
                      ],
                    ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _isLoading ? null : () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40.0, vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
