import 'package:agrifrontend/AI%20pages/AI%20chat/AI_chat_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:agrifrontend/AI%20pages/vision/plant_identification.dart';

class UploadImagePage extends StatefulWidget {
  @override
  _UploadImagePageState createState() => _UploadImagePageState();
}

class _UploadImagePageState extends State<UploadImagePage> {
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _identifyImage() async {
    if (_image != null) {
      var request = http.MultipartRequest('POST', Uri.parse('YOUR_BACKEND_URL_HERE'));
      request.files.add(await http.MultipartFile.fromPath('image', _image!.path));

      var response = await request.send();

      if (response.statusCode == 200) {
        // Handle the response from the backend
        Navigator.push(context, MaterialPageRoute(builder: (context) => ResultPage()));
      } else {
        // Handle error
        print('Failed to identify the image');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button press
          },
        ),
        title: Text("Upload Image"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image display
          Expanded(
            child: _image == null
                ? Image.asset('assets/logo.png') // Replace with your image path
                : Image.file(_image!),
          ),
          // Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_image == null) // Show Choose Image button only if no image is selected
                  ElevatedButton(
                    onPressed: _pickImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Button background color
                      minimumSize: Size(double.infinity, 60), // Increase height
                    ),
                    child: Text("Choose Image"),
                  ),
                SizedBox(height: 8.0),
                ElevatedButton(
                  onPressed: _identifyImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Button background color
                    minimumSize: Size(double.infinity, 60), // Increase height
                  ),
                  child: Text("Identify"),
                ),
                SizedBox(height: 8.0),
                ElevatedButton(
                  onPressed: () {
                    // Handle Health Analysis button press
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.grey[200], // Button background color
                    minimumSize: Size(double.infinity, 60), // Increase height
                  ),
                  child: Text("Health Analysis"),
                ),
                SizedBox(height: 8.0),
                ElevatedButton(
                  onPressed: () {
                    // Handle Ask Agri-Assist-AI button press
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ChatPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Button background color
                    minimumSize: Size(double.infinity, 60), // Increase height
                  ),
                  child: Text("Ask Agri-Assist-AI"),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.0),
        ],
      ),
    );
  }
}
