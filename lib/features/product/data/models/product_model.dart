import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.categoryId,
    required super.name,
    required super.price,
    required super.pictureUrl,
    required super.createdAt,
    required super.updatedAt,
    super.deletedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'name': name,
      'price': price,
      'picture_url': pictureUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }
}
