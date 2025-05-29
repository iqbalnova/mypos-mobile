class Product {
  final String id;
  final String categoryId;
  final String name;
  final int price;
  final String pictureUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  const Product({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.price,
    required this.pictureUrl,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      categoryId: json['category_id'],
      name: json['name'],
      price: json['price'],
      pictureUrl: json['picture_url'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt:
          json['deleted_at'] != null
              ? DateTime.parse(json['deleted_at'])
              : null,
    );
  }
}
