class Commodity {
  final String cropName;
  final String marketName;
  final double price;

  Commodity({required this.cropName, required this.marketName, required this.price});

  factory Commodity.fromJson(Map<String, dynamic> json) {
    return Commodity(
      cropName: json['crop_name'],
      marketName: json['market_name'],
      price: double.parse(json['price']), // Assuming 'price' is a String in your JSON
    );
  }
}
