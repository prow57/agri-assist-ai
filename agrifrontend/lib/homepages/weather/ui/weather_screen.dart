import 'dart:convert';
import 'package:agrifrontend/AI%20pages/personal%20advice/all_courses.dart';
import 'package:agrifrontend/AI%20pages/personal%20advice/personalized_advice_page.dart';
import 'package:agrifrontend/home/settings_page.dart';
import 'package:agrifrontend/homepages/weather/ui/detail_page.dart';
import 'package:agrifrontend/homepages/weather/ui/farmer_recommendation.dart';
import 'package:agrifrontend/homepages/weather/weather_forecasting.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final WeatherService _weatherService = WeatherService();
  Map<String, dynamic>? _weatherData;
  String _selectedCity = 'Lilongwe';
  bool _isLoading = true;
  int _selectedIndex = 0;
  final cacheManager = DefaultCacheManager();
  double _opacity = 1.0;

  bool _isPremiumUser = false; // Tracks if the user is a premium user

  @override
  void initState() {
    super.initState();
    _checkUserPremiumStatus(); // Check if user is premium
    _fetchWeatherWithAnimation();
  }

  void _checkUserPremiumStatus() {
    // Mock implementation to check if a user is premium
    // In real case, fetch this from a server or local storage
    setState(() {
      _isPremiumUser = false; // Default to free user
    });
  }

  void _fetchWeatherWithAnimation() async {
    setState(() {
      _opacity = 0.0;
    });

    await Future.delayed(
        const Duration(milliseconds: 300)); // Small delay for smooth animation

    await _fetchWeather();

    setState(() {
      _opacity = 1.0;
    });

    if (!_isPremiumUser) {
      _showPremiumPopup(); // Show popup if not a premium user
    }
  }

  Future<void> _fetchWeather() async {
    setState(() {
      _isLoading = true;
    });

    // Check if data is cached
    final fileInfo = await cacheManager.getFileFromCache(_selectedCity);

    if (fileInfo != null &&
        DateTime.now().difference(fileInfo.validTill).inMinutes < 30) {
      // Load cached data if it's not older than 30 minutes
      final jsonString = await fileInfo.file.readAsString();
      final json = jsonDecode(jsonString);
      _updateWeatherData(json);
    } else {
      // Fetch data from the network
      try {
        final data = await _weatherService.fetchWeather(_selectedCity);
        await cacheManager.putFile(
            _selectedCity, utf8.encode(jsonEncode(data)));
        _updateWeatherData(data);
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to load weather data: ${e.toString()}')),
        );
      }
    }
  }

  void _updateWeatherData(Map<String, dynamic> data) {
    setState(() {
      _weatherData = data;
      _isLoading = false;
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
      _fetchWeatherWithAnimation();
    }
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

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
            MaterialPageRoute(
                builder: (context) => const PersonalizedAdvicePage()),
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
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEEE, h:mm a').format(now);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Forecast',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green[700],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.location_on, color: Colors.white),
            onPressed: _selectLocation,
          ),
          if (_isPremiumUser)
            IconButton(
              icon: const Icon(Icons.star, color: Colors.yellow),
              onPressed: _onPremiumIconPressed,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : AnimatedOpacity(
              opacity: _opacity,
              duration: const Duration(milliseconds: 500),
              child: _weatherData != null
                  ? SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildCityAndDate(formattedDate),
                          const SizedBox(height: 20),
                          _buildCurrentWeather(),
                          const SizedBox(height: 20),
                          _buildWeatherDetails(),
                          const SizedBox(height: 20),
                          _buildWeatherForecast(), // Shows full or limited forecast
                          if (_isPremiumUser) ...[
                            const SizedBox(height: 20),
                            _buildFeatureButton("Get Farm Recommendations"),
                          ]
                        ],
                      ),
                    )
                  : const Center(child: Text('No weather data available')),
            ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildCityAndDate(String formattedDate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _selectedCity,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          formattedDate,
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentWeather() {
    return Row(
      children: [
        Image.network(
          'https:${_weatherData!['current']['condition']['icon']}',
          height: 120,
          width: 120,
          fit: BoxFit.cover,
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_weatherData!['current']['temp_c']}°C',
              style: const TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _weatherData!['current']['condition']['text'],
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.green[700]!, width: 1.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetails() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: _buildDetailWithIcon(
                  'assets/max-temp.png',
                  'Temp.',
                  '${_weatherData!['current']['feelslike_c']}°',
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: _buildDetailWithIcon(
                  'assets/heavyrain.png',
                  'Rain',
                  '${_weatherData!['current']['precip_mm']} mm',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: _buildDetailWithIcon(
                  'assets/sleet.png',
                  'UV index',
                  '${_weatherData!['current']['uv']}',
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: _buildDetailWithIcon(
                  'assets/windspeed.png',
                  'Air Quality',
                  _weatherData!['current']['air_quality'] != null
                      ? '${_weatherData!['current']['air_quality']['us-epa-index']}'
                      : 'N/A',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailWithIcon(String iconPath, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.green[700]!, width: 1.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            iconPath,
            height: 50, // Adjusted icon size
            width: 50,
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherForecast() {
    // Show all forecast data if user is premium, otherwise show only today
    final forecastDays = _isPremiumUser
        ? _weatherData!['forecast']['forecastday'] as List<dynamic>
        : [_weatherData!['forecast']['forecastday'][0]];

    final numberOfDays = forecastDays.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Weather Forecast',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 250,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: _buildForecast(forecastDays),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildForecast(List<dynamic> forecastDays) {
    if (forecastDays.isEmpty) {
      return [const Text('No forecast data available')];
    }

    return List<Widget>.generate(forecastDays.length, (index) {
      final dayForecast = forecastDays[index];
      final date = DateTime.parse(dayForecast['date']);
      final dayOfWeek = DateFormat('EEEE').format(date);

      return GestureDetector(
        onTap: () {
          _navigateToDetailPage(context, dayForecast);
        },
        child: SizedBox(
          width: 150,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    dayOfWeek,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 8),
                  Image.network(
                    'https:${dayForecast['day']['condition']['icon']}',
                    height: 100,
                    width: 100,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${dayForecast['day']['avgtemp_c']}°C',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Text(
                      '${dayForecast['day']['condition']['text']}',
                      style: const TextStyle(fontSize: 16),
                      // overflow: TextOverflow.fade,
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  void _navigateToDetailPage(
      BuildContext context, Map<String, dynamic> dayForecast) {
    Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          DetailPage(dayForecast: dayForecast),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        final tween = Tween(begin: begin, end: end);
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      },
    ));
  }

Widget _buildFeatureButton(String title) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FarmerRecommendationsPage(
            city: _selectedCity,
          ),
        ),
      );
    },
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8.0,
          ),
        ],
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}



  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
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
      selectedItemColor: Colors.green[800],
      unselectedItemColor: Colors.green[300],
      showUnselectedLabels: false,
      selectedLabelStyle:
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  void _onPremiumIconPressed() {
    if (!_isPremiumUser) {
      _showPremiumPopup();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You are already a premium user!')),
      );
    }
  }

  void _showPremiumPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Upgrade to Premium'),
          content: const Text(
              'Upgrade to premium to access the full weather forecast and more!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog without upgrading
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _upgradeToPremium();
              },
              child: const Text('Go Premium'),
            ),
          ],
        );
      },
    );
  }

  void _upgradeToPremium() {
    setState(() {
      _isPremiumUser = true; // Mark user as premium
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('You have upgraded to premium!')),
    );
  }
}
