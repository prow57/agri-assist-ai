class Market {
  final int id;
  final String name;

  Market({required this.id, required this.name});

  factory Market.fromJson(Map<String, dynamic> json) {
    return Market(
      id: json['id'],
      name: json['name'],
    );
  }
}
