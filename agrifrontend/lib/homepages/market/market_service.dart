import 'dart:convert';
import 'package:http/http.dart' as http;
import 'market.dart'; // Import your Market model
import 'commodity.dart'; // Import your Commodity model

class MarketService {
  final String baseUrl = 'https://agri-backend-8het.onrender.com/api';

  Future<List<Market>> fetchMarkets() async {
    final response = await http.get(Uri.parse('$baseUrl/markets'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Market.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load markets');
    }
  }

  Future<List<Commodity>> fetchCropPrices(int marketId) async {
    final response = await http.get(Uri.parse('$baseUrl/prices/market/$marketId'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Commodity.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load market prices');
    }
  }

  Future<List<Commodity>> fetchAnimalPrices(int marketId) async {
    final response = await http.get(Uri.parse('$baseUrl/prices/animal/$marketId'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Commodity.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load animal and crop products');
    }
  }

  Future<List<Commodity>> fetchCropProductPrices(int marketId) async {
    final response = await http.get(Uri.parse('$baseUrl/crops/get/products/price/$marketId'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Commodity.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load animal and crop products');
    }
  }

    Future<List<Commodity>> fetchAnimalProductPrices(int marketId) async {
    final response = await http.get(Uri.parse('$baseUrl/animal/get/products/price/$marketId'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Commodity.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load animal and crop products');
    }
  }
}
