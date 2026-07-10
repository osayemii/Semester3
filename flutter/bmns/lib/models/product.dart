class Product {
  final String? id; // Realtime Database push key; null until saved.
  final String name;
  final int quantity;
  final double price;
  final String productionDate; // stored as ISO yyyy-MM-dd, like the web app

  Product({
    this.id,
    required this.name,
    required this.quantity,
    required this.price,
    required this.productionDate,
  });

  factory Product.fromMap(String id, Map<dynamic, dynamic> data) {
    return Product(
      id: id,
      name: data['name'] ?? '',
      quantity: data['quantity'] is int
          ? data['quantity'] as int
          : int.tryParse('${data['quantity']}') ?? 0,
      price: data['price'] is num
          ? (data['price'] as num).toDouble()
          : double.tryParse('${data['price']}') ?? 0.0,
      productionDate: data['productionDate'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'price': price,
      'productionDate': productionDate,
    };
  }

  Product copyWith({
    String? id,
    String? name,
    int? quantity,
    double? price,
    String? productionDate,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      productionDate: productionDate ?? this.productionDate,
    );
  }
}
