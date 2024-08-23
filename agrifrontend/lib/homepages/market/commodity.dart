abstract class Commodity {
  final String name;
  final double price;

  Commodity({required this.name, required this.price});
}

class CropCommodity extends Commodity {
  CropCommodity({required String crop_name, required double price})
      : super(name: crop_name, price: price);
}

class AnimalCommodity extends Commodity {
  AnimalCommodity({required String animal_name, required double price})
      : super(name: animal_name, price: price);
}

class CropProductCommodity extends Commodity {
  CropProductCommodity({required String product_name, required double price})
      : super(name: product_name, price: price);
}

class AnimalProductCommodity extends Commodity {
  AnimalProductCommodity({required String product_name, required double price})
      : super(name: product_name, price: price);
}
