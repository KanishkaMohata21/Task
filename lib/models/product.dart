class Product {
  final int id;
  final String title;
  final double price;
  final int discountPercentage;
  final String thumbnail;
  final int quantity;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.discountPercentage,
    required this.thumbnail,
    this.quantity = 1,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: json['price'].toDouble(),
      discountPercentage: json['discountPercentage'].toInt(),
      thumbnail: json['thumbnail'],
    );
  }

  double get discountedPrice {
    return price - (price * discountPercentage / 100);
  }

  Product copyWith({
    int? id,
    String? title,
    double? price,
    int? discountPercentage,
    String? thumbnail,
    int? quantity,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      thumbnail: thumbnail ?? this.thumbnail,
      quantity: quantity ?? this.quantity,
    );
  }
}
