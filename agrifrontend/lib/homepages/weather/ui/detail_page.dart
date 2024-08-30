import 'package:agrifrontend/AI%20pages/personal%20advice/all_courses.dart';
import 'package:agrifrontend/AI%20pages/personal%20advice/personalized_advice_page.dart';
import 'package:agrifrontend/home/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailPage extends StatefulWidget {
  final Map<String, dynamic> dayForecast;

  DetailPage({required this.dayForecast});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return; // Ignore tap if already on the selected tab

    setState(() {
      _selectedIndex = index;

      switch (index) {
        case 0:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AllCoursesPage()),
          );
          break;
        case 1:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AllCoursesPage()),
          );
          break;
        case 2:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const PersonalizedAdvicePage()),
          );
          break;
        case 3:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SettingsPage()),
          );
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final date = DateTime.parse(widget.dayForecast['date']);
    final dayOfWeek = DateFormat('EEEE').format(date);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          dayOfWeek,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                'https:${widget.dayForecast['day']['condition']['icon']}',
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 10),
              Text(
                '${widget.dayForecast['day']['avgtemp_c']}°C',
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '${widget.dayForecast['day']['condition']['text']}',
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.separated(
                  itemCount: 7,
                  separatorBuilder: (context, index) =>
                      Divider(height: 16.0, color: Colors.grey[300]),
                  itemBuilder: (context, index) {
                    final details = [
                      ['Maximum Temperature', '${widget.dayForecast['day']['maxtemp_c']}°C', 'assets/max-temp.png'],
                      ['Minimum Temperature', '${widget.dayForecast['day']['mintemp_c']}°C', 'assets/fog.png'],
                      ['Humidity', '${widget.dayForecast['day']['avghumidity']}%', 'assets/humidity.png'],
                      ['Wind Speed', '${widget.dayForecast['day']['maxwind_kph']} kph', 'assets/windspeed.png'],
                      ['Precipitation', '${widget.dayForecast['day']['totalprecip_mm']} mm', 'assets/heavyrain.png'],
                      ['Sunrise', '${widget.dayForecast['astro']['sunrise']}', 'assets/clear.png'],
                      ['Sunset', '${widget.dayForecast['astro']['sunset']}', 'assets/sunset.png'],
                    ];
                    return _buildDetailBox(details[index][0], details[index][1], details[index][2]);
                  },
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
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
            icon: Icon(Icons.person),
            label: 'AI',
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

  Widget _buildDetailBox(String label, String value, String iconPath) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.lightGreen[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green, width: 1.0),
      ),
      child: Row(
        children: [
          Image.asset(
            iconPath,
            height: 24,
            width: 24,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
