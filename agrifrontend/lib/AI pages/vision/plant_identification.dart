import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button press
          },
        ),
        title: const Text("Results"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Plant identification",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Image.asset(
                  'assets/logo.png', // Replace with your image path
                  width: 60,
                  height: 60,
                ),
                const SizedBox(width: 16.0),
                const Column(
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
            const SizedBox(height: 16.0),
            _buildInfoRow(Icons.local_florist, "Common name", "Corn, Maize"),
            _buildInfoRow(Icons.nature, "Family", "Poaceae"),
            _buildInfoRow(Icons.event, "Life cycle", "Annual"),
            const SizedBox(height: 24.0),
            const Text(
              "Health assessment",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
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
            const CircleAvatar(
              backgroundImage: AssetImage(
                  'assets/logo.png'), // Replace with your profile image path
              radius: 20,
            ),
            const SizedBox(width: 8.0),
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
              icon: const Icon(Icons.mic),
              onPressed: () {
                // Handle mic button press
              },
            ),
            IconButton(
              icon: const Icon(Icons.send),
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
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Icon(icon, color: Colors.green),
          ),
          const SizedBox(width: 16.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(subtitle),
            ],
          ),
        ],
      ),
    );
  }
}
