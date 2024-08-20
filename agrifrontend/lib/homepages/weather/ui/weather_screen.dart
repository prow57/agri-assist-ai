import 'package:agrifrontend/AI%20pages/personal%20advice/all_courses.dart';
import 'package:agrifrontend/AI%20pages/personal%20advice/personalized_advice_page.dart';
import 'package:agrifrontend/home/settings_page.dart';
import 'package:agrifrontend/homepages/weather/weather_forecasting.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:agrifrontend/homepages/weather/ui/detail_page.dart';

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final WeatherService _weatherService = WeatherService();
  Map<String, dynamic>? _weatherData;
  String _selectedCity = 'Lilongwe';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  void _fetchWeather() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final data = await _weatherService.fetchWeather(_selectedCity);
      setState(() {
        _weatherData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load weather data: ${e.toString()}')),
      );
    }
  }

// code for bottom navigation bar
   int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return; // Ignore tap if already on the selected tab

    setState(() {
      _selectedIndex = index;

      if (index == 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const AllCoursesPage(),
          ),
        );
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


  void _selectLocation() async {
    final List<String> locations = ['Zomba', 'Mzuzu', 'Blantyre', 'Lilongwe'];

    final String? selectedLocation = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select a location'),
          children: locations.map((String location) {
            return SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, location);
              },
              child: Text(location),
            );
          }).toList(),
        );
      },
    );

    if (selectedLocation != null && selectedLocation != _selectedCity) {
      setState(() {
        _selectedCity = selectedLocation;
      });
      _fetchWeather();
    }
  }

  List<Widget> _buildForecast() {
    if (_weatherData == null || _weatherData!['forecast'] == null) {
      return [Text('No forecast data available')];
    }

    final forecastDays = _weatherData!['forecast']['forecastday'] as List<dynamic>;
    final numberOfDays = forecastDays.length;

    return List<Widget>.generate(numberOfDays, (index) {
      final dayForecast = forecastDays[index];
      final date = DateTime.parse(dayForecast['date']);
      final dayOfWeek = DateFormat('EEEE').format(date);

      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailPage(dayForecast: dayForecast),
            ),
          );
        },
        child: SizedBox(
          width: 150, // Set a fixed width for the forecast cards
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    dayOfWeek,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Image.network(
                    'https:${dayForecast['day']['condition']['icon']}',
                    height: 100,
                    width: 100,
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${dayForecast['day']['avgtemp_c']}°C',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${dayForecast['day']['condition']['text']}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  String _getRecommendation(String condition) {
    if (condition.contains('rain')) {
      return 'It is likely to rain. Ensure your crops have proper drainage.';
    } else if (condition.contains('sunny')) {
      return 'It will be sunny. Consider watering your crops early in the morning or late in the evening.';
    } else {
      return 'Weather is stable. Regular farming activities can continue.';
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEEE, h:mm a').format(now);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Weather Page',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.location_on, color: Colors.white),
            onPressed: _selectLocation,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _weatherData != null
              ? SingleChildScrollView(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedCity,
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        formattedDate,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 150,
                            width: 150,
                            child: Image.network(
                              'https:${_weatherData!['current']['condition']['icon']}',
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${_weatherData!['current']['temp_c']}°',
                                  style: TextStyle(fontSize: 50),
                                ),
                                Text(
                                  _weatherData!['current']['condition']['text'],
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildDetailBox('Temp.',
                              '${_weatherData!['current']['feelslike_c']}°'),
                          _buildDetailBox('Rain',
                              '${_weatherData!['current']['precip_mm']} mm'),
                          _buildDetailBox(
                              'UV index', '${_weatherData!['current']['uv']}'),
                          _buildDetailBox(
                            'Air Quality',
                            _weatherData!['current']['air_quality'] != null
                                ? '${_weatherData!['current']['air_quality']['us-epa-index']}'
                                : 'N/A',
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Weather Forecast',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 250, // Set a fixed height for the forecast list
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: _buildForecast(),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Farmer Recommendations',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(_getRecommendation(
                          _weatherData!['current']['condition']['text'])),
                    ],
                  ),
                )
              : Center(child: Text('No weather data available')),

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

  Widget _buildDetailBox(String label, String value) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.lightGreen[100],
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.green, width: 1.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
