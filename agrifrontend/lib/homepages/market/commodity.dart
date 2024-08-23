abstract class Commodity {
  final String name;
  final String price;

  Commodity({required this.name, required this.price});
}

class CropCommodity extends Commodity {
  CropCommodity({required String crop_name, required String price})
      : super(name: crop_name, price: price);
}

class AnimalCommodity extends Commodity {
  AnimalCommodity({required String animal_name, required String price})
      : super(name: animal_name, price: price);
}

class CropProductCommodity extends Commodity {
  CropProductCommodity({required String product_name, required String price})
      : super(name: product_name, price: price);
}

class AnimalProductCommodity extends Commodity {
  AnimalProductCommodity({required String product_name, required String price})
      : super(name: product_name, price: price);
}
