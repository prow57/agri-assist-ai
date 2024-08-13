import 'dart:convert';
import 'package:http/http.dart' as http;

class MarketService {
  static const String apiUrl =
      'https://www.nsomalawi.mw/publications/agriculture/monthly-statistical-bulletin-2024'; // Replace with the actual endpoint

  Future<List<Commodity>> fetchMarketPrices() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(
          response.body); // Adjust according to the actual JSON structure
      return data.map((item) => Commodity.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load market prices');
    }
  }
}

class Commodity {
  final String name;
  final double supply;

  Commodity({required this.name, required this.supply});

  factory Commodity.fromJson(Map<String, dynamic> json) {
    return Commodity(
      name: json['product_name'], // Adjust according to actual JSON structure
      supply: json['supply']
          .toDouble(), // Adjust according to actual JSON structure
    );
  }
}
