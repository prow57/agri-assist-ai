import 'package:agrifrontend/AI%20pages/vision/plant_identification.dart';
import 'package:flutter/material.dart';
import 'package:agrifrontend/AI%20pages/vision/chat_page.dart';

class UploadImagePage extends StatelessWidget {
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
            child:
                Image.asset('assets/logo.png'), // Replace with your image path
          ),
          // Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle Identify button press
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ResultPage()));
                  },
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
