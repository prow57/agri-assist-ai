import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = '8e5331509f424194a30195043240408';
  final String baseUrl = 'http://api.weatherapi.com/v1';

  Future<Map<String, dynamic>> fetchWeather(String city) async {
    final url = '$baseUrl/forecast.json?key=$apiKey&q=$city&days=7';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
