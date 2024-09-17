abstract class Commodity {
  final String name;
  final double price;
  final String quantity;

  Commodity({required this.name, required this.price, required this.quantity});
}

class CropCommodity extends Commodity {
  CropCommodity({required String crop_name, required super.price, required super.quantity})
      : super(name: crop_name);
}

class AnimalCommodity extends Commodity {
  AnimalCommodity({required String animal_name, required super.price, required super.quantity})
      : super(name: animal_name);
}

class CropProductCommodity extends Commodity {
  CropProductCommodity({required String product_name, required super.price, required super.quantity})
      : super(name: product_name);
}

class AnimalProductCommodity extends Commodity {
  AnimalProductCommodity({required String product_name, required super.price, required super.quantity})
      : super(name: product_name);
}
