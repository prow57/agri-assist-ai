import 'package:agrifrontend/AI%20pages/AI%20chat/ai_chat_page.dart';
import 'package:agrifrontend/AI%20pages/leaf%20scan/leaf_diagnosis_page.dart';
import 'package:agrifrontend/AI%20pages/personal%20advice/all_courses.dart';
import 'package:agrifrontend/AI%20pages/personal%20advice/personalized_advice_page.dart';
import 'package:agrifrontend/AI%20pages/soil%20scan/soil_diagnosis_page.dart';
import 'package:agrifrontend/home/settings_page.dart';
import 'package:agrifrontend/homepages/market/market_place.dart';
import 'package:agrifrontend/homepages/market/market_selection_page.dart';
import 'package:agrifrontend/homepages/weather/ui/weather_screen.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Add this property to track the selected index

   void _onItemTapped(int index) {
    if (index == _selectedIndex) return; // Ignore tap if already on the selected tab

    setState(() {
      _selectedIndex = index;

      if (index == 0) {
        //Already in home page
      } else if (index == 1) {
          Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const AllCoursesPage(),
          ),
        );
      } else if (index == 2) {
          Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const PersonalizedAdvicePage(),
          ),
        );
      } else if (index == 3) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SettingsPage(),
          ),
        );
      }
    });
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
                                    const LeafAnalysisScreen()));
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
                                builder: (context) => WeatherPage()));
                      }),
                  CustomButton(
                      icon: Icons.attach_money,
                      label: 'Market Prices',
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MarketSelectionPage()));
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
                      icon: Icons.chat_bubble,
                      label: 'AI chat',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ChatPage()),
                        );
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
       bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Set the current index
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
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
