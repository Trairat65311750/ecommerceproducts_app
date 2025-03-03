class ProductItem {
  int? keyID;
  String productName;
  double price;
  String category;
  int stockQuantity;
  DateTime? date;
  String? imagePath;

  ProductItem({
    this.keyID,
    required this.productName,
    required this.price,
    required this.category,
    required this.stockQuantity,
    this.date,
    this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'price': price,
      'category': category,
      'stockQuantity': stockQuantity,
      'date': date?.toIso8601String(),
    };
  }
}
