import 'package:flutter/material.dart';

class ScanHistoryPage extends StatelessWidget {
  // Sample data categorized into different scan types
  final Map<String, List<Map<String, String>>> scanCategories = {
    "Healthy Scans": [
      {
        "plantName": "Zea mays",
        "commonName": "Corn",
        "disease": "None",
        "date": "Aug 25, 2024",
      },
    ],
    "Diseased Scans": [
      {
        "plantName": "Solanum lycopersicum",
        "commonName": "Tomato",
        "disease": "Blight",
        "date": "Aug 20, 2024",
      },
      {
        "plantName": "Cucumis sativus",
        "commonName": "Cucumber",
        "disease": "Powdery Mildew",
        "date": "Aug 18, 2024",
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan History"),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: scanCategories.keys.length,
        itemBuilder: (context, index) {
          final category = scanCategories.keys.elementAt(index);
          final scans = scanCategories[category]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  category,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
              ...scans.map((scan) {
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text(scan["plantName"]!),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Common Name: ${scan['commonName']}"),
                        Text("Disease: ${scan['disease']}"),
                        Text("Date: ${scan['date']}"),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailedResultPage(scan: scan),
                        ),
                      );
                    },
                  ),
                );
              }).toList(),
            ],
          );
        },
      ),
    );
  }
}

class DetailedResultPage extends StatelessWidget {
  final Map<String, String> scan;

  const DetailedResultPage({required this.scan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan Details"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              scan["plantName"]!,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            _buildInfoRow(Icons.local_florist, "Common Name", scan["commonName"]!),
            _buildInfoRow(Icons.nature, "Disease", scan["disease"]!),
            _buildInfoRow(Icons.date_range, "Date Scanned", scan["date"]!),
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
