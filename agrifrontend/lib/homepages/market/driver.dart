class Driver {
  final String id;
  final String firstName;
  final String lastName;
  final String phone1;
  final String phone2;
  final String carType;
  final int marketId;

  Driver({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone1,
    required this.phone2,
    required this.carType,
    required this.marketId,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      phone1: json['phone_1'],
      phone2: json['phone_2'],
      carType: json['car_type'],
      marketId: json['market_id'],
    );
  }
}
