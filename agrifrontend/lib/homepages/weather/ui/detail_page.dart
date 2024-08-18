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
        title: Text(
          dayOfWeek,
          style: TextStyle(color: Colors.white), // Set title color to white
        ),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // Set back arrow color to white
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
              // Weather Icon
              Image.network(
                'https:${dayForecast['day']['condition']['icon']}',
                height: 200, // Increased icon height
                width: 200, // Increased icon width
                fit: BoxFit.cover,
              ),
              SizedBox(height: 20),
              // Temperature
              Container(
                child: Column(
                  children: [
                    Text(
                      '${dayForecast['day']['avgtemp_c']}°C',
                      style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              // Weather Condition
              Container(
                child: Column(
                  children: [
                    Text(
                      '${dayForecast['day']['condition']['text']}',
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Additional Weather Details
              Expanded(
                child: ListView.separated(
                  itemCount: 7, // Number of items
                  separatorBuilder: (context, index) => Divider(height: 16.0, color: Colors.grey[300]),
                  itemBuilder: (context, index) {
                    final details = [
                      ['Max Temp', '${dayForecast['day']['maxtemp_c']}°C'],
                      ['Min Temp', '${dayForecast['day']['mintemp_c']}°C'],
                      ['Humidity', '${dayForecast['day']['avghumidity']}%'],
                      ['Wind Speed', '${dayForecast['day']['maxwind_kph']} kph'],
                      ['Precipitation', '${dayForecast['day']['totalprecip_mm']} mm'],
                      ['Sunrise', '${dayForecast['astro']['sunrise']}'],
                      ['Sunset', '${dayForecast['astro']['sunset']}'],
                    ];
                    return _buildDetailBox(details[index][0], details[index][1]);
                  },
                ),
              ),
              SizedBox(height: 20),
              // Recommendations based on weather
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.lightGreen[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recommendation:',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 8),
                    Text(
                      _getRecommendation(dayForecast['day']['condition']['text']),
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailBox(String label, String value) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.lightGreen[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green, width: 1.0),
      ),
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
            style: TextStyle(fontSize: 16),
          ),
        ],
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
