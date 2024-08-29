import 'dart:convert';
import 'package:http/http.dart' as http;
import 'driver.dart';

class DriverService {
  static const String baseUrl = 'https://agri-backend-8het.onrender.com/api';

  Future<List<Driver>> fetchDriversByMarket(int marketId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/drivers/by-market/$marketId'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data
          .map((driver) => Driver(
                id: driver['id'],
                firstName: driver['first_name'] ?? 'N/A',
                lastName: driver['last_name'] ?? 'N/A',
                phone1: driver['phone_1'] ?? 'N/A',
                phone2: driver['phone_2'] ?? 'N/A',
                carType: driver['car_type'] ?? 'N/A',
                marketId: driver['market_id'] ?? 'N/A',
              ))
          .toList();
    } else {
      throw Exception('Failed to load drivers');
    }
  }
}
