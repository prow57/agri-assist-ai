class WeatherData {
  final DateTime dateTime;
  final double temperature;
  final double feelsLike;
  final String description;
  final String icon;
  final double windSpeed;
  final int humidity;

  WeatherData({
    required this.dateTime,
    required this.temperature,
    required this.feelsLike,
    required this.description,
    required this.icon,
    required this.windSpeed,
    required this.humidity,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final dt = DateTime.parse(json['dt_txt']);
    final main = json['main'];
    final weather = json['weather'][0];

    return WeatherData(
      dateTime: dt,
      temperature: main['temp'] - 273.15, // Convert Kelvin to Celsius
      feelsLike: main['feels_like'] - 273.15, // Convert Kelvin to Celsius
      description: weather['description'],
      icon: weather['icon'],
      windSpeed: json['wind']['speed'],
      humidity: main['humidity'],
    );
  }
}

class WeatherResponse {
  final List<WeatherData> list;
  final String cityName;

  WeatherResponse({
    required this.list,
    required this.cityName,
  });

  factory WeatherResponse.fromJson(Map<String, dynamic> json) {
    final list = (json['list'] as List)
        .map((item) => WeatherData.fromJson(item))
        .toList();
    final cityName = json['city']['name'];

    return WeatherResponse(
      list: list,
      cityName: cityName,
    );
  }
}
