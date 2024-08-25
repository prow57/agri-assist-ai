import 'package:flutter/material.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

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
                children: farmingTypes.map((type) {
                  return ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedFarmingType = type;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedFarmingType == type
                          ? Colors.blue
                          : Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    child: Text(
                      type,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
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
                  return ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (selectedPreferences.contains(preference)) {
                          selectedPreferences.remove(preference);
                        } else {
                          selectedPreferences.add(preference);
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedPreferences.contains(preference)
                          ? Colors.blue
                          : Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    child: Text(
                      preference,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  );
                }).toList(),
              ),

              SizedBox(height: 40),

              // Save Button
              ElevatedButton(
                onPressed: () {
                  // Save preferences and navigate to the next screen
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
            ],
          ),
        ),
      ),
    );
  }
}
