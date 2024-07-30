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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Weather Forecast',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            WeatherCard(
              day: 'Yesterday',
              temperature: '25°C',
              condition: 'Sunny',
              icon: Icons.wb_sunny,
            ),
            const SizedBox(height: 10.0),
            WeatherCard(
              day: 'Today',
              temperature: '28°C',
              condition: 'Partly Cloudy',
              icon: Icons.cloud_queue,
            ),
            const SizedBox(height: 10.0),
            WeatherCard(
              day: 'Tomorrow',
              temperature: '30°C',
              condition: 'Rainy',
              icon: Icons.grain,
            ),
          ],
        ),
      ),
    );
  }
}

class WeatherCard extends StatelessWidget {
  final String day;
  final String temperature;
  final String condition;
  final IconData icon;

  const WeatherCard({
    required this.day,
    required this.temperature,
    required this.condition,
    required this.icon,
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
        child: Row(
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
      ),
    );
  }
}
