class Market {
  final int id;
  final String name;
  final String location;

  Market({required this.id, required this.name, required this.location});

  factory Market.fromJson(Map<String, dynamic> json) {
    return Market(
      id: json['id'],
      name: json['name'],
      location: json['location'],
    );
  }
}
