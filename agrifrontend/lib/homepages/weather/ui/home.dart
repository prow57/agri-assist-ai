import 'dart:convert';
import 'package:agrifrontend/homepages/weather/models/city.dart';
import 'package:agrifrontend/homepages/weather/ui/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.selectedCities}) : super(key: key);

  final List<City> selectedCities; // Receive the list of selected cities

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const String apiKey = '40b2ee689b1a72e6e9b44c594c93bc10';
  static const String searchWeatherUrl = 'https://api.openweathermap.org/data/2.5/weather?q=';

  int temperature = 0;
  int maxTemp = 0;
  String weatherStateName = 'Loading..';
  int humidity = 0;
  int windSpeed = 0;
  String currentDate = 'Loading..';
  String imageUrl = '';
  String location = 'London'; // Default city

  List<Map<String, dynamic>> consolidatedWeatherList = []; 

  late List<String> cities; // List of cities

  @override
  void initState() {
    super.initState();
    cities = widget.selectedCities.map((city) => city.city).toList(); // Extract city names
    if (cities.isNotEmpty) {
      location = cities.first; // Set default location to the first city
      fetchWeatherData();
      // fetch7DayForecast(); // Fetch the 7-day forecast data
    }
  }

  void fetchWeatherData() async {
    try {
      var weatherResult = await http.get(Uri.parse('$searchWeatherUrl$location&appid=$apiKey'));
      if (weatherResult.statusCode == 200) {
        var result = json.decode(weatherResult.body);

        setState(() {
          temperature = (result['main']['temp'] - 273.15).round(); // Convert Kelvin to Celsius
          weatherStateName = result['weather'][0]['description'];
          humidity = result['main']['humidity'];
          windSpeed = (result['wind']['speed'] * 3.6).round(); // Convert m/s to km/h
          maxTemp = (result['main']['temp_max'] - 273.15).round(); // Convert Kelvin to Celsius

          var dateTime = DateTime.fromMillisecondsSinceEpoch(result['dt'] * 1000);
          currentDate = DateFormat('EEEE, d MMMM').format(dateTime);

          // Extract the icon code from the API response
          String iconCode = result['weather'][0]['icon'];
          imageUrl = 'https://openweathermap.org/img/wn/$iconCode@2x.png';
        });
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      print('Error fetching weather data: $e');
    }
  }

  final Shader linearGradient = const LinearGradient(
    colors: <Color>[Color(0xffABCFF2), Color(0xff9AC6F3)],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        titleSpacing: 0,
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous page
          },
        ),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end, // Align items to the right
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Location Icon and Dropdown Button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0), // Space between icon and dropdown
                    child: Image.asset(
                      'assets/pin.png',
                      width: 20,
                    ),
                  ),
                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: location,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: cities.map((String city) {
                        return DropdownMenuItem<String>(
                          value: city,
                          child: Text(city),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          location = newValue!;
                          fetchWeatherData();
                          // fetch7DayForecast(); // Fetch forecast for new location
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              location,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
              ),
            ),
            Text(
              currentDate,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              width: size.width,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.blue[200],
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue[200]!.withOpacity(.5),
                    offset: const Offset(0, 25),
                    blurRadius: 10,
                    spreadRadius: -12,
                  )
                ],
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: -40,
                    left: 5,
                    child: imageUrl == ''
                      ? const Text('')
                      : Image.network(
                          imageUrl,
                          width: 200, 
                          height: 200, 
                          fit: BoxFit
                          .cover,
                        ),
                    ),
                  Positioned(
                    bottom: 30,
                    left: 20,
                    child: Text(
                      weatherStateName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            temperature.toString(),
                            style: TextStyle(
                              fontSize: 80,
                              fontWeight: FontWeight.bold,
                              foreground: Paint()..shader = linearGradient,
                            ),
                          ),
                        ),
                        Text(
                          '°C',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()..shader = linearGradient,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  weatherItem(
                    text: 'Wind Speed',
                    value: windSpeed,
                    unit: 'km/h',
                    imageUrl: 'assets/windspeed.png',
                  ),
                  weatherItem(
                    text: 'Humidity',
                    value: humidity,
                    unit: '%',
                    imageUrl: 'assets/humidity.png',
                  ),
                  weatherItem(
                    text: 'Max Temp',
                    value: maxTemp,
                    unit: '°C',
                    imageUrl: 'assets/max-temp.png',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget weatherItem({
    required String text,
    required int value,
    required String unit,
    required String imageUrl,
  }) {
    return Column(
      children: [
        Image.asset(
          imageUrl,
          width: 30,
        ),
        Text(
          '$value $unit',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
