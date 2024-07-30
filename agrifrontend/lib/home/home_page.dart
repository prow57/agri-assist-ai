// lib/home_page.dart
import 'package:agrifrontend/AI%20pages/leaf%20scan/leaf_diagnosis_page.dart';
import 'package:agrifrontend/AI%20pages/soil%20scan/soil_diagnosis_page.dart';
import 'package:agrifrontend/AI%20pages/personal%20advice/personalized_advice_page.dart';
import 'package:agrifrontend/homepages/market/market_place.dart';
import 'package:agrifrontend/homepages/weather/weather_forecasting.dart';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon:
              const Icon(Icons.person, color: Color.fromARGB(255, 10, 10, 10)),
          onPressed: () {
            // Define your action here
          },
        ),
        title: const Text('OpenTechZ App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Greetings! Welcome to AgriAssist-AI.',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                children: [
                  CustomButton(
                      icon: Icons.search,
                      label: 'Scan Leaf',
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const LeafDiagnosisPage()));
                      }),
                  CustomButton(
                      icon: Icons.landscape,
                      label: 'Soil Detection',
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const SoilDiagnosisPage()));
                      }),
                  CustomButton(
                      icon: Icons.cloud,
                      label: 'Weather Forecast',
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const WeatherForecastPage()));
                      }),
                  CustomButton(
                      icon: Icons.attach_money,
                      label: 'Market Prices',
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MarketPlacePage()));
                      }),
                  CustomButton(
                      icon: Icons.person,
                      label: 'Personalized AI',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const PersonalizedAdvicePage()),
                        );
                      }),
                  CustomButton(
                      icon: Icons.settings,
                      label: 'Settings',
                      onPressed: () {}),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: '',
          ),
        ],
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 50.0, color: Colors.white),
          const SizedBox(height: 10.0),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
        ],
      ),
    );
  }
}
