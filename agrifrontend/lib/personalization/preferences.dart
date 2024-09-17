import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'CommunityPage.dart'; // Import CommunityPage

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  _PreferencesScreenState createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  String selectedFarmingType = '';
  List<String> selectedPreferences = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<String> farmingTypes = ['Crop Farming', 'Animal Farming', 'Both'];
  List<String> preferenceCategories = [
    'Irrigation',
    'Soil Management',
    'Pest Control',
    'Harvesting',
    'Marketing',
    'Agricultural Technology'
  ];

  Future<void> _savePreferences() async {
    if (selectedFarmingType.isEmpty || selectedPreferences.isEmpty) {
      setState(() {
        _errorMessage = 'Please select a farming type and at least one interest.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final url = Uri.parse('https://agriback-plum.vercel.app/set-preferences');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'phone': 'userPhone', // You might need to get this from user data
        'farming_type': selectedFarmingType,
        'interests': selectedPreferences,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        _isLoading = false;
      });
      // Navigate to Community Page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CommunityPage()),
      );
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error saving preferences. Please try again.';
      });
    }
  }

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
              const SizedBox(height: 20),
              const Text(
                'Personalize Your Experience',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Choose your farming type and interests to get customized content.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 30),

              // Type of Farming Section
              const Text(
                'Select Type of Farming',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),

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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 40),

              // Preferences Section
              const Text(
                'Select Your Interests',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),

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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 40),

              // Error Message
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              const SizedBox(height: 20),

              // Save Button
              Center(
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _savePreferences,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 80, vertical: 15),
                        ),
                        child: const Text(
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
