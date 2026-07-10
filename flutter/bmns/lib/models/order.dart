class Order {
  final String? id; // Realtime Database push key; null until saved.
  final String customerName;
  final String productName;
  final String orderedGoods;
  final double totalPrice;
  final String orderedDate; // stored as ISO yyyy-MM-dd, like the web app

  Order({
    this.id,
    required this.customerName,
    required this.productName,
    required this.orderedGoods,
    required this.totalPrice,
    required this.orderedDate,
  });

  factory Order.fromMap(String id, Map<dynamic, dynamic> data) {
    return Order(
      id: id,
      customerName: data['customerName'] ?? '',
      productName: data['productName'] ?? '',
      orderedGoods: data['orderedGoods'] ?? '',
      totalPrice: data['totalPrice'] is num
          ? (data['totalPrice'] as num).toDouble()
          : double.tryParse('${data['totalPrice']}') ?? 0.0,
      orderedDate: data['orderedDate'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'customerName': customerName,
      'productName': productName,
      'orderedGoods': orderedGoods,
      'totalPrice': totalPrice,
      'orderedDate': orderedDate,
    };
  }

  Order copyWith({
    String? id,
    String? customerName,
    String? productName,
    String? orderedGoods,
    double? totalPrice,
    String? orderedDate,
  }) {
    return Order(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      productName: productName ?? this.productName,
      orderedGoods: orderedGoods ?? this.orderedGoods,
      totalPrice: totalPrice ?? this.totalPrice,
      orderedDate: orderedDate ?? this.orderedDate,
    );
  }
}
