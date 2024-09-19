import 'package:agrifrontend/personalization/preferences.dart';
import 'package:flutter/material.dart';

class SelectLanguageScreen extends StatelessWidget {
  const SelectLanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Section
              Image.asset('assets/images/logo.png', height: 100),
              const SizedBox(height: 50),

              
              const Text(
                'Select Language',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 50),

              // English Button
              ElevatedButton(
                onPressed: () {
                  // Set language to English and navigate to the next screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PreferencesScreen(phone: null,)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Assuming green is your primary color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                ),
                child: const Text(
                  'English',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Chichewa Button
              ElevatedButton(
                onPressed: () {
                  // Set language to Chichewa and navigate to the next screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Assuming green is your primary color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                ),
                child: const Text(
                  'Chichewa',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Additional Spacing or Branding Message (if needed)
            ],
          ),
        ),
      ),
    );
  }
}
