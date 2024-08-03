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

  // void fetch7DayForecast() async {
  //   try {
  //     final coordinatesUrl = 'https://api.openweathermap.org/data/2.5/weather?q=$location&appid=$apiKey';
  //     final weatherResult = await http.get(Uri.parse(coordinatesUrl));
  //     if (weatherResult.statusCode == 200) {
  //       var weatherData = json.decode(weatherResult.body);
  //       var lat = weatherData['coord']['lat'];
  //       var lon = weatherData['coord']['lon'];

  //       var forecastResult = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&exclude=hourly,minutely&appid=$apiKey'));
  //       if (forecastResult.statusCode == 200) {
  //         var forecastData = json.decode(forecastResult.body);
  //         print('7-Day Forecast Data: $forecastData');
  //         setState(() {
  //           consolidatedWeatherList = forecastData;
  //         });
  //       } else {
  //         throw Exception('Failed to load 7-day forecast');
  //       }
  //     } else {
  //       throw Exception('Failed to load weather data');
  //     }
  //   } catch (e) {
  //     print('Error fetching 7-day forecast: $e');
  //   }
  // }

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
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Image.asset(
                  'assets/logo.jpg',
                  width: 40,
                  height: 40,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/pin.png',
                    width: 20,
                  ),
                  const SizedBox(
                    width: 4,
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
                  )
                ],
              )
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
                    left: 20,
                    child: imageUrl == ''
                        ? const Text('')
                        : Image.network(
                            imageUrl,
                            width: 150,
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
            // const SizedBox(
            //   height: 50,
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   children: [
            //     const Text(
            //       'Today',
            //       style: TextStyle(
            //         fontWeight: FontWeight.bold,
            //         fontSize: 24,
            //       ),
            //     ),
            //     Text(
            //       'Next 7 Days',
            //       style: TextStyle(
            //         fontWeight: FontWeight.w600,
            //         fontSize: 18,
            //         color: Colors.blue,
            //       ),
            //     ),
            //   ],
            // ),
            // const SizedBox(
            //   height: 20,
            // ),
            // Expanded(
          //     child: ListView.builder(
          //       scrollDirection: Axis.horizontal,
          //       itemCount: consolidatedWeatherList.length,
          //       itemBuilder: (BuildContext context, int index) {
          //         String today = DateTime.now().toString().substring(0, 10);
          //         var selectedDay = DateFormat('yyyy-MM-dd').format(DateTime.fromMillisecondsSinceEpoch(consolidatedWeatherList[index]['dt'] * 1000));
          //         var weatherDescription = consolidatedWeatherList[index]['weather'][0]['description'];
          //         var iconCode = consolidatedWeatherList[index]['weather'][0]['icon'];
          //         var weatherUrl = 'https://openweathermap.org/img/wn/$iconCode@2x.png';

          //         var parsedDate = DateTime.fromMillisecondsSinceEpoch(consolidatedWeatherList[index]['dt'] * 1000);
          //         var newDate = DateFormat('EEEE').format(parsedDate).substring(0, 3);

          //         return GestureDetector(
          //           onTap: () {
          //             Navigator.push(
          //               context,
          //               MaterialPageRoute(
          //                 builder: (context) => DetailPage(
          //                   consolidatedWeatherList: consolidatedWeatherList,
          //                   selectedId: index,
          //                   location: location,
          //                 ),
          //               ),
          //             );
          //           },
          //           child: Container(
          //             padding: const EdgeInsets.symmetric(vertical: 20),
          //             margin: const EdgeInsets.only(right: 20, bottom: 10, top: 10),
          //             width: 80,
          //             decoration: BoxDecoration(
          //               color: selectedDay == today ? Colors.blue : Colors.white,
          //               borderRadius: const BorderRadius.all(Radius.circular(10)),
          //               boxShadow: [
          //                 BoxShadow(
          //                   offset: const Offset(0, 1),
          //                   blurRadius: 5,
          //                   color: selectedDay == today
          //                       ? Colors.blue
          //                       : Colors.black54.withOpacity(.2),
          //                 ),
          //               ],
          //             ),
          //             child: Column(
          //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //               children: [
          //                 Text(
          //                   consolidatedWeatherList[index]['temp']['day'].round().toString() + "°C",
          //                   style: TextStyle(
          //                     fontSize: 17,
          //                     color: selectedDay == today ? Colors.white : Colors.blue,
          //                     fontWeight: FontWeight.w500,
          //                   ),
          //                 ),
          //                 Image.network(
          //                   weatherUrl,
          //                   width: 30,
          //                 ),
          //                 Text(
          //                   newDate,
          //                   style: TextStyle(
          //                     fontSize: 17,
          //                     color: selectedDay == today ? Colors.white : Colors.blue,
          //                     fontWeight: FontWeight.w500,
          //                   ),
          //                 )
          //               ],
          //             ),
          //           ),
          //         );
          //       },
          //     ),
          //   ),
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
