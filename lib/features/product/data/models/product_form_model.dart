import 'package:equatable/equatable.dart';

class ProductFormModel extends Equatable {
  final String categoryId;
  final String name;
  final int price;

  const ProductFormModel({
    required this.categoryId,
    required this.name,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return {'category_id': categoryId, 'name': name, 'price': price};
  }

  @override
  List<Object?> get props => [categoryId, name, price];
}
