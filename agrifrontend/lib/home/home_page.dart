// lib/home_page.dart
import 'package:agrifrontend/AI%20pages/leaf%20scan/leaf_diagnosis_page.dart';
import 'package:agrifrontend/AI%20pages/personal%20advice/personalized_advice_page.dart';
import 'package:agrifrontend/AI%20pages/soil%20scan/soil_diagnosis_page.dart';
import 'package:agrifrontend/homepages/market/market_place.dart';
import 'package:agrifrontend/homepages/weather/weather_forecasting.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 1) {
        _showChat(context);
      }
    });
  }

  void _showChat(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => const ChatPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.person, color: Colors.green),
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
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help),
            label: 'Help',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
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
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 5,
        padding: const EdgeInsets.symmetric(vertical: 20.0),
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

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Chat with AgriBot',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          Expanded(
            child: ListView(
              children: const [
                Text('Welcome! How can I assist you today?'),
                // Add more chat bubbles here
              ],
            ),
          ),
          TextField(
            decoration: InputDecoration(
              hintText: 'Type your message...',
              suffixIcon: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  // Handle send action
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
