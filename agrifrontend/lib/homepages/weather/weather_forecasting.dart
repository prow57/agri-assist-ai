import 'package:flutter/material.dart';

class WeatherForecastPage extends StatelessWidget {
  const WeatherForecastPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Forecast'),
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CurrentWeather(
                location: 'Lilongwe',
                temperature: '28°C',
                condition: 'Sunny',
                icon: Icons.wb_sunny,
                high: '30°C',
                low: '20°C',
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Today\'s Hourly Forecast',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10.0),
              HourlyForecast(),
              const SizedBox(height: 20.0),
              WeatherCard(
                day: 'Yesterday',
                temperature: '25°C',
                condition: 'Sunny',
                icon: Icons.wb_sunny,
                suggestion:
                    'Yesterday was sunny. Today’s irrigation can be reduced to conserve water.',
              ),
              const SizedBox(height: 10.0),
              WeatherCard(
                day: 'Today',
                temperature: '28°C',
                condition: 'Partly Cloudy',
                icon: Icons.cloud_queue,
                suggestion:
                    'Today is partly cloudy. Good day for fertilizing and checking for pests.',
              ),
              const SizedBox(height: 10.0),
              WeatherCard(
                day: 'Tomorrow',
                temperature: '30°C',
                condition: 'Rainy',
                icon: Icons.grain,
                suggestion:
                    'Tomorrow is expected to be rainy. Prepare for drainage and check the irrigation system.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CurrentWeather extends StatelessWidget {
  final String location;
  final String temperature;
  final String condition;
  final IconData icon;
  final String high;
  final String low;

  const CurrentWeather({
    required this.location,
    required this.temperature,
    required this.condition,
    required this.icon,
    required this.high,
    required this.low,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              location,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 40.0,
                  color: Colors.orangeAccent,
                ),
                const SizedBox(width: 10.0),
                Text(
                  temperature,
                  style: const TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text(
              condition,
              style: const TextStyle(fontSize: 20.0),
            ),
            Text(
              'High: $high, Low: $low',
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}

class HourlyForecast extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(6, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                Text(
                  '${index + 12} PM',
                  style: const TextStyle(fontSize: 16.0),
                ),
                Icon(
                  Icons.wb_sunny,
                  color: Colors.orangeAccent,
                  size: 30.0,
                ),
                Text(
                  '28°C',
                  style: const TextStyle(fontSize: 16.0),
                ),
                Text(
                  '0%',
                  style: const TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class WeatherCard extends StatelessWidget {
  final String day;
  final String temperature;
  final String condition;
  final IconData icon;
  final String suggestion;

  const WeatherCard({
    required this.day,
    required this.temperature,
    required this.condition,
    required this.icon,
    required this.suggestion,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 40.0,
                  color: Colors.blueAccent,
                ),
                const SizedBox(width: 20.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      day,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      temperature,
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    Text(
                      condition,
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Text(
              suggestion,
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
