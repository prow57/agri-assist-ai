import 'package:flutter/material.dart';
import 'package:agrifrontend/personalization/CommunityPage.dart'; // Import CommunityPage

class PreferencesScreen extends StatefulWidget {
  @override
  _PreferencesScreenState createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  String selectedFarmingType = '';
  List<String> selectedPreferences = [];

  List<String> farmingTypes = ['Crop Farming', 'Animal Farming', 'Both'];
  List<String> preferenceCategories = [
    'Irrigation',
    'Soil Management',
    'Pest Control',
    'Harvesting',
    'Marketing',
    'Agricultural Technology'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                'Personalize Your Experience',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Choose your farming type and interests to get customized content.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 30),

              // Type of Farming Section
              Text(
                'Select Type of Farming',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),

              // Farming Type Buttons
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: farmingTypes.map((type) {
                  return ChoiceChip(
                    label: Text(
                      type,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: selectedFarmingType == type
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    selected: selectedFarmingType == type,
                    onSelected: (bool selected) {
                      setState(() {
                        selectedFarmingType = selected ? type : '';
                      });
                    },
                    selectedColor: Colors.green,
                    backgroundColor: Colors.grey[200],
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 40),

              // Preferences Section
              Text(
                'Select Your Interests',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),

              // Preferences Buttons
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: preferenceCategories.map((preference) {
                  return FilterChip(
                    label: Text(
                      preference,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: selectedPreferences.contains(preference)
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    selected: selectedPreferences.contains(preference),
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          selectedPreferences.add(preference);
                        } else {
                          selectedPreferences.remove(preference);
                        }
                      });
                    },
                    selectedColor: Colors.green,
                    backgroundColor: Colors.grey[200],
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 40),

              // Save Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to Community Page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommunityPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  ),
                  child: Text(
                    'Save Preferences',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
