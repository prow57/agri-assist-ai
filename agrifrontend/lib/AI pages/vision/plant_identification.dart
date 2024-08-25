import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
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
        title: Text("Results"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Plant identification",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Image.asset(
                  'assets/logo.png', // Replace with your image path
                  width: 60,
                  height: 60,
                ),
                SizedBox(width: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Most likely match"),
                    Text(
                      "Zea mays",
                      style: TextStyle(color: Colors.green),
                    ),
                    Text("Corn"),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.0),
            _buildInfoRow(Icons.local_florist, "Common name", "Corn, Maize"),
            _buildInfoRow(Icons.nature, "Family", "Poaceae"),
            _buildInfoRow(Icons.event, "Life cycle", "Annual"),
            SizedBox(height: 24.0),
            Text(
              "Health assessment",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            _buildInfoRow(
                Icons.search, "Disease", "Ustilago maydis\nCorn smut"),
            _buildInfoRow(Icons.search, "Symptoms",
                "White to gray galls on leaves and stalks"),
            _buildInfoRow(Icons.assessment, "Severity", "Moderate"),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(
                  'assets/logo.png'), // Replace with your profile image path
              radius: 20,
            ),
            SizedBox(width: 8.0),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: "How can I help you?",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.mic),
              onPressed: () {
                // Handle mic button press
              },
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                // Handle send button press
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Icon(icon, color: Colors.green),
          ),
          SizedBox(width: 16.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(subtitle),
            ],
          ),
        ],
      ),
    );
  }
}
