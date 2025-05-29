import 'package:equatable/equatable.dart';

class Product extends Equatable {
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

  @override
  List<Object?> get props => [
    id,
    categoryId,
    name,
    price,
    pictureUrl,
    createdAt,
    updatedAt,
    deletedAt,
  ];
}
