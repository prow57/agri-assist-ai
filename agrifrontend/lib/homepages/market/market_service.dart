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

  Future<List<CropCommodity>> fetchCropPrices(int marketId) async {
    final response = await http.get(Uri.parse('$baseUrl/prices/market/$marketId'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => CropCommodity(
        crop_name: item['crop_name'] ?? 'N/A',
        price: (item['price'] ?? 0),
      )).toList();
    } else {
      throw Exception('Failed to load crop prices');
    }
  }

  Future<List<AnimalCommodity>> fetchAnimalPrices(int marketId) async {
    final response = await http.get(Uri.parse('$baseUrl/prices/animal/$marketId'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => AnimalCommodity(
        animal_name: item['animal_name'] ?? 'N/A',
        price: (item['price'] ?? 0),
      )).toList();
    } else {
      throw Exception('Failed to load animal prices');
    }
  }

  Future<List<CropProductCommodity>> fetchCropProductPrices(int marketId) async {
    final response = await http.get(Uri.parse('$baseUrl/crops/get/products/price/$marketId'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => CropProductCommodity(
        product_name: item['product_name'] ?? 'N/A',
        price: (item['price'] ?? 0),
      )).toList();
    } else {
      throw Exception('Failed to load crop product prices');
    }
  }

  Future<List<AnimalProductCommodity>> fetchAnimalProductPrices(int marketId) async {
    final response = await http.get(Uri.parse('$baseUrl/animals/get/products/price/$marketId'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => AnimalProductCommodity(
        product_name: item['product_name'] ?? 'N/A',
        price: (item['price'] ?? 0),
      )).toList();
    } else {
      throw Exception('Failed to load animal product prices');
    }
  }
}
