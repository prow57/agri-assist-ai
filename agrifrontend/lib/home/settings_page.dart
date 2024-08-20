import 'package:agrifrontend/AI%20pages/personal%20advice/all_courses.dart';
import 'package:agrifrontend/home/home_page.dart';
import 'package:agrifrontend/AI%20pages/personal%20advice/personalized_advice_page.dart'; // Import other necessary pages
import 'package:agrifrontend/theme_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _selectedIndex = 3; // Set the index to 1 for Settings

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
    bool isDarkMode = Provider.of<ThemeNotifier>(context).isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: isDarkMode,
              onChanged: (value) {
                Provider.of<ThemeNotifier>(context, listen: false).toggleTheme(value);
              },
            ),
          ),
        ],
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
