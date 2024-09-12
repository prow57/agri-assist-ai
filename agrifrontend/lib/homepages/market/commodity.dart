abstract class Commodity {
  final String name;
  final double price;
  final String quantity;

  Commodity({required this.name, required this.price, required this.quantity});
}

class CropCommodity extends Commodity {
  CropCommodity({required String crop_name, required double price, required String quantity})
      : super(name: crop_name, price: price, quantity: quantity);
}

class AnimalCommodity extends Commodity {
  AnimalCommodity({required String animal_name, required double price, required String quantity})
      : super(name: animal_name, price: price, quantity: quantity);
}

class CropProductCommodity extends Commodity {
  CropProductCommodity({required String product_name, required double price, required String quantity})
      : super(name: product_name, price: price, quantity: quantity);
}

class AnimalProductCommodity extends Commodity {
  AnimalProductCommodity({required String product_name, required double price, required String quantity})
      : super(name: product_name, price: price, quantity: quantity);
}
