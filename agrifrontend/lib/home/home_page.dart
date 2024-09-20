import 'package:agrifrontend/AI%20pages/AI%20chat/AI_chat_page.dart';
import 'package:agrifrontend/AI%20pages/leaf%20scan/leaf_diagnosis_page.dart';
import 'package:agrifrontend/AI%20pages/personal%20advice/all_courses.dart';
import 'package:agrifrontend/AI%20pages/personal%20advice/personalized_advice_page.dart';
import 'package:agrifrontend/authentication/community_signin.dart';
import 'package:agrifrontend/home/settings_page.dart';
import 'package:agrifrontend/homepages/market/market_selection_page.dart';
import 'package:agrifrontend/homepages/weather/ui/weather_screen.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;

      if (index == 0) {
        // Already on the home page
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDarkMode ? Colors.black : Colors.white;
    final textColor = isDarkMode ? Colors.black : Colors.white;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/logo.png',
              height: 40,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 10),
            const Text(
              'AgriAssist-AI',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.notifications),
        //     onPressed: () {
        //       // Handle notifications
        //     },
        //   ),
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20.0),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                children: [
                  _buildCustomButton(
                    context,
                    icon: Icons.chat_bubble,
                    label: 'AI Chat',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChatPage(),
                        ),
                      );
                    },
                    iconColor: iconColor,
                    textColor: textColor,
                  ),
                  _buildCustomButton(
                    context,
                    icon: Icons.person,
                    label: 'Personalized AI',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PersonalizedAdvicePage(),
                        ),
                      );
                    },
                    iconColor: iconColor,
                    textColor: textColor,
                  ),
                  _buildCustomButton(
                    context,
                    icon: Icons.search,
                    label: 'Scan Leaf',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LeafAnalysisScreen(),
                        ),
                      );
                    },
                    iconColor: iconColor,
                    textColor: textColor,
                  ),
                  _buildCustomButton(
                    context,
                    icon: Icons.cloud,
                    label: 'Weather Forecast',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WeatherPage(),
                        ),
                      );
                    },
                    iconColor: iconColor,
                    textColor: textColor,
                  ),
                  _buildCustomButton(
                    context,
                    icon: Icons.attach_money,
                    label: 'Market',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MarketSelectionPage(),
                        ),
                      );
                    },
                    iconColor: iconColor,
                    textColor: textColor,
                  ),
                  _buildCustomButton(
                    context,
                    icon: Icons.group,
                    label: 'Community',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CommunitySignIn(),
                        ),
                      );
                    },
                    iconColor: iconColor,
                    textColor: textColor,
                  ),
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
            icon: Icon(Icons.book),
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.memory),
            label: 'Personalised AI',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        selectedItemColor: Colors.green[800],
        unselectedItemColor: Colors.green[300],
        showUnselectedLabels: true, // Ensure labels are always shown
        selectedLabelStyle:
            const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildCustomButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color iconColor,
    required Color textColor,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 8,
        shadowColor: Colors.grey.withOpacity(0.5),
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 60.0, color: iconColor),
          const SizedBox(height: 10.0),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
