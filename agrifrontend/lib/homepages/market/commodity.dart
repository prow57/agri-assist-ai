class Commodity {
  final String name;
  final double price; // or the appropriate type based on your API response

  Commodity({required this.name, required this.price});

  factory Commodity.fromJson(Map<String, dynamic> json) {
    return Commodity(
      name: json['name'],
      price: json['price'].toDouble(), // Adjust as needed
    );
  }
}
