import 'package:flutter/material.dart';
import 'package:agrifrontend/homepages/weather/weather_forecasting.dart';

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final WeatherService _weatherService = WeatherService();
  Map<String, dynamic>? _weatherData;
  String _selectedCity = 'Lilongwe';

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  void _fetchWeather() async {
    try {
      final data = await _weatherService.fetchWeather(_selectedCity);
      setState(() {
        _weatherData = data;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load weather data')),
      );
    }
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

    return List<Widget>.generate(7, (index) {
      final dayForecast = _weatherData!['forecast']['forecastday'][index];
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network('https:${dayForecast['day']['condition']['icon']}'),
              Text('Date: ${dayForecast['date']}'),
              Text('Temp: ${dayForecast['day']['avgtemp_c']}°C'),
              Text('Condition: ${dayForecast['day']['condition']['text']}'),
            ],
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
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
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: _weatherData != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Section
                    Text(
                      _selectedCity,
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Mon, September 16 14:15',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Image.network(
                          'https:${_weatherData!['current']['condition']['icon']}',
                          width: 50,
                        ),
                        SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${_weatherData!['current']['temp_c']}°',
                              style: TextStyle(fontSize: 50),
                            ),
                            Text(
                              _weatherData!['current']['condition']['text'],
                              style:
                                  TextStyle(fontSize: 20, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Weather Details Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text('Feels like'),
                            Text('${_weatherData!['current']['feelslike_c']}°'),
                          ],
                        ),
                        Column(
                          children: [
                            Text('Precipitation'),
                            Text('${_weatherData!['current']['precip_mm']} mm'),
                          ],
                        ),
                        Column(
                          children: [
                            Text('UV index'),
                            Text('${_weatherData!['current']['uv']}'),
                          ],
                        ),
                        Column(
                          children: [
                            Text('Air Quality'),
                            Text(_weatherData!['current']['air_quality'] != null
                                ? '${_weatherData!['current']['air_quality']['us-epa-index']}'
                                : 'N/A'),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Forecast Section
                    Text(
                      '7-Day Weather Forecast',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: _buildForecast(),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Recommendations Section
                    Text(
                      'Farmer Recommendations',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(_getRecommendation(
                        _weatherData!['current']['condition']['text'])),
                  ],
                )
              : Center(
                  child:
                      CircularProgressIndicator()), // Show loading spinner while fetching data
        ),
      ),
    );
  }
}
