import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailPage extends StatelessWidget {
  final Map<String, dynamic> dayForecast;

  DetailPage({required this.dayForecast});

  @override
  Widget build(BuildContext context) {
    // Convert the date string to a DateTime object
    final date = DateTime.parse(dayForecast['date']);
    final dayOfWeek = DateFormat('EEEE').format(date);
    final dateFormatted = DateFormat('yyyy-MM-dd').format(date);

    return Scaffold(
      appBar: AppBar(
        title: Text(dayOfWeek),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Weather Icon
              Image.network(
                'https:${dayForecast['day']['condition']['icon']}',
                height: 150, // Adjust image height as needed
                width: 150, // Adjust image width as needed
              ),
              SizedBox(height: 16),
              // Temperature
              Text(
                '${dayForecast['day']['avgtemp_c']}°C',
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              // Weather Condition
              Text(
                '${dayForecast['day']['condition']['text']}',
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
              SizedBox(height: 16),
              // Additional Weather Details
              Text(
                'Date: $dateFormatted',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text(
                'Max Temp: ${dayForecast['day']['maxtemp_c']}°C',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'Min Temp: ${dayForecast['day']['mintemp_c']}°C',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'Humidity: ${dayForecast['day']['avghumidity']}%',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'Wind Speed: ${dayForecast['day']['maxwind_kph']} kph',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'Precipitation: ${dayForecast['day']['totalprecip_mm']} mm',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 16),
              // Recommendations based on weather
              Text(
                'Recommendation:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text(
                _getRecommendation(dayForecast['day']['condition']['text']),
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
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
}
