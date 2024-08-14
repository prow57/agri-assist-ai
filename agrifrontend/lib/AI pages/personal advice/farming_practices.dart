// farming_practices_page.dart
import 'package:agrifrontend/AI%20pages/personal%20advice/practice_detail.dart';
import 'package:flutter/material.dart';
import 'practice_detail.dart';

class FarmingPracticesPage extends StatelessWidget {
  const FarmingPracticesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> farmingPractices = [
      {
        'name': 'Crop Rotation',
        'description':
            'Crop rotation is the practice of growing different types of crops in the same area in sequential seasons. It helps in improving soil fertility and controlling pests and diseases.'
      },
      {
        'name': 'Cover Cropping',
        'description':
            'Cover cropping involves growing certain plants during off-seasons to protect and enrich the soil. It helps prevent soil erosion, improve soil structure, and add nutrients to the soil.'
      },
      {
        'name': 'No-Till Farming',
        'description':
            'No-till farming is an agricultural technique that involves growing crops without disturbing the soil through tillage. This method helps conserve moisture, reduce erosion, and improve soil health.'
      },
      {
        'name': 'Integrated Pest Management',
        'description':
            'Integrated Pest Management (IPM) is a sustainable approach to managing pests by combining biological, cultural, physical, and chemical tools in a way that minimizes economic, health, and environmental risks.'
      },
      {
        'name': 'Agroforestry',
        'description':
            'Agroforestry is a land use management system where trees or shrubs are grown around or among crops or pastureland. It helps increase biodiversity, reduce erosion, and improve land productivity.'
      },
    ]; // List of practices with names and descriptions

    return Scaffold(
      appBar: AppBar(
        title: const Text('Farming Practices'),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: farmingPractices.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              title: Text(farmingPractices[index]['name']!),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PracticeDetailPage(
                      practiceName: farmingPractices[index]['name']!,
                      practiceDescription: farmingPractices[index]
                          ['description']!,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
