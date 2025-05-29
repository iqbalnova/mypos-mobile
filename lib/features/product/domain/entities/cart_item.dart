import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  final int? id;
  final String productId;
  final String productName;
  final String imageUrl;
  final double price;
  final int quantity;

  const CartItem({
    this.id,
    required this.productId,
    required this.productName,
    required this.imageUrl,
    required this.price,
    required this.quantity,
  });

  CartItem copyWith({
    int? id,
    String? productId,
    String? productName,
    String? imageUrl,
    double? price,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }

  double get totalPrice => price * quantity;

  @override
  List<Object?> get props => [
    id,
    productId,
    productName,
    imageUrl,
    price,
    quantity,
  ];
}
